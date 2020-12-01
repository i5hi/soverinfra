#!/bin/bash 


SSID=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2 | cut -c5-)

cat /etc/NetworkManager/system-connections/$SSID | grep ps

# if this doesnt work try below
# ls /etc/NetworkManager/system-connections
# find the SSID based folder and rerun the cat command
