#!/bin/bash

# RhoAI Training Setup Script
# This script calls install-components.sh with enable-hw-profile and configure-hw-profile

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Path to install-components.sh
INSTALL_SCRIPT="$SCRIPT_DIR/install-components.sh"

# Check if install-components.sh exists
if [ ! -f "$INSTALL_SCRIPT" ]; then
    echo "Error: install-components.sh not found at $INSTALL_SCRIPT"
    exit 1
fi

# Make sure install-components.sh is executable
chmod +x "$INSTALL_SCRIPT"

# Call install-components.sh with the hardware profile arguments
"$INSTALL_SCRIPT" enable-hw-profile configure-hw-profile

# Exit with the same exit code as install-components.sh
exit $?

