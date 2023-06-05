#!/bin/sh
# This script has been tested on Ubuntu
# Update repository
apt update -y && sudo apt upgrade -y 
#Traceroute
apt-get install traceroute -y
# TCP traceroute
apt-get install tcptraceroute -y
# Nmap
apt-get install nmap -y
# Hping3
apt-get install hping3 -y
# iPerf
apt-get install iperf3 -y
# Nginx and adds machine name on main page
apt-get install nginx -y && hostname > /var/www/html/index.html
# Speedtest
apt-get install speedtest-cli -y
# net-tools
apt-get install net-tools -y

## Install the DHCP Server daemon
apt-get install -y kea-dhcp4-server

## Move existing conf file to a backup
mv /etc/kea/kea-dhcp4.conf /etc/kea/kea-dhcp4.conf.bak

echo "DHCP Server config"
cat <<EOF > /etc/kea/kea-dhcp4.conf
{
  "Dhcp4": {
	"interfaces-config": {
  	"interfaces": [ "eth0" ]
	},
	"control-socket": {
    	"socket-type": "unix",
    	"socket-name": "/run/kea/kea4-ctrl-socket"
	},
	"lease-database": {
    	"type": "memfile",
    	"lfc-interval": 3600
	},
	"valid-lifetime": 600,
	"max-valid-lifetime": 7200,
	"subnet4": [
  	{
    	"id": 1,
    	"subnet": "192.168.1.0/24",
    	"pools": [
      	{
        	"pool": "192.168.1.150 - 192.168.1.200"
      	}
    	],
    	"option-data": [
      	{
        	"name": "routers",
        	"data": "192.168.1.1"
      	},
      	{
        	"name": "domain-name-servers",
        	"data": "8.8.8.8"
      	},
      	{
        	"name": "domain-name",
        	"data": "mydomain.example"
      	}
    	]
  	}
	]
  }
}
EOF
echo Restarting DHCP Server
systemctl restart kea-dhcp4-server