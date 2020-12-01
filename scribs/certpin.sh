#!/bin/bash

#openssl s_client -servername api.sats.cc -connect api.sats.cc:443 < /dev/null | sed -n "/-----BEGIN/,/-----END/p" > api.sats.cc.pem
openssl x509 -pubkey < api.sats.cc.pem | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | base64 