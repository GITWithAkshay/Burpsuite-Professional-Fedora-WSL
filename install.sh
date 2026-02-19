#!/bin/bash

# Burpsuite Professional Installer for Fedora Linux (WSL Compatible)
# Run this script from within the Burpsuite-Professional directory

set -e  # Exit on error

echo "==================================="
echo "Burpsuite Professional Installer"
echo "Fedora Linux / WSL"
echo "==================================="
echo ""

# Check if running in WSL
if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "✓ WSL environment detected"
    export DISPLAY=${DISPLAY:-:0}
    echo "  Display set to: $DISPLAY"
    echo ""
fi

# Installing Dependencies
echo "Installing Dependencies..."
sudo dnf update -y
sudo dnf install -y git wget java-21-openjdk java-21-openjdk-devel

# Verify Java installation
echo ""
echo "Verifying Java installation..."
java -version

# Download Burpsuite Professional
echo ""
echo "Downloading Burp Suite Professional Latest..."
version=2026
if [ ! -f "burpsuite_pro_v$version.jar" ]; then
    wget -O burpsuite_pro_v$version.jar https://github.com/xiv3r/Burpsuite-Professional/releases/download/burpsuite-pro/burpsuite_pro_v$version.jar
    echo "✓ Burpsuite Professional downloaded"
else
    echo "✓ Burpsuite Professional already exists"
fi

# Check if loader.jar exists
if [ ! -f "loader.jar" ]; then
    echo "ERROR: loader.jar not found in current directory"
    echo "Please ensure you have all required files"
    exit 1
fi

# Create launcher script
echo ""
echo "Creating launcher script..."
cat > burpsuitepro << EOF
#!/bin/bash
# Burpsuite Professional Launcher

# Set display for WSL if needed
if grep -qi microsoft /proc/version 2>/dev/null; then
    export DISPLAY=\${DISPLAY:-:0}
fi

# Get script directory
SCRIPT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")" && pwd)"

# Start loader in background
java -jar "\$SCRIPT_DIR/loader.jar" &
LOADER_PID=\$!

# Wait a moment for loader to initialize
sleep 2

# Launch Burpsuite Professional
java --add-opens=java.desktop/javax.swing=ALL-UNNAMED \\
     --add-opens=java.base/java.lang=ALL-UNNAMED \\
     --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED \\
     --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED \\
     --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED \\
     -javaagent:"\$SCRIPT_DIR/loader.jar" \\
     -noverify \\
     -jar "\$SCRIPT_DIR/burpsuite_pro_v$version.jar"

# Clean up loader process on exit
kill \$LOADER_PID 2>/dev/null || true
EOF

chmod +x burpsuitepro

# Install system-wide
echo ""
echo "Installing system-wide launcher..."
sudo cp burpsuitepro /usr/local/bin/burpsuitepro
echo "✓ Launcher installed to /usr/local/bin/burpsuitepro"

echo ""
echo "==================================="
echo "Installation Complete!"
echo "==================================="
echo ""
echo "To run Burpsuite Professional, use:"
echo "  burpsuitepro"
echo ""
echo "Note: The loader will start automatically with the GUI."
echo "      Copy license keys between the loader and Burpsuite"
echo "      windows for activation."
echo ""

if grep -qi microsoft /proc/version 2>/dev/null; then
    echo "WSL Notes:"
    echo "  - Make sure you have WSLg installed (Windows 11 or updated Windows 10)"
    echo "  - GUI applications should work automatically"
    echo "  - If GUI doesn't appear, try: export DISPLAY=:0"
    echo ""
fi
