#!/bin/bash

cd ~/
# Update and upgrade the system
sudo apt update && sudo apt upgrade -y

sudo apt-get --purge remove wayvnc
wget https://downloads.realvnc.com/download/file/vnc.files/VNC-Server-7.12.1-Linux-ARM64.deb
sudo apt install ./VNC-Server-7.12.1-Linux-ARM64.deb
sudo systemctl enable vncserver-x11-serviced.service
sudo systemctl start vncserver-x11-serviced.service
sudo systemctl status vncserver-x11-serviced.service


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
