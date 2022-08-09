#!/bin/bash

L_PATH="/home/swade/CCTV/CCTV_Storage_Temp"
S_PATH="/home/swade/CCTV/CCTV_Storage"
OVERRIDE_PATH="/home/swade/Scripts/CCTV/encode_override.txt"

QUALITY=32
ENCODE_SPEED='ultrafast'

DATE=$(date +'%B %d, %Y')
EPOCHDATE10MIN=$(($(date +%s) - 600))

# Cameras
CAM1_NAME="Side Door"
CAM1_SHORTENED="Sidedoor"

CAM2_NAME="Bird Feeder"
CAM2_SHORTENED="Birdfeeder"

OVERRIDE=$(grep "override" $OVERRIDE_PATH | cut -d "=" -f2)

# Check to make sure previous job is finished
if [[ $OVERRIDE -eq 0 ]]; then

    # Update override variable
    sudo sed -i 's/^override.*$/override=1/' $OVERRIDE_PATH

    #####################################
    ####           Cam 1             ####
    #####################################

    mkdir -p "$S_PATH/$CAM1_NAME/$DATE"
    # Re-encode the old clips with HEVC to save space.
    cd "$L_PATH/$CAM1_NAME/"
    for FILE in *.mkv; do
      VIDEO_NAME="${FILE%.*}"
      MODTIME=$(stat -c "%Y" "$FILE")
      if [[ $MODTIME -lt $EPOCHDATE10MIN ]]; then
        sudo ffmpeg -i "$FILE" -c:v libx265 -crf $QUALITY -preset $ENCODE_SPEED -y -r 15 -an "$S_PATH/$CAM1_NAME/$DATE/$VIDEO_NAME.mp4"
        sudo rm "$VIDEO_NAME.mkv"
        sudo rclone move -v "$S_PATH/$CAM1_NAME/$DATE/$VIDEO_NAME.mp4" swadesdesigns:"$CAM1_NAME/$(date +'%Y-%m-%d')/"
      fi
    done


    #####################################
    ####           Cam 2             ####
    #####################################

    mkdir -p "$S_PATH/$CAM2_NAME/$DATE"
    # Re-encode the old clips with HEVC to save space.
    cd "$L_PATH/$CAM2_NAME/"
    for FILE in *.mkv; do
      VIDEO_NAME="${FILE%.*}"
      MODTIME=$(stat -c "%Y" "$FILE")
      if [[ $MODTIME -lt $EPOCHDATE10MIN ]]; then
        sudo ffmpeg -i "$FILE" -c:v libx265 -crf $QUALITY -preset $ENCODE_SPEED -y -r 15 -an "$S_PATH/$CAM2_NAME/$DATE/$VIDEO_NAME.mp4"
        sudo rm "$VIDEO_NAME.mkv"
        sudo rclone move -v "$S_PATH/$CAM2_NAME/$DATE/$VIDEO_NAME.mp4" swadesdesigns:"$CAM2_NAME/$(date +'%Y-%m-%d')/"
      fi
    done

    # Update override variable
    sudo sed -i 's/^override.*$/override=0/' $OVERRIDE_PATH

fi
