#!/bin/bash
# Script to backup whatsapp data (locally, on the phone) and uninstall it
## The periodic phone backup will take care of copying the data out of the
## phone, asynchronously.

set -euo pipefail

pushd $(dirname $0)
./make-whatsapp-backup.sh
adb shell cmd package uninstall -k com.whatsapp
