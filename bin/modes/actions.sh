#!/bin/bash

# System actions mode - : prefix
# Self-contained implementation of all system actions

get_mode_info() {
    echo ": ⚡ Actions --actions"
}

# Declare associative arrays for action metadata
declare -A ACTION_TITLES
declare -A ACTION_DESCRIPTIONS

# Function to register action metadata
register_action() {
    local key="$1"
    local title="$2" 
    local description="$3"
    ACTION_TITLES["$key"]="$title"
    ACTION_DESCRIPTIONS["$key"]="$description"
}

# Power Management Actions
power_menu() {
    ~/.local/share/omarchy/bin/tlauncher --power
}
register_action "power_menu" "Power" "Show power menu"

lock_session() {
    launch_app hyprlock
}
register_action "lock_session" "Lock" "Lock the current session"

suspend_system() {
    systemctl suspend
}
register_action "suspend_system" "Suspend" "Suspend the system"

relaunch_hyprland() {
    hyprctl dispatch exit
}
register_action "relaunch_hyprland" "Relaunch" "Restart Hyprland window manager"

restart_waybar() {
    pkill waybar && hyprctl dispatch exec waybar
}
register_action "restart_waybar" "Restart Waybar" "Kill and restart waybar"

reload_waybar() {
    pkill -SIGUSR2 waybar
}
register_action "reload_waybar" "Reload Waybar" "Reload waybar config"

toggle_waybar() {
    pkill -SIGUSR1 waybar
}
register_action "toggle_waybar" "Toggle Waybar" "Toggle waybar visibility"


restart_system() {
    systemctl reboot
}
register_action "restart_system" "Restart" "Restart the system"

shutdown_system() {
    systemctl poweroff
}
register_action "shutdown_system" "Shutdown" "Shut down the system"

# System Configuration Actions
governor_menu() {
    ~/.local/share/omarchy/bin/tlauncher --governor
}
register_action "governor_menu" "Governor" "Switch CPU governor settings"

theme_menu() {
    ~/.local/share/omarchy/bin/tlauncher --themes
}
register_action "theme_menu" "Theme" "Change system theme"

location_menu() {
    ~/.local/share/omarchy/bin/tlauncher --location
}
register_action "location_menu" "Location" "Switch location settings"

tmux_sessions() {
    setsid alacritty -e ~/.local/share/omarchy/bin/tlauncher --tmux >/dev/null 2>&1 &
}
register_action "tmux_sessions" "Tmux" "Control tmux sessions"

# Audio Actions
audio_mixer() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "wiremix"
    else
        launch_app "alacritty --class wiremix -e bash -c 'sleep 0.2; wiremix'"
    fi
}
register_action "audio_mixer" "Audio Mixer" "Open audio mixer"

audio_output() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "wiremix -v output"
    else
        launch_app "alacritty --class wiremix -e bash -c 'sleep 0.2; wiremix -v output'"
    fi
}
register_action "audio_output" "Audio Output" "Open audio output panel"

audio_input() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "wiremix -v input"
    else
        launch_app "alacritty --class wiremix -e bash -c 'sleep 0.2; wiremix -v input'"
    fi
}
register_action "audio_input" "Audio Input" "Open audio input panel"

# Network Actions
network_manager() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "nmtui"
    else
        launch_app "alacritty --class nmtui -e bash -c 'sleep 0.5; nmtui'"
    fi
}
register_action "network_manager" "Network" "Control network connections"

wifi_manager() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "nmtui"
    else
        launch_app "alacritty --class nmtui -e bash -c 'sleep 0.5; nmtui'"
    fi
}
register_action "wifi_manager" "WiFi" "Control WiFi connections"

ethernet_manager() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "nmtui"
    else
        launch_app "alacritty --class nmtui -e bash -c 'sleep 0.5; nmtui'"
    fi
}
register_action "ethernet_manager" "Ethernet" "Control ethernet connections"

bluetooth_manager() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "bluetui"
    else
        launch_app "alacritty --class bluetui -e bash -c 'sleep 0.5; bluetui'"
    fi
}
register_action "bluetooth_manager" "Bluetooth" "Control bluetooth devices"

