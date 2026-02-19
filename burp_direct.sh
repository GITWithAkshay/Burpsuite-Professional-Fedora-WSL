#!/bin/bash
# Burpsuite Professional Direct Launcher (No Loader)
# Use this after initial license activation

# Set display for WSL if needed
if grep -qi microsoft /proc/version 2>/dev/null; then
    export DISPLAY=${DISPLAY:-:0}
fi

# Installation directory
INSTALL_DIR="/root/Burpsuite-Professional-Fedora-WSL"

# Verify required files exist
if [ ! -f "$INSTALL_DIR/burpsuite_pro_v2026.jar" ]; then
    echo "ERROR: Burpsuite jar not found in $INSTALL_DIR"
    echo "Please reinstall Burpsuite Professional"
    exit 1
fi

if [ ! -f "$INSTALL_DIR/loader.jar" ]; then
    echo "ERROR: loader.jar not found in $INSTALL_DIR"
    echo "The loader is required to maintain license activation"
    exit 1
fi

# Launch Burpsuite Professional with javaagent (no loader GUI)
java --add-opens=java.desktop/javax.swing=ALL-UNNAMED \
     --add-opens=java.base/java.lang=ALL-UNNAMED \
     --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \
     --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \
     --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \
     -javaagent:"$INSTALL_DIR/loader.jar" \
     -noverify \
     -jar "$INSTALL_DIR/burpsuite_pro_v2026.jar"
