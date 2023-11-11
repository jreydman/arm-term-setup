#!/bin/bash

set -e

SH_SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# OVERRIDE -- XDG/default endpoints

#-------------------------------------------------------#
# XDG_DATA_HOME=$HOME/Library				#
# XDG_CONFIG_HOME=$HOME/Library/Preferences		#
# XDG_CACHE_HOME=$HOME/Library/Caches			#
# XDG_RUNTIME_DIR=$HOME/Library/Caches/TemporaryItems	#
#-------------------------------------------------------#

XDG_ENVIRONMENTS=("XDG_DATA_HOME" "XDG_CONFIG_HOME" "XDG_CACHE_HOME" "XDG_RUNTIME_DIR")
XDG_DEFAULT_VALUES=("$HOME/.local/share" "$HOME/.config" "$HOME/.cache" "$HOME/.tmp")

RC_PROFILE_FILE=.zprofile
RC_FILE=.zshrc
RC_ENV_FILE=.zshenv
#########################################################

logger() { printf "($SH_SCRIPT_DIR)|Log: <%s>\t|%s|\t%s\n" "$1" "$2" "$3"; }
logger:flow() { printf "($SH_SCRIPT_DIR)|Log: <%s>\t|%s|>flow[%s]\t%s\n" "$1" "$2" "$3" "$4"; }

