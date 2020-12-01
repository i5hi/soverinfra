#!/bin/bash
#This script scans your local network for all 256 last octet combinations
#It outputs the addresses that respond to a ping

echo "Enter first 3 octets of your local network's ip address:"
read first_three_ipoctets

for last_ipoctet in `seq 1 255`; do
ping -c 1 $first_three_ipoctets.$last_ipoctet | grep 64 | awk '{print $4}' | tr -d ":"&
done

#&threading