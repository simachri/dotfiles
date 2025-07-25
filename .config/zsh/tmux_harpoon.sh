#!/bin/bash

HARPOON_FILE="$HOME/.tmux_harpoon"
HARPOON_WINDOW_FILE="$HOME/.tmux_harpoon_windows"

init_harpoon() {
    if [ ! -f "$HARPOON_FILE" ]; then
        touch "$HARPOON_FILE"
    fi
    if [ ! -f "$HARPOON_WINDOW_FILE" ]; then
        touch "$HARPOON_WINDOW_FILE"
    fi
}

update_last_window() {
    local session="$1"
    local window_index="$2"
    
    if [ -f "$HARPOON_WINDOW_FILE" ]; then
        grep -v "^${session}:" "$HARPOON_WINDOW_FILE" > "${HARPOON_WINDOW_FILE}.tmp" || true
        mv "${HARPOON_WINDOW_FILE}.tmp" "$HARPOON_WINDOW_FILE"
    fi
    echo "${session}:${window_index}" >> "$HARPOON_WINDOW_FILE"
}

get_last_window() {
    local session="$1"
    local last_window=$(grep "^${session}:" "$HARPOON_WINDOW_FILE" 2>/dev/null | cut -d: -f2)
    echo "$last_window"
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
    
    local target_session=$(echo "$entry" | cut -d: -f1)
    local harpooned_window=$(echo "$entry" | cut -d: -f2)
    
    if ! tmux has-session -t "$target_session" 2>/dev/null; then
        echo "Session '$target_session' no longer exists"
        return 1
    fi
    
    if [ -n "$TMUX" ]; then
        local current_session=$(tmux display-message -p '#S')
        local current_window_index=$(tmux display-message -p '#I')
        update_last_window "$current_session" "$current_window_index"
        
        local last_window=$(get_last_window "$target_session")
        if [ -n "$last_window" ]; then
            tmux switch-client -t "${target_session}:${last_window}"
        else
            tmux switch-client -t "${target_session}:${harpooned_window}"
        fi
    else
        local last_window=$(get_last_window "$target_session")
        if [ -n "$last_window" ]; then
            tmux attach-session -t "${target_session}:${last_window}"
        else
            tmux attach-session -t "${target_session}:${harpooned_window}"
        fi
    fi
}

harpoon_nav_session() {
    init_harpoon
    local session_name="$1"
    
    if [ -z "$session_name" ]; then
        echo "Usage: harpoon_nav_session <session_name>"
        return 1
    fi
    
    if ! tmux has-session -t "$session_name" 2>/dev/null; then
        echo "Session '$session_name' does not exist"
        return 1
    fi
    
    if [ -n "$TMUX" ]; then
        local current_session=$(tmux display-message -p '#S')
        local current_window_index=$(tmux display-message -p '#I')
        update_last_window "$current_session" "$current_window_index"
        
        local last_window=$(get_last_window "$session_name")
        if [ -n "$last_window" ]; then
            tmux switch-client -t "${session_name}:${last_window}"
        else
            tmux switch-client -t "${session_name}:0"
        fi
    else
        local last_window=$(get_last_window "$session_name")
        if [ -n "$last_window" ]; then
            tmux attach-session -t "${session_name}:${last_window}"
        else
            tmux attach-session -t "${session_name}:0"
        fi
    fi
}
