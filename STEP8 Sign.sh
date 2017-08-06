#!/bin/bash

HOMEDIR=`pwd`

if [ ${BUILD_MODE} == "0" ] || [ ${BUILD_MODE} == "1" ]; then

        # -------------------- Kernel signing --------------------

  echo -e '==> Kernel signing...'
  cp -rfv ${HOMEDIR}/dist/* ${PRJDIR}/${PLATFORM}/dist/
  chmod -Rf 777 ${PRJDIR}/${PLATFORM}/dist/*
  chown -Rf :avtotest ${PRJDIR}/${PLATFORM}/dist/*
  rm -rfv ${PRJDIR}/${PLATFORM}/dist/firmware/image/*
  rm -rfv ${PRJDIR}/${PLATFORM}/dist/kernel.tar

        # -------------------- Sign dir checking --------------------

  while(true); do
    if [[ -f ${PRJDIR}/${PLATFORM}/dist/tzm || -f ${PRJDIR}/${PLATFORM}/dist/kernel.tar ]]; then
      sleep 10; 
      cp -rfv ${PRJDIR}/${PLATFORM}/dist/* ${HOMEDIR}/dist/  
      break;  
    fi
    sleep 5;
  done

        # -------------------- Check files --------------------

  case '${PLATFORM}' in
  'PLATFORM_A')
    if ! [[ -f ${HOMEDIR}/dist/image/tzm1 ]]; then
      echo -e '==> tzm.* is NOT_FOUND'
    fi
  ;;
  'PLATFORM_B'|'PLATFORM_C'|'PLATFORM_D'|'PLATFORM_E')
    if ! [[ -f ${HOMEDIR}/dist/kernel.tar ]]; then
      echo -e '==> kernel.tar is NOT_FOUND'
    fi
  ;;
  esac

else
    exit 0
fi