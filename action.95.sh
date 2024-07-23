#!/bin/bash

# Action for 95% memory usage
echo "Memory usage has reached the threshold of 95%. Running the action script."

# Forcibly kill the process using the most RAM
process_to_kill=$(top -b -o +%MEM | head -n 10 | tail -n 1 | awk '{print $1}')
kill -9 $process_to_kill
notify-send "High Memory Usage Alert" "Process $process_to_kill has been forcibly killed to free up memory."

