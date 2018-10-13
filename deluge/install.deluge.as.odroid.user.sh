#!/bin/bash
### Script to install and setup Deluge on Odroid C2 running Ubuntu 16.04 as odroid default user
### maintained by Aunlead

# SET FOLLOWING VALUES
# Read Deluge Password
stty -echo
printf "Deluge password: "
read DELUGE_PASSWORD
stty echo
printf "\n"
# Mount point if you need to start Deluge after mount point is loaded
MOUNT_POINT=/mnt/SeedboxIII/

# Run Command
 apt-get install -y software-properties-common \
	&& add-apt-repository ppa:deluge-team/ppa \
	&& apt-get update \
	&& apt-get install -y deluged deluge-web 

sudo mkdir -p /var/log/deluge 
sudo chown -R odroid:odroid /var/log/deluge 
sudo chmod -R 750 /var/log/deluge 
sudo mkdir -p /home/odroid/deluge/downloading 
sudo mkdir -p /home/odroid/deluge/seeding 
sudo mkdir -p /home/odroid/deluge/watch 
sudo mkdir -p /home/odroid/deluge/torrentfiles 

sudo rm -f /home/odroid/deluge/.config/deluge/deluge.pid

if [ ! -f /home/odroid/deluge/.config/auth ]; then
    echo "auth not found, creating"
    sudo mkdir -p /home/odroid/deluge/.config \
	&& echo \"odroid:"${DELUGE_PASSWORD}":10\" > /home/odroid/deluge/.config/auth
fi

if [ ! -f /home/odroid/deluge/.config/core.conf ]; then
    echo "config not found, creating"
    sudo mkdir -p /home/odroid/deluge/.config \
	&& cp ./core.as.odroid.user.conf /home/odroid/deluge/.config/core.conf 
fi

sudo chown -R odroid:odroid /home/odroid/deluge

sudo tee /etc/systemd/system/deluged.service <<-'EOF'
[Unit]
Description=Deluge Bittorrent Client Daemon
After=network-online.target
# Unit starts after the following mounts are available. Check using systemctl -t mount
RequiresMountsFor=${MOUNT_POINT}
# Unit is stopped when any of these mounts disappear.
BindsTo=${MOUNT_POINT}

[Service]
Type=simple
User=odroid
Group=odroid
UMask=022

ExecStart=/usr/bin/deluged -d -c /home/odroid/deluge/.config/ -l /var/log/deluge/daemon.log -L info

Restart=on-failure

# Configures the time to wait before service is stopped forcefully.
TimeoutStopSec=300

[Install]
WantedBy=multi-user.target
EOF



sudo tee /etc/systemd/system/deluge-web.service <<-'EOF'
[Unit]
Description=Deluge Bittorrent Client Web Interface
After=network-online.target
# Unit starts after the following mounts are available. Check using systemctl -t mount
RequiresMountsFor=${MOUNT_POINT} 
# Unit is stopped when any of these mounts disappear.
BindsTo=${MOUNT_POINT}

[Service]
Type=simple

User=odroid
Group=odroid
UMask=027

ExecStart=/usr/bin/deluge-web -c /home/odroid/deluge/.config/ -l /var/log/deluge/web.log -L info

Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload \
	&& systemctl enable /etc/systemd/system/deluged.service  \
	&& systemctl start deluged  \
	&& systemctl status deluged \
	&& systemctl enable /etc/systemd/system/deluge-web.service \
	&& systemctl start deluge-web \
	&& systemctl status deluge-web


echo 'Adding firewall rules'
ufw allow from 192.168.0.0/16  to any port 2222
ufw allow from 192.168.0.0/16  to any port 8112


echo 'Setup complete. Configure MOUNTPOINTS in SystemD.'
