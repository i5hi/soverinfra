#!/bin/bash
# Bring in all vault secrets required by sats.cc

VAULT_TOKEN_MEW=$1

curl --header "X-Vault-Token: ${VAULT_TOKEN_MEW}" https://vault.sats.cc/v1/kv-v1/mew/fullchain \
| jq -r ".data.secret" > /home/nginx/.ssl/fullchain.pem
curl --header "X-Vault-Token: ${VAULT_TOKEN_MEW}" https://vault.sats.cc/v1/kv-v1/mew/privkey \
| jq -r ".data.secret" > /home/nginx/.ssl/privkey.pem

chown -R nginx /home/nginx 
# s.Z9S0lC6lpdAH8jcJ5UK9kzBp