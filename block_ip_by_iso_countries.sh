#!/bin/bash
# Purpose: Block all traffic from specific countries. Use ISO code, example VE venezuela. #
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
 
	# get fresh zone file
	$WGET -O $tDB $DLROOT/$c.zone
 
	# get list of ips for that ISO country from local directory
	BLACKLISTIP=$(egrep -v "^#|^$" $tDB)
	for iptoblock in $BLACKLISTIP
	do
       iptables -A INPUT -s $iptoblock -j DROP
       echo $iptoblock
	done
done

exit 0