#!/bin/bash
terraform apply -auto-approve

IP=$(terraform output | cut -c6-)
HOSTNAME="	Hostname $IP"
USER="	User root"

FILE=$HOME/.ssh/config

sed -i "2s/.*/$HOSTNAME/" "$FILE"
sed -i "3s/.*/$USER/"     "$FILE"
