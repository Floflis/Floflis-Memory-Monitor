#!/bin/bash

# Action for 89% memory usage
echo "Memory usage has reached the threshold of 89%. Running the action script."

# Gracefully close the process using the most RAM (uncomment to activate)
# process_to_close=$(top -b -o +%MEM | head -n 10 | tail -n 1 | awk '{print $1}')
# kill -15 $process_to_close
# notify-send "High Memory Usage Alert" "Process $process_to_close has been asked to close to free up memory."

