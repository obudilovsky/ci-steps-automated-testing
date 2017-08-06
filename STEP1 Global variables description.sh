#!/bin/bash

HOMEDIR=`pwd`

#Descriprion of BUILD_MODE variable
#Download firmware, install and run tests => 0
#Install and run tests => 1
#Run tests => 2
#Download firmware => 3

if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "1" ] || [ ${BUILD_MODE} == "2" ] || [[ ${BUILD_MODE} == "3" && ${flash_device} == "1" ]]; then 
  if [[ ${DEVICEID} == "" ]]; then

    case ${PLATFORM} in
    "PLATFORM_A")
        echo "##teamcity[setParameter name='env.DEVICEID' value='c177dc82']"                    #Change device id for next steps
        DEVICEID=c177dc82
    ;;
    "PLATFORM_B")                                                                      
        echo "No necessary devices"
        echo "##teamcity[setParameter name='env.DEVICEID' value='']"                            #Change device id for next steps
        DEVICEID=
    ;;
    "PLATFORM_C" | "PLATFORM_D" | "PLATFORM_E")
        echo "##teamcity[setParameter name='env.DEVICEID' value='12147dec84327a0b']"            #Change device id for next steps
        DEVICEID=12147dec84327a0b
    ;;
    "PLATFORM_F")
        echo "No necessary devices"
        echo "##teamcity[setParameter name='env.DEVICEID' value='']"                            #Change device id for next steps
        DEVICEID=
    ;;
    "PLATFORM_G")
        echo "No necessary devices"
        echo "##teamcity[setParameter name='env.DEVICEID' value='']"                            #Change device id for next steps
        DEVICEID=
    ;;
    esac
  fi
  echo "##teamcity[setParameter name='env.USB_PORT' value='$(/opt/android-sdk-linux/platform-tools/adb -s ${DEVICEID} get-devpath | awk -F':' '{print $2}')']" #Find USB_ID by DEVICEID
fi

case ${PLATFORM} in
    "PLATFORM_A")
        echo "##teamcity[setParameter name='env.storage_branch' value='PLATFORM_A']"        #Change storage branch for next steps
    ;;
    "PLATFORM_B")
        echo -e "Unable to download firmware for PLATFORM_B"
        exit 1
    ;;
    "PLATFORM_C" | "PLATFORM_D" | "PLATFORM_E")
        echo "##teamcity[setParameter name='env.storage_branch' value='PLATFORM_C_D_E']" #Change storage branch for next steps
    ;;
    "PLATFORM_F")
        echo "##teamcity[setParameter name='env.storage_branch' value='PLATFORM_F']"      #Change storage branch for next steps
    ;;
    "PLATFORM_G")
        echo "##teamcity[setParameter name='env.storage_branch' value='PLATFORM_G']"     #Change storage branch for next steps
    ;;
esac