#!/bin/bash

CONFIG_DIR="$HOME/.config/floflis/flomem"
#SCRIPT_DIR="/usr/lib"
SCRIPT_NAME="flomem"

# Function to drop sudo privileges whenever it isn't needed anymore
drop_sudo() {
    # Drop sudo privileges
    if [ "$(id -u)" = "0" ]; then
       exec su -c "$0" "$SUDO_USER"
    fi
}

# Function to create the config directory and files
create_config() {
    mkdir -p "$CONFIG_DIR"
    cp config.sh "$CONFIG_DIR/config.sh"
    chmod +x "$CONFIG_DIR/config.sh"
}

# Function to create the action scripts
create_action_scripts() {
    cp action.89.sh "$CONFIG_DIR/action.89.sh"
    chmod +x "$CONFIG_DIR/action.89.sh"
    cp action.95.sh "$CONFIG_DIR/action.95.sh"
    chmod +x "$CONFIG_DIR/action.95.sh"
}

# Function to create the memory monitor script
create_monitor_script() {
    sudo cp -f "$SCRIPT_NAME" "/usr/lib/"
    sudo chmod +x "/usr/lib/$SCRIPT_NAME"
}

# Function to set up the cronjob
setup_cronjob() {
    crontab -e #thanks to https://unix.stackexchange.com/a/212705 - HAS TO UPVOTE
    (crontab -l ; echo "@reboot /usr/lib/$SCRIPT_NAME") | crontab -
}

create_config
create_action_scripts
create_monitor_script
setup_cronjob
drop_sudo

echo "It seems that Floflis Memory Monitor has been installed successfully!"

