#!/bin/bash
# Roku Test Runner with proper output capture
# Usage: ./run-tests.sh [ROKU_IP] [ROKU_PASSWORD]

set -e

# Get Roku IP from argument or prompt user
if [ -n "$1" ]; then
    ROKU_IP="$1"
else
    read -p "Enter Roku IP address: " ROKU_IP
    if [ -z "$ROKU_IP" ]; then
        echo "❌ Roku IP address is required!"
        exit 1
    fi
fi

ROKU_PASSWORD=${2:-""}

echo "🧪 Building and running Rooibos tests..."
echo "📡 Roku IP: $ROKU_IP"
echo ""

# Build the test package
echo "📦 Building test package..."
npx bsc --project bsconfig-test.json

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build successful!"
echo ""

# Start telnet capture in background
echo "📡 Connecting to Roku debug port..."
nc $ROKU_IP 8085 > /tmp/roku_test_output.txt &
NC_PID=$!
sleep 2

# Deploy the package
echo "🚀 Deploying to Roku..."
if [ -n "$ROKU_PASSWORD" ]; then
    curl --digest -s -S -F "mysubmit=Install" -F "archive=@./out/mparticle-roku-sdk.zip" \
        -u "rokudev:$ROKU_PASSWORD" \
        "http://$ROKU_IP/plugin_install" > /dev/null
else
    echo "⚠️  No password provided - you may be prompted"
    curl --digest -S -F "mysubmit=Install" -F "archive=@./out/mparticle-roku-sdk.zip" \
        -u "rokudev" \
        "http://$ROKU_IP/plugin_install" > /dev/null
fi

# Press home to ensure clean state
for i in {1..3}; do
    curl -s -d '' "http://$ROKU_IP:8060/keypress/Home" > /dev/null 2>&1
    sleep 0.3
done
sleep 2

# Launch the dev channel
echo "▶️  Launching tests..."
curl -s -d '' "http://$ROKU_IP:8060/launch/dev" > /dev/null 2>&1

# Wait for tests to complete (look for "Rooibos Shutdown" message)
echo "⏳ Waiting for tests to complete..."
for i in {1..60}; do
    if grep -q "Rooibos Shutdown" /tmp/roku_test_output.txt 2>/dev/null; then
        sleep 1
        break
    fi
    sleep 1
done

# Kill the netcat process
kill $NC_PID 2>/dev/null || true

echo ""
echo "=================================================="
echo "📊 TEST RESULTS"
echo "=================================================="
echo ""

# Extract and display the test report
if [ -f /tmp/roku_test_output.txt ]; then
    # Show the test report section
    sed -n '/\[START TEST REPORT\]/,/\[END TEST REPORT\]/p' /tmp/roku_test_output.txt | \
        grep -v "^\s*$" || echo "⚠️  No test report found"
    
    echo ""
    echo "=================================================="
    
    # Show the result
    if grep -q "\[Rooibos Result\]: PASS" /tmp/roku_test_output.txt; then
        echo "✅ ALL TESTS PASSED!"
    elif grep -q "\[Rooibos Result\]: FAIL" /tmp/roku_test_output.txt; then
        echo "❌ TESTS FAILED"
    else
        echo "⚠️  Test execution status unclear"
    fi
    
    # Save full output
    cp /tmp/roku_test_output.txt ./last_test_output.log
    echo ""
    echo "📝 Full output saved to: last_test_output.log"
else
    echo "❌ No test output captured!"
fi

echo ""
rm -f /tmp/roku_test_output.txt