# Network Toggle Actions
toggle_wifi() {
    if [[ $(nmcli radio wifi) == "enabled" ]]; then
        nmcli radio wifi off && notify-send "WiFi" "Disabled"
    else
        nmcli radio wifi on && notify-send "WiFi" "Enabled"
    fi
}
register_action "toggle_wifi" "Toggle WiFi" "Toggle WiFi on/off"

toggle_bluetooth() {
    if rfkill list bluetooth | grep -q "Soft blocked.*no"; then
        rfkill block bluetooth && notify-send "Bluetooth" "Disabled"
    else
        rfkill unblock bluetooth && notify-send "Bluetooth" "Enabled"
    fi
}
register_action "toggle_bluetooth" "Toggle Bluetooth" "Toggle Bluetooth on/off"

toggle_ethernet() {
    ETH_DEV=$(nmcli device | grep ethernet | awk "{print $1}" | head -1)
    if nmcli device show $ETH_DEV | grep -q "STATE.*connected"; then
        nmcli device disconnect $ETH_DEV && notify-send "Ethernet" "Disconnected"
    else
        nmcli device connect $ETH_DEV && notify-send "Ethernet" "Connected"
    fi
}
register_action "toggle_ethernet" "Toggle Ethernet" "Toggle Ethernet connection"

# Window Management Actions
window_menu() {
    ~/.local/share/omarchy/bin/tlauncher --win
}
register_action "window_menu" "Window" "Window management options"

# Workspace Actions
workspaces_menu() {
    ~/.local/share/omarchy/bin/tlauncher --ws
}
register_action "workspaces_menu" "Workspaces" "Workspace management options"

# Application Actions
terminal() {
    launch_app alacritty
}
register_action "terminal" "Terminal" "Open terminal"

file_manager() {
    launch_app thunar
}
register_action "file_manager" "File Manager" "Open file manager"

browser() {
    launch_app firefox
}
register_action "browser" "Browser" "Open Firefox browser"

system_monitor() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "btop"
    else
        launch_app "alacritty --class btop -e btop"
    fi
}
register_action "system_monitor" "System Monitor" "Open system monitor"

notes() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "~/.local/share/omarchy/bin/notes"
    else
        launch_app "alacritty -e ~/.local/share/omarchy/bin/notes"
    fi
}
register_action "notes" "Notes" "Open notes in terminal"

# Claude integration action
claude_folder() {
    if command -v claude-code >/dev/null 2>&1; then
        SELECTED_DIR=$(find ~ -type d -not -path '*/.*' 2>/dev/null | grep -E '^/home/[^/]+/[^/]+$' | fzf --prompt="Select folder for Claude: " --height=15 --reverse)
        [[ -n "$SELECTED_DIR" ]] && cd "$SELECTED_DIR" && claude-code .
    else
        notify-send "Claude" "claude-code not found"
    fi
}
register_action "claude_folder" "Claude Folder" "Choose folder for Claude"

# Screenshot Actions
screenshot_region() {
    launch_app_hyprland ~/.local/share/omarchy/bin/omarchy-screenshot-region
}
register_action "screenshot_region" "Screenshot Region" "Take region screenshot"

screenshot_window() {
    launch_app_hyprland ~/.local/share/omarchy/bin/omarchy-screenshot-window
}
register_action "screenshot_window" "Screenshot Window" "Take window screenshot"

screenshot_output() {
    launch_app_hyprland ~/.local/share/omarchy/bin/omarchy-screenshot-output
}
register_action "screenshot_output" "Screenshot Output" "Take output screenshot"

# Brightness Actions (only register if brightnessctl is available)
if command -v brightnessctl >/dev/null 2>&1; then
    brightness_up() {
        brightnessctl set +15%
    }
    register_action "brightness_up" "Brightness Up" "Increase display brightness"

    brightness_down() {
        brightnessctl set 15%-
    }
    register_action "brightness_down" "Brightness Down" "Decrease display brightness"

    brightness_max() {
        brightnessctl set 100%
    }
    register_action "brightness_max" "Brightness Max" "Set maximum brightness"
