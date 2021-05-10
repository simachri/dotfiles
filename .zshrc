# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/xi3k/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Aliases
alias nvim=/opt/nvim.appimage
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto'
function backup_journal() {
  foldername=`date +"%Y-%m-%d"`
  folderpath=~/VmHostShare/Journal_Backups/$foldername
  mkdir -p $folderpath
  cp -R ~/wiki $folderpath/wiki
  cp -R ~/Notes $folderpath/Notes
  cp -R ~/SAP $folderpath/SAP
  echo "Backup finished."
}
alias backup_journal=backup_journal
alias update='sudo pacman -Syy && sudo pacman -Su && yay -Syu && yay -Sc && zplug update'
alias git-dotfiles='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

## Plugins
# Init zplug
source ~/.zplug/init.zsh
# i10k theme
zplug romkatv/powerlevel10k, as:theme, depth:1
zplug "plugins/git", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/fzf", from:oh-my-zsh
zplug "plugins/command-not-found", from:oh-my-zsh
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-completions"
# Load plugins
zplug load

## Theming
# Load the i10k theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Load customized dircolors.
# https://unix.stackexchange.com/a/241735
[ -e ~/.dircolors ] && eval $(dircolors -b ~/.dircolors) || 
    eval $(dircolors -b)

# FZF
# --files: List files that would be searched but do not search
# -L follow/list symlinks
export FZF_DEFAULT_COMMAND="rg --files -L"
_gen_fzf_default_opts() {
  local base03="234"
  local base02="235"
  local base01="240"
  local base00="241"
  local base0="244"
  local base1="245"
  local base2="254"
  local base3="230"
  local yellow="136"
  local orange="166"
  local red="160"
  local magenta="125"
  local violet="61"
  local blue="33"
  local cyan="37"
  local green="64"
  # Solarized Light color scheme for fzf
  export FZF_DEFAULT_OPTS="--color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue,info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow"
}
_gen_fzf_default_opts
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## Custom settings
# Ignore all history duplicates and share history among multiple shells.
setopt histignorealldups sharehistory
# Set font color for autocompletion text
# https://coderwall.com/p/pb1uzq/z-shell-colors
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=29'
# Autocomplete for kitty
kitty + complete setup zsh | source /dev/stdin

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
