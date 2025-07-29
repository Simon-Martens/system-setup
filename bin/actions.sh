#!/bin/bash

# System Actions - Shell functions with metadata
# This replaces the JavaScript actions.js file with native bash functions

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
    ~/.local/share/omarchy/bin/omarchy-launcher --power
}
register_action "power_menu" "Power" "Show power menu"

lock_session() {
    hyprctl dispatch exec hyprlock
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
    ~/.local/share/omarchy/bin/omarchy-launcher --governor
}
register_action "governor_menu" "Governor" "Switch CPU governor settings"

theme_menu() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-theme-menu
}
register_action "theme_menu" "Theme" "Change system theme"

tmux_sessions() {
    hyprctl dispatch exec "~/.local/share/omarchy/bin/omarchy-launcher-terminal --tmux"
}
register_action "tmux_sessions" "Tmux" "Control tmux sessions"

# Audio Actions
audio_mixer() {
    hyprctl dispatch exec "alacritty --class wiremix -e bash -c 'sleep 0.2; wiremix'"
}
register_action "audio_mixer" "Audio Mixer" "Open audio mixer"

audio_output() {
    hyprctl dispatch exec "alacritty --class wiremix -e bash -c 'sleep 0.2; wiremix -v output'"
}
register_action "audio_output" "Audio Output" "Open audio output panel"

audio_input() {
    hyprctl dispatch exec "alacritty --class wiremix -e bash -c 'sleep 0.2; wiremix -v input'"
}
register_action "audio_input" "Audio Input" "Open audio input panel"

# Network Actions
network_manager() {
    hyprctl dispatch exec "alacritty --class nmtui -e bash -c 'sleep 0.5; nmtui'"
}
register_action "network_manager" "Network" "Control network connections"

wifi_manager() {
    hyprctl dispatch exec "alacritty --class nmtui -e bash -c 'sleep 0.5; nmtui'"
}
register_action "wifi_manager" "WiFi" "Control WiFi connections"

ethernet_manager() {
    hyprctl dispatch exec "alacritty --class nmtui -e bash -c 'sleep 0.5; nmtui'"
}
register_action "ethernet_manager" "Ethernet" "Control ethernet connections"

bluetooth_manager() {
    hyprctl dispatch exec "alacritty --class bluetui -e bash -c 'sleep 0.5; bluetui'"
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
minimize_window() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/hyprland-minimizer
}
register_action "minimize_window" "Minimize" "Minimize current window"

restore_windows() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-show-minimized-fzf-terminal
}
register_action "restore_windows" "Restore" "Show minimized windows"

close_window() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-close-window
}
register_action "close_window" "Close" "Close current window"

toggle_float() {
    hyprctl dispatch togglefloating
}
register_action "toggle_float" "Float" "Toggle floating window"

toggle_fullscreen() {
    hyprctl dispatch fullscreen
}
register_action "toggle_fullscreen" "Fullscreen" "Toggle fullscreen"

center_window() {
    ~/.local/share/omarchy/bin/omarchy-window-action centerwindow
}
register_action "center_window" "Center Window" "Center floating window"

pin_window() {
    ~/.local/share/omarchy/bin/omarchy-window-action pin
}
register_action "pin_window" "Pin Window" "Pin window to all workspaces"

pseudo_tile() {
    ~/.local/share/omarchy/bin/omarchy-window-action pseudo
}
register_action "pseudo_tile" "Pseudo Tile" "Toggle pseudo tiling"

# Workspace Navigation Actions
next_workspace() {
    hyprctl dispatch workspace r+1
}
register_action "next_workspace" "Next Workspace" "Switch to next workspace"

prev_workspace() {
    hyprctl dispatch workspace r-1
}
register_action "prev_workspace" "Prev Workspace" "Switch to previous workspace"

# Workspace Direct Navigation Actions (1-6)
workspace_1() { hyprctl dispatch workspace 1; }
register_action "workspace_1" "Workspace 1" "Switch to workspace 1"

workspace_2() { hyprctl dispatch workspace 2; }
register_action "workspace_2" "Workspace 2" "Switch to workspace 2"

workspace_3() { hyprctl dispatch workspace 3; }
register_action "workspace_3" "Workspace 3" "Switch to workspace 3"

workspace_4() { hyprctl dispatch workspace 4; }
register_action "workspace_4" "Workspace 4" "Switch to workspace 4"

