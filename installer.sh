#!/bin/bash
# ==============================================
# INSTALLATION SCRIPT FOR IqraaQuran PLUGIN
# Command: wget https://raw.githubusercontent.com/angelheart150/IqraaQuran/main/installer.sh -O - | /bin/sh #
# ================================================================
# Preparing colors for printing
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'
PACKAGE_DIR="IqraaQuran/main"
MY_MAIN_URL="https://raw.githubusercontent.com/angelheart150/"
BASE_URL="${MY_MAIN_URL}${PACKAGE_DIR}/"
# ---------------------------
# The internet connection verification function
# ---------------------------
if ! ping -c 1 github.com >/dev/null 2>&1; then
    echo -e "${RED}ERROR: No internet connection!${RESET}"
    exit 1
fi
# ---------------------------
# Python version detection function
# ---------------------------
detect_python_version() {
    if command -v python3 &>/dev/null; then
        PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}' | cut -d'.' -f1-2)
    elif command -v python &>/dev/null; then
        PYTHON_VERSION=$(python --version 2>&1 | awk '{print $2}' | cut -d'.' -f1-2)
    else
        echo -e "${RED}ERROR: Python is not installed in this Image! Please install Python 3.9 or higher.${RESET}"
        exit 1
    fi
    MIN_VERSION="3.9"
    if [[ "$(printf '%s\n' "$MIN_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" != "$MIN_VERSION" ]]; then
        echo -e "${RED}ERROR: Image Python is $PYTHON_VERSION It isn't supported . i can installed on 3.9,3.10,3.11,3.12 and 3.13.${RESET}"
        exit 1
    fi
    echo "$PYTHON_VERSION"
}
# ---------------------------
# Start installation
# ---------------------------
echo -e "${YELLOW}************************************************************${RESET}"
echo -e "${GREEN}**           IqraaQuran Plugin Installer STARTED           **${RESET}"
echo -e "${YELLOW}************************************************************${RESET}"
echo '************************************************************'
echo "**              Developed by: Angel_heart                 **"
echo "**  https://www.tunisia-sat.com/forums/threads/4477396/   **"
echo '************************************************************'
PY_VER=$(detect_python_version)
# Determine the name of the file based on the Python version
IPK="enigma2-plugin-extensions-iqraaquran_1.1.py${PY_VER}_all.ipk"
MY_URL="${BASE_URL}${IPK}"
MY_TMP_FILE="/tmp/${IPK}"
# ---------------------------
# Check for updates
# ---------------------------
echo "Checking for updates..."
REMOTE_VERSION=$(curl -s "${BASE_URL}version" | grep "CURRENT_VERSION" | cut -d'"' -f2)
LOCAL_VERSION=$(grep "CURRENT_VERSION" /usr/lib/enigma2/python/Plugins/Extensions/IqraaQuran/__init__.py 2>/dev/null | cut -d'"' -f2)
if [ -z "$REMOTE_VERSION" ]; then
    echo -e "${RED}ERROR: Could not retrieve remote version.${RESET}"
    exit 1
fi
if [ -z "$LOCAL_VERSION" ]; then
    echo -e "${YELLOW}Local version not found. Assuming fresh install...${RESET}"
else
    COMPARE_RESULT=$(printf '%s\n' "$REMOTE_VERSION" "$LOCAL_VERSION" | sort -V | head -n1)
    if [ "$REMOTE_VERSION" = "$LOCAL_VERSION" ]; then
        echo "=============================================="
        echo "You already have the latest version: $LOCAL_VERSION"
        echo "No update needed."
        echo "=============================================="
        exit 0
    elif [ "$COMPARE_RESULT" = "$REMOTE_VERSION" ]; then
        echo "=============================================="
        echo "You already have version: $LOCAL_VERSION"
        echo "No update needed."
        echo "=============================================="
        exit 0
    fi
fi
echo "=============================================="
echo "NEW VERSION $REMOTE_VERSION AVAILABLE!"
echo "CURRENT VERSION: ${LOCAL_VERSION:-None}"
echo "=============================================="
if wget -q -O /tmp/changelog.txt "${BASE_URL}changelog.txt"; then
    echo "CHANGELOG:"
    cat /tmp/changelog.txt
    echo ""
else
    echo "No changelog available"
fi
echo "=============================================="
# ---------------------------
# Download and install package
# ---------------------------
echo "Downloading package for Python $PY_VER..."
sleep 2
if wget -T 15 -q "$MY_URL" -P "/tmp/"; then
    echo "Installing package..."
    sleep 2
    if opkg install --force-reinstall "$MY_TMP_FILE"; then
        echo -e "${GREEN}SUCCESSFULLY INSTALLED${RESET}"
        echo "Restarting enigma2..."
        killall -9 enigma2
    else
        echo -e "${RED}INSTALLATION FAILED!${RESET}"
        exit 1
    fi
else
    echo -e "${RED}DOWNLOAD FAILED: $MY_URL${RESET}"
    exit 1
fi
exit 0