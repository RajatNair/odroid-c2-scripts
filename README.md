## Collection of BASH scripts for Odroid C2 which will -
###### 1. Harden Ubuntu
###### 2. Install scripts to setup specific softwares

#### Initial Setup
###### 1. SSH to odroid-ip:22 (Default username and password - odroid)
###### 2. Change odroid password from default
```shell
passwd odroid
```
###### 3. Change root user password from default
```shell
sudo bash && passwd
```
###### 3. Update C2
```shell
sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade
```
###### 4. Change default SSH port and disable root login
```shell
## Lockdown - changing default ports
nano /etc/ssh/sshd_config
## Disable root login
PermitRootLogin no
## Change default SSH port
Port 2230
## Lockdown - Firewall 
ufw limit ssh/tcp
ufw allow 2230/tcp
sudo systemctl reload sshd
```
###### 5. Enable firewall
```shell
# Allow Incoming SSH from Specific IP Address or Subnet
ufw allow from 192.168.0.0/16  to any port 2230
ufw limit 2230/tcp comment 'SSH port'
sudo ufw enable && sudo ufw status
```
