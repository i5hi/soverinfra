#!/bin/bash

bitcoin-cli getnewaddress "exit" bech32
bitcoin-cli getbalance => balance
bitcoin-cli sendtoaddress "exit" <balance>
bitcoin-cli dumpprivkey "exit" => privkey

# save priv key to vault an import at new node

bitcoin-cli importprivkey <privkey>