workspace_5() { hyprctl dispatch workspace 5; }
register_action "workspace_5" "Workspace 5" "Switch to workspace 5"

workspace_6() { hyprctl dispatch workspace 6; }
register_action "workspace_6" "Workspace 6" "Switch to workspace 6"

# Move to Workspace Actions (1-6)
move_to_workspace_1() { ~/.local/share/omarchy/bin/omarchy-window-action movetoworkspace 1; }
register_action "move_to_workspace_1" "Move to WS 1" "Move window to workspace 1"

move_to_workspace_2() { ~/.local/share/omarchy/bin/omarchy-window-action movetoworkspace 2; }
register_action "move_to_workspace_2" "Move to WS 2" "Move window to workspace 2"

move_to_workspace_3() { ~/.local/share/omarchy/bin/omarchy-window-action movetoworkspace 3; }
register_action "move_to_workspace_3" "Move to WS 3" "Move window to workspace 3"

move_to_workspace_4() { ~/.local/share/omarchy/bin/omarchy-window-action movetoworkspace 4; }
register_action "move_to_workspace_4" "Move to WS 4" "Move window to workspace 4"

move_to_workspace_5() { ~/.local/share/omarchy/bin/omarchy-window-action movetoworkspace 5; }
register_action "move_to_workspace_5" "Move to WS 5" "Move window to workspace 5"

move_to_workspace_6() { ~/.local/share/omarchy/bin/omarchy-window-action movetoworkspace 6; }
register_action "move_to_workspace_6" "Move to WS 6" "Move window to workspace 6"

# Screenshot Actions
screenshot_region() {
    hyprctl dispatch exec "hyprshot -m region"
}
register_action "screenshot_region" "Screenshot Region" "Take region screenshot"

screenshot_window() {
    hyprctl dispatch exec "hyprshot -m window"
}
register_action "screenshot_window" "Screenshot Window" "Take window screenshot"

screenshot_output() {
    hyprctl dispatch exec "hyprshot -m output"
}
register_action "screenshot_output" "Screenshot Output" "Take output screenshot"

# Notification Actions
dismiss_notification() {
    hyprctl dispatch exec "makoctl dismiss"
}
register_action "dismiss_notification" "Dismiss Notification" "Dismiss notification"

dismiss_all_notifications() {
    hyprctl dispatch exec "makoctl dismiss --all"
}
register_action "dismiss_all_notifications" "Dismiss All" "Dismiss all notifications"

toggle_dnd() {
    hyprctl dispatch exec "makoctl mode -t do-not-disturb"
}
register_action "toggle_dnd" "Toggle DND" "Toggle do not disturb"

# System Utility Actions
toggle_idle() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-toggle-idle
}
register_action "toggle_idle" "Toggle Idle" "Toggle idle timeout"

show_keybindings() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-show-keybindings
}
register_action "show_keybindings" "Keybindings" "Show keybindings"

next_wallpaper() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/swaybg-next
}
register_action "next_wallpaper" "Next Wallpaper" "Change wallpaper"

reload_waybar() {
    hyprctl dispatch exec "pkill -SIGUSR1 waybar"
}
register_action "reload_waybar" "Reload Waybar" "Reload waybar"

# Omarchy System Management Actions
update_omarchy() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-update
}
register_action "update_omarchy" "Update Omarchy" "Update omarchy system and packages"

refresh_waybar() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-refresh-waybar
}
register_action "refresh_waybar" "Refresh Waybar" "Reset Waybar to omarchy defaults"

sync_apps() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-sync-applications
}
register_action "sync_apps" "Sync Apps" "Sync application entries and icons"

config_link() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/omarchy-config-link
}
register_action "config_link" "Config Link" "Link omarchy configs for testing"

relaunch_waybar() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/waybar-relaunch
}
register_action "relaunch_waybar" "Relaunch Waybar" "Restart Waybar"

# Application Actions
terminal() {
    hyprctl dispatch exec alacritty
}
register_action "terminal" "Terminal" "Open terminal"

file_manager() {
    hyprctl dispatch exec "nautilus --new-window"
}
register_action "file_manager" "File Manager" "Open file manager"

browser() {
    hyprctl dispatch exec firefox
}
register_action "browser" "Browser" "Open Firefox browser"

notes() {
    hyprctl dispatch exec "alacritty --class notes -e ~/.local/share/omarchy/bin/notes"
}
register_action "notes" "Notes" "Open notes in terminal"

