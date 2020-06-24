#!/bin/bash
mqttserver=$(cat mqtt-servername.txt)
eui=$(cat eui.txt)
# $1 == EUI
DATA="t:20,d:$1"
DATA_B64=`echo ${DATA} | base64`
REF=$(cat /dev/urandom | tr -dc 'a-zzA-Z0-9' | fold -w 8 | head -n 1)
echo ${DATA}
echo ${DATA_B64}
echo "Command Sent to: "${eui} " listening on: " $mqttserver  " using customer id: " $1
/usr/bin/mosquitto_pub -t "ubicell/${eui}/tx" -m "{\"payload\": \"$DATA_B64\"}" --id $REF -q 1 -h $mqttserver -p 1883 -u test -P test