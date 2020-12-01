#!/bin/bash
sudo apt-get install -y software-properties-common
sudo add-apt-repository -u ppa:bitcoin/bitcoin
sudo add-apt-repository -u ppa:lightningnetwork/ppa
sudo apt-get install bitcoind lightningd