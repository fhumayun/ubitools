!/usr/bin/bash
set -x

mqtt_server=$(cat mqtt_server.txt)
cust_id=$(cat cust_id.txt)
./ubipush.sh "$mqtt_server" "$cust_id"