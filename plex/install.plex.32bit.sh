#!/bin/bash
### Script to install and setup Plex 32bit on Odroid C2 running Ubuntu 16.04
### maintained by Aunlead

#sudo dpkg --add-architecture armhf
#sudo apt install binutils:armhf
#sudo apt-get install plexmediaserver-installer -y

	apt-get update && apt-get install apt-transport-https && \
	wget -O - https://dev2day.de/pms/dev2day-pms.gpg.key | sudo apt-key add - && \
	echo "deb [arch=armhf] https://dev2day.de/pms/ jessie main" | tee /etc/apt/sources.list.d/pms.list && \
	apt-get update -q && \
	apt-get install plexmediaserver-installer -qy && \
	apt-get clean

echo 'Setup complete'
