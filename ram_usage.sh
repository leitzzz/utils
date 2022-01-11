#!/bin/bash
# script ram_usage.sh
# script to return the % of memory usage in server using the command "free"
MEM_USAGE_LIMIT = 90
MEM_USAGE=$(free | awk '/Mem/{printf("RAM Usage: %.2f%\n"), $3/$2*100}' |  awk '{print $3}' | cut -d"." -f1)

if [ $mem_usage > $MEM_USAGE_LIMIT ]; then
   echo "Memory usage: $MEM_USAGE%" 
   # extra commands to do in case of high memory usage
else
   echo "Memory usage is in under the limits"
fi