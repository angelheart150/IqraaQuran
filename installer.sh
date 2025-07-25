#!/bin/bash
# ==============================================
# INSTALLATION SCRIPT FOR IqraaQuran PLUGIN
# Command: wget https://raw.githubusercontent.com/angelheart150/IqraaQuran/main/installer.sh -O - | /bin/sh #
# ==================================================================
PACKAGE_DIR='IqraaQuran/main'
IPK="enigma2-plugin-extensions-iqraaquran_1.1.py3_all.ipk"
MY_MAIN_URL="https://raw.githubusercontent.com/angelheart150/"
MY_URL=$MY_MAIN_URL$PACKAGE_DIR'/'$IPK
MY_TMP_FILE="/tmp/"$IPK

# Check internet connection
if ! ping -c 1 github.com >/dev/null 2>&1; then
    echo "ERROR: No internet connection!"
    exit 1
fi

echo ''
echo '************************************************************'
echo '**                         STARTED                        **'
echo '************************************************************'
echo "**              Developed by: Angel_heart                  **"
echo "**  https://www.tunisia-sat.com/forums/threads/4477396/   **"
echo "************************************************************"
echo ''

# Check for updates
echo "Checking for updates..."
REMOTE_VERSION=$(curl -s https://raw.githubusercontent.com/angelheart150/IqraaQuran/main/version | grep "CURRENT_VERSION" | cut -d'"' -f2)
LOCAL_VERSION=$(grep "CURRENT_VERSION" /usr/lib/enigma2/python/Plugins/Extensions/IqraaQuran/__init__.py 2>/dev/null | cut -d'"' -f2)

if [ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]; then
    echo "=============================================="
    echo "NEW VERSION $REMOTE_VERSION AVAILABLE!"
    echo "CURRENT VERSION: $LOCAL_VERSION"
    echo "=============================================="
    if wget -q -O /tmp/changelog.txt $MY_MAIN_URL$PACKAGE_DIR'/changelog.txt'; then
        echo "CHANGELOG:"
        cat /tmp/changelog.txt
    else
        echo "No changelog available"
    fi
    echo "=============================================="
    sleep 5
fi

# Download and install package
echo "Downloading package..."
if wget -T 15 -q $MY_URL -P "/tmp/"; then
    echo "Installing package..."
    if opkg install --force-reinstall $MY_TMP_FILE; then
        echo "SUCCESSFULLY INSTALLED"
        echo "Restarting enigma2..."
        if which systemctl >/dev/null 2>&1; then
            systemctl restart enigma2
        else
            killall -9 enigma2
        fi
    else
        echo "INSTALLATION FAILED!"
        exit 1
    fi
else
    echo "DOWNLOAD FAILED!"
    exit 1
fi

exit 0