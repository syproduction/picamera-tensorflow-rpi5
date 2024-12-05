#!/bin/bash

cd ~/
# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

sudo apt-get --purge remove wayvnc -y
wget https://downloads.realvnc.com/download/file/vnc.files/VNC-Server-7.12.1-Linux-ARM64.deb
sudo apt install ./VNC-Server-7.12.1-Linux-ARM64.deb -y
sudo systemctl enable vncserver-x11-serviced.service
sudo systemctl start vncserver-x11-serviced.service

CMDLINE_FILE="/boot/firmware/cmdline.txt"
CONFIG_FILE="/boot/firmware/config.txt"
sudo sed -i '1s/$/ video=HDMI-A-1:1920x1080M@60D/' "$CMDLINE_FILE"

LINES_TO_APPEND=$(cat <<EOL

# HDMI settings added by script
hdmi_force_hotplug=1
hdmi_group=2
hdmi_mode=82
EOL
)
sudo echo "$LINES_TO_APPEND" >> "$CONFIG_FILE"
# Install required packages
sudo apt install -y python3-venv git

# Create a virtual environment with access to system packages
python3 -m venv --system-site-packages myenv

# Activate the virtual environment
source myenv/bin/activate

# Install additional system dependencies and Python packages
sudo apt install -y libatlas-base-dev python3-pip python3-opencv python3-pyqt5
pip3 install tflite-runtime

# Clone the picamera2 repository
git clone https://github.com/raspberrypi/picamera2

# Navigate to the TensorFlow examples directory
cd picamera2/examples/tensorflow

# Prompt the user before running the real-time object detection script
echo "The environment is set up. Press Enter to run the real-time object detection script or Ctrl+C to cancel."
read -p "Press Enter to continue..."

# Run the real-time object detection script with the specified model and labels
python3 real_time_with_labels.py --model mobilenet_v2.tflite --label coco_labels.txt
