#!/bin/bash
# Script that automates clicking around and creating a WhatsApp backup on the phone

set -euo pipefail

function wait-until-backup {
    sleep 5;
    set +e
    while true;
    do
        adb shell input tap 100 100  # prevent screen locking
        $(adb shell uiautomator dump --compressed | grep -q dumped) && break
    done
    adb pull /sdcard/window_dump.xml
    set -e
}

function cancel-upload {
    sleep 5;
    set +e
    while true;
    do
        click-description "com.whatsapp:id/cancel_download" && break
    done
    set -e
}

function click-description {
    adb shell uiautomator dump --compressed
    adb pull /sdcard/window_dump.xml
    xy=$(grep -oEe "<node[^<>]*?${1}[^<>]*/>" window_dump.xml|grep -oEe '\[([0-9,]*)\]'| sed -e 's/\[//;s/\]//;s/,/ /'|head -n 1)
    adb shell input tap ${xy}
}

adb shell am start -n com.whatsapp/com.whatsapp.Main
click-description "More options"
click-description "Settings"
click-description "Chats"
click-description "Chat backup"
click-description "com.whatsapp:id/google_drive_backup_now_btn"
wait-until-backup
cancel-upload
adb shell am start -n com.whatsapp/com.whatsapp.Main
