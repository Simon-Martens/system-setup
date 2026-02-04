#!/bin/bash
# Smart focus: move column or jump monitor at edge
# Usage: smart-focus.sh [left|right]

DIRECTION="$1"

# Get workspaces and windows
WORKSPACES=$(niri msg -j workspaces 2>/dev/null)
WINDOWS=$(niri msg -j windows 2>/dev/null)

if [ -z "$WORKSPACES" ] || [ -z "$WINDOWS" ]; then
    exit 1
fi

# Get current FOCUSED workspace (not just active)
CURRENT_WS=$(echo "$WORKSPACES" | jq -r '.[] | select(.is_focused == true) | .id')

# Get focused window
FOCUSED_WIN=$(echo "$WINDOWS" | jq -r '.[] | select(.is_focused == true) | .id')

# Get current column position
CURRENT_COL=$(echo "$WINDOWS" | jq --argjson win "$FOCUSED_WIN" -r '.[] | select(.id == $win) | .layout.pos_in_scrolling_layout[0]')

# Get all unique column positions on current workspace, sorted
COLUMNS=$(echo "$WINDOWS" | jq --argjson ws "$CURRENT_WS" -r '.[] | select(.workspace_id == $ws) | .layout.pos_in_scrolling_layout[0]' | sort -n | uniq)

# Find position of current column
COL_POS=$(echo "$COLUMNS" | grep -n "^${CURRENT_COL}$" | cut -d: -f1)
TOTAL_COLS=$(echo "$COLUMNS" | wc -l)

if [ "$DIRECTION" = "left" ]; then
    if [ -z "$COL_POS" ] || [ "$COL_POS" -le 1 ]; then
        niri msg action focus-monitor-left
    else
        niri msg action focus-column-left
    fi
elif [ "$DIRECTION" = "right" ]; then
    if [ -z "$COL_POS" ] || [ "$COL_POS" -ge "$TOTAL_COLS" ]; then
        niri msg action focus-monitor-right
    else
        niri msg action focus-column-right
    fi
fi
