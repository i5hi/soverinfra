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
    jq

exit 0
