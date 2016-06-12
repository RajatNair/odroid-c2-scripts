#!/bin/bash
### Script to install and setup VNC on Odroid C2 running Ubuntu 16.04
### maintained by Aunlead

# SET FOLLOWING VALUES
# VNC password
VNC_PASSWORD=yourVNCpasswordHERE

sudo apt-get install -y x11vnc
sudo x11vnc -storepasswd ${VNC_PASSWORD} /etc/x11vnc.pass

sudo tee /etc/systemd/system/x11vnc.service <<-'EOF'
[Unit]
Description="x11vnc"
Requires=display-manager.service
After=display-manager.service

[Service]
ExecStart=/usr/bin/x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :0 -auth guess -rfbauth /etc/x11vnc.pass
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

echo mate-session >~/.xsession
systemctl restart x11vnc

echo 'Setting up firewall rules'
echo 'NOTE - Current firewall rules restricts IP range to 192.168.0.0/16'
ufw allow from 192.168.0.0/16  to any port 5900
ufw limit 5900 comment 'VNC port'

echo 'Setup complete. Connect using any VNC client to Odroid-C2-Port:5900'
