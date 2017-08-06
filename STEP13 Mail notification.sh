#!/bin/bash  

        # -------------------- Search build status value --------------------

curl -k -v -u %system.teamcity.auth.userId%:%system.teamcity.auth.password% %teamcity.serverUrl%/httpAuth/app/rest/builds/id:%teamcity.build.id% --request GET -o build_info.txt
BUILD_STATUS=$(cat build_info.txt | awk '{ print $8 }' | awk -F'=' '{ print $2}' | awk -F'"' '{ print $2}')
STATUS_TEXT=$(cat build_info.txt | awk -F'<statusText>' '{ print $2}' | awk -F'</statusText' '{ print $1}')

        # -------------------- Send e-mail --------------------


   if ! [[ ${SHELVES} == "" ]]; then
      echo ${SHELVES} > SHELVES.txt
      SHELVES=`sed 's/ //g' SHELVES.txt`
      IFS=$','
      index_shelve_number=0
      for i in ${SHELVES[@]}; do
         if ! [[ ${i} == "" ]]; then
            array_shelve[$index_shelve_number]=${i}
            EMAIL_RECIPIENT=$(/usr/local/bin/p4 describe ${array_shelve[$index_shelve_number]} | head -n1 | awk '{ print $4 }' | awk -F'@' '{ print $1 }')
            echo "%system.teamcity.projectName%::$%system.teamcity.buildConfName% #%build.number% ${STATUS_TEXT}
Please check result at TeamCity. Here is the link to build: %teamcity.serverUrl%/viewLog.html?buildId=%teamcity.build.id%
Agent: %system.agent.name%" | mail -s "[TeamCity, ${BUILD_STATUS}] %system.teamcity.projectName%::%system.teamcity.buildConfName% #%build.number%" ${EMAIL_RECIPIENT[$index_shelve_number]}@mail.com
            let index_shelve_number=${index_shelve_number}+1
         fi
     done
   fi