environments_check() { # $1[env_names] $[env_default_values]
  env_vars=("${!1}")
  default_values=("${!2}")
  for ((i=0; i<${#env_vars[@]}; i++)); do
    env_var="${env_vars[$i]}"
    default_value="${default_values[$i]}"
    if eval "[ -z \${$env_var+x} ]"; then
      eval "$env_var='$default_value'"
      logger:flow info "env:check:$env_var" ${!env_var} "successful"
    else logger:flow warning env:check:$env_var ${!env_var} "already exists"
    fi
  done
}

paths_check() { # $1[env_name_paths] $2"force"?
echo $2
logger info "paths:check" init
env_vars=("${!1}")
for env_name_path in "${env_vars[@]}"; do
path=$(eval echo "\${$env_name_path}")
if [ -d "$path" ] && [ -z "$2" ]; then logger:flow warning "paths:check:$env_name_path" ${path} "already exists";
elif [ -d "$path" ] && [ ! -z "$2" ]; then rm -rf "$path"; mkdir -p "$path"; logger:flow info "paths:check<force>:$env_name_path" ${path} successful;
else mkdir -p "$path"; logger:flow info "paths:check:$env_name_path" ${path} successful;
fi
done
logger info "paths:check" successful
}

homebrew-uninstall() { logger info homebrew:uninstall init; rm -rf $(eval echo $HOMEBREW_PREFIX); rm -rf $(eval echo $HOMEBREW_REPOSITYRY); rm -rf $(eval echo $HOMEBREW_CACHE); rm -rf $(eval echo $HOMEBREW_TEMP); export PATH=$(echo $PATH | tr ':' '\n' | grep -v $(eval echo $HOMEBREW_PREFIX)/bin | tr '\n' ':'); export PATH=$(echo $PATH | tr ':' '\n' | grep -v $(eval echo $HOMEBREW_PREFIX)/sbin | tr '\n' ':'); logger info homebrew:uninstall successful; }
homebrew-check() {
logger info homebrew:check init
PATH="/opt/homebrew/bin:$PATH"
command -v brew &> /dev/null && { logger:flow warning homebrew:check install "already exists"; return; }
mkdir $(eval echo $HOMEBREW_PREFIX) && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $(eval echo $HOMEBREW_PREFIX) &&
wait && logger:flow info homebrew:check init successful
}

zsh-rc-check() { source $(eval echo "$ZSH_CONFIG/$RC_FILE") && logger:flow info root:source:check $RC_FILE successful; }

zsh-ln-refresh() {
logger info zsh:ln:check init
links=("$RC_FILE" "$RC_PROFILE_FILE")
for link in "${links[@]}"; do
[ ! -e "$HOME/$link" ] && ln -s "$(eval echo "$ZSH_CONFIG/$link")" "$HOME/$link" && logger:flow info zsh:ln:check $link created || logger:flow warning zsh:ln:check $link "already exists"
done
logger info zsh:ln:check successful
}

zsh-rc-dump() {
logger info zsh:rc:dump init
ZSH_CONFIG=$XDG_CONFIG_HOME/zsh
echo $ZSH_CONFIG
# Проверяем существование папки и файла
if [ ! -d "$ZSH_CONFIG" ] || [ ! -e "$RC_PROFILE_PATH" ]; then
    # Если что-то не существует, создаем папку и файл
    mkdir -p "$ZSH_CONFIG"
    touch "$RC_PROFILE_PATH"
    logger:flow info zsh:rc:dump $RC_PROFILE_FILE created
else
    # Если оба существуют, выводим логгер "already exists"
    logger:flow warning zsh:rc:dump $RC_PROFILE_FILE "already exists"
fi

cat > $(eval echo "$ZSH_CONFIG/$RC_FILE") <<EOL
#########################################################
# 		OVERWRITE -- [protected]		#
#-------------------------------------------------------#
# [alterworld] term dumper				#
# author: 		<pikj.reyderman@gmail.com>	#
# specification: 	XDG				#
# root manual: 		https://shorturl.at/fjAB3	#
#########################################################

export ROOT=/
export DATE=\$(date +'20%y-%m-%d')
export DATETIME=\$(date)
export BASH_VERSION="$(/bin/bash --version)"

# -- observer[XDG]
export XDG_DATA_HOME=$XDG_DATA_HOME	# -- observer-point
export XDG_CONFIG_HOME=$XDG_CONFIG_HOME		# -- observer-point
export XDG_CACHE_HOME=$XDG_CACHE_HOME		# -- observer-point
export XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR		# -- observer-point
# -- end-observer[XDG]

# override native bash environments
export BASH_SESSIONS_DIR=$XDG_RUNTIME_DIR/bash/.bash_sessions
export HISTFILE=$XDG_RUNTIME_DIR/bash/.bash_history

# override zsh shell app root dir 
export ZSH=\$XDG_DATA_HOME/zsh
export ZSH_CONFIG=\$XDG_CONFIG_HOME/zsh
export ZSH_CACHE=\$XDG_CACHE_HOME/zsh
export ZSH_TEMP=\$XDG_RUNTIME_DIR/zsh

# override homebrew package manager paths
export HOMEBREW_REPOSITORY=\$XDG_DATA_HOME/homebrew

# export HOMEBREW_PREFIX=/opt/homebrew # RECOMMENDED BY OFF MANUAL
export HOMEBREW_PREFIX=\$XDG_CONFIG_HOME/homebrew # TESTING
export HOMEBREW_CACHE=\$XDG_CACHE_HOME/homebrew
export HOMEBREW_TEMP=\$XDG_RUNTIME_DIR/homebrew
#########################################################
# -- EXTENSIONS -- [protected]
EOL
logger:flow info zsh:rc:dump rc-write successful
zsh-ln-refresh
zsh-rc-check

#[home brew] ext #########################################
command -v $HOMEBREW_PREFIX/bin/brew &> /dev/null && {
	(echo "# Homebrew EXT automate"; echo "eval \"\$(${HOMEBREW_PREFIX}/bin/brew shellenv)\"") >> $HOME/$RC_FILE
	eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
	logger:flow info zsh:rc:dump opt:homebrew observed
	wait
}
logger info zsh:rc:dump successful
}

# -- OVERRIDE -- [protected] > rcprofile
# [ -e $(eval echo "$ZSH_CONFIG/$RC_PROFILE_FILE") ] || echo "Hello, this is the content of the file!" > $HOME/$RC_PROFILE_FILE
#########################################################
SETUP() {
environments_check "XDG_ENVIRONMENTS[@]" "XDG_DEFAULT_VALUES[@]"
paths_check "XDG_ENVIRONMENTS[@]" # -f
#zsh-paths-refresh	# initialise xdg infrastructure
#zsh-rc-dump		# initialise zsh
#homebrew-check		# checkin homebrew
}
#########################################################
SETUP
# homebrew-uninstall
logger:flow info bash:compose:log close successful
# IN LAST
# zsh-rc-check
# clear && printf '\e[3J'