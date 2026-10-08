#!/bin/bash
# Build the Rooibos tests, install them on a Roku in developer mode, run them and report the result.
#
# Usage: ./run-tests.sh [ROKU_IP] [ROKU_PASSWORD]
#   The developer password is asked for when it is not given (preferred: a password given as an argument
#   stays in your shell history and is visible in the process list while the install runs).
#
# Exit codes: 0 = tests passed
#             1 = tests failed, or the app did not compile on the device
#             2 = could not run (build/install failed, device unreachable, or no new output)
#
# Only console output produced after this run's launch is trusted: the Roku replays recent console
# history whenever a client connects, and that history may belong to an older run.
#
# For testing the capture logic without a device: SKIP_DEPLOY=1 CONSOLE_HOST=... CONSOLE_PORT=...
# ROKU_TEST_TIMEOUT sets how many seconds to wait for results (default 90).

set -u

ROKU_IP="${1:-}"
if [ -z "$ROKU_IP" ]; then
    read -r -p "Enter Roku IP address: " ROKU_IP
    if [ -z "$ROKU_IP" ]; then
        echo "❌ Roku IP address is required!"
        exit 2
    fi
fi
ROKU_PASSWORD="${2:-}"

CONSOLE_HOST="${CONSOLE_HOST:-$ROKU_IP}"
CONSOLE_PORT="${CONSOLE_PORT:-8085}"
TIMEOUT="${ROKU_TEST_TIMEOUT:-90}"
PACKAGE="./out/mparticle-roku-sdk-test.zip"

RAW="$(mktemp -t roku_console.XXXXXX)"
NEW="$RAW.new"
BUILD_LOG="$RAW.build"
NC_PID=""
cleanup() {
    if [ -n "$NC_PID" ]; then { kill "$NC_PID"; wait "$NC_PID"; } 2>/dev/null; fi
    rm -f "$RAW" "$NEW" "$BUILD_LOG"
}
trap cleanup EXIT

echo "🧪 Running Rooibos tests on the Roku at $ROKU_IP"

if [ "${SKIP_DEPLOY:-0}" != "1" ]; then
    echo "📦 Building the test package..."
    rm -f ./out/*.zip
    if ! npx bsc --project bsconfig-test.json > "$BUILD_LOG" 2>&1; then
        cat "$BUILD_LOG"
        echo "❌ Build failed"
        exit 2
    fi
    mkdir -p out
    if ! (cd build-test && zip -q -r ../out/mparticle-roku-sdk-test.zip .); then
        echo "❌ Could not create $PACKAGE (is 'zip' installed?)"
        exit 2
    fi

    # Install first. Installing resets the console session, so we only connect to the console afterwards.
    echo "🚀 Installing on the device (type the developer password if asked)..."
    AUTH="rokudev"
    [ -n "$ROKU_PASSWORD" ] && AUTH="rokudev:$ROKU_PASSWORD"
    RESPONSE=$(curl --digest -s -S -m 120 -w $'\n%{http_code}' \
        -F "mysubmit=Install" -F "archive=@$PACKAGE" -u "$AUTH" "http://$ROKU_IP/plugin_install")
    HTTP_CODE="${RESPONSE##*$'\n'}"
    BODY="${RESPONSE%$'\n'*}"
    if [ "$HTTP_CODE" = "401" ]; then
        echo "❌ The device rejected the developer password (HTTP 401)"
        exit 2
    elif [ "$HTTP_CODE" = "000" ] || [ -z "$HTTP_CODE" ]; then
        echo "❌ Could not reach the device at $ROKU_IP. Check the IP, that developer mode is on, and that"
        echo "   this computer and the Roku are on the same network (guest Wi-Fi often blocks this)."
        exit 2
    fi
    if echo "$BODY" | grep -q "Compilation Failed"; then
        echo "❌ THE APP DID NOT COMPILE ON THE DEVICE:"
        echo "$BODY" | sed 's/<[^>]*>/ /g' | grep -i -E "syntax error|compil|pkg:/" | sed 's/^ *//' | sort -u | head -30
        exit 1
    fi
    if ! echo "$BODY" | grep -q "Install Success"; then
        echo "❌ Install did not succeed (HTTP $HTTP_CODE):"
        echo "$BODY" | sed 's/<[^>]*>/ /g' | grep -i -E "install|fail|error|compil" | sed 's/^ *//' | head -10
        exit 2
    fi
    echo "✅ Install Success"
