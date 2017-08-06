#!/bin/bash

HOMEDIR=`pwd`

if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "1" ] || [ ${BUILD_MODE} == "2" ] || [[ ${BUILD_MODE} == "3" && ${flash_device} == "1" ]]; then 
   
   ${PRJDIR}/check_device.sh ${DEVICEID}
   if ! [[ $(/opt/android-sdk-linux/platform-tools/adb devices -l | grep "${DEVICEID}") == "" ]]; then
       if [[ $(/home/DEVICES/devices_status_update.sh -s "${DEVICEID}" --get_status | grep "EXITCODE" |awk -F'=' '{ print $2}') == "0" ]]; then
           /home/DEVICES/devices_status_update.sh -s "${DEVICEID}" --set_status 1
       fi
   else 
       /home/DEVICES/devices_status_update.sh -s "${DEVICEID}" --set_status 2
   fi
else
    exit 0
fi