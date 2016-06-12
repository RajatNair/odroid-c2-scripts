#!/bin/bash
### Script to install and setup Deluge on Odroid C2 running Ubuntu 16.04
### maintained by Aunlead

# SET FOLLOWING VALUES
DELUGE_PASSWORD=yourDELUGEpasswordHERE
MOUNT_POINT=/mnt/Seedbox

 apt-get install -y software-properties-common \
	&& add-apt-repository ppa:deluge-team/ppa \
	&& apt-get update \
	&& apt-get install -y deluged deluge-web \
	&& apt-get clean \
	&& adduser --system  --gecos "Deluge Service" --disabled-password --group --home /home/deluge deluge
	&& sudo mkdir -p /var/log/deluge \
	&& sudo chown -R deluge:deluge /var/log/deluge \
	&& sudo chmod -R 750 /var/log/deluge \
	&& sudo mkdir -p /home/deluge/downloading \
	&& sudo mkdir -p /home/deluge/seeding \
	&& sudo mkdir -p /home/deluge/watch \ 
	&& sudo mkdir -p /home/deluge/torrentfiles \
	&& sudo chown -R deluge:deluge /home/deluge

rm -f /home/deluge/.config/deluge/deluge.pid

if [ ! -f /home/deluge/.config/deluge/auth ]; then
    echo "auth not found, creating"
    sudo mkdir -p /home/deluge/.config/deluge \
	&& echo \"deluge:"${DELUGE_PASSWORD}":10\" > /home/deluge/.config/deluge/auth
fi

if [ ! -f /home/deluge/.config/deluge/core.conf ]; then
    echo "config not found, creating"
    sudo mkdir -p /home/deluge/.config/deluge \
	&& cp ./core.conf /home/deluge/.config/deluge/core.conf # \
	#&& cp ./web.conf /home/deluge/.config/deluge/web.conf \
	#&& cp ./label.conf /home/deluge/.config/deluge/label.conf \
	#&& cp ./scheduler.conf /home/deluge/.config/deluge/scheduler.conf \
    chown deluge:deluge /home/deluge/.config/deluge/core.conf
fi

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
User=deluge
Group=deluge
UMask=022

ExecStart=/usr/bin/deluged -d -c /home/deluge/.config/ -l /var/log/deluge/daemon.log -L info

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

User=deluge
Group=deluge
UMask=027

ExecStart=/usr/bin/deluge-web -c /home/deluge/.config/ -l /var/log/deluge/web.log -L info

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


echo 'Setup complete.'
