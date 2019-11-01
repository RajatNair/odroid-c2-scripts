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
dns proxy = no
log file = /var/log/samba/log.%m
max log size = 1000
syslog only = no
syslog = 0
panic action = /usr/share/samba/panic-action %d
security = user
encrypt passwords = true
passdb backend = tdbsam
obey pam restrictions = yes
unix password sync = yes
passwd program = /usr/bin/passwd %u
passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
pam password change = yes
map to guest = bad user
load printers = no

#============================ Share Definitions ============================== 

[Backups]
comment = Backups
path = /mnt/SeedboxV/Backups
browseable = yes
create mask = 0775
directory mask = 0775
valid users = odroid
writeable = yes

[Carbon]
path = /mnt/Carbon/
browseable = yes
create mask = 0775
directory mask = 0775
valid users = odroid
writeable = yes

[Seedbox]
path = /mnt/SeedboxV/odroid-torrentbox
browseable = yes
create mask = 0775
directory mask = 0775
valid users = odroid
writeable = yes

[Media]
path = /mnt/SeedboxV/Media
browsable = yes
writable = no
guest ok = yes
read only = yes
EOF


sudo systemctl restart smbd 

echo 'Adding firewall rules for Samba'
sudo ufw allow from 192.168.0.0/16 to any app Samba

echo 'Setup complete.'
