Vault aims to solve the problem of secret management by centralizing the storage of secrets and developing 'policies' for a more controlled access and distribution of secrets.

This tutorial will cover setup of vault to serve secrets on localhost over http. 
In a production scenario you would create a domain name such as vault.mywebsite.com
Nginx or apache would be used to receive https requests to this domaini at port 443; ideally whitelisted to only serve your private IPs
The webserver would then proxy_pass requests to localhost:8200

## Install
cmd
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vault
vault -v
```
## Configure 

We will be using the $HOME directory to store all our operational files

```
cd
mkdir vault/data
export VAULT_ADDR=http://127.0.0.1:8200

touch config.hcl
nano config.hcl

#------CONFIG-------
storage "raft" {
  path    = "./vault/data"
  node_id = "n1"
}

listener "tcp" {
  address     = "127.0.0.1:8200"
  tls_disable = 1
}

api_addr = "http://127.0.0.1:8200"
ui = true
disable_mlock = true

#------CONFIG-------
```

storage: Vault has various storage options from SQL, Consul, Manta, Google Cloud Storage, S3 etc. We use raft, which is the standard production ready local storage backend.
We create a directory vault/data where vault stores all our encrypted secrets

listener: sets up the communication protocol
the VAULT_ADDR env exported initially, must match the listener.address
tls is disabled since we will be enabling it at the top most proxy server level 

api_addr is the route that clients will requeset to access secrets

disable_mlock is only required if you get an error when initializing vault


Vault Usage
Initializing
```
vault server -config=config.hcl
vault operator init
```
Unseal Keys
Root Token
Login
Secret
Policy
Hardening
