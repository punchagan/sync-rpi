#!/bin/bash
set -e

PHONE_IP=192.168.1.100
TARGET_DIR=/mnt/hdd/PhoneBackup
SRC_DIRS=("DCIM" "Download" "Notes" "Pictures" "Record" "VoiceRecorder" "WhatsApp")

# Check adb-sync exists
command -v adb-sync

# Connect to phone
adb connect "$PHONE_IP:5555"

# Sync videos
for dir in ${SRC_DIRS[@]}; do
    echo "Backing up /sdcard/${dir} ..."
    adb-sync --reverse "/sdcard/${dir}" "$TARGET_DIR"
done