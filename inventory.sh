#!/bin/sh
DONELEDS=led0 led1
SERVER=$(cat server.txt)
SERIAL=$(cat /proc/cpuinfo | grep ^Serial | head -n1 | awk '{print $3}')

for DONELED in ${DONELEDS}
do
    echo none > /sys/class/leds/${DONELED}/trigger
    echo 0 > /sys/class/leds/${DONELED}/brightness
done

upload() {
    curl --data-binary @- "${SERVER}/cgi-bin/data.cgi/${SERIAL}/$1"
}

echo "Running inventory script on ${SERIAL} downloaded from ${SERVER}."
cat /proc/cpuinfo | upload cpuinfo &
free 2>&1 | upload free &
ifconfig 2>&1 | upload ifconfig &
iwconfig 2>&1 | upload iwconfig &
wait

for DONELED in ${DONELEDS}
do
    echo heartbeat > /sys/class/leds/${DONELED}/trigger
done
