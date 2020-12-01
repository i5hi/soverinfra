#!/bin/bash

# A few essential tools to get a fresh debian system equipped to download new software over secure channels

apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common \
    dirmngr \
    unzip \
    git \
    expect \
    jq  \
    python-pexpect \
    htop


exit 0


apt-get install -y curl software-properties-common 
