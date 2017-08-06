#!/bin/bash

HOMEDIR=`pwd`
WORKDIR_part1="${HOMEDIR}/../CustomBuildsPart1"
WORKDIR_part2="${HOMEDIR}/../CustomBuildsPart2"



if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "1" ] || [ ${BUILD_MODE} == "2" ]; then

        # -------------------- Functions --------------------

    function revert ()

    {
        if [[ %teamcity.agent.name% == "Build-xxx" ]]; then
           export P4WORKSPACE=FIRMWARE_REPO_Build-xxx
        elif [[ %teamcity.agent.name% == "SQA-Servx" ]]; then
           export P4WORKSPACE=FIRMWARE_REPO_SQA-Servx
        elif [[ %teamcity.agent.name% == "Build-sdax" ]]; then
           export P4WORKSPACE=FIRMWARE_REPO_Build-sdax
        elif [[ %teamcity.agent.name% == "xxxsd" ]]; then
           export P4WORKSPACE=FIRMWARE_REPO_xxxsd
        fi


        /usr/local/bin/p4 -c $P4WORKSPACE revert //... > /dev/null
        echo -e "==> p4 revert $P4WORKSPACE"
    }

    function get_revision  ()

    {
        if [[ $1 != "" ]]; then
               /usr/local/bin/p4 -c $P4WORKSPACE sync -f -q $P4BRANCH/part2/...@$1
               echo -e "==> p4 sync -f -q $P4BRANCH/part2/...$1"
        else 
                echo -e "==> p4 changes -m 1 -s submitted $P4BRANCH/part2/..."
                /usr/local/bin/p4 -c $P4WORKSPACE changes -m 1 -s submitted $P4BRANCH/part2/...
                /usr/local/bin/p4 -c $P4WORKSPACE changes -m 1 -s submitted $P4BRANCH/part2/... > ./sync_ver
                SYNC_CHANGELIST='@'`cat ./sync_ver | awk '{ print $2 }'`
                rm sync_ver
                echo -e "==> p4 get part2 last revision ...$SYNC_CHANGELIST"
                /usr/local/bin/p4 -c $P4WORKSPACE sync -f -q $P4BRANCH/part2/...$SYNC_CHANGELIST
        fi
        if [[ $2 != "" ]]; then
               echo -e "==> p4 sync -f -q $P4BRANCH/part1/...$2"
              /usr/local/bin/p4 -c $P4WORKSPACE sync -f -q $P4BRANCH/part1/...@$2
        else 
                echo -e "==> p4 changes -m 1 -s submitted $P4BRANCH/part1/..."
                /usr/local/bin/p4 -c $P4WORKSPACE changes -m 1 -s submitted $P4BRANCH/part1/...
                /usr/local/bin/p4 -c $P4WORKSPACE changes -m 1 -s submitted $P4BRANCH/part1/... > ./sync_ver
                SYNC_CHANGELIST='@'`cat ./sync_ver | awk '{ print $2 }'`
                rm sync_ver
                echo -e "==> p4 get part1 last revision ...$SYNC_CHANGELIST"
                /usr/local/bin/p4 -c $P4WORKSPACE sync -f -q $P4BRANCH/part1/...$SYNC_CHANGELIST

        fi
    }

    function unshelving ()  

    {
        if [[ $1 != "" ]]; then
            echo -e "==> p4 unshelve -s $1 -f"
           #/usr/local/bin/p4 -c $P4WORKSPACE unshelve -s $1 -f
           ${PRJDIR}/checklog.sh "n" "/usr/local/bin/p4 -c $P4WORKSPACE unshelve -s $1 -f" " must resolve " "Unshelved $1 - !!!Merging conflict: must resolve changes before submitting" "Unshelved $1 - SUCCESS" || exit 1
         fi
    }

        # -------------------- Revert --------------------

    revert

        # -------------------- Get revision  --------------------

    get_revision $CHANGELIST_SK $CHANGELIST_PART1

        # -------------------- Unshelve --------------------

   if ! [[ ${SHELVES} == "" ]]; then
      echo ${SHELVES} > SHELVES.txt
      SHELVES=`sed 's/ //g' SHELVES.txt`
      IFS=$','
      index_shelve_number=0
      for i in ${SHELVES[@]}; do
         if ! [[ ${i} == "" ]]; then
            array_shelve[$index_shelve_number]=${i}
            unshelving ${array_shelve[$index_shelve_number]}
            let index_shelve_number=${index_shelve_number}+1
         fi
     done
   fi
 
        # -------------------- Copy src files from repo workspace --------------------

    sleep 10
    cp -rf ${WORKDIR_part1} ${HOMEDIR}/
    rm -rf ${WORKDIR_part1}
    cp -rf ${WORKDIR_part2} ${HOMEDIR}/
    rm -rf ${WORKDIR_part2}
    chmod -R 777 ${HOMEDIR}/

else
    exit 0
fi