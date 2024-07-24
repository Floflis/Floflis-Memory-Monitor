#!/bin/bash

# Action for 95% memory usage
echo "Memory usage has reached the threshold of 95%. Running the action script."

# List of non-essential processes to close first
non_essential_processes=("firefox" "chromium" "vlc" "gimp" "libreoffice")

for process in "${non_essential_processes[@]}"; do
    pid=$(pgrep -x "$process")
    if [ -n "$pid" ]; then
        echo "Forcibly closing $process (PID: $pid)"
        kill -9 "$pid"
        notify-send "High Memory Usage Alert" "Process $process has been forcibly closed to free up memory."
        exit 0
    fi
done

# If no non-essential process found, target the largest process excluding critical ones
largest_process=$(ps -eo pid,pmem,comm --sort=-pmem | awk 'NR>1 && $3 !~ /^(systemd|kernel|init|Xorg|cinnamon)$/ {print $1,$3; exit}')

if [ -n "$largest_process" ]; then
    pid=$(echo "$largest_process" | awk '{print $1}')
    name=$(echo "$largest_process" | awk '{print $2}')
    echo "Forcibly closing $name (PID: $pid)"
    kill -9 "$pid"
    notify-send "High Memory Usage Alert" "Process $name has been forcibly closed to free up memory."
fi