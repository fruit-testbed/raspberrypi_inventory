#!/bin/sh
cd $(dirname $0)
if grep -q 'options single-request-reopen' /etc/resolv.conf
then
        :
else
        echo 'options single-request-reopen' >> /etc/resolv.conf
fi
SERVER=$(cat server.txt)

rm -f liveinventory.sh
while [ ! -s liveinventory.sh ]
do
    echo "Downloading $SERVER/inventory.sh to liveinventory.sh..."
    curl -s $SERVER/inventory.sh > liveinventory.sh
    if [ ! -s liveinventory.sh ]
    then
        sleep 3
    fi
done

sh ./liveinventory.sh
