#Without download
#docker run -v .:/home -it skasimalla/generate_report:1

echo $USER
echo $TOKEN
echo $DOWNLOAD_URL

docker run --env  "USER=${USER}" --env "TOKEN=${TOKEN}" --env "BASE_URL=${BASE_URL}" --env "JSON=${res_incoming_webhook_payload}" --env "UPLOAD_URL=${UPLOAD_URL}" skasimalla/generate_report:1.2