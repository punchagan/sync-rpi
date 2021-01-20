#!/bin/bash
# Script to sync folders from the Phone
## See README for documentation

set -e

# FIXME: Hard-coded phone IP, should be able to discover it?
PHONE_IP=192.168.1.100
ADB_PORT=5555
TARGET_DIR=/mnt/hdd/PhoneBackup
SRC_DIRS=("DCIM" "Download" "Notes" "Pictures" "Record" "VoiceRecorder" "WhatsApp")

# Check if adb exists
command -v adb || (echo "Please Install adb: sudo apt install adb" && false)

# Check adb-sync exists
command -v adb-sync || (echo "Please Install adb-sync: https://github.com/google/adb-sync and ensure it is on \$PATH" && false)

# Check if Phone is connected
ping -q -c 1 -W 3 $PHONE_IP || (echo "Incorrect Phone IP address: $PHONE_IP" && false)

# Connect to phone
adb connect "$PHONE_IP:$ADB_PORT" | sed '/connected to/!{q42}'

# Sync videos
for dir in ${SRC_DIRS[@]}; do
    echo "Backing up /sdcard/${dir} ..."
    adb-sync --reverse "/sdcard/${dir}" "$TARGET_DIR"
done
