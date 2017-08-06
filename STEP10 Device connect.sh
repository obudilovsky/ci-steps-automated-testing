#!/bin/bash

#Descriprion of BUILD_MODE variable
#Download QB firmware, install BF and run tests => 0
#Install BF and run tests => 1
#Run tests => 2
#Download QB firmware => 3

if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "1" ] || [ ${BUILD_MODE} == "2" ]; then

    ${PRJDIR}/check_device.sh ${DEVICEID}

else
    exit 0
fi