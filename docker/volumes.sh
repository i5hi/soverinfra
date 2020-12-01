#!/bin/bash

docker volume create --name bitcoindata --opt type=none --opt device=/home/bitcoin/.bitcoin/ --opt o=bind

