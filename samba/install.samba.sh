#!/bin/bash
### Script to install and setup Samba on Odroid C2 running Ubuntu 16.04
### maintained by Aunlead

apt-get update \
	&& apt-get install -y samba samba-common python-glade2 system-config-samba \
	&& apt-get clean \
	&& cp -pf /etc/samba/smb.conf /etc/samba/smb.conf.bak \
	&& cat /dev/null  > /etc/samba/smb.conf


sudo tee /etc/samba/smb.conf <<-'EOF'
[global]
workgroup = CARB0N
server string = Odroid Server %v
netbios name = odroid64
security = user
map to guest = bad user
dns proxy = no
name resolve order = bcast host

#============================ Share Definitions ============================== 

[Carbon]
path = /mnt/Carbon/
browsable =yes
writable = yes
guest ok = yes
read only = no
#force user = nobody

[Seedbox]
path = [Carbon]
path = /mnt/SeedboxIII/odroid-torrentbox
browsable =yes
writable = yes
guest ok = yes
read only = no
EOF


sudo systemctl restart smbd 

echo 'Adding firewall rules for Samba'
sudo ufw allow from 192.168.0.0/16 to any app Samba

echo 'Setup complete.'
