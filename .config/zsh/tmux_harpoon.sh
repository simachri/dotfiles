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

harpoon_remove() {
    init_harpoon
    local line_num="$1"
    
    if [ -z "$line_num" ]; then
        echo "Usage: harpoon_remove <line_number>"
        return 1
    fi
    
    sed -i "${line_num}d" "$HARPOON_FILE"
    echo "Removed harpoon entry #$line_num"
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

harpoon_list() {
    init_harpoon
    
    if [ ! -s "$HARPOON_FILE" ]; then
        echo "No harpoon entries"
        return 0
    fi
    
    echo "=== Tmux Harpoon Entries ==="
    cat -n "$HARPOON_FILE"
}

harpoon_clear() {
    init_harpoon
    > "$HARPOON_FILE"
    echo "Cleared all harpoon entries"
}

# Main harpoon function - acts as dispatcher
harpoon() {
    case "$1" in
        "add"|"a")
            harpoon_add
            ;;
        "remove"|"rm"|"r")
            harpoon_remove "$2"
            ;;
        "nav"|"n")
            harpoon_nav "$2"
            ;;
        "list"|"ls"|"l")
            harpoon_list
            ;;
        "clear"|"c")
            harpoon_clear
            ;;
        "clean")
            harpoon_clean
            ;;
        "help"|"h"|"--help")
            cat << EOF
Tmux Harpoon - Quick session/window navigation

Commands:
  harpoon add     - Add current tmux location to harpoon
  harpoon nav <n> - Navigate to harpoon entry number n
  harpoon list    - List all harpoon entries
  harpoon remove <n> - Remove harpoon entry number n
  harpoon clear   - Clear all harpoon entries
EOF
            ;;
        *)
            echo "Unknown command: $1"
            echo "Use 'harpoon help' for usage information"
            return 1
            ;;
    esac
}
