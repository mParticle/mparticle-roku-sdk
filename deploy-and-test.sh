#!/bin/bash

# Roku Test Deployment Script
# Usage: ./deploy-and-test.sh YOUR_ROKU_IP

ROKU_IP=$1
ROKU_USER="rokudev"
ZIP_FILE="example-legacy-sdk.zip"

if [ -z "$ROKU_IP" ]; then
    echo "❌ Error: Please provide your Roku IP address"
    echo "Usage: ./deploy-and-test.sh YOUR_ROKU_IP"
    exit 1
fi

# Clean up old package if it exists
rm -f "$ZIP_FILE"

echo "📦 Packaging channel..."
cd "$(dirname "$0")/example-legacy-sdk"
zip -r ../$ZIP_FILE . -x "*.git*" -x "*/.DS_Store" -x "*.zip" > /dev/null 2>&1
cd ..

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
    
    # Start nc in background to capture output
    nc $ROKU_IP 8085 > /tmp/roku_test_output_$$.txt 2>&1 &
    NC_PID=$!
    
    # Give nc time to connect
    sleep 2
    
    # Trigger tests
    curl -s -d '' "http://$ROKU_IP:8060/launch/dev?RunUnitTests=true" > /dev/null
    
    # Wait for tests to complete
    sleep 15
    
    # Kill nc
    kill $NC_PID 2>/dev/null || true
    
    # Display results
    echo "📊 TEST RESULTS:"
    echo "================================================================"
    cat /tmp/roku_test_output_$$.txt
    echo "================================================================"
    
    # Cleanup
    rm -f /tmp/roku_test_output_$$.txt
else
    echo "❌ Deployment failed. Check your Roku IP and password."
fi

