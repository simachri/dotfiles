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


# Add to path:
# Only keep the first occurrence of each duplicated value. https://superuser.com/a/598924
typeset -U path

# Note: The Windows path is NOT appended, see the wsl.conf file which contains appendWindowsPath=false

# Add powershell
path+=('/mnt/c/Windows/System32/WindowsPowerShell/v1.0')
# Add cmd and standard windows tools
path+=('/mnt/c/Windows/System32')
# ~/.local/bin contains locally installed Python modules. The most prominent one is 
path+=('/home/xi3k/.local/bin')
# ~/node_modules/.bin locally installed Node modules.
path+=('/home/xi3k/node_modules/.bin')
# bun binaries
path+=('/home/xi3k/.bun/bin')
# Golang binaires
path+=('/home/xi3k/go/bin')
# Java
export JAVA_HOME="/usr/lib/jvm/sapmachine-jdk-21.0.2"
path+=("$JAVA_HOME/bin")
path+=('/usr/lib/maven/apache-maven-3.9.6/bin')
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

# User Docker BuildKit
export DOCKER_BUILDKIT=1

export BROWSER=brave

export OPENAI_API_KEY=$(cat ~/.openai/api_key)

# Make pipenv create virutal environment in project directory.
export PIPENV_VENV_IN_PROJEC="enabled"
