#!/bin/bash
DONELEDS="led0 led1"
SERVER=$(cat server.txt)
SERIAL=$(cat /proc/cpuinfo | grep ^Serial | head -n1 | awk '{print $3}')
if [ -z "$SERIAL" ]; then
    # Debian/Raspbian includes Serial/Revision in cpuinfo; Alpine doesn't
    # See https://github.com/raspberrypi/linux/issues/2110
    SERIAL=$(cat /proc/device-tree/serial-number)
    brokencpuinfo=yes
fi

for DONELED in ${DONELEDS}
do
    echo none > /sys/class/leds/${DONELED}/trigger
    echo 0 > /sys/class/leds/${DONELED}/brightness
done

upload() {
    curl --data-binary @- "${SERVER}/cgi-bin/data.cgi/${SERIAL}/$1"
}

echo "Running inventory script on ${SERIAL} downloaded from ${SERVER}."
if [ "$brokencpuinfo" = "yes" ]; then
    ( \
      cat /proc/cpuinfo; \
      echo "Revision	: $(cat /proc/device-tree/system/linux,revision | xxd -p)"; \
      echo "Serial		: $(cat /proc/device-tree/system/linux,serial | xxd -p)"; \
      :
    ) | upload cpuinfo &
else
    cat /proc/cpuinfo | upload cpuinfo &
fi
free 2>&1 | upload free &
ifconfig 2>&1 | upload ifconfig &
iwconfig 2>&1 | upload iwconfig &
wait

for DONELED in ${DONELEDS}
do
    echo heartbeat > /sys/class/leds/${DONELED}/trigger
done
