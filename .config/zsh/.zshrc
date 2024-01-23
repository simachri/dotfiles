# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...

## Set font color for autocompletion text
## https://coderwall.com/p/pb1uzq/z-shell-colors
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=29'

# Aliases
# alias nvim=/opt/nvim.appimage
alias tw="clear && task next user:"
alias vim=nvim
# NNN file manager.
# -P p: Start plugin preview-tui on nnn startup.
# -a: Auto NNN_FIFO
# -o: Open files only on enter
# -e: Use $EDITOR to open text files.
# -D: Set colors for directories using NNN_FCOLORS
# -n: Type-to-nav mode
# -H: Show hidden files
# -A: Disable auto enter directory on unique filter match
alias ls='n -aADoeH'
# The n () function is defined further below.
# alias ls='n -aDo'
alias ll='ls -lah --color=auto'
function backup_journal() {
  foldername=`date +"%Y-%m-%d"`
  folderpath=~/VmHostShare/Journal_Backups/$foldername
  mkdir -p $folderpath
  rsync -av --progress ~/Wiki $folderpath
  rsync -av --progress ~/Journal $folderpath
  rsync -av --progress ~/SAP $folderpath
  rsync -av --progress ~/Development $folderpath --exclude={.venv,node_modules,taskd,target}
  rsync -av --progress ~/.task $folderpath
  rsync -av --progress ~/E-Mail $folderpath
  echo "Backup finished."
}
alias backup_journal=backup_journal
alias update_sys='sudo pacman -Syy && sudo pacman -Su && yay -Syu && yay -Sc && zprezto-update'
alias update_go='gup update'
alias update_rust='rustup update'
# alias update_npm='cd ~ && bun update && npm audit fix && npm outdated'
alias update_bun='cd ~ && bun update'
alias update_pip="cd ~ && pip list --outdated | grep -v '^-e' | cut -d = -f 1  | xargs -n1 pip install -U --user"
alias df='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
alias ws='tmuxinator start workspace -n ws -p ~/.config/tmux/tmuxinator-ws.yml'
function www() {
  if [ -n "$1" ] 
  then
    ${BROWSER} "$(wslpath -w -a $1)"
  else
    ${BROWSER}
  fi
}

# Custom key bindings
# Accept the autosuggestion: <Ctrl-j>
bindkey '^j' autosuggest-accept
# Use <space> in command mode to open the current line in Vim
# https://unix.stackexchange.com/a/6622
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line
## When using the vi-mode 'yank' command, copy to clipboard.
## Source: https://unix.stackexchange.com/a/390523
#function x11-clip-wrap-widgets() {
#    # NB: Assume we are the first wrapper and that we only wrap native widgets
#    # See zsh-autosuggestions.zsh for a more generic and more robust wrapper
#    local copy_or_paste=$1
#    shift
#    for widget in $@; do
#        # Ugh, zsh doesn't have closures
#        if [[ $copy_or_paste == "copy" ]]; then
#            eval "
#            function _x11-clip-wrapped-$widget() {
#                zle .$widget
#                xclip -in -selection clipboard <<<\$CUTBUFFER
#            }
#            "
#        else
#            eval "
#            function _x11-clip-wrapped-$widget() {
#                CUTBUFFER=\$(xclip -out -selection clipboard)
#                zle .$widget
#            }
#            "
#        fi
#        zle -N $widget _x11-clip-wrapped-$widget
#    done
#}
#local copy_widgets=(
#    vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line
#)
#local paste_widgets=(
#    vi-put-{before,after}
#)
#x11-clip-wrap-widgets copy $copy_widgets
#x11-clip-wrap-widgets paste  $paste_widgets

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# NNN: cd into the current directory when leaving nnn only on ^G.
# https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash_zsh
n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi


    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, either remove the "export" as in:
    #    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    #    (or, to a custom path: NNN_TMPFILE=/tmp/.lastd)
    # or, export NNN_TMPFILE after nnn invocation
    # 21-10-20: Do NOT cd on quit, that is, remove the word "export".
    NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
            . "$NNN_TMPFILE"
            rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# Rename tmux window to current directory.
# Source: https://stackoverflow.com/q/29723307, https://stackoverflow.com/a/56568134
#precmd () {
#    tmux_conf_theme_window_status_format='#F#I:#W:#(tmux_pwd="#{pane_current_path}"; echo "${tmux_pwd//*\//}")'
#    tmux_conf_theme_window_status_current_format='#F[#I:#W:#(tmux_pwd="#{pane_current_path}"; echo "${tmux_pwd//*\//}")]'
#    tmux set-window-option -qg window-status-format ${tmux_conf_theme_window_status_format}
#    tmux set-window-option -qg window-status-current-format ${tmux_conf_theme_window_status_current_format}
#}

# Start Docker daemon automatically when logging in if not running.
# Source: https://blog.nillsf.com/index.php/2020/06/29/how-to-automatically-start-the-docker-daemon-on-wsl2/
DOCKERD_RUNNING=`ps aux | grep dockerd | grep -v grep`
if [ -z "$DOCKERD_RUNNING" ]; then
   sudo dockerd > /dev/null 2>&1 &
   disown
fi

# Set up Node Version Manager
source /usr/share/nvm/init-nvm.sh
