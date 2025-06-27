#!/bin/bash

echo "Testing QLC+ Plugin Loading..."
echo "=============================="

# Kill any existing QLC+ processes
pkill -f qlcplus

# Wait a moment
sleep 2

# Start QLC+ with debug output and capture plugin loading messages
cd /Users/branson/git/qlcplus
timeout 10s ./main/qlcplus --debug 2>&1 | grep -i "plugin\|artnet\|dmx\|usb" | head -20

echo ""
echo "Plugin files in PlugIns directory:"
echo "=================================="
ls -la PlugIns/*.dylib

echo ""
echo "Test completed. If you see plugin loading messages above, the plugins are working!"