fi

# Notification Actions
dismiss_notification() {
    makoctl dismiss
}
register_action "dismiss_notification" "Dismiss Notification" "Dismiss notification"

dismiss_all_notifications() {
    makoctl dismiss -a
}
register_action "dismiss_all_notifications" "Dismiss All" "Dismiss all notifications"

toggle_dnd() {
    makoctl mode -t dnd
}
register_action "toggle_dnd" "Toggle DND" "Toggle do not disturb"

update_omarchy() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "cd ~/.local/share/omarchy && git pull && ~/.local/share/omarchy/bin/omarchy-refresh-config --non-interactive && yay -Syu --noconfirm && echo 'Update complete.'"
    else
        launch_app "alacritty -e bash -c 'cd ~/.local/share/omarchy && git pull && ~/.local/share/omarchy/bin/omarchy-refresh-config --non-interactive && yay -Syu --noconfirm && echo \"Update complete. Press any key to continue...\" && read'"
    fi
}
register_action "update_omarchy" "Update System" "Update omarchy, refresh config, and system packages"

reload_config() {
    ~/.local/share/omarchy/bin/omarchy-refresh-config --non-interactive
}
register_action "reload_config" "Reload Config" "Refresh omarchy configuration"

show_keybindings() {
    # Check if we're in terminal mode (launched with -t)
    if [[ -n "$OMARCHY_PREVIOUS_WINDOW_FILE" ]]; then
        run_in_current_terminal "~/.local/share/omarchy/bin/omarchy-show-keybindings"
    else
        launch_app "alacritty --class=launcher -e ~/.local/share/omarchy/bin/omarchy-show-keybindings"
    fi
}
register_action "show_keybindings" "Keybindings" "Show keybindings"

next_wallpaper() {
    launch_app_hyprland ~/.local/share/omarchy/bin/omarchy-next-wallpaper
}
register_action "next_wallpaper" "Next Wallpaper" "Change wallpaper"

toggle_idle() {
    if pgrep -x hypridle > /dev/null; then
        pkill hypridle && notify-send "Idle" "Disabled"
    else
        hypridle & notify-send "Idle" "Enabled"
    fi
}
register_action "toggle_idle" "Toggle Idle" "Toggle idle timeout"

# Helper functions
get_all_action_names() {
    printf '%s\n' "${!ACTION_TITLES[@]}" | sort
}

should_show_action() {
    local key="$1"
    # Add filtering logic here if needed
    # For now, show all actions
    return 0
}

get_action_title() {
    local key="$1"
    echo "${ACTION_TITLES[$key]}"
}

get_action_description() {
    local key="$1"
    echo "${ACTION_DESCRIPTIONS[$key]}"
}

get_actions_for_launcher() {
    local key title description display_name search_text
    for key in $(get_all_action_names); do
        # Skip actions that shouldn't be shown based on system state
        should_show_action "$key" || continue
        
        title="${ACTION_TITLES[$key]}"
        description="${ACTION_DESCRIPTIONS[$key]}"
        display_name="${title}"$'\x1b[90m'" · ${description}"$'\x1b[0m'
        search_text="${title} ${description}"
        printf "%s\t%s\t%s\n" "$display_name" "$search_text" "$key"
    done
}

load_data() {
    # Output actions in launcher format with : prefix
    get_actions_for_launcher | while IFS=$'\t' read -r display_name search_text command; do
        echo ":$display_name"$'\t'":$search_text"$'\t'"$command"
    done
}

handle_selection() {
    local selected="$1"
    
    # Check if it's a direct command (hyprctl, systemctl, etc.)
    if [[ "$selected" =~ ^(loginctl|systemctl|hyprctl|omarchy-|/home/[^/]+/.local/share/omarchy/bin/) ]]; then
        # Execute system action directly
        eval "$selected"
        return 0
    # Check if it's a function defined in this script
    elif declare -f "$selected" >/dev/null 2>&1; then
        "$selected"
        return 0
    fi
    
    return 1
}
