#!/bin/bash 

vault secrets enable -path=sats/ kv

vault kv put sats-cc/mongo/auth                   secret=$1

vault kv put sats-cc/bitcoind/auth                secret=$2
vault kv put sats-cc/bitcoind/wallet/root         secret=$3
vault kv put sats-cc/bitcoind/wallet/cc-pass      secret=$4

vault kv put sats-cc/nginx/api-fullchain          secret=$5
vault kv put sats-cc/nginx/api-privkey            secret=$6
vault kv put sats-cc/nginx/root-fullchain         secret=$7
vault kv put sats-cc/nginx/root-privkey           secret=$8

vault kv put sats-cc/moltres/firebase/privkey     secret=$9
vault kv put sats-cc/moltres/gsec/app             secret=$10
vault kv put sats-cc/moltres/gsec/tfa             secret=$11
vault kv put sats-cc/moltres/gsec/profile         secret=$12

