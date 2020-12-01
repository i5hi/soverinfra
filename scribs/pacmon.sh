#!/bin/bash
#This script is designed to monitor network packet information through a specified port on a specified network interface.
#By default the script scans port 80 on a wireless network interface

echo "These are your available network interfaces:"

echo ""
sudo tcpdump -D  
echo ""

echo "Pick the interface to monitor:"
echo "NOTE: YOUR INPUT MUST BE THE FULL NAME OF THE INTERFACE WITHOUT THE NUMBER"

read interface

echo "Enter Port To Scan: (default: 80)"
read port

if [$port gt 0] && [$port lt 65556];then
sudo tcpdump -i "$interface" -nn -s0 -v port "$port"
else
sudo tcpdump -i "$interface" -nn -s0 -v port 80
fi

