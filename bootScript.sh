# So the script still runs after a power outage
sudo rm /home/swade/Scripts/CCTV/encode_override.txt
echo "override=0" >> /home/swade/Scripts/CCTV/encode_override.txt
