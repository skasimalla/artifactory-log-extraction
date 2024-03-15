#!/bin/bash

#Env Variables needed for this script to run
echo $USER
echo $TOKEN
echo $BASE_URL
echo $UPLOAD_PATH
echo $JSON

BASE_URL=https://solengcustomersupport.jfrog.io/artifactory/customer-support-bundles/
UPLOAD_PATH=https://solengcustomersupport.jfrog.io/artifactory/customer-support-bundles-results/

FILE_PATH=$(echo "$JSON" | jq -r '.data.path')
echo $FILE_PATH

DOWNLOAD_PATH=$BASE_URL$FILE_PATH
echo $DOWNLOAD_PATH

export OUTPUT_FILE="${DOWNLOAD_PATH##*/}"_output
echo $OUTPUT_FILE

mkdir -p /app/inputs
cd /app/inputs
curl -L -u $USER:$TOKEN -O "${DOWNLOAD_PATH}"

cd /app
ls -lrt 

python3 generate_report.py --output_filename $OUTPUT_FILE

#Upload PDF to results folder
export UPLOAD_PATH=${UPLOAD_PATH}${FILE_PATH}
echo ${UPLOAD_PATH}
curl -u $USER:$TOKEN -T ./outputs/* "${UPLOAD_PATH}/${OUTPUT_FILE}"

#Move the processed file to processed folder
export FILE_PATH_MOVE=customer-support-bundles-processed/$FILE_PATH
echo $FILE_PATH_MOVE
#jf rt move  $FILE_PATH $FILE_PATH_MOVE

curl -X POST -u $USER:$TOKEN "https://solengcustomersupport.jfrog.io/artifactory/api/move/customer-support-bundles/$FILE_PATH?to=/$FILE_PATH_MOVE"
