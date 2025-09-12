#!/usr/bin/env node

// System Actions - Dynamic action definitions with bash functions
const actions = {
  // Power Management
  power_menu: {
    title: "Power",
    description: "Show power menu",
    action: () => "~/.local/share/system-setup/bin/system-setup-launcher --power"
  },
  
  lock_session: {
    title: "Lock",
    description: "Lock the current session",
    action: () => "hyprctl dispatch exec hyprlock"
  },
  
  suspend_system: {
    title: "Suspend",
    description: "Suspend the system",
    action: () => "systemctl suspend"
  },
  
  relaunch_hyprland: {
    title: "Relaunch",
    description: "Restart Hyprland window manager",
    action: () => "hyprctl dispatch exit"
  },
  
  restart_system: {
    title: "Restart",
    description: "Restart the system",
    action: () => "systemctl reboot"
  },
  
  shutdown_system: {
    title: "Shutdown",
    description: "Shut down the system",
    action: () => "systemctl poweroff"
  },

  // System Configuration
  governor_menu: {
    title: "Governor",
    description: "Switch CPU governor settings",
    action: () => "~/.local/share/system-setup/bin/system-setup-launcher --governor"
  },
  
  theme_menu: {
    title: "Theme",
    description: "Change system theme",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/system-setup-theme-menu"
  },
  
  tmux_sessions: {
    title: "Tmux",
    description: "Control tmux sessions",
    action: () => "hyprctl dispatch exec \"~/.local/share/system-setup/bin/system-setup-launcher-terminal --tmux\""
  },

  // Audio
  audio_mixer: {
    title: "Audio Mixer",
    description: "Open audio mixer",
    action: () => "hyprctl dispatch exec \"alacritty --class wiremix -e bash -c 'sleep 0.2; wiremix'\""
  },
  
  audio_output: {
    title: "Audio Output",
    description: "Open audio output panel",
    action: () => "hyprctl dispatch exec \"alacritty --class wiremix -e bash -c 'sleep 0.2; wiremix -v output'\""
  },
  
  audio_input: {
    title: "Audio Input", 
    description: "Open audio input panel",
    action: () => "hyprctl dispatch exec \"alacritty --class wiremix -e bash -c 'sleep 0.2; wiremix -v input'\""
  },

  // Network
  network_manager: {
    title: "Network",
    description: "Control network connections",
    action: () => "hyprctl dispatch exec \"alacritty --class nmtui -e bash -c 'sleep 0.5; nmtui'\""
  },
  
  wifi_manager: {
    title: "WiFi",
    description: "Control WiFi connections", 
    action: () => "hyprctl dispatch exec \"alacritty --class nmtui -e bash -c 'sleep 0.5; nmtui'\""
  },
  
  ethernet_manager: {
    title: "Ethernet",
    description: "Control ethernet connections",
    action: () => "hyprctl dispatch exec \"alacritty --class nmtui -e bash -c 'sleep 0.5; nmtui'\""
  },
  
  bluetooth_manager: {
    title: "Bluetooth",
    description: "Control bluetooth devices",
    action: () => "hyprctl dispatch exec \"alacritty --class bluetui -e bash -c 'sleep 0.5; bluetui'\""
  },

  // Network Toggles
  toggle_wifi: {
    title: "Toggle WiFi",
    description: "Toggle WiFi on/off",
    action: () => "bash -c 'if [[ $(nmcli radio wifi) == \"enabled\" ]]; then nmcli radio wifi off && notify-send \"WiFi\" \"Disabled\"; else nmcli radio wifi on && notify-send \"WiFi\" \"Enabled\"; fi'"
  },
  
  toggle_bluetooth: {
    title: "Toggle Bluetooth",
    description: "Toggle Bluetooth on/off", 
    action: () => "bash -c 'if rfkill list bluetooth | grep -q \"Soft blocked.*no\"; then rfkill block bluetooth && notify-send \"Bluetooth\" \"Disabled\"; else rfkill unblock bluetooth && notify-send \"Bluetooth\" \"Enabled\"; fi'"
  },
  
  toggle_ethernet: {
    title: "Toggle Ethernet",
    description: "Toggle Ethernet connection",
    action: () => "bash -c 'ETH_DEV=$(nmcli device | grep ethernet | awk \"{print $1}\" | head -1); if nmcli device show $ETH_DEV | grep -q \"STATE.*connected\"; then nmcli device disconnect $ETH_DEV && notify-send \"Ethernet\" \"Disconnected\"; else nmcli device connect $ETH_DEV && notify-send \"Ethernet\" \"Connected\"; fi'"
  },

  // Window Management
  minimize_window: {
    title: "Minimize",
    description: "Minimize current window",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/hyprland-minimizer"
  },
  
  restore_windows: {
    title: "Restore",
    description: "Show minimized windows",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/system-setup-show-minimized-fzf-terminal"
  },
  
  close_window: {
    title: "Close",
    description: "Close current window",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/system-setup-close-window"
  },
  
  toggle_float: {
    title: "Float",
    description: "Toggle floating window",
    action: () => "hyprctl dispatch togglefloating"
  },
  
  toggle_fullscreen: {
    title: "Fullscreen",
    description: "Toggle fullscreen",
    action: () => "hyprctl dispatch fullscreen"
  },
  
  center_window: {
    title: "Center Window",
    description: "Center floating window", 
    action: () => "~/.local/share/system-setup/bin/system-setup-window-action centerwindow"
  },
  
  pin_window: {
    title: "Pin Window",
    description: "Pin window to all workspaces",
    action: () => "~/.local/share/system-setup/bin/system-setup-window-action pin"
  },
  
  pseudo_tile: {
    title: "Pseudo Tile",
    description: "Toggle pseudo tiling",
    action: () => "~/.local/share/system-setup/bin/system-setup-window-action pseudo"
  },

  // Workspace Navigation
  next_workspace: {
    title: "Next Workspace",
    description: "Switch to next workspace",
    action: () => "hyprctl dispatch workspace r+1"
  },
  
  prev_workspace: {
    title: "Prev Workspace", 
    description: "Switch to previous workspace",
    action: () => "hyprctl dispatch workspace r-1"
  },

  // Workspace Direct Navigation
  ...Array.from({length: 6}, (_, i) => ({
    key: `workspace_${i + 1}`,
    value: {
      title: `Workspace ${i + 1}`,
      description: `Switch to workspace ${i + 1}`,
      action: () => `hyprctl dispatch workspace ${i + 1}`
    }
  })).reduce((acc, {key, value}) => ({...acc, [key]: value}), {}),

  // Move to Workspace
  ...Array.from({length: 6}, (_, i) => ({
    key: `move_to_workspace_${i + 1}`,
    value: {
      title: `Move to WS ${i + 1}`,
      description: `Move window to workspace ${i + 1}`,
      action: () => `~/.local/share/system-setup/bin/system-setup-window-action movetoworkspace ${i + 1}`
    }
  })).reduce((acc, {key, value}) => ({...acc, [key]: value}), {}),

  // Screenshots
  screenshot_region: {
    title: "Screenshot Region",
    description: "Take region screenshot",
    action: () => "hyprctl dispatch exec \"hyprshot -m region\""
  },
  
  screenshot_window: {
    title: "Screenshot Window",
    description: "Take window screenshot",
    action: () => "hyprctl dispatch exec \"hyprshot -m window\""
  },
  
  screenshot_output: {
    title: "Screenshot Output", 
    description: "Take output screenshot",
    action: () => "hyprctl dispatch exec \"hyprshot -m output\""
  },

  // Notifications
  dismiss_notification: {
    title: "Dismiss Notification",
    description: "Dismiss notification",
    action: () => "hyprctl dispatch exec \"makoctl dismiss\""
  },
  
  dismiss_all_notifications: {
    title: "Dismiss All",
    description: "Dismiss all notifications",
    action: () => "hyprctl dispatch exec \"makoctl dismiss --all\""
  },
  
  toggle_dnd: {
    title: "Toggle DND",
    description: "Toggle do not disturb",
    action: () => "hyprctl dispatch exec \"makoctl mode -t do-not-disturb\""
  },

  // System Utilities
  toggle_idle: {
    title: "Toggle Idle",
    description: "Toggle idle timeout",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/system-setup-toggle-idle"
  },
  
  show_keybindings: {
    title: "Keybindings",
    description: "Show keybindings",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/system-setup-show-keybindings"
  },
  
  next_wallpaper: {
    title: "Next Wallpaper",
    description: "Change wallpaper",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/swaybg-next"
  },
  
  reload_waybar: {
    title: "Reload Waybar",
    description: "Reload waybar",
    action: () => "hyprctl dispatch exec \"pkill -SIGUSR1 waybar\""
  },

  // system-setup System Management
  update_system-setup: {
    title: "Update system-setup",
    description: "Update system-setup system and packages", 
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/system-setup-update"
  },
  
  refresh_waybar: {
    title: "Refresh Waybar",
    description: "Reset Waybar to system-setup defaults",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/system-setup-refresh-waybar"
  },
  
  sync_apps: {
    title: "Sync Apps",
    description: "Sync application entries and icons",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/system-setup-sync-applications"
  },
  
  config_link: {
    title: "Config Link",
    description: "Link system-setup configs for testing",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/system-setup-config-link"
  },
  
  relaunch_waybar: {
    title: "Relaunch Waybar",
    description: "Restart Waybar",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/waybar-relaunch"
  },

  // Applications
  terminal: {
    title: "Terminal",
    description: "Open terminal",
    action: () => "hyprctl dispatch exec alacritty"
  },
  
  file_manager: {
    title: "File Manager",
    description: "Open file manager",
    action: () => "hyprctl dispatch exec \"nautilus --new-window\""
  },
  
  browser: {
    title: "Browser",
    description: "Open Firefox browser",
    action: () => "hyprctl dispatch exec firefox"
  },
  
  notes: {
    title: "Notes",
    description: "Open notes in terminal",
    action: () => "hyprctl dispatch exec \"alacritty --class notes -e ~/.local/share/system-setup/bin/notes\""
  },
  
  system_monitor: {
    title: "System Monitor",
    description: "Open system monitor",
    action: () => "hyprctl dispatch exec \"alacritty -e btop\""
  },
  
  claude_folder: {
    title: "Claude Folder",
    description: "Choose folder for Claude",
    action: () => "hyprctl dispatch exec ~/.local/share/system-setup/bin/claude-folder-chooser"
  },

  // Display Brightness
  brightness_down: {
    title: "Brightness Down",
    description: "Decrease display brightness",
    action: () => "hyprctl dispatch exec \"~/.local/share/system-setup/bin/apple-display-brightness -5000\""
  },
  
  brightness_up: {
    title: "Brightness Up", 
    description: "Increase display brightness",
    action: () => "hyprctl dispatch exec \"~/.local/share/system-setup/bin/apple-display-brightness +5000\""
  },
  
  brightness_max: {
    title: "Brightness Max",
    description: "Set maximum brightness",
    action: () => "hyprctl dispatch exec \"~/.local/share/system-setup/bin/apple-display-brightness +60000\""
  }
};