system_monitor() {
    hyprctl dispatch exec "alacritty -e btop"
}
register_action "system_monitor" "System Monitor" "Open system monitor"

claude_folder() {
    hyprctl dispatch exec ~/.local/share/omarchy/bin/claude-folder-chooser
}
register_action "claude_folder" "Claude Folder" "Choose folder for Claude"

# Display Brightness Actions
brightness_down() {
    ~/.local/share/omarchy/bin/apple-display-brightness -5000
}
register_action "brightness_down" "Brightness Down" "Decrease display brightness"

brightness_up() {
    ~/.local/share/omarchy/bin/apple-display-brightness +5000
}
register_action "brightness_up" "Brightness Up" "Increase display brightness"

brightness_max() {
    ~/.local/share/omarchy/bin/apple-display-brightness +60000
}
register_action "brightness_max" "Brightness Max" "Set maximum brightness"

# Helper Functions
get_all_action_names() {
    printf '%s\n' "${!ACTION_TITLES[@]}" | sort
}

get_action_title() {
    local key="$1"
    echo "${ACTION_TITLES[$key]}"
}

get_action_description() {
    local key="$1"
    echo "${ACTION_DESCRIPTIONS[$key]}"
}

should_show_action() {
    local key="$1"
    
    # Conditional logic for actions that should only show when relevant
    case "$key" in
        # Bluetooth actions only show if bluetooth is available
        "bluetooth_manager"|"toggle_bluetooth")
            rfkill list bluetooth >/dev/null 2>&1 || return 1
            ;;
        # WiFi actions only show if WiFi is available
        "wifi_manager"|"toggle_wifi")
            nmcli radio wifi >/dev/null 2>&1 || return 1
            ;;
        # Ethernet actions only show if ethernet interface exists
        "ethernet_manager"|"toggle_ethernet")
            nmcli device | grep -q ethernet || return 1
            ;;
        # Brightness actions only show if brightness control script exists
        "brightness_down"|"brightness_up"|"brightness_max")
            [[ -f "$HOME/.local/share/omarchy/bin/apple-display-brightness" ]] || return 1
            ;;
        # Tmux actions only show if tmux is available
        "tmux_sessions")
            command -v tmux >/dev/null 2>&1 || return 1
            ;;
        # Minimize/restore actions only show in Hyprland
        "minimize_window"|"restore_windows")
            command -v hyprctl >/dev/null 2>&1 || return 1
            ;;
        # Hyprland-specific actions
        "toggle_float"|"toggle_fullscreen"|"center_window"|"pin_window"|"pseudo_tile"|"next_workspace"|"prev_workspace"|"workspace_"*|"move_to_workspace_"*)
            command -v hyprctl >/dev/null 2>&1 || return 1
            ;;
        # Screenshot actions only show if hyprshot is available
        "screenshot_"*)
            command -v hyprshot >/dev/null 2>&1 || return 1
            ;;
        # Notification actions only show if mako is available
        "dismiss_notification"|"dismiss_all_notifications"|"toggle_dnd")
            command -v makoctl >/dev/null 2>&1 || return 1
            ;;
        # Governor actions only show if CPU frequency scaling is available
        "governor_menu")
            [[ -f "/sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors" ]] || return 1
            ;;
    esac
    
    return 0
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

# Command-line interface
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-}" in
        "")
            # Output all actions in launcher format
            get_actions_for_launcher
            ;;
        "--list")
            # List all action keys
            get_all_action_names
            ;;
        "--get")
            # Get specific action command (just call the function)
            if [[ -n "$2" ]] && declare -f "$2" >/dev/null; then
                "$2"
            else
                echo "Action '$2' not found" >&2
                exit 1
            fi
            ;;
        "--title")
            # Get action title
            if [[ -n "$2" ]]; then
                get_action_title "$2"
            else
                echo "Usage: $0 --title <action_key>" >&2
                exit 1
            fi
            ;;
        "--description")
            # Get action description
            if [[ -n "$2" ]]; then
                get_action_description "$2"
            else
                echo "Usage: $0 --description <action_key>" >&2
                exit 1
            fi
            ;;
        *)
            echo "Usage:"
            echo "  $0                        - Output all actions for launcher"
            echo "  $0 --list                 - List all action keys"
            echo "  $0 --get <key>            - Execute specific action"
            echo "  $0 --title <key>          - Get action title"
            echo "  $0 --description <key>    - Get action description"
            ;;
    esac
fi
