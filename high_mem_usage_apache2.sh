#!/bin/bash
# script high_mem_usage_apache2
# script to detect high memory usage in apache2, check for messages:
# Cannot allocate memory, Unable to fork, possible coredump in /etc/apache2
APACHE2_LOG_DIR='/var/log/apache2/error.log'
NUM_OF_LINES_TO_CHECK=1500

result=$(tail -n$NUM_OF_LINES_TO_CHECK "$APACHE2_LOG_DIR" | egrep -i "Memory allocation failed|Cannot allocate memory|Unable to fork|possible coredump in /etc/apache2")

if [[ ! -z $result ]]; then
    # put in here specific actions to do when detect high usage
    echo $result
fi