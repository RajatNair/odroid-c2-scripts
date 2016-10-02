#!/bin/bash
### Script to install and setup x11vnc on Odroid C2 running DietPi.
### With this setup, you can remotely connect to an existing desktop session
### maintained by Aunlead

# SET FOLLOWING VALUES
# VNC password
VNC_PASSWORD=yourVNCpasswordHERE

sudo apt-get update
sudo apt-get install -y x11vnc
sudo apt-get clean
sudo x11vnc -storepasswd ${VNC_PASSWORD} /etc/x11vnc.pass

sudo tee /etc/systemd/system/x11vnc.service <<-'EOF'
[Unit]
Description="x11vnc"
After=dietpi-service.service
After=rc.local.service

[Service]
ExecStart=/usr/bin/x11vnc -xkb -noxrecord -noxfixes -noxdamage -geometry 1920x1080 -display :0 -auth guess -rfbauth /etc/x11vnc.pass
ExecStop=/usr/bin/killall x11vnc
Restart=on-failure
Restart-sec=2

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload \
&& systemctl enable /etc/systemd/system/x11vnc.service  \
&& systemctl start x11vnc  \
&& systemctl status x11vnc 

echo 'Setup complete. Connect using any VNC client (eg. TightVNC viewer) to Odroid-C2-IP:0 (eg. 192.168.0.100:1)'
