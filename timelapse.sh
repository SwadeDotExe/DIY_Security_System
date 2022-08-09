#!/bin/bash

#####################################
####    THIS SCRIPT IS UNUSED    ####
#####################################

L_PATH="/home/swade/CCTV/CCTV_Storage_Temp"
S_PATH="/home/swade/CCTV/CCTV_Storage"
SPEED=.005 #Sets the speed the video will be sped up by (.025=100x)
SECONDS=0

QUALITY=30
ENCODE_SPEED='ultrafast'


DATE=$(date --date="1 day ago" +'%B %d, %Y')

# Debug Date
#DATE=$(date +'%B %d, %Y')

# Cameras
CAM1_NAME="Side Door"
CAM1_SHORTENED="Sidedoor"

CAM2_NAME="Bird Feeder"
CAM2_SHORTENED="Birdfeeder"

#####################################
####           Cam 1             ####
#####################################

# Create a new folder for converted files.
mkdir -p "$S_PATH/$CAM1_NAME/$DATE/Spedup"

# Change directory to camera 1 footage.
cd "$S_PATH/$CAM1_NAME/$DATE"

# Use FFmpeg to speed up videos by $SPEED times.
for FILE in *.mp4; do
  VIDEO_NAME="${FILE%.*}"
   ffmpeg -i "$FILE" -vcodec h264 -r 60 -an -vf "fps=60, setpts=$SPEED*PTS" "$S_PATH/$CAM1_NAME/$DATE/Spedup/$VIDEO_NAME-faster.mp4"
done

# Change directory to converted camera 1 footage.
cd "$S_PATH/$CAM1_NAME/$DATE/Spedup"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mp4 > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c:v libx265 -crf 35 -r 60 -preset superfast "$CAM1_NAME Timelapse $(date --date="1 day ago" +'%m-%d-%Y').mp4"

# Change directory back to home.
cd

# Move finalized .mp4 files to the main folder.
sudo mv "$S_PATH/$CAM1_NAME/$DATE/Spedup/$CAM1_NAME Timelapse $(date --date="1 day ago" +'%m-%d-%Y').mp4" "$S_PATH/$CAM1_NAME/$DATE"

# Delete the sped-up footage.
sudo rm -r "$S_PATH/$CAM1_NAME/$DATE/Spedup/"

#####################################
####           Cam 2             ####
#####################################

# Create a new folder for converted files.
mkdir -p "$S_PATH/$CAM2_NAME/$DATE/Spedup"

# Change directory to camera 1 footage.
cd "$S_PATH/$CAM2_NAME/$DATE"

# Use FFmpeg to speed up videos by $SPEED times.
for FILE in *.mp4; do
  VIDEO_NAME="${FILE%.*}"
   ffmpeg -i "$FILE" -vcodec h264 -an -r 60 -vf "fps=60, setpts=$SPEED*PTS" "$S_PATH/$CAM2_NAME/$DATE/Spedup/$VIDEO_NAME-faster.mp4"
done

# Change directory to converted camera 1 footage.
cd "$S_PATH/$CAM2_NAME/$DATE/Spedup"

# Create a file listing all the videos in the current directory.
printf "file '%s'\n" *.mp4 > concat.txt

# Concatenate all the videos using ffmpeg.
ffmpeg -f concat -safe 0 -i concat.txt -c:v libx265 -crf 35 -r 60 -preset superfast "$CAM2_NAME Timelapse $(date --date="1 day ago" +'%m-%d-%Y').mp4"

# Change directory back to home.
cd

# Move finalized .mp4 files to the main folder.
sudo mv "$S_PATH/$CAM2_NAME/$DATE/Spedup/$CAM2_NAME Timelapse $(date --date="1 day ago" +'%m-%d-%Y').mp4" "$S_PATH/$CAM2_NAME/$DATE"

# Delete the sped-up footage.
sudo rm -r "$S_PATH/$CAM2_NAME/$DATE/Spedup/"

# # Discord Notification
# if (( $SECONDS > 3600 )); then
#     let "hours=SECONDS/3600"
#     let "minutes=(SECONDS%3600)/60"
#     let "seconds=(SECONDS%3600)%60"
#     echo "Completed in $hours hour(s), $minutes minute(s) and $seconds second(s)"
#     PAYLOAD=" { \"content\": \"The CCTV footage finished the time lapse in $hours hour(s), $minutes minute(s) and $seconds second(s). The size after the time lapse is **$PRE_SIZE**.\" }"
#
# elif (( $SECONDS > 60 )); then
#     let "minutes=(SECONDS%3600)/60"
#     let "seconds=(SECONDS%3600)%60"
#     echo "Completed in $minutes minute(s) and $seconds second(s)"
#     PAYLOAD=" { \"content\": \"The CCTV footage finished the time lapse in $minutes minute(s) and $seconds second(s). The size after the time lapse is **$PRE_SIZE**.\" }"
# else
#     echo "Completed in $SECONDS seconds"
#     PAYLOAD=" { \"content\": \"The CCTV footage finished the time lapse in $SECONDS seconds. The size after the time lapse is **$PRE_SIZE**.\" }"
# fi
#
# curl -X POST -H 'Content-Type: application/json' -d "$PAYLOAD" "$WEBHOOK_URL"
