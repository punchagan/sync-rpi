#!/bin/bash
# Script to sync folders from the Phone
## See README for documentation

set -e

pushd $(dirname $0)
source .envrc

ADB_PORT=5555
TARGET_DIR=/mnt/backup-drive/PhoneBackup
SRC_DIRS=("DCIM" "Download" "Notes" "Pictures" "Recorders" "WhatsApp")


function check_setup () {
    # Check if adb exists
    command -v adb || (echo "Please Install adb: sudo apt install adb" && false)

    # Check adb-sync exists
    command -v adb-sync || (echo "Please Install adb-sync: https://github.com/google/adb-sync and ensure it is on \$PATH" && false)

    # Check if Phone is connected
    ping -q -c 1 -W 3 $PHONE_IP || (echo "Incorrect Phone IP address: $PHONE_IP" && false)
}

# Check system setup before
check_setup

# Connect to phone
# FIXME: Hard-coded phone IP, should be able to discover it?
adb connect "$PHONE_IP:$ADB_PORT" | sed '/connected to/!{q42}'

# Sync directories
for dir in ${SRC_DIRS[@]}; do
    echo "LOG:$(date -Iseconds): Backing up /sdcard/${dir} ..."
    adb-sync --reverse "/sdcard/${dir}" "$TARGET_DIR"
done

echo "LOG:$(date -Iseconds):Successfully finished backup"
