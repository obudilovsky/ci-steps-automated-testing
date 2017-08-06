#!/bin/bash

HOMEDIR=`pwd`

if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "1" ]; then

        # -------------------- Make --------------------

   cd ${HOMEDIR}/part1/
   make clean
   make -j 8
   if ! [ -f ${HOMEDIR}/part1/tar.gz ]; then
      echo -e '==> tar.gz NOT_FOUND'
   else
      echo -e '==> Make - SUCCESS' 
   fi

   chmod -Rf 777 ${HOMEDIR}/
else
   exit 0
fi