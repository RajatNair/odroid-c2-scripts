apt-get install -y software-properties-common \
	&& add-apt-repository ppa:deluge-team/ppa \
	&& apt-get update \
	&& apt-get install -y deluged deluge-web \
	&& apt-get clean \
	&& adduser --system  --gecos "Deluge Service" --disabled-password --group --home /var/lib/deluge deluge
	&& sudo mkdir -p /var/lib/deluge/config/ \
	&& sudo mkdir -p /var/log/deluge \
	&& sudo chown -R deluge:deluge /var/log/deluge \
	&& sudo chmod -R 750 /var/log/deluge


sudo tee /etc/systemd/system/deluged.service <<-'EOF'
[Unit]
Description=Deluge Bittorrent Client Daemon
After=network-online.target

[Service]
Type=simple
User=deluge
Group=deluge
UMask=022

ExecStart=/usr/bin/deluged -d -c /var/lib/deluge/config/ -l /var/log/deluge/daemon.log -L info

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

[Service]
Type=simple

User=deluge
Group=deluge
UMask=027

ExecStart=/usr/bin/deluge-web -c /var/lib/deluge/config/ -l /var/log/deluge/web.log -L info

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
