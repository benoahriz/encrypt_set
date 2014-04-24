#!/bin/bash
#A simple wrapper for openssl to be able to encrypt a batch set of files using symetrical encryption.
#This will work with filenames with spaces.

FILEPATH=/tmp/unenc
DATESTMP=$(date +%Y%m%d%H%M)
PASSFILE=/tmp/password.txt
LOGFILE=/tmp/cryptfiles.log
CRYPTFOLDER=/tmp/enc
STARTSCRIPT=$(date +"%s")
#make sure things exist first
if [ -d ${FILEPATH} ]
then
  echo "${FILEPATH} exists...move along"
else
  echo "create the dir"
  mkdir ${FILEPATH}
  echo "since you don't have a dir you might need some test files..."
  echo "sometextforatestfile" > ${FILEPATH}/tmp1.txt
  echo "sometextforatestfile" > ${FILEPATH}/tmp2.txt
  echo "sometextforatestfile" > ${FILEPATH}/tmp3.txt
  echo "sometextforatestfile" > ${FILEPATH}/tmp4.txt
fi
if [ -d ${CRYPTFOLDER} ]
then
  echo "${CRYPTFOLDER} exists...move along"
else
  echo "create the dir"
  mkdir ${CRYPTFOLDER}
fi
if [ -f ${PASSFILE} ] 
then
  echo "${PASSFILE} exists...move along"
else
  echo "makeasecurepassphrase" > ${PASSFILE}
fi
#cd into teh path
cd ${FILEPATH}
for f in *
    do
      #openssl basic symetrical encryption using a passphrase contained inside a file.
        openssl aes-256-cbc -in "${f}" -out ${CRYPTFOLDER}/"${f}".enc -pass file:$PASSFILE
          echo "$(date +%Y%m%d%H%M) IN:${f} OUT:${f}.enc"
    done > ${LOGFILE}
ENDSCRIPT=$(date +"%s")
diff=$((${STARTSCRIPT}-${ENDSCRIPT}))
echo "$(($diff/60)) minutes and $(($diff%60)) seconds elapsed."
echo "cat ${LOGFILE}"
