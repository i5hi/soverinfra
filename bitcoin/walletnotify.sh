#!/bin/bash -e

echo $1 >> /home/bitcoin/track

CORE_UPDATE_ADDRESS="http://localhost:52323/wallet/bitcoin/notify"

curl -X POST $CORE_UPDATE_ADDRESS -d "txid="$1"&secret=supersecretsauces"

exit 0;