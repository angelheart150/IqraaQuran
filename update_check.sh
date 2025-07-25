#!/bin/bash
# Update checker script
REMOTE_URL="https://raw.githubusercontent.com/angelheart150/IqraaQuran/main/version"
LOCAL_VERSION_FILE="/usr/lib/enigma2/python/Plugins/Extensions/IqraaQuran/version"

# Get versions
REMOTE_VERSION=$(curl -s $REMOTE_URL | grep "CURRENT_VERSION" | cut -d'"' -f2)
LOCAL_VERSION=$(grep "CURRENT_VERSION" $LOCAL_VERSION_FILE 2>/dev/null | cut -d'"' -f2)

# Compare versions
if [ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]; then
    echo "UPDATE_AVAILABLE:1"
    echo "REMOTE_VERSION:$REMOTE_VERSION"
    echo "LOCAL_VERSION:$LOCAL_VERSION"
    echo "MESSAGE:New version available! Please run installer."
else
    echo "UPDATE_AVAILABLE:0"
    echo "MESSAGE:You have the latest version ($LOCAL_VERSION)"
fi