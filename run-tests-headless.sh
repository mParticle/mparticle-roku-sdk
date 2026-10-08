#!/bin/bash
# Build the Rooibos tests and run them in brs-node, a BrightScript simulator, without a Roku. Used by CI.
#
# Usage: ./run-tests-headless.sh
#
# Exit codes: 0 = tests passed
#             1 = tests failed, or the app did not compile
#             2 = could not run (build failed, or no result before the timeout)
#
# The simulator is not a Roku: a pass here does not replace ./run-tests.sh on a device before a release.
# ROKU_TEST_TIMEOUT sets how many seconds to wait for results (default 120).

set -u

TIMEOUT="${ROKU_TEST_TIMEOUT:-120}"
PACKAGE="./out/mparticle-roku-sdk-test.zip"
LOG="last_test_output.log"

echo "📦 Building the test package..."
rm -rf build-test out
if ! npx bsc --project bsconfig-test.json; then
    echo "❌ Build failed"
    exit 2
fi
mkdir -p out
if ! (cd build-test && zip -q -r ../out/mparticle-roku-sdk-test.zip .); then
    echo "❌ Could not create $PACKAGE (is 'zip' installed?)"
    exit 2
fi

# Rooibos keeps the app open after the report, so stop the simulator once the result line is printed.
echo "🧪 Running the tests in brs-node..."
: > "$LOG"
npx brs-cli "$PACKAGE" > "$LOG" 2>&1 &
PID=$!
i=0
while [ "$i" -lt "$TIMEOUT" ] && kill -0 "$PID" 2>/dev/null; do
    grep -q -E "Rooibos Shutdown|EXIT_BRIGHTSCRIPT_CRASH" "$LOG" && break
    sleep 1
    i=$((i + 1))
done
{ kill "$PID"; wait "$PID"; } 2>/dev/null

cat "$LOG"
echo "=================================================="
RESULT=$(grep -o "\[Rooibos Result\]: [A-Z]*" "$LOG" | tail -1)
if [ "$RESULT" = "[Rooibos Result]: PASS" ]; then
    echo "✅ ALL TESTS PASSED"
    exit 0
elif [ -n "$RESULT" ]; then
    echo "❌ TESTS FAILED"
    exit 1
elif grep -q "EXIT_BRIGHTSCRIPT_CRASH" "$LOG"; then
    echo "❌ THE APP CRASHED OR DID NOT COMPILE"
    exit 1
fi
echo "⚠️  No test result after ${TIMEOUT}s"
exit 2
