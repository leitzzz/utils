#!/bin/bash
# Purpose: Block all traffic from specific countries. Use ISO code, example ca for canada. #
# the script uses iptables and by default block any traffic from the clients
# -------------------------------------------------------------------------------
COUNTRYISOS="ca" 
 
### Set PATH ###
IPT=/sbin/iptables
WGET=/usr/bin/wget
EGREP=/bin/egrep
 
### No editing below ###
ZONEROOT="/install/iptables"
LISTISOSOURCE="http://www.ipdeny.com/ipblocks/data/countries"
 
# create a dir if not exists
[ ! -d $ZONEROOT ] && /bin/mkdir -p $ZONEROOT

# clean ip tables rules
$IPT -F
  
for c  in $COUNTRYISOS
do 
	# read local zone file for the ISO Country
	tDB=$ZONEROOT/$c.zone
 
	# get fresh zone file, from http://www.ipdeny.com
	$WGET -O $tDB $LISTISOSOURCE/$c.zone
 
	# get list of ips for that ISO country from local directory
	BLACKLISTIP=$(egrep -v "^#|^$" $tDB)
	for iptoblock in $BLACKLISTIP
	do
	   # block any type of traffic from the listed block of ips
       iptables -A INPUT -s $iptoblock -j DROP

	   # to block specific port, for example http 80
	   #iptables -A INPUT -s $iptoblock -p tcp --destination-port 80 -j DROP

	   # comment this line if you dont want to see what ip is being blocked in the terminal.
       echo $iptoblock
	done
done

exit 0