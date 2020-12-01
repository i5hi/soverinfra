#!/bin/bash

# find usb file system usually /dev/sdb1
df | grep media | awk '{ print $1 }'

sudo umount /dev/sdb1

sudo mkfs.vfat -n "UbuntuFocal" -I /dev/sdb1 