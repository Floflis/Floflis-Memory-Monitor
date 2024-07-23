#!/bin/bash

# Add the action you want to perform when the threshold is reached
echo "Memory usage has reached the threshold. Running the action script."
# Add more actions here

# Sample action: Gracefully close the process that is using the most RAM (uncomment to activate)
# process_to_close=$(top -b -o +%MEM | head -n 10 | tail -n 1 | awk '{print $1}')
# kill -15 $process_to_close
# notify-send "High Memory Usage Alert" "Process $process_to_close has been asked to close to free up memory."

