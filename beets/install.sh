#!/bin/bash
### Script to install and setup Beets on Odroid C2 running Ubuntu 16.04
### maintained by Aunlead

# Install PIP
apt-get update \
        && apt-get install -y python-dev python-pip \
        && apt-get clean

# Update PIP
python -m pip install -U pip

pip install beets

echo 'Setup complete. Run "beet config -e"'
