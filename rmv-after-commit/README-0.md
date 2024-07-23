# Floflis Memory Monitor

## Overview

The Floflis Memory Monitor (`flomem`) is a Bash script that monitors your RAM usage and sends a notification when the usage exceeds a specified threshold. Additionally, it supports executing a custom action script when the threshold is reached multiple times.

## Installation

To install the Floflis Memory Monitor, run the `install.sh` script:

```sh
chmod +x install.sh
./install.sh

# Configuration

The configuration file is located at ~/.config/floflis/flomem/config.sh. You can adjust the following variables:

- THRESHOLD: The RAM usage threshold percentage. Default is 89.
- ACTION_SCRIPT: The path to the custom action script. Default is ~/.config/floflis/flomem/action.sh.
- MAX_THRESHOLD_REACHED: The maximum number of times the threshold can be reached before notifying the user to restart the computer. Default is 2.

# Action Script

The action script is located at ~/.config/floflis/flomem/action.sh. By default, it contains a sample action to kill the process using the most RAM (commented out). Uncomment the following lines to enable this action:

```bash
# top -b -o +%MEM | head -n 10 | tail -n 1 | awk '{print $1}' | xargs -I {} kill -9 {}
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
   - Save the action script as `action.sh`.
   - Save the memory monitor script as `flomem`.
   - Save the installation script as `install.sh`.
   - Save the README file as `README.md`.

2. **Make the Install Script Executable**:
   Make the install script executable with the following command:
   ```sh
   chmod +x install.sh

3. **Run the Install Script**:

Run the script with:

```bash
./install.sh
```

This setup will create the necessary configuration and action scripts in ~/.config/floflis/flomem/, install the flomem monitoring script to /usr/lib, set up a cronjob to run the flomem script at startup, and handle sudo privileges properly. The script will also keep a temporary count of threshold breaches and notify the user to restart the computer if the threshold is reached a specified number of times.
