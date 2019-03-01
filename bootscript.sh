#!/bin/sh
cd /boot/inventory
if grep -q 'options single-request-reopen' /etc/resolv.conf
then
        :
else
        echo 'options single-request-reopen' >> /etc/resolv.conf
fi
SERVER=$(cat server.txt)
curl -s $SERVER/inventory.sh | sh
