#!/bin/bash
# read_tbw_disk.sh
# Purpose: Read the TBW of a SSD Drive from smartctl and print it. For example in a Samsung 850 SSD 512Gb of capacity the maximun is 150#
smartctl -A /dev/sda | awk '/^241/ { print "TBW: "($10 * 512) * 1.0e-12, "TB" } '