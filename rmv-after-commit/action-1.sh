#!/bin/bash

# Add the action you want to perform when the threshold is reached
echo "Memory usage has reached the threshold. Running the action script."
# Add more actions here

# Sample action: Kill the process that is using the most RAM (uncomment to activate)
# top -b -o +%MEM | head -n 10 | tail -n 1 | awk '{print $1}' | xargs -I {} kill -9 {}

