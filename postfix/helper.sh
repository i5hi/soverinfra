#!/bin/bash -e

# 
# add domain, tld and username in hosts - api.sats.cc sushi
nano /etc/hosts

# ************************INTERACTIVE**************************
apt-get install postfix
apt-get install postfix-policyd-spf-python  
# ************************INTERACTIVE**************************

nano /etc/postfix/main.cf
# inet_interfaces = loopback-only
apt-get install opendkim opendkim-tools -y
adduser postfix opendkim
nano /etc/opendkim.conf
# Canonicalization     relaxed/simple
# Mode                 s
# SubDomains           no

# Map domains in From addresses to keys used to sign messages
# KeyTable           refile:/etc/opendkim/key.table
# SigningTable       refile:/etc/opendkim/signing.table

# A set of internal hosts whose mail should be signed
# InternalHosts       /etc/opendkim/trusted.hosts

mkdir /etc/opendkim && \
mkdir /etc/opendkim/keys && \
chown -R opendkim:opendkim /etc/opendkim && \
chmod go-rw /etc/opendkim/keys && \
nano /etc/opendkim/signing.table 

# *@api.sats.cc     sendonly._domainkey.api.sats.cc
nano /etc/opendkim/key.table

# sendonly._domainkey.api.sats.cc    api.sats.cc:sendonly:/etc/opendkim/keys/api.sats.cc/sendonly.private

nano /etc/opendkim/trusted.hosts

# 127.0.0.1
# localhost

# *.api.sats.cc

# GENERATE KEYS

mkdir /etc/opendkim/keys/api.sats.cc &&
    opendkim-genkey -b 2048 -d api.sats.cc -D /etc/opendkim/keys/api.sats.cc -s sendonly -v &&
    chown opendkim:opendkim /etc/opendkim/keys/api.sats.cc/sendonly.private


# *********** DNS UPDATE **************
# *********** DNS UPDATE **************
cat /etc/opendkim/keys/api.sats.cc/sendonly.txt

# copy without quotes and jazz; as below
 v=DKIM1; h=sha256; k=rsa; 
	  p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqDUp7pM6NCaceDVTVOmJ+ANOwIwriYurNZs9uxdCkthxNlgkcrMEGkyKyM6Z5kXN76gcFSx40jIw1xjWZLJfdgJZLV50v2ZAcaArzE2YRXO1axPirxwtvuI7RKG8fAidYsC9vrgEobVcSomVYf7YU5RH5hq+aFAlBwls8X2PneKXpNlz3IHjD4DhAnDdhzFddo+Zm7arhMopyB
	  H9WENoIsqQK+IrQ25bGe5Z7jBXKrBS1fgOw2vU/kwGW6+UbJRphWsROYZyLlfuKEOPxMwUkY3vawobilxjhjJOLYvdMwI1PFgx+XJRyRX62Dua8JRCLqxCL4wM7Q9TRlIPn/zPhQIDAQAB
# add TXT to domain with name = sendonly._domainname content = cat output within parenthesis
# remove double quotes

# TEST

opendkim-testkey -d api.sats.cc -s sendonly -vvv
# If you see Key not secure in the command output, don’t panic. This is because DNSSEC isn’t enabled on your domain name. For testing its okay.
# Enbale DNNSEC on cloudflare. 

# *********** DNS UPDATE **************
# *********** DNS UPDATE **************

# LINK UP POSTFIX AND OPENDKIM

# 
mkdir /var/spool/postfix/opendkim && \
    chown opendkim:postfix /var/spool/postfix/opendkim
    
nano /etc/opendkim.conf

# Find and replce: 
# Socket    local:/var/run/opendkim/opendkim.sock
# WITH: 
# Socket local:/var/spool/postfix/opendkim/opendkim.sock
nano /etc/default/opendkim
# replace: SOCKET="local:/var/run/opendkim/opendkim.sock"
# with
#   SOCKET="local:/var/run/opendkim/opendkim.sock"

# FINALLY ADD OPENDKIM TO POSTFIX

nano /etc/postfix/main.cf

# Milter configuration
#milter_default_action = accept
#milter_protocol = 6
#smtpd_milters = local:opendkim/opendkim.sock
#non_smtpd_milters = $smtpd_milters

hostnamectl set-hostname api.sats.cc
systemctl restart opendkim postfix


# Add TXT RECORD
# TXT  @   v=spf1 mx ip4:12.34.56.78 ip6:2600:3c01::f03c:93d8:f2c6:78ad ~all
# ref: https://www.linuxbabe.com/mail-server/setting-up-dkim-and-spf

echo "Hi ishi! You are now an active email recipient for notifications at api.sats.cc. Lets GO!!!!" | mail -s "Woof woof" vishalmenon.92@gmail.com

#jusChekdid
tail -1000 /var/log/mail.log