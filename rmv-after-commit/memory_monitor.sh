#!/bin/bash

# Load configuration
source ~/.config/floflis_memory-monitor/config.sh

# Function to get the total and used memory
get_memory_usage() {
    total_mem=$(free -m | awk '/^Mem:/ { print $2 }')
    used_mem=$(free -m | awk '/^Mem:/ { print $3 }')
    percent_used=$(( 100 * $used_mem / $total_mem ))
}

# Function to send notification
send_notification() {
    notify-send "High Memory Usage Alert" "Memory usage has reached $percent_used%!"
}

while true; do
    get_memory_usage
    echo "Total Memory: ${total_mem}MB"
    echo "Used Memory: ${used_mem}MB"
    echo "Memory Usage: ${percent_used}%"

    if [ $percent_used -gt $THRESHOLD ]; then
        send_notification
        $ACTION_SCRIPT
    fi

    sleep 60  # Check every minute
done

