#!/bin/bash

# Tmux Harpoon - Quick session/window navigation inspired by ThePrimeagen's harpoon

HARPOON_FILE="$HOME/.tmux_harpoon"

init_harpoon() {
    if [ ! -f "$HARPOON_FILE" ]; then
        touch "$HARPOON_FILE"
    fi
}

harpoon_add() {
    init_harpoon
    
    if [ -z "$TMUX" ]; then
        echo "Not in a tmux session"
        return 1
    fi
    
    local current_session=$(tmux display-message -p '#S')
    local current_window=$(tmux display-message -p '#W')
    local current_index=$(tmux display-message -p '#I')
    local entry="${current_session}:${current_index}:${current_window}"
    
    if grep -Fxq "$entry" "$HARPOON_FILE"; then
        return 0
    fi
    
    echo "$entry" >> "$HARPOON_FILE"
}

# Navigate to harpoon entry by number (1-indexed)
harpoon_nav() {
    init_harpoon
    local num="$1"
    
    if [ -z "$num" ]; then
        echo "Usage: harpoon_nav <number>"
        return 1
    fi
    
    local entry=$(sed -n "${num}p" "$HARPOON_FILE")
    
    if [ -z "$entry" ]; then
        echo "No harpoon entry #$num"
        return 1
    fi
    
    local session=$(echo "$entry" | cut -d: -f1)
    local window_index=$(echo "$entry" | cut -d: -f2)
    
    if ! tmux has-session -t "$session" 2>/dev/null; then
        echo "Session '$session' no longer exists"
        return 1
    fi
    
    if [ -n "$TMUX" ]; then
        tmux switch-client -t "${session}:${window_index}"
    else
        tmux attach-session -t "${session}:${window_index}"
    fi
}
