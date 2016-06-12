### Script to install and setup VNC on Odroid C2 running Ubuntu 16.04
### maintained by Rajat

# SET FOLLOWING VALUES
# VNC password
VNC_PASSWORD = yourVNCpasswordHERE

sudo apt-get install x11vnc
sudo x11vnc -storepasswd $VNC_PASSWORD /etc/x11vnc.pass

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
sudo service xrdp restart
