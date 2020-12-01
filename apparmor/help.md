# Start by creating a default profile for a given program:

```
aa-easyprof /usr/bin/node
aa-easyprof /usr/bin/node > usr.bin.node
mv usr.bin.node /etc/apparmor.d
apparmor_parser -r /etc/apparmor.d/usr.bin.node
```

# Running the program will result in errors
```
node status
```

# Updating the profile based on error logs

AppArmor denials are logged to /var/log/syslog (or /var/log/audit/audit.log for non-DBus policy violations if auditd is installed). 

The kernel will rate limit AppArmor denials which can cause problems while profiling. 

To avoid this install auditd or adjust the rate limit in the kernel:

```
sysctl -w kernel.printk_ratelimit=0
```

## View  error logs
```
# tail -100 /var/log/syslog
# alternative to tailing logs: this shows denials in the last day
/usr/bin/aa-notify -s 1 -v
```

## Complain mode

```
# set app to complain mode
aa-complain node
# now running node will give a more detailed log
node status
# use aa-logprof interactive to update profile
aa-logprof
```

### Hand editing the profile?
```
nano /etc/apparmor.d/usr.bin.node
apparmor_parser -r /etc/apparmor.d/usr.bin.node
```

# Enforce profile

After we are done setting up the profile and testing it until it stops complaining, we change modes
```
aa-enforce node
```