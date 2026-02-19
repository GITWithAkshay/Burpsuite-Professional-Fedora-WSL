#!/bin/bash
# Burpsuite Professional Launche

# Set display for WSL if needed
if grep -qi microsoft /proc/version 2>/dev/null; then
    export DISPLAY=${DISPLAY:-:0}
fi

# Installation directory
INSTALL_DIR="/root/Burpsuite-Professional-Fedora-WSL"

# Verify files exist
if [ ! -f "$INSTALL_DIR/loader.jar" ] || [ ! -f "$INSTALL_DIR/burpsuite_pro_v2026.jar" ]; then
    echo "ERROR: Required files not found in $INSTALL_DIR"
    echo "Please run with sudo: sudo burpsuitepro"
    exit 1
fi

# Start loader in background
java -jar "$INSTALL_DIR/loader.jar" &
LOADER_PID=$!

# Wait a moment for loader to initialize
sleep 2

# Launch Burpsuite Professional
java --add-opens=java.desktop/javax.swing=ALL-UNNAMED \
     --add-opens=java.base/java.lang=ALL-UNNAMED \
     --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \
     --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \
     --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \
     -javaagent:"$INSTALL_DIR/loader.jar" \
     -noverify \
     -jar "$INSTALL_DIR/burpsuite_pro_v2026.jar"

# Clean up loader process on exit
kill $LOADER_PID 2>/dev/null || true
