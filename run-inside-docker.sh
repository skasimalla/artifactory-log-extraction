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

rm -rf /app/requests-report/inputs/*
rm -rf /app/requests-report/outputs/*

mkdir -p /app/requests-report/inputs
cd /app/requests-report/inputs
ls -lrt
curl -L -u $USER:$TOKEN -O "${DOWNLOAD_PATH}"

cd /app/requests-report
ls -lrt 

#The below ##*/ will print the first part after slash
export OUTPUT_FILE="${DOWNLOAD_PATH##*/}"_output
echo $OUTPUT_FILE

python3 generate_report.py --output_filename $OUTPUT_FILE --generate_csv --generate_png


#Upload PDF to results folder
#export UPLOAD_PATH="${UPLOAD_PATH}${FILE_PATH}/"
#echo ${UPLOAD_PATH}
#curl -u $USER:$TOKEN -i -T ./outputs/${OUTPUT_FILE}.pdf "${UPLOAD_PATH}"


cd /app
ls -lrt
INPUT_FILE="${DOWNLOAD_PATH##*/}"
chmod +x log-extractor.sh
./log-extractor.sh ./requests-report/inputs/$INPUT_FILE



grep -l -f patterns.txt * > ./outputs/pattern_match.txt
zip -r output.zip ./outputs 

#Upload TSV to results folder
curl -u $USER:$TOKEN -i -T /app/outputs/output.zip "${UPLOAD_PATH}"


cd /app/requests-report
ls -lrt 

#Move the processed file to processed folder
export FILE_PATH_DIR=$(dirname $FILE_PATH)
echo $FILE_PATH_DIR
#jf rt move  $FILE_PATH $FILE_PATH_MOVE

rm -rf /app/requests-report/inputs/*
rm -rf /app/requests-report/outputs/*
rm -rf /app/output.txt

curl -X POST -u $USER:$TOKEN "https://solengcustomersupport.jfrog.io/artifactory/api/move/customer-support-bundles/$FILE_PATH_DIR?to=customer-support-bundles-processed/"

