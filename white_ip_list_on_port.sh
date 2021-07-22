#!/bin/bash
# iptables -n -L -v --line-number
# white_ip_list_on_port.sh

IP="127.0.0.2,127.0.0.1"

IFS=',' read -ra array <<< "$IP"
for element in "${array[@]}"
#for index in "${!array[@]}"
do
        # in case of various ports.
        #iptables -I INPUT 1 -p tcp --match multiport --dport 3306,8080 -s "$element" -j ACCEPT
        
        # in case of one port
        iptables -I INPUT 1 -p tcp --dport 8080 -s "$element" -j ACCEPT
        echo "$element added to SSH 8080"
done
VALOR="${#array[@]}"
FINAL=`expr $VALOR + 1`

# in case of various ports.
#iptables -I INPUT "$FINAL" -p tcp --match multiport --dport 3306,8080 -j DROP

# in case of one port
iptables -I INPUT "$FINAL" -p tcp --dport 8080 -j DROP
iptables -n -L -v --line-number
echo "$FINAL"