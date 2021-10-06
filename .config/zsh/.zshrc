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
alias nvim=/opt/nvim.appimage
# NNN file manager. The n () function is defined further below.
# -P p: Start plugin preview-tui on nnn startup.
# -a: Auto NNN_FIFO
# -o: Open files only on enter
# -e: Use $EDITOR to open text files.
# -D: Set colors for directories using NNN_FCOLORS
# -n: Type-to-nav mode
alias ls='n -aDoe'
alias ll='ls -lah --color=auto'
function backup_journal() {
  foldername=`date +"%Y-%m-%d"`
  folderpath=~/VmHostShare/Journal_Backups/$foldername
  mkdir -p $folderpath
  cp -R ~/Wiki $folderpath/Wiki
  cp -R ~/Journal $folderpath/Journal
  cp -R ~/SAP $folderpath/SAP
  cp -R ~/Development $folderpath/Development
  echo "Backup finished."
}
alias backup_journal=backup_journal
alias update='sudo pacman -Syy && sudo pacman -Su && yay -Syu && yay -Sc && zprezto-update'
alias df='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

# Custom key bindings
# Accept the autosuggestion: <Ctrl-n>
bindkey '^n' autosuggest-accept
# Use <space> in command mode to open the current line in Vim
# https://unix.stackexchange.com/a/6622
autoload edit-command-line; zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line
# When using the vi-mode 'yank' command, copy to clipboard.
# Source: https://unix.stackexchange.com/a/390523
function x11-clip-wrap-widgets() {
    # NB: Assume we are the first wrapper and that we only wrap native widgets
    # See zsh-autosuggestions.zsh for a more generic and more robust wrapper
    local copy_or_paste=$1
    shift
    for widget in $@; do
        # Ugh, zsh doesn't have closures
        if [[ $copy_or_paste == "copy" ]]; then
            eval "
            function _x11-clip-wrapped-$widget() {
                zle .$widget
                xclip -in -selection clipboard <<<\$CUTBUFFER
            }
            "
        else
            eval "
            function _x11-clip-wrapped-$widget() {
                CUTBUFFER=\$(xclip -out -selection clipboard)
                zle .$widget
            }
            "
        fi
        zle -N $widget _x11-clip-wrapped-$widget
    done
}
local copy_widgets=(
    vi-yank vi-yank-eol vi-delete vi-backward-kill-word vi-change-whole-line
)
local paste_widgets=(
    vi-put-{before,after}
)
x11-clip-wrap-widgets copy $copy_widgets
x11-clip-wrap-widgets paste  $paste_widgets

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
