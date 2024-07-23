#!/bin/bash

CONFIG_DIR="$HOME/.config/floflis/flomem"
SCRIPT_DIR="/usr/lib"
SCRIPT_NAME="flomem"

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
    sudo cp flomem "$SCRIPT_DIR/$SCRIPT_NAME"
    sudo chmod +x "$SCRIPT_DIR/$SCRIPT_NAME"
}

# Function to set up the cronjob
setup_cronjob() {
    (crontab -l ; echo "@reboot $SCRIPT_DIR/$SCRIPT_NAME") | crontab -
}

# Drop sudo privileges
if [ "$(id -u)" = "0" ]; then
    exec su -c "$0" "$SUDO_USER"
fi

# Main installation process
main() {
    create_config
    create_action_scripts
    create_monitor_script
    setup_cronjob

    echo "Floflis Memory Monitor installed successfully!"
}

main

