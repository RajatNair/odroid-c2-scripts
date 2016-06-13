#!/bin/bash
### Script to install and setup Firefox 32bit on Odroid C2 running Ubuntu 16.04
### maintained by Aunlead

apt-get install -y software-properties-common \
	&& apt-get remove -y firefox \
	&& apt-get update \
	&& apt-get install -y firefox:armhf \
	&& apt-get clean 

echo 'Setup complete'
