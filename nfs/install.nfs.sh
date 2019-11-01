!/bin/bash
### Script to install and setup NFS on Odroid C2 running Ubuntu 18.04
### maintained by Aunlead

	apt update \
        && apt-get install -y nfs-kernel-server nfs-common libnfs11

echo 'Adding firewall rules'
ufw allow from 192.168.0.0/16  to any port nfs

echo 'Done. Add you mountpoints to /etc/exports'
