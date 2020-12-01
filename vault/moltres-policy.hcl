path "sats/moltres/node/gsec" {
capabilities = ["read"]
}

path "sats/moltres/mongo/tfa_crypt" {
capabilities = ["read"]
}

path "sats/moltres/mongo/profile_crypt" {
capabilities = ["read"]
}

path "sats/moltres/bitcoind/rpc" {
capabilities = ["read"]
}

path "sats/moltres/bitcoind/wallet/*" {
capabilities = ["read"]
}

path "sats/moltres/bitcoind/cc_pass" {
capabilities = ["read"]
}

path "sats/moltres/firebase/privkey" {
capabilities = ["read"]     
}
