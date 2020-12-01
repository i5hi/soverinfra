#!/bin/bash -e

free -m

# clear cache, inodes and dentries
sync; echo 3 > /proc/sys/vm/drop_caches

free -m
