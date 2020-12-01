#!/bin/bash

wget https://www.atomicorp.com/OSSEC-ARCHIVE-KEY.asc
gpg --import OSSEC-ARCHIVE-KEY.asc

wget https://github.com/ossec/ossec-hids/releases/download/3.6.0/ossec-hids-3.6.0.tar.gz.asc
wget https://github.com/ossec/ossec-hids/archive/3.6.0.tar.gz
gpg --verify ossec-hids-3.6.0.tar.gz.asc 3.6.0.tar.gz

rm -rf ossec-hids-3.6.0.tar.gz.asc

tar -xvf 3.6.0.tar.gz && \
rm -rf 3.6.0.tar.gz


cd ossec-hids-3.6.0 && \
./install.sh

exit 0
