#!/bin/bash

#####################################
####    THIS SCRIPT IS UNUSED    ####
#####################################

L_PATH="/home/swade/CCTV/CCTV_Storage_Temp"
S_PATH="/home/swade/CCTV/CCTV_Storage"

WEBHOOK_URL="********"
SECONDS=0
# PRE_SIZE=$(du -sh "$S_PATH/$CAM1_NAME/$(date --date="1 day ago" +'%B %d, %Y')" | awk '{print $1}')
PAYLOAD=" { \"content\": \"Started uploading the security footage from $(date --date="1 day ago" +'%B %d, %Y') to Google Drive.\" }"

curl -X POST -H 'Content-Type: application/json' -d "$PAYLOAD" "$WEBHOOK_URL"

# Cameras
CAM1_NAME="Bird Feeder"
CAM1_SHORTENED="Birdfeeder"

CAM2_NAME="Side Door"
CAM2_SHORTENED="Sidedoor"

# Change directory to camera 1 footage.
cd "$S_PATH/$CAM1_NAME/"

sudo rclone move -v "$S_PATH/$CAM1_NAME/$(date --date="1 day ago" +'%B %d, %Y')" swadesdesigns:"$CAM1_NAME/$(date --date="1 day ago" +'%Y-%m-%d')/"

if [ -z "$(ls -A "$S_PATH/$CAM1_NAME/$(date --date="1 day ago" +'%B %d, %Y')")" ]; then
  sudo rm -r "$S_PATH/$CAM1_NAME/$(date --date="1 day ago" +'%B %d, %Y')"
else
  echo "Not deleting, some files still didn't get uploaded"
  ERRORS="**THERE WAS A PROBLEM UPLOADING, MAKE SURE TO CHECK THE SERVER DIRECTORY**"
fi


# # Change directory to camera 2 footage.
cd "$S_PATH/$CAM2_NAME/"

sudo rclone move -v "$S_PATH/$CAM2_NAME/$(date --date="1 day ago" +'%B %d, %Y')" swadesdesigns:"$CAM2_NAME/$(date --date="1 day ago" +'%Y-%m-%d')/"

if [ -z "$(ls -A "$S_PATH/$CAM2_NAME/$(date --date="1 day ago" +'%B %d, %Y')")" ]; then
  sudo rm -r "$S_PATH/$CAM2_NAME/$(date --date="1 day ago" +'%B %d, %Y')"
else
  echo "Not deleting, some files still didn't get uploaded"
  ERRORS="**THERE WAS A PROBLEM UPLOADING, MAKE SURE TO CHECK THE SERVER DIRECTORY**"
fi

# Discord Notification
if (( $SECONDS > 3600 )); then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)"
    PAYLOAD=" { \"content\": \"The CCTV footage finished uploading in $hours hour(s), $minutes minute(s) and $seconds second(s). $ERRORS\" }"

elif (( $SECONDS > 60 )); then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    echo "Completed in $minutes minute(s) and $seconds second(s)"
    PAYLOAD=" { \"content\": \"The CCTV footage finished uploading in $minutes minute(s) and $seconds second(s). $ERRORS\" }"
else
    echo "Completed in $SECONDS seconds"
    PAYLOAD=" { \"content\": \"The CCTV footage finished uploading in $SECONDS seconds. $ERRORS\" }"
fi

curl -X POST -H 'Content-Type: application/json' -d "$PAYLOAD" "$WEBHOOK_URL"
