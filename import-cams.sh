#!/bin/bash

# Here is where you put all the ffmpeg/cctv streams. Make this script run every 10 minutes in crontab (It didn't run reliably when run continuously).

DIR="/home/swade/CCTV/CCTV_Storage_Temp"
SEG_LENGTH="00:10:00"

#---------------------------------------------------------------------
# Bird Feeder Camera
CAMERA1=rtsp://admin:Boone2017@192.168.1.151:554//h264Preview_01_main
CAM1_NAME="Bird Feeder"
CAM1_SHORTENED="Birdfeeder"
CAM1_KILLSWITCH=$(grep "$CAM1_SHORTENED" /home/swade/Scripts/CCTV/killswitch.txt | cut -d "=" -f2)

if [[ $CAM1_KILLSWITCH -eq 1 ]]; then

  mkdir -p "$DIR/$CAM1_NAME/"

  sudo ffmpeg -rtsp_transport tcp -i $CAMERA1 -acodec copy -vcodec copy -map 0 -t $SEG_LENGTH -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "$DIR/$CAM1_NAME/$CAM1_SHORTENED $(date +"%H;%M %m-%d-%Y")".mkv & \

fi

#---------------------------------------------------------------------
# Side Door Camera
CAMERA2=rtsp://admin:Boone2017@192.168.1.152:554//h264Preview_01_main
CAM2_NAME="Side Door"
CAM2_SHORTENED="Sidedoor"
CAM2_KILLSWITCH=$(grep "$CAM2_SHORTENED" /home/swade/Scripts/CCTV/killswitch.txt | cut -d "=" -f2)

if [[ $CAM2_KILLSWITCH -eq 1 ]]; then

  mkdir -p "$DIR/$CAM2_NAME/"

  sudo ffmpeg -rtsp_transport tcp -i $CAMERA2 -acodec copy -vcodec copy -map 0 -t $SEG_LENGTH -segment_atclocktime 1 -reset_timestamps 1 -strftime 1 "$DIR/$CAM2_NAME/$CAM2_SHORTENED $(date +"%H;%M %m-%d-%Y")".mkv & \

fi
#---------------------------------------------------------------------
