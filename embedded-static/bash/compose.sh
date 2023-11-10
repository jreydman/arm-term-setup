#!/bin/bash

# OVERRIDE -- XDG/default endpoints

#declare -A default_paths_dictionary=( ["XDG_DATA_HOME"]="$HOME/.local/#share" ["XDG_CONFIG_HOME"]="$HOME/.config" ["XDG_CACHE_HOME"]="$HOME/.cache" ["XDG_RUNTIME_DIR"]="$HOME/.tmp")
#-------------------------------------------------------#
# declare -A xdg_paths_dictionary
# xdg_paths_dictionary["XDG_DATA_HOME"]=$HOME/Library
# xdg_paths_dictionary["XDG_CONFIG_HOME"]=$HOME/Library/Preferences
# xdg_paths_dictionary["XDG_CACHE_HOME"]=$HOME/Library/Caches
# xdg_paths_dictionary["XDG_RUNTIME_DIR"]=$HOME/Library/Caches/TemporaryItems


RC_PROFILE_FILE=.zprofile
RC_FILE=.zshrc
#########################################################

logger() { echo "Log: <$1>    |$2|    $3"; }
logger:flow() { echo "Log: <$1>    |$2|>flow[$3]    $4"; }

xdg-environment-refresh() {
  check_and_set() {
    local var_name=$1; local var_path=$2
    [ -z "${!var_name}" ] && eval "$var_name=\$HOME/$var_path" && logger:flow info xdg:environment:check $var_path successful || logger:flow warning xdg:environment:check $var_path "already exists"
  }
  check_and_set XDG_DATA_HOME .local/share
  check_and_set XDG_CONFIG_HOME .config
  check_and_set XDG_CACHE_HOME .cache
  check_and_set XDG_RUNTIME_DIR .tmp
}

homebrew-install() {
logger info homebrew:install init
command -v brew &> /dev/null && { logger warning> homebrew:install "already exists"; return; }
/bin/bash -i -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
wait && logger:flow info homebrew:install opt-write successful && (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/$RC_FILE && eval "$(/opt/homebrew/bin/brew shellenv)" && logger:flow info homebrew:install init successful
}

zsh-paths-refresh() {
logger info zsh:paths:check init
directories=("$ZSH" "$ZSH_CONFIG" "$ZSH_CACHE" "$ZSH_TEMP")
for dir in "${directories[@]}"; do
    [ -d "$dir" ] || mkdir -p "$dir" && logger:flow warning zsh:paths:check ${dir} "already exists"
done
logger info zsh:paths:check	successful
}

zsh-ln-refresh() {
logger info zsh:ln:check init
links=("$RC_FILE" "$RC_PROFILE_FILE")
for link in "${links[@]}"; do
[ ! -e "$HOME/$link" ] && ln -s "$(eval echo "$ZSH_CONFIG/$link")" "$HOME/$link" && logger:flow info zsh:ln:check $link created || logger:flow warning zsh:ln:check $link "already exists"
done
logger info zsh:ln:check successful
}

zsh-dump-rc() {
xdg-environment-refresh
logger info zsh:dump:rc init
ZSH_CONFIG=$XDG_CONFIG_HOME/zsh
rm -rf $(eval echo "$ZSH_CONFIG")
mkdir -p $(eval echo "$ZSH_CONFIG")
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

# override zsh shell app root dir 
export ZSH=\$XDG_DATA_HOME/zsh
export ZSH_CONFIG=\$XDG_CONFIG_HOME/zsh
export ZSH_CACHE=\$XDG_CACHE_HOME/zsh
export ZSH_TEMP=\$XDG_RUNTIME_DIR/zsh

# override homebrew package manager paths
export HOMEBREW_REPOSITORY=\$XDG_DATA_HOME/homebrew
export HOMEBREW_PREFIX=\$XDG_CONFIG_HOME/homebrew
export HOMEBREW_CACHE=\$XDG_CACHE_HOME/homebrew
export HOMEBREW_TEMP=\$XDG_RUNTIME_DIR/homebrew
#########################################################
# -- EXTENSIONS -- [protected]
EOL
logger:flow info zsh:dump:rc z-write successful
source $(eval echo "$ZSH_CONFIG/$RC_FILE") && logger:flow info root:source:check $RC_FILE successful
zsh-ln-refresh

#[homebrew] ext #########################################
command -v brew &> /dev/null && { (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/$RC_FILE && wait; }
}

# -- OVERRIDE -- [protected] > rcprofile
# [ -e $(eval echo "$ZSH_CONFIG/$RC_PROFILE_FILE") ] || echo "Hello, this is the content of the file!" > $HOME/$RC_PROFILE_FILE
#########################################################
SETUP() {
zsh-dump-rc		# initialise zsh
zsh-paths-refresh	# initialise xdg infrastructure
homebrew-install	# checkin homebrew
}
#########################################################
SETUP
logger:flow info bash:compose:log close successful