// Export function to get all actions in launcher format
function getActionsForLauncher() {
  return Object.entries(actions).map(([key, action]) => {
    const command = action.action();
    const displayName = `${action.title}\x1b[90m · ${action.description}\x1b[0m`;
    const searchText = `${action.title} ${action.description}`;
    return `${displayName}\t${searchText}\t${command}`;
  }).join('\n');
}

// Export function to get action by key
function getAction(key) {
  return actions[key];
}

// Command line interface
if (require.main === module) {
  const args = process.argv.slice(2);
  
  if (args.length === 0) {
    // Output all actions in launcher format
    console.log(getActionsForLauncher());
  } else if (args[0] === '--list') {
    // List all action keys
    console.log(Object.keys(actions).join('\n'));
  } else if (args[0] === '--get' && args[1]) {
    // Get specific action command
    const action = getAction(args[1]);
    if (action) {
      console.log(action.action());
    } else {
      console.error(`Action '${args[1]}' not found`);
      process.exit(1);
    }
  } else {
    console.log('Usage:');
    console.log('  actions.js              - Output all actions for launcher');
    console.log('  actions.js --list       - List all action keys');
    console.log('  actions.js --get <key>  - Get command for specific action');
  }
}

module.exports = { actions, getActionsForLauncher, getAction };