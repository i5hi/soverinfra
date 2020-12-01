#!/bin/bash -e

# ADMIN_USER  passed in packer as environment variable
BASHRC=/home/$ADMIN_USER/.bashrc

echo 'export NODE_ENV="PROD"' >> $BASHRC
echo 'export KEY_PATH="/home/sushi/.keys"' >> $BASHRC
echo 'export MOLTRES_PORT="2323"' >> $BASHRC
echo 'export METAPOD_PORT="3751"' >> $BASHRC
echo 'export DB_IP="127.0.0.1"' >> $BASHRC
echo 'export DB_PORT="27017"' >> $BASHRC
echo 'export LOGGER_IP="staryu"' >> $BASHRC
echo 'export LOGGER_PORT="9936"' >> $BASHRC
echo 'export BITCOIN_IP="127.0.0.1"' >> $BASHRC
echo 'export BITCOIN_PORT="8332"' >> $BASHRC
echo 'export CLAM_IP="172.17.0.2"' >> $BASHRC
echo 'export CLAM_PORT="3310"' >> $BASHRC

echo 'export VAULT_TOKEN=""' >> $BASHRC

echo 'alias edenv="nano /home/'$ADMIN_USER'/.bashrc"' >> $BASHRC
echo 'alias senv="source /home/'$ADMIN_USER'/.bashrc"' >> $BASHRC

echo 'alias gooss="sudo /var/ossec/bin/ossec-control start"' >> $BASHRC
echo 'alias nooss="sudo /var/ossec/bin/ossec-control stop"' >> $BASHRC
echo 'alias flogoss="sudo tail -f /var/ossec/logs/alerts/alerts.log"' >> $BASHRC 
echo 'alias clogoss="sudo tail -909 /var/ossec/logs/alerts/alerts.log"' >> $BASHRC

echo 'alias btcd="bitcoind -conf=/home/bitcoin/.bitcoin/bitcoin.conf -datadir=/home/bitcoin/.bitcoin"' >> $BASHRC
echo 'alias bcli="bitcoin-cli -conf=/home/bitcoin/.bitcoin/bitcoin.conf"' >> $BASHRC

source $BASHRC

exit 0;