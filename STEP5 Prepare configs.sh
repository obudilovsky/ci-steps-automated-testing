#!/bin/bash

HOMEDIR=`pwd`

if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "1" ] || [ ${BUILD_MODE} == "2" ]; then
 
        # -------------------- Copy and changing default config.mk --------------------

    cd ${HOMEDIR}/part1/
    echo -e "config.mk.default ==> config.mk"
    cp config.mk.default config.mk

    echo -e "CONFIG_ENV = android"
    sed -i "s/^CONFIG_ENV =.*/CONFIG_ENV = android/g" config.mk
   
    case ${PLATFORM} in
		"PLATFORM_A"|"PLATFORM_B"|"PLATFORM_C"|"PLATFORM_D")
	
			echo -e "CONFIG = Linux"
			sed -i "s/^CONFIG =.*/CONFIG = Linux/g" config.mk			
		;;

		"PLATFORM_E")
					
			echo -e "CONFIG = SELinux"
			sed -i "s/^CONFIG =.*/CONFIG = SELinux/g" config.mk			
		;;

	esac

    echo -e "CONFIG_ROOT = /opt/Android/android"
    sed -i "s/^CONFIG_ROOT =.*/CONFIG_ROOT = \/opt\/Android\/android\//g" config.mk
	
   
    # -------------------- Check .config --------------------

    if ! [[ -f ${HOMEDIR}/part2/.attach ]]; then
        echo -e "==> .attach doesn't exist"
        exit 1
    fi
	
else
   exit 0
fi