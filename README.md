# Floflis Memory Monitor

## Overview

The Floflis Memory Monitor (`flomem`) is a Bash script that monitors your RAM usage and sends a notification when the usage exceeds specified thresholds. Additionally, it supports executing custom action scripts for different thresholds.

## Installation

To install the Floflis Memory Monitor, run the `install.sh` script:

```sh
chmod +x install.sh
./install.sh
```

# Configuration

The configuration file is located at ~/.config/floflis/flomem/config.sh. You can adjust the following variables:

- `THRESHOLDS`: An array of RAM usage threshold percentages. Default is `(89 95)`.
- `ACTION_SCRIPTS`: An array of paths to the custom action scripts corresponding to the thresholds. Default is `("~/.config/floflis/flomem/action.89.sh" "~/.config/floflis/flomem/action.95.sh")`.
- `MAX_THRESHOLD_REACHED`: The maximum number of times the threshold can be reached before notifying the user to restart the computer. Default is 2.

# Action Scripts

The action scripts are located at `~/.config/floflis/flomem/action.89.sh` and `~/.config/floflis/flomem/action.95.sh`.

## Action for 89% (`action.89.sh`):

```sh
#!/bin/bash

# Action for 89% memory usage
echo "Memory usage has reached the threshold of 89%. Running the action script."

# Gracefully close the process using the most RAM (uncomment to activate)
# process_to_close=$(top -b -o +%MEM | head -n 10 | tail -n 1 | awk '{print $1}')
# kill -15 $process_to_close
# notify-send "High Memory Usage Alert" "Process $process_to_close has been asked to close to free up memory."

```

## Action for 95% (`action.95.sh`):

```sh
#!/bin/bash

# Action for 95% memory usage
echo "Memory usage has reached the threshold of 95%. Running the action script."

# Forcibly kill the process using the most RAM
process_to_kill=$(top -b -o +%MEM | head -n 10 | tail -n 1 | awk '{print $1}')
kill -9 $process_to_kill
notify-send "High Memory Usage Alert" "Process $process_to_kill has been forcibly killed to free up memory."

```

# Cronjob

The install script sets up a cronjob to run the memory monitor script at startup. The cronjob entry is added to the user's crontab.

# Usage

The memory monitor script (flomem) is installed at /usr/lib/flomem. It runs in the background, checking RAM usage every 3 seconds and logging usage details every minute.

# License

This project is licensed under the MIT License.

### Steps to Set Up:

1. **Save the Files**:
   - Save the configuration file as `config.sh`.
   - Save the action scripts as `action.89.sh` and `action.95.sh`.
   - Save the memory monitor script as `flomem`.
   - Save the installation script as `install.sh`.
   - Save the README file as `README.md`.

2. **Make the Install Script Executable**:
   Make the install script executable with the following command:
   ```sh
   chmod +x install.sh
   ```

3. **Run the Install Script**:

Run the script with:

```sh
./install.sh
```

This setup will create the necessary configuration and action scripts in ~/.config/floflis/flomem/, install the flomem monitoring script to /usr/lib, set up a cronjob to run the flomem script at startup, and handle sudo privileges properly. The script will also keep a temporary count of threshold breaches and notify the user to restart the computer if the threshold is reached a specified number of times.
