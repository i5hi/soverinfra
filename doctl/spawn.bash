#!/bin/bash

if [ $# -lt 7 ]
then
 printf "\nAvailable images (use Slug):\n"
 doctl compute image list-distribution
 printf "\nAvailable sizes (use Slug):\n"
 doctl compute size list
 printf "\nAvailable regions (use Slug):\n"
 doctl compute region list
 printf "\nAvailable ssh-keys (use Name):\n"
 doctl compute ssh-key list
 printf "\n"
 printf "\nWrong Usage: Not enough arguments.\nusage:\n./spawn.bash <project_name> <new_resource_name> <os_image> <size> <region> <ssh_key_name> <tag>\n\n\n"

 exit 1
fi

# login
# doctl auth init API_KEY
PROJECT_NAME=$1
RESOURCE_NAME=$2
# 1gb mem 1 cpu
IMAGE=$3
SIZE=$4
REGION=$5
SSH_NAME=$6
SSH_FINGERPRINT=$(doctl compute ssh-key list | grep $SSH_NAME | awk '{print $3}')
TAG=$7
PROJECT_ID=$(doctl projects ls | grep $PROJECT_NAME | awk '{print $1}')


printf "$PROJECT_ID\n"

printf "\nDisplaying current project resource URNs\n"
doctl projects resources ls $PROJECT_ID | awk '{if (NR!=1) print $1}' 

printf "\nCreating a new droplet...\n"

doctl compute droplet create $RESOURCE_NAME \
--size $SIZE \
--ssh-keys $SSH_FINGERPRINT \
--enable-backups \
--enable-monitoring \
--enable-private-networking \
--image $IMAGE \
--region $REGION \
--tag-name $TAG \
--wait \
| awk '{if (NR!=1) printf "ID:%s\nPublicIP:%s\nPrivateIP:%s\n",$1,$3,$4}'

printf "\nAdd Public IP to .ssh/config for selected ssh key pair\n"
exit 0;
