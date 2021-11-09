#!/bin/bash
# Block all traffic from specific ips reported into https://www.abuseipdb.com/
# the script uses iptables and by default block any traffic from that hosts
# -------------------------------------------------------------------------------

### Set PATH ###
# set the path of the commands used by this script
IPT=/sbin/iptables
EGREP=/bin/egrep
WGET=/usr/bin/wget
CURL=/usr/bin/curl
RM=/bin/rm
# set the minimum confidence for each report, as filter for the api
MINCONFIDENCE=25

# get the next key from https://www.abuseipdb.com/
ABUSEIPKEY=584bc425dcfd0e57bc77cca9e558386bdf6457d4ca6ed001bc06b5cd9b7f7ac8ba2dd994977ff1fa

# clean all the current iptables rules, this is optional
$IPT -F

$CURL -G https://api.abuseipdb.com/api/v2/blacklist -d confidenceMinimum=$MINCONFIDENCE -H "Key: $ABUSEIPKEY" -H "Accept: text/plain" > abuse_ip_list.txt

# get list of ips to blacklist
BLACKLISTIP=$(egrep -v "^#|^$" abuse_ip_list.txt)
for iptoblock in $BLACKLISTIP
do
	# block any type of traffic from the listed block of ips
    #$IPT -A INPUT -s $iptoblock -j DROP

	# comment this line if you dont want to see what ip is being blocked in the terminal.
    echo $iptoblock
done

# delete ip list file
$RM abuse_ip_list.txt

exit 0