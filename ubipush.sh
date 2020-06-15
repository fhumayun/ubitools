!/usr/bin/bash

# Reads servername.txt for MQTT server URL and assigns string to variable "server"
# Echo eui_listserver=$(cat servername.txt).txt
# Asks user to continue
# If answer is "Y" or "y" then perform reboot, else exit
# Clears schedules for all EUI in eui_list.txt
# eui_list.txt is whitespace separated, empty new lines (/r/n) cause errors

server=$(cat servername.txt)
#cust_id="19750"
#configserver="mqtt.${cust_id}.ubicquia.com"
configserver=$1
cust_id=$2

mqtt_payload_custid(){
	local cid="$2"
	echo "Processing Dev EUI: "$EUI
	echo "Processing Customer ID: " $(cid)
	DATA="t:20,d:$2"
	DATA_B64=`echo ${DATA} | base64`
	export LC_CTYPE=C
	REF=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
	echo ${DATA}
	# echo ${DATA_B64}
	mosquitto_pub -t "ubicell/${EUI}/tx" -m "{\"payload\": \"$DATA_B64\"}" --id $REF -q 1 -h $server -p 1883 -u test -P test
}
mqtt_payload_redirect_node(){
	local bid="$1"
	echo "Processing Dev EUI: "$EUI
	echo "Processing MQTT Broker: "$(bid)
	echo $EUI
	echo $1
	DATA="t:10,d:$1"
	DATA_B64=`echo ${DATA} | base64`
	export LC_CTYPE=Ccar
	REF=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
	echo ${DATA}
	# echo ${DATA_B64}
	mosquitto_pub -t "ubicell/${EUI}/tx" -m "{\"payload\": \"$DATA_B64\"}" --id $REF -q 1 -h $server -p 1883 -u test -P test
}

echo "Update will point to the MQTT broker at: "$1
echo "The following Dev EUI will be processed: "$(cat eui_list.txt)
echo "The Customer ID is going to be set to: "$2
echo -n "Are you sure? (y/n)"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
	while read EUI; do
		mqtt_payload_custid $2
		sleep 1
		mqtt_payload_redirect_node $1
		sleep 1
	done < eui_list.txt
	echo "Customer ID was SET to $2 console log if available."
	echo "MQTT broker was SET to $1 console log if available."
else
	echo "No Customer ID or MQTT broker was set"
	exit
fi
