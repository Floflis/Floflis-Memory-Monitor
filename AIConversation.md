# Chat Transcript - Tab 1

## User:

Hello, Claude 3.5 Sonnet!

I don't want anymore flomem to run on boot, but after logon!

## AI:

To change flomem to run after logon instead of on boot, we need to modify the installation process. Let's update the `install.sh` script to create a desktop entry file that will launch flomem when the user logs in. Here are the changes we need to make:

1. Remove the cronjob setup from `install.sh`.
2. Add a function to create a desktop entry file.

Let's modify the `install.sh` script:


```1:50:install.sh
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
```


Replace the `setup_cronjob` function and its call with a new function to create a desktop entry:

```shell:install.sh
# Function to create a desktop entry for autostart
create_desktop_entry() {
    mkdir -p "$HOME/.config/autostart"
    cat > "$HOME/.config/autostart/flomem.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Floflis Memory Monitor
Exec=/usr/lib/$SCRIPT_NAME
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
EOF
    chmod +x "$HOME/.config/autostart/flomem.desktop"
}

create_config
create_action_scripts
create_monitor_script
create_desktop_entry
drop_sudo
```

This change will create a `.desktop` file in the user's autostart directory, which will launch flomem when the user logs in.

Also, update the README.md file to reflect this change:


```58:60:README.md
# Cronjob

The install script sets up a cronjob to run the memory monitor script at startup. The cronjob entry is added to the user's crontab.
```


Replace these lines with:

```markdown
# Autostart

The install script creates a desktop entry file that will automatically start the memory monitor when you log in to your desktop environment.
```

These changes will make flomem start after the user logs in, rather than on system boot. The desktop entry file will ensure that flomem starts with the user's session, providing the same monitoring functionality but only when a user is actually logged in.

## User:

Another issue, this time about @action.89.sh and @action.95.sh : instead of asking to close the process which is using the most RAM (in my case Firefox), it closed other (in this case my Cinnamon DE crashed into fallback mode 3 times, while Firefox left open).

## AI:

I understand the issue. The problem is that the current implementation is targeting the process using the most RAM, which might not always be the one causing the memory pressure. Let's modify both action scripts to target processes more intelligently. We'll focus on closing non-essential processes first and only target larger processes if necessary.

Here's an updated version for both scripts:

For `action.89.sh`:

```shell:action.89.sh
#!/bin/bash

echo "Memory usage has reached the threshold of 89%. Running the action script."

# List of non-essential processes to close first
non_essential_processes=("firefox" "chromium" "vlc" "gimp" "libreoffice")

for process in "${non_essential_processes[@]}"; do
    pid=$(pgrep -x "$process")
    if [ -n "$pid" ]; then
        echo "Asking $process (PID: $pid) to close gracefully"
        kill -15 "$pid"
        notify-send "High Memory Usage Alert" "Process $process has been asked to close to free up memory."
        exit 0
    fi
done

# If no non-essential process found, target the largest process excluding critical ones
largest_process=$(ps -eo pid,pmem,comm --sort=-pmem | awk 'NR>1 && $3 !~ /^(systemd|kernel|init|Xorg|cinnamon)$/ {print $1,$3; exit}')

if [ -n "$largest_process" ]; then
    pid=$(echo "$largest_process" | awk '{print $1}')
    name=$(echo "$largest_process" | awk '{print $2}')
    echo "Asking $name (PID: $pid) to close gracefully"
    kill -15 "$pid"
    notify-send "High Memory Usage Alert" "Process $name has been asked to close to free up memory."
fi
```

For `action.95.sh`:

```shell:action.95.sh
#!/bin/bash

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
```

These updated scripts do the following:

1. They first try to close non-essential processes from a predefined list.
2. If no non-essential process is found, they target the largest process that isn't a critical system process.
3. The 89% script uses a graceful termination signal (SIGTERM, -15), while the 95% script uses a forceful termination signal (SIGKILL, -9).
4. Critical processes like systemd, kernel, init, Xorg, and cinnamon are excluded from being targeted.

This approach should prevent the Cinnamon DE from crashing while still effectively managing memory usage. Remember to adjust the `non_essential_processes` list according to your system's typical usage patterns.

## User:


