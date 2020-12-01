### Turn off Core Dumps
ulimit -c 0

# Approles
In practice, when services that require secret values are deployed, a token should not be distributed as part of the deployment or configuration management. Rather, services should authenticate themselves to Vault in order to acquire a token that has a limited lifetime. This ensures that credentials eventually expire and cannot be reused if they are ever leaked or disclosed.

The AppRole authentication method works by requiring that clients provide two pieces of information: the AppRole RoleID and SecretID. The recommendation approach to using this method is to store these two pieces of information in separate locations, as one alone is not sufficient to authenticate against Vault, but together, they permit a client to retrieve a valid Vault token. For example, in a production service, a RoleID might be present in a service’s configuration file, while the SecretID could be provided as an environment variable.

```
vault auth enable approle
```
```
vault write auth/approle/role/msec \
    token_ttl=10m \
    policies=basic
```

Read role-id

```
vault read auth/approle/role/msec/role-id
```

Write+Read secret-id
```
vault write -f auth/approle/role/msec/secret-id
```

Get a token 

```
vault write auth/approle/login \
    role_id=147cd412-d1c2-4d2c-c57e-d660da0b1fa8 \
    secret_id=2225c0c3-9b9f-9a9c-a0a5-10bf06df7b25
```