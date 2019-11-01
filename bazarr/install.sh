#!/bin/bash
### Script to install and setup Bazarr on Odroid C2 running Ubuntu 18
### maintained by Aunlead

# Configure Mono
sudo apt install -y gnupg ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update

# Install Mono, Git and Python Python version 2.7.13 or greater
sudo apt install -y mono-devel git-core python-pip libxml2-dev libxslt1-dev python-libxml2 python-lxml

cd /opt
sudo git clone https://github.com/morpheus65535/bazarr.git
sudo chown -R $(whoami):$(whoami) /opt/bazarr

# Install Python requirements using
pip install -r requirements.txt

sudo tee /etc/systemd/system/bazarr.service <<-'EOF'
[Unit]
Description="Bazarr Daemon"
After=syslog.target network.target
[Service]
User=odroid
Group=odroid
ExecStart=/usr/bin/python /opt/bazarr/bazarr.py
KillMode=process
Restart=on-failure
Restart-sec=2
Type=simple
TimeoutStopSec=20
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload \
&& sudo systemctl enable /etc/systemd/system/bazarr.service  \
&& sudo systemctl start bazarr  \
&& sudo systemctl status bazarr

echo 'Setting up firewall rules'
echo 'NOTE - Current firewall rules restricts IP range to 192.168.0.0/16'
sudo ufw allow from 192.168.0.0/16  to any port 6767
sudo ufw limit 6767 comment 'Bazarr port'

echo 'Setup complete. Connect using localhost:6767'
