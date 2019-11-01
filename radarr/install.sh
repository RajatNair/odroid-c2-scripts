#!/bin/bash
### Script to install and setup Radarr on Odroid C2 running Ubuntu 18
### maintained by Aunlead

# Configure Mono
sudo apt install -y gnupg ca-certificates
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list
sudo apt update

# Install Mono, Curl, Mediainfo
sudo apt install -y mono-devel curl mediainfo


cd /opt
sudo curl -L -O $( curl -s https://api.github.com/repos/Radarr/Radarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 )
sudo tar -xvzf Radarr.develop.*.linux.tar.gz

mkdir -p ~/.radarr

sudo chown -R odroid:odroid /opt/Radarr
sudo chown -R odroid:odroid /home/odroid/.radarr/

sudo tee /etc/systemd/system/radarr.service <<-'EOF'
[Unit]
Description="Radarr Daemon"
After=syslog.target network.target
[Service]
User=odroid
Group=odroid
Type=simple
ExecStart=/usr/bin/mono --debug /opt/Radarr/Radarr.exe -nobrowser -data=/home/odroid/.radarr/
TimeoutStopSec=20
KillMode=process
Restart=on-failure
Restart-sec=2
[Install]
WantedBy=multi-user.target
EOF


sudo systemctl daemon-reload \
&& sudo systemctl enable /etc/systemd/system/radarr.service  \
&& sudo systemctl start radarr  \
&& sudo systemctl status radarr 


echo 'Setting up firewall rules'
echo 'NOTE - Current firewall rules restricts IP range to 192.168.0.0/16'
sudo ufw allow from 192.168.0.0/16  to any port 7878
sudo ufw limit 7878 comment 'Radarr port'

echo 'Setup complete. Connect using localhost:7878'
