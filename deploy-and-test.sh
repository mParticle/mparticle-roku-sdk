#!/bin/bash

# Roku Test Deployment Script
# Usage: ./deploy-and-test.sh YOUR_ROKU_IP

ROKU_IP=$1
ROKU_USER="rokudev"

if [ -z "$ROKU_IP" ]; then
    echo "❌ Error: Please provide your Roku IP address"
    echo "Usage: ./deploy-and-test.sh YOUR_ROKU_IP"
    exit 1
fi

# Get absolute path to script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ZIP_FILE="$SCRIPT_DIR/example-legacy-sdk.zip"

# Clean up old package if it exists
rm -f "$ZIP_FILE"

echo "📦 Packaging channel..."

# Temporarily copy test framework into the example app
# (test files are already symlinked from testing/tests)
TEST_FRAMEWORK_SRC="$SCRIPT_DIR/testing/unit-testing-framework/UnitTestFramework.brs"
TEST_FRAMEWORK_DEST="$SCRIPT_DIR/example-legacy-sdk/source/testFramework"

echo "   Copying test framework..."
mkdir -p "$TEST_FRAMEWORK_DEST"
cp "$TEST_FRAMEWORK_SRC" "$TEST_FRAMEWORK_DEST/"

# Package the channel
echo "   Creating zip package..."
cd "$SCRIPT_DIR/example-legacy-sdk"
zip -r "$ZIP_FILE" . -x "*.git*" -x "*/.DS_Store" -x "*.zip" > /dev/null 2>&1
ZIP_RESULT=$?
cd "$SCRIPT_DIR"

# Clean up temporary test framework
echo "   Cleaning up temporary test framework..."
rm -rf "$TEST_FRAMEWORK_DEST"

# Check if zip was successful
if [ $ZIP_RESULT -ne 0 ]; then
    echo "❌ Failed to create package"
    exit 1
fi

echo "🚀 Deploying to Roku at $ROKU_IP..."
echo "   (You'll be prompted for your Roku developer password)"

curl --digest -s -S -F "mysubmit=Install" -F "archive=@$ZIP_FILE" \
  -u $ROKU_USER \
  "http://$ROKU_IP/plugin_install" | grep -i "install"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Channel deployed successfully!"
    echo ""
    echo "🧪 Running unit tests..."
    echo ""
    
    # Connect to debug console FIRST before launching
    nc $ROKU_IP 8085 > /tmp/roku_test_output_$$.txt 2>&1 &
    NC_PID=$!
    
    # Give nc time to establish connection
    sleep 3
    
    # Launch the dev channel with test parameters
    # Note: Roku ECP requires custom params as contentId with encoded key-value pairs
    curl -s -d '' "http://$ROKU_IP:8060/launch/dev?contentId=RunUnitTests%3Dtrue" > /dev/null
    
    # Wait for tests to complete
    sleep 30
    
    # Kill nc
    kill $NC_PID 2>/dev/null || true
    
    # Display results
    echo ""
    echo "📊 TEST RESULTS:"
    echo "================================================================"
    if [ -s /tmp/roku_test_output_$$.txt ]; then
        cat /tmp/roku_test_output_$$.txt
        echo "================================================================"
        echo ""
        
        # Extract and display test summary if available
        if grep -q "Total.*Passed.*Failed" /tmp/roku_test_output_$$.txt; then
            echo "📈 SUMMARY:"
            grep "Total.*Passed.*Failed" /tmp/roku_test_output_$$.txt | head -1
            echo ""
        fi
    else
        echo "⚠️  No output captured from debug console!"
        echo "   This might mean:"
        echo "   - The app didn't launch"
        echo "   - Debug console (port 8085) isn't accessible"
        echo "   - The app exited too quickly"
        echo "================================================================"
    fi
    
    # Cleanup
    rm -f /tmp/roku_test_output_$$.txt
else
    echo "❌ Deployment failed. Check your Roku IP and password."
fi

