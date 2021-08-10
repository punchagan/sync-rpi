#!/bin/bash
# Script to backup whatsapp data and uninstall it

set -euo pipefail

pushd $(dirname $0)
./make-whatsapp-backup.sh
./phone.sh
adb shell cmd package uninstall -k com.whatsapp
