#!/bin/bash

HOMEDIR=`pwd`

if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "1" ] || [ ${BUILD_MODE} == "2" ]; then

    # -------------------- Add custom options of .config --------------------

    IFS=''

    if ! [[ ${custom_options} == "" ]]; then

        cd ${HOMEDIR}/part2/
        sed -i '/#.*/g' .config && sed -i '/^$/d' .config
        touch custom_options.txt
        echo ${custom_options} > custom_options.txt
        cat custom_options.txt | tr -d ' ' > custom_options_notr.txt
        cat custom_options_notr.txt > custom_options.txt
        while read line; do
              if ! [[ $(cat .config | awk -F '=' '{print $1}' | grep "$(echo ${line} | awk -F '=' '{print $1}')") == "" ]]; then
                 echo -e "Update ${line} >> .config"
                 sed -i "s/^$(echo ${line} | awk -F '=' '{print $1}').*/${line}/g" .config
              else
                 echo -e "Add ${line} >> .config"
                 echo ${line} >> .config
              fi
        done < custom_options.txt
    fi
    dos2unix .config

else
	exit 0
fi