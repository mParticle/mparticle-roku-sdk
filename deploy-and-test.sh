#!/bin/bash

# Roku Test Deployment Script
# Usage: ./deploy-and-test.sh YOUR_ROKU_IP

set -u  # (optional) treat unset vars as errors; avoid set -e for now to not exit on grep

ROKU_IP=$1
ROKU_USER="rokudev"

if [ -z "$ROKU_IP" ]; then
    echo "❌ Error: Please provide your Roku IP address"
    echo "Usage: ./deploy-and-test.sh YOUR_ROKU_IP"
    exit 1
fi

# Get absolute path to script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Common test framework source
TEST_FRAMEWORK_SRC="$SCRIPT_DIR/testing/unit-testing-framework/UnitTestFramework.brs"

# Set paths for Scene Graph example
EXAMPLE_DIR="$SCRIPT_DIR/example-scenegraph-sdk"
ZIP_FILE="$SCRIPT_DIR/example-scenegraph-sdk.zip"
TEST_FRAMEWORK_DEST="$EXAMPLE_DIR/source/testFramework"

# Clean up old package if it exists
rm -f "$ZIP_FILE"

# Clean any cached build artifacts
if [ -f "$EXAMPLE_DIR/Makefile" ]; then
    echo "🧹 Cleaning build cache..."
    (
        cd "$EXAMPLE_DIR"
        make clean > /dev/null 2>&1 || true
    )
fi

echo "📦 Packaging Scene Graph example channel..."

# Temporarily copy test framework into the example app
echo "   Copying test framework..."
mkdir -p "$TEST_FRAMEWORK_DEST"
cp "$TEST_FRAMEWORK_SRC" "$TEST_FRAMEWORK_DEST/"

# Dereference mParticleTask symlinks by copying actual files
echo "   Copying mParticleTask files (dereferencing symlinks)..."
COMPONENTS_DIR="$EXAMPLE_DIR/components"
# Remove symlinks and copy actual files from root
rm -f "$COMPONENTS_DIR/mParticleTask.brs" "$COMPONENTS_DIR/mParticleTask.xml"
cp "$SCRIPT_DIR/mParticleTask.brs" "$COMPONENTS_DIR/mParticleTask.brs"
cp "$SCRIPT_DIR/mParticleTask.xml" "$COMPONENTS_DIR/mParticleTask.xml"

# Package the channel from the project root so manifest + source/ etc. are included
echo "   Creating zip package at $ZIP_FILE..."
(
    cd "$EXAMPLE_DIR"
    zip -r "$ZIP_FILE" . \
        -x "*.git*" \
        -x "*/.DS_Store" \
        -x "*.zip" \
        -x "*/dist/*" \
        -x "*.mk" \
        -x "Makefile" \
        > /dev/null 2>&1
)
ZIP_RESULT=$?

# Clean up temporary test framework
echo "   Cleaning up temporary test framework..."
rm -rf "$TEST_FRAMEWORK_DEST"

# Restore symlinks for mParticleTask files
echo "   Restoring mParticleTask symlinks..."
rm -f "$COMPONENTS_DIR/mParticleTask.brs" "$COMPONENTS_DIR/mParticleTask.xml"
(cd "$COMPONENTS_DIR" && ln -s ../../../mParticleTask.brs mParticleTask.brs)
(cd "$COMPONENTS_DIR" && ln -s ../../../mParticleTask.xml mParticleTask.xml)

# Check if zip was successful
if [ $ZIP_RESULT -ne 0 ]; then
    echo "❌ Failed to create package"
    exit 1
fi

echo "🧹 Clearing cache - deleting existing app..."
echo "   (You'll be prompted for your Roku developer password)"
curl --digest -s -S -F "mysubmit=Delete" -F "archive=" \
  -u "$ROKU_USER" \
  "http://$ROKU_IP/plugin_install" > /dev/null || true

# Press Home multiple times to ensure the app is fully closed
echo "   Waiting for Roku to process deletion..."
for i in {1..5}; do
    curl -s -d '' "http://$ROKU_IP:8060/keypress/Home" > /dev/null 2>&1
    sleep 0.5
done
sleep 5

echo ""
echo "🚀 Deploying to Roku at $ROKU_IP..."
echo "   (Enter the same password again)"

# Capture full installer response, don't pipe to grep directly
INSTALL_OUTPUT=$(
  curl --digest -s -S -F "mysubmit=Install" -F "archive=@$ZIP_FILE" \
    -u "$ROKU_USER" \
    "http://$ROKU_IP/plugin_install"
)

# Uncomment this if you want to see the raw HTML response for debugging
# echo "---- INSTALLER RESPONSE ----"
# echo "$INSTALL_OUTPUT"
# echo "----------------------------"

if echo "$INSTALL_OUTPUT" | grep -qi "Install Success"; then
    echo ""
    echo "✅ Scene Graph example channel deployed successfully!"
else
    echo "❌ Deployment failed. Roku did NOT report 'Install Success'."
    echo ""
    echo "Installer response:"
    echo "$INSTALL_OUTPUT"
    exit 1
fi

echo ""
echo "🧪 Running unit tests..."
echo "   The app will auto-detect fresh deployment and run tests automatically"
echo ""

# Press Home to stop any auto-launched app
echo "   Ensuring app is fully stopped..."
for i in {1..5}; do
    curl -s -d '' "http://$ROKU_IP:8060/keypress/Home" > /dev/null 2>&1
    sleep 0.5
done
sleep 3

# Start capturing debug console output BEFORE we launch
echo "   Starting debug console capture..."
nc "$ROKU_IP" 8085 > "/tmp/roku_test_output_$$.txt" 2>&1 &
NC_PID=$!
sleep 2

# Launch the dev channel - it will auto-detect deployment and run tests
echo "   Launching dev channel..."
curl -s -d '' "http://$ROKU_IP:8060/launch/dev" > /dev/null 2>&1

# Wait for tests to complete
echo "   Waiting for tests to complete (60 seconds)..."
sleep 60

# Kill nc
kill "$NC_PID" 2>/dev/null || true

# Display results
echo ""
echo "📊 TEST RESULTS:"
echo "================================================================"
if [ -s "/tmp/roku_test_output_$$.txt" ]; then
    grep -E "(Starting Unit Tests|Test directory|Found.*test|TestSuite__|MainTestSuite:|Total.*Passed.*Failed|Start testing|End testing|Unit Tests Complete)" \
        "/tmp/roku_test_output_$$.txt" || {
        echo "⚠️  Test output not found in debug console. Showing last 50 lines:"
        tail -50 "/tmp/roku_test_output_$$.txt"
    }
    echo "================================================================"
    echo ""

    if grep -q "Total.*Passed.*Failed" "/tmp/roku_test_output_$$.txt"; then
        echo "📈 SUMMARY:"
        grep "Total.*Passed.*Failed" "/tmp/roku_test_output_$$.txt" | tail -1
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

# Save a copy of the output for debugging
cp "/tmp/roku_test_output_$$.txt" "last_test_output.log" 2>/dev/null || true
echo "📝 Full test output saved to: last_test_output.log"

# Cleanup
rm -f "/tmp/roku_test_output_$$.txt"