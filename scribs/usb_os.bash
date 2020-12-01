#!/bin/bash
if [ $# -lt 1 ]
then
 printf "\nWrong Usage: Not enough arguments.\nusage:\n./os_image.bash <path/to/image>\n\n\n"
 exit 1
fi

OS_IMAGE_PATH=$1
# find usb file system usually /dev/sdb1
df | grep media | awk '{ print $1 }'

sudo umount /dev/sdb1

sudo mkfs.vfat -n "UBUNTU20" -I /dev/sdb1 

sudo dd if=$OS_IMAGE_PATH of=/dev/sdb1 status="progress"