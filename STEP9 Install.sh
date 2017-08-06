#!/bin/bash

HOMEDIR=`pwd`

if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "1" ]; then
    
    export PATH="$PATH:/opt/android-sdk-linux/platform-tools"
    echo -e "Installing to device..."
    /opt/android-sdk-linux/platform-tools/adb -s ${DEVICEID} shell su -c "setenforce 0"
    make -C ${HOMEDIR}/ install-target DEVICE_ID=${DEVICEID}
    /opt/android-sdk-linux/platform-tools/adb -s ${DEVICEID} shell sync

else
    exit 0
fi