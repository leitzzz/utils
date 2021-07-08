#!/bin/bash
# Purpose: White list all traffic from specific countries. Use ISO code, example ec for Ecuador. #
# the script uses iptables and by default Allow any traffic from the clients
# -------------------------------------------------------------------------------
COUNTRYISOS="ec" 
 
### Set PATH ###
IPT=/sbin/iptables
WGET=/usr/bin/wget
EGREP=/bin/egrep
 
### No editing below ###
ZONEROOT="/install/iptables"
LISTISOSOURCE="http://www.ipdeny.com/ipblocks/data/countries"
 
# create a dir if not exists
[ ! -d $ZONEROOT ] && /bin/mkdir -p $ZONEROOT

# clean ip tables rules and accept connections
$IPT -F
$IPT -P INPUT ACCEPT
$IPT -P FORWARD ACCEPT
$IPT -P OUTPUT ACCEPT
  
for c  in $COUNTRYISOS
do 
	# read local zone file for the ISO Country
	tDB=$ZONEROOT/$c.zone
 
	# get fresh zone file, from http://www.ipdeny.com
	$WGET -O $tDB $LISTISOSOURCE/$c.zone
 
	# get list of ips for that ISO country from local directory
	WHITELISTIP=$(egrep -v "^#|^$" $tDB)
	for iptoallow in $WHITELISTIP
	do
	   # block any type of traffic from the listed block of ips
       $IPT -A INPUT -s $iptoallow -j ACCEPT
       
	   # to block specific port, for example http 80
	   #$IPT -A INPUT -s $iptoallow -p tcp --destination-port 80 -j ACCEPT

	   # comment this line if you dont want to see what ip is being blocked in the terminal.
       echo $iptoallow
	done
done


# block all the rest of traffic and allow connections from de server
$IPT -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPT -P INPUT DROP
$IPT -P FORWARD DROP
$IPT -P OUTPUT ACCEPT

exit 0