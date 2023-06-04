#!/bin/sh
## Install the DHCP Server daemon
apt-get update
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