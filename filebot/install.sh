#!/bin/bash
### Script to install and setup Filebot on Odroid C2 running Ubuntu 16.04
### maintained by Aunlead

# Set path
SETUP_PATH=/home/odroid/Workspace/filebot

sudo apt-get -y install mediainfo libchromaprint-tools

FILEBOT_DOWNLOAD_URL=http://liquidtelecom.dl.sourceforge.net/project/filebot/filebot/FileBot_4.7.2/filebot_4.7.2_noarch.ipk

# Create folder
mkdir -p $SETUP_PATH
mkdir -p $SETUP_PATH/scripts

# Download filebot
wget ${FILEBOT_DOWNLOAD_URL} -O filebot.ipk

sudo ar -x filebot.ipk

sudo chown odroid:odroid -R $SETUP_PATH

tar -xvf data.tar.gz

echo "Manually edit paths in following file - "
nano $SETUP_PATH/opt/share/filebot/bin/filebot.sh