fi

# Free the console (the Roku allows one connection; this stops any other 'nc' session to it), connect,
# and note how much history was replayed: wait until the console has been quiet for 2 seconds.
pkill -f "^nc ${CONSOLE_HOST//./\\.} ${CONSOLE_PORT}\$" 2>/dev/null
nc "$CONSOLE_HOST" "$CONSOLE_PORT" > "$RAW" 2>/dev/null &
NC_PID=$!
prev=-1
quiet=0
waited=0
while [ "$waited" -lt 10 ] && [ "$quiet" -lt 2 ]; do
    sleep 1
    cur=$(wc -c < "$RAW" | tr -d ' ')
    if [ "$cur" = "$prev" ]; then quiet=$((quiet + 1)); else quiet=0; fi
    prev=$cur
    waited=$((waited + 1))
done
BASE=$cur
echo "📡 Console connected; ignoring $BASE bytes of older output replayed on connect"

if [ "${SKIP_DEPLOY:-0}" != "1" ]; then
    # Exit whatever is running, then launch, so the tests start fresh while we are listening.
    HOME_CODE=$(curl -s -m 10 -o /dev/null -w "%{http_code}" -d '' "http://$ROKU_IP:8060/keypress/Home")
    sleep 2
    LAUNCH_CODE=$(curl -s -m 10 -o /dev/null -w "%{http_code}" -d '' "http://$ROKU_IP:8060/launch/dev")
    echo "▶️  Home=$HOME_CODE, launch=$LAUNCH_CODE"
    if [ "$HOME_CODE" = "403" ]; then
        echo "   ⚠️  The Roku blocked the Home key press. Set Settings > System > Advanced system settings >"
        echo "      Control by mobile apps > Network access to Permissive, or press Home on the remote."
    fi
    if [ "$LAUNCH_CODE" = "204" ]; then
        echo "   ⚠️  The app was already running, so it was not restarted. Press Home on the remote and re-run."
    fi
    if [ "$LAUNCH_CODE" = "000" ]; then
        echo "   ⚠️  The device did not answer the launch request."
    fi
fi

echo "⏳ Waiting up to ${TIMEOUT}s for new console output..."
i=0
while [ "$i" -lt "$TIMEOUT" ]; do
    tail -c +$((BASE + 1)) "$RAW" > "$NEW"
    if grep -q -E "Rooibos Shutdown|Compilation Failed" "$NEW"; then
        sleep 2
        break
    fi
    sleep 1
    i=$((i + 1))
done
{ kill "$NC_PID"; wait "$NC_PID"; } 2>/dev/null
NC_PID=""
tail -c +$((BASE + 1)) "$RAW" > "$NEW"
cp "$NEW" last_test_output.log

echo ""
echo "=================================================="
if grep -q "Compilation Failed" "$NEW"; then
    echo "❌ THE APP DID NOT COMPILE ON THE DEVICE:"
    grep -E "Syntax Error|ERROR compiling|pkg:/" "$NEW" | sort -u | head -30
    echo "=================================================="
    exit 1
elif grep -q "\[START TEST REPORT\]" "$NEW"; then
    # Show the last report (two runs can arrive if the install launched the app as well).
    awk '/\[START TEST REPORT\]/{buf=""; on=1} on{buf=buf $0 "\n"} /\[END TEST REPORT\]/{if(on){last=buf; on=0}} END{printf "%s", last}' "$NEW" | grep -v "^\s*$"
    echo "=================================================="
    RESULT=$(grep -o "\[Rooibos Result\]: [A-Z]*" "$NEW" | tail -1)
    if [ "$RESULT" = "[Rooibos Result]: PASS" ]; then
        echo "✅ ALL TESTS PASSED"
        echo "📝 Output saved to last_test_output.log"
        exit 0
    fi
    echo "❌ TESTS FAILED (${RESULT:-no result line})"
    echo "📝 Output saved to last_test_output.log"
    exit 1
else
    echo "⚠️  No test report arrived in the new output ($BASE bytes of older output ignored)."
    echo "    Is the Roku on the same network, with Network access set to Permissive? Last lines received:"
    tail -n 15 "$NEW"
    echo "=================================================="
    echo "📝 Output saved to last_test_output.log"
    exit 2
fi
