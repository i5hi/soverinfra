#!/bin/bash

echo "sats" | openssl aes-256-cbc -e  -a -K 'bas64hexplease' -iv '0000000002a6ad145f53a5d7382a6ad1'
# openssl enc -aes-256-cbc -k secret -P -md sha1
# echo "V0mbTupus/B/cgU+13wV3g==" | openssl aes-256-cbc -a -d -K 'bas64hexplease' -iv '585a1b4c23beb8ee0beb64d5b7a70452'

# cat input.txt
# rm -rf text.*
