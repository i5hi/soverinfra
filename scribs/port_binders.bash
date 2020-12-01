#!/bin/bash

if [ $# -lt 1 ]
then
 printf "\nWrong Usage:\nusage:\n./port_binders.bash port \nport: the port to scan for  binders\n\n"
 exit 1
fi

PORT=$1
#sudo apt install net-tools
sudo netstat -tulpn | grep -w :'$PORT'

exit 0;
