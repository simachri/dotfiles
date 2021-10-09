#
# Defines environment variables.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi

# Set nvim as the default editor.
# https://unix.stackexchange.com/a/4861
export VISUAL="nvim"
export EDITOR="nvim"
# Add to path:
# Only keep the first occurrence of each duplicated value. https://superuser.com/a/598924
typeset -U path
# ~/.local/bin contains locally installed Python modules. The most prominent one is 
path+=('/home/xi3k/.local/bin')
# ~/node_modules/.bin locally installed Node modules.
path+=('/home/xi3k/node_modules/.bin')
# Golang binaires
path+=('/home/xi3k/go/bin')
export PATH
# Pipenv: Create environment in local project directory.
# Source: https://stackoverflow.com/a/52540270
export PIPENV_VENV_IN_PROJECT="enabled"
# nnn file browser
# Set bookmarks
#export NNN_BMS="w:$HOME/Wiki;s:$HOME/SAP;d:$HOME/Development"
# Show hidden files on top
export LC_COLLATE="C"
# Plugins
# NNN_FIFO is required for preview-tui, https://github.com/jarun/nnn/blob/master/plugins/preview-tui
#export NNN_FIFO=/tmp/nnn.fifo
#NNN_PLUG_FZF='e:fzopen;d:finder'
#NNN_PLUG_DEFAULT='p:preview-tui'
#NNN_PLUG="$NNN_PLUG_FZF;$NNN_PLUG_DEFAULT"
#export NNN_PLUG
# Set colors, currently using the values of 'Nord' theme.
# https://github.com/jarun/nnn/wiki/Themes
BLK="0B" CHR="0B" DIR="04" EXE="06" REG="00" HARDLINK="06" SYMLINK="06" MISSING="00" ORPHAN="09" FIFO="06" SOCK="0B" OTHER="06"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
# cd into the current directory when leaving nnn.
# https://github.com/jarun/nnn/blob/master/misc/quitcd/quitcd.bash_zsh
n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # The default behaviour is to cd on quit (nnn checks if NNN_TMPFILE is set)
    # To cd on quit only on ^G, remove the "export" as in:
    #     NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

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
## FZF
# 21-10-04: Is done in .zpreztorc
## --files: List files that would be searched but do not search
## -L follow/list symlinks
#export FZF_DEFAULT_COMMAND="rg --files -L"
#_gen_fzf_default_opts() {
#  local base03="234"
#  local base02="235"
#  local base01="240"
#  local base00="241"
#  local base0="244"
#  local base1="245"
#  local base2="254"
#  local base3="230"
#  local yellow="136"
#  local orange="166"
#  local red="160"
#  local magenta="125"
#  local violet="61"
#  local blue="33"
#  local cyan="37"
#  local green="64"
#  # Solarized Light color scheme for fzf
#  export FZF_DEFAULT_OPTS="--color fg:-1,bg:-1,hl:$blue,fg+:$base02,bg+:$base2,hl+:$blue,info:$yellow,prompt:$yellow,pointer:$base03,marker:$base03,spinner:$yellow"
#}
#_gen_fzf_default_opts

