#!/bin/bash

# Roku Test Deployment Script
# Usage: ./deploy-and-test.sh YOUR_ROKU_IP [legacy|scenegraph]

ROKU_IP=$1
EXAMPLE_TYPE=${2:-scenegraph}  # Default to scenegraph if not specified
ROKU_USER="rokudev"

if [ -z "$ROKU_IP" ]; then
    echo "❌ Error: Please provide your Roku IP address"
    echo "Usage: ./deploy-and-test.sh YOUR_ROKU_IP [legacy|scenegraph]"
fi

# Validate example type
if [ "$EXAMPLE_TYPE" != "legacy" ] && [ "$EXAMPLE_TYPE" != "scenegraph" ]; then
    echo "❌ Error: Invalid example type '$EXAMPLE_TYPE'"
    echo "   Must be either 'legacy' or 'scenegraph'"
    exit 1
fi

# Get absolute path to script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Set paths based on example type
if [ "$EXAMPLE_TYPE" = "legacy" ]; then
    EXAMPLE_DIR="$SCRIPT_DIR/example-legacy-sdk"
    ZIP_FILE="$SCRIPT_DIR/example-legacy-sdk.zip"
    TEST_FRAMEWORK_SRC="$SCRIPT_DIR/testing/unit-testing-framework/UnitTestFramework.brs"
    TEST_FRAMEWORK_DEST="$EXAMPLE_DIR/source/testFramework"
else
    EXAMPLE_DIR="$SCRIPT_DIR/example-scenegraph-sdk/source"
    ZIP_FILE="$SCRIPT_DIR/example-scenegraph-sdk.zip"
    TEST_FRAMEWORK_SRC="$SCRIPT_DIR/testing/unit-testing-framework/UnitTestFramework.brs"
    TEST_FRAMEWORK_DEST="$EXAMPLE_DIR/source/testFramework"
fi

# Clean up old package if it exists
rm -f "$ZIP_FILE"

# Clean any cached build artifacts
if [ "$EXAMPLE_TYPE" = "scenegraph" ] && [ -f "$EXAMPLE_DIR/Makefile" ]; then
    echo "🧹 Cleaning build cache..."
    cd "$EXAMPLE_DIR"
    make clean > /dev/null 2>&1 || true
    cd "$SCRIPT_DIR"
fi

echo "📦 Packaging $EXAMPLE_TYPE channel..."

# Temporarily copy test framework into the example app
echo "   Copying test framework..."
mkdir -p "$TEST_FRAMEWORK_DEST"
cp "$TEST_FRAMEWORK_SRC" "$TEST_FRAMEWORK_DEST/"

# Package the channel
echo "   Creating zip package..."
cd "$EXAMPLE_DIR"
zip -r "$ZIP_FILE" . -x "*.git*" -x "*/.DS_Store" -x "*.zip" -x "*/dist/*" -x "*.mk" -x "Makefile" > /dev/null 2>&1
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

echo "🧹 Clearing cache - deleting existing app..."
echo "   (You'll be prompted for your Roku developer password)"
curl --digest -s -S -F "mysubmit=Delete" -F "archive=" \
  -u $ROKU_USER \
  "http://$ROKU_IP/plugin_install" > /dev/null || true

echo ""
echo "🚀 Deploying to Roku at $ROKU_IP..."
echo "   (Enter the same password again)"

curl --digest -s -S -F "mysubmit=Install" -F "archive=@$ZIP_FILE" \
  -u $ROKU_USER \
  "http://$ROKU_IP/plugin_install" | grep -i "install"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ $EXAMPLE_TYPE channel deployed successfully!"
    echo ""
    echo "🧪 Running unit tests..."
    echo ""
    
    # Connect to debug console FIRST before launching
    nc $ROKU_IP 8085 > /tmp/roku_test_output_$$.txt 2>&1 &
    NC_PID=$!
    
    # Give nc time to establish connection
    sleep 5
    
    # Launch the dev channel with test parameters
    # Note: Roku ECP requires custom params as contentId with encoded key-value pairs
    echo "Launching dev channel with test parameters..."
    curl -s -d '' "http://$ROKU_IP:8060/launch/dev?contentId=RunUnitTests%3Dtrue"
    
    # Wait for tests to complete (increased time for network calls)
    echo "Waiting for tests to run..."
    sleep 60
    
    # Kill nc
    kill $NC_PID 2>/dev/null || true
    
    # Display results
    echo ""
    echo "📊 TEST RESULTS:"
    echo "================================================================"
    if [ -s /tmp/roku_test_output_$$.txt ]; then
        # Filter out system noise and show only test-related output
        grep -E "(Starting Unit Tests|Test directory|Found.*test|TestSuite__|MainTestSuite:|Total.*Passed.*Failed|Start testing|End testing|Unit Tests Complete)" /tmp/roku_test_output_$$.txt || {
            echo "⚠️  Test output not found in debug console. Showing last 50 lines:"
            tail -50 /tmp/roku_test_output_$$.txt
        }
        echo "================================================================"
        echo ""
        
        # Extract and display test summary if available
        if grep -q "Total.*Passed.*Failed" /tmp/roku_test_output_$$.txt; then
            echo "📈 SUMMARY:"
            grep "Total.*Passed.*Failed" /tmp/roku_test_output_$$.txt | tail -1
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

