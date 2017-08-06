#!/bin/bash

echo "=========== $(dirname $(readlink -f $0))"
HOMEDIR=`pwd`

if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "1" ] || [ ${BUILD_MODE} == "2" ]; then

  sleep 20
  export PATH="$PATH:/opt/android-sdk-linux/platform-tools"
  python /$PRJDIR/checklog.py "pr" "/opt/android-sdk-linux/platform-tools/adb -s ${DEVICEID} shell ps | grep pr" "Running - SUCCESS" "Running - ERROR"
  sleep 20
  python /$PRJDIR/checklog.py "passed" "/opt/android-sdk-linux/platform-tools/adb -s ${DEVICEID} shell /system/test" "Checked test - SUCCESS" "Checked test - ERROR"

  cd ${HOMEDIR}/
  make check TARGET=PLATFORM_A  DEVICE_ID=${DEVICEID}
  TARGET_LOG=${DEVICEID}
  cd ${HOMEDIR}/logs/; mkdir failed/
  cd ${HOMEDIR}/logs/${TARGET_LOG}.log.latest/
  for file in $(ls | grep failed); do
    cp -v $(echo $file | sed 's/\..*//')* ${HOMEDIR}/logs/failed/
  done

else
    exit 0
fi