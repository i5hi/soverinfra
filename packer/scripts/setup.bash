#!/bin/bash -e
MONGO_VER=4.2
BITCOIN_VER=0.20.1
NODE_VER=14
# ADMIN_USER  passed in packer as environment variable
ADMIN_HOME=/home/$ADMIN_USER
useradd -m -c "admin" $ADMIN_USER 
usermod -aG sudo $ADMIN_USER
usermod -s /bin/bash $ADMIN_USER

cd $ADMIN_HOME

# install programs
# mail
apt-get install mailutils opendkim opendkim-tools -y
echo "postfix postfix/main_mailer_type string 'Internet Site'" | debconf-set-selections 
echo "postfix postfix/mailname string api.sats.cc" | debconf-set-selections 
apt-get install postfix -y > /dev/null 2>&1
# apparmor,nodeJS,bitcoin,mongo,docker
git clone https://github.com/Laziemo/banditscribs

# bash $ADMIN_HOME/banditscribs/bitcoin/install.bash $BITCOIN_VER 
bash $ADMIN_HOME/banditscribs/mongoDB/install_mongodb.sh $MONGO_VER 
bash $ADMIN_HOME/banditscribs/docker/install.bash $OS $ADMIN_USER 
bash $ADMIN_HOME/banditscribs/node.JS/install.sh $NODE_VER 
# bash $ADMIN_HOME/banditscribs/nginx/install.sh $NODE_VER 

apt-get install -y auditd \
    postfix-policyd-spf-python \
    apparmor-utils  \
    apparmor-easyprof \
    apparmor-notify \

#add users with UID based on Dockerfiles for correct permissions
useradd -u 1900 -U -o -m -c "" nginx
usermod -p 'test' nginx
mkdir /home/nginx/.ssl
chown nginx /home/nginx/.ssl -R
chmod 400 /home/nginx/.ssl -R
id nginx 

useradd -u 1700 -U -o -m -c "" bitcoin
mkdir /home/bitcoin/.bitcoin
chown bitcoin /home/bitcoin/.bitcoin -R
chmod 700 /home/bitcoin/.bitcoin
id bitcoin

cat /etc/hosts
printf "\nremember to celebrate the milestones, as you prepare for the road ahead."

exit 0;


