#!/bin/bash

cd $HOME/linux20/packer
packer build do.json

# alternative to manifest method
# packer build -machine-readable packer.json | awk -F, '$0 ~/artifact,0,id/ {print $6}'
ID=$(cat manifest.json | jq -r .builds[-1].artifact_id |  cut -d':' -f2)
REPLACE="image      = "\"$ID\"""

FILE=$HOME/linux20/terraform/do/terraform.tfvars

echo $REPLACE

sed -i "4s/.*/$REPLACE/" "$FILE"
