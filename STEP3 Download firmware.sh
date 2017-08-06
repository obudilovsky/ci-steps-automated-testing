#!/bin/bash

HOMEDIR=`pwd`

if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "3" ]; then

    chmod -Rf 777 ${storage_root}/ 

        # -------------------- Check firmware --------------------

if [ -d ${storage_root}/${storage_branch}/${stor_build_type}/${num}/ ]; then
    cd ${storage_root}/${storage_branch}/${stor_build_type}/${num}/
    for file in $(ls); do
        if [[ ${file} == *.md5 ]]; then
            echo -e "Renaming $file to ${file::-4}"
            mv $file ${file::-4}
        elif [[ ${file} == *.tar ]]; then 
            echo -e "Firmware is already present"
        else
            echo -e "Firmware is not present. Downloading..."   
            # -------------------- Download  firmware --------------------
            python ${storage_root}/download_firmware_conf.py "${user}" "${passwd}" "${max_builds}" "${storage_root}" "${storage_branch}" "${stor_build_type}" "${num}"
            chmod -Rf 777 ${storage_root}/  
        fi
    done
else
    python ${storage_root}/download_firmware_conf.py "${user}" "${passwd}" "${max_builds}" "${storage_root}" "${storage_branch}" "${stor_build_type}" "${num}"
    chmod -Rf 777 ${storage_root}/ 
fi

    echo -e "Directory ${storage_root}/${storage_branch}/${stor_build_type}/${num}/ includes files:"
    ls ${storage_root}/${storage_branch}/${stor_build_type}/${num}/

        # -------------------- Flash device --------------------

    touch ${HOMEDIR}/path_to_firmware.txt 
    echo "---------------------------------- DONE ----------------------------------" >> ${HOMEDIR}/path_to_firmware.txt 
    echo "------------------------ Linux kernel downloaded -------------------------" >> ${HOMEDIR}/path_to_firmware.txt 

    if [ ${flash_device} == 1 ]; then

        # -------------------- Device checking --------------------

        ${PRJDIR}/check_device.sh ${DEVICEID}
        
        # -------------------- Flashing device by odin4linux --------------------

        echo -e "Flashing device by odin4linux..."
        /opt/android-sdk-linux/platform-tools/adb -s ${DEVICEID} reboot download
        sleep 60
        tty_id=$(dmesg | grep %env.USB_PORT% | grep ttyACM | tail -1 | awk '{print $4}' | awk -F':' '{print $1}') #Find tty port by USB_PORT
        echo "##teamcity[setParameter name='env.tty_id' value='${tty_id}']" 
        if [ -f ${storage_root}/${storage_branch}/${stor_build_type}/${num}/ALL* ]; then
            echo -e "Trying to flash ALL binary file..."
            ${PRJDIR}/odin4linuxnull ${storage_root}/${storage_branch}/${stor_build_type}/${num}/ALL* -d /dev/${tty_id}

        # -------------------- Device checking --------------------

            sleep 120
            ${PRJDIR}/check_device.sh ${DEVICEID}
    
        else
            echo -e "Unfortunately, the device can not be flashed by ALL binary. "ALL" file is not found"
            if [ -f ${storage_root}/${storage_branch}/${stor_build_type}/${num}/KERNEL* ]; then
                echo -e "Trying to flash KERNEL binary file..."
                ${PRJDIR}/odin4linuxnull ${storage_root}/${storage_branch}/${stor_build_type}/${num}/KERNEL* -d /dev/${tty_id}
                sleep 60
                ${PRJDIR}/check_device.sh ${DEVICEID}
            else
                echo -e "Unfortunately, the device can not be flashed also by KERNEL binary. Firmware is not found"
                exit 1
            fi
        fi
        ${PRJDIR}/check_device.sh ${DEVICEID}
        cat ${HOMEDIR}/path_to_firmware.txt
    else
        cat ${HOMEDIR}/path_to_firmware.txt 
    fi

        # -------------------- Rename binaries "*.tar" > "*.tar.md5" --------------------

    cd  ${storage_root}/${storage_branch}/${stor_build_type}/${num}/
    for file in $(ls); do
        if [[ "${file}" == "*.tar" ]]; then
            echo -e "Renaming $file to ${file}.md5"
            mv ${file} ${file}.md5
        elif [[ "${file}" == "*.md5" ]]; then 
            echo -e "$file is not renamed"
        else
            echo -e "Firmware is not present"
            exit 1          
        fi
    done
    chmod -Rf 777 ${storage_root}/ 
    exit 0

else
    exit 0
fi