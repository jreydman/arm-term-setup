# OVERRIDE -- XDG endpoints

# XDG_DATA_HOME=$HOME/Library
# XDG_CONFIG_HOME=$HOME/Library/Preferences
# XDG_CACHE_HOME=$HOME/Library/Caches
# XDG_RUNTIME_DIR=$HOME/Library/Caches/TemporaryItems

#########################################################

xdg-environment-refresh() {
  check_and_set() {
    local var_name=$1; local var_path=$2
    [ -z "${!var_name}" ] && eval "$var_name=\$HOME/$var_path" && echo "Log:	<info>	|xdg:environment:check|>flow[$var_path] successful" || echo "Log:	<warning>	|xdg:environment:check|>flow[$var_path] already exists"
  }
  check_and_set XDG_DATA_HOME .local/share
  check_and_set XDG_CONFIG_HOME .config
  check_and_set XDG_CACHE_HOME .cache
  check_and_set XDG_RUNTIME_DIR .tmp
}

homebrew-install() {
echo "Log:	<info>	|homebrew:install|	init"
command -v brew &> /dev/null && { echo "Log:	<warning>	|homebrew:install| already exists"; return; }
/bin/bash -i -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &&
wait &&
echo "Log:	<info>	|homebrew:install|>flow[opt-write]	successful" &&
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zshrc &&
eval "$(/opt/homebrew/bin/brew shellenv)" &&
echo "Log:	<info>	|homebrew:install|>flow[init] successful"
}

zsh-paths-refresh() {
echo "Log: <info>	|zsh:paths:check|	init"
directories=("$ZSH" "$ZSH_CONFIG" "$ZSH_CACHE" "$ZSH_TEMP")
for dir in "${directories[@]}"; do
    [ -d "$dir" ] || mkdir -p "$dir" && echo "Log:	<warning>	|zsh:paths:check|>flow[${dir}]	already exists"
done
echo "Log: <info>	|zsh:paths:check|	successful"
}

zsh-ln-refresh() {
echo "Log: <info>	|zsh:ln:check|	init"
[ -e $HOME/.zprofile ] || ln -s $(eval echo "$ZSH_CONFIG/.zprofile") $HOME/.zprofile && echo "Log: <warning>	|zsh:ln:check|>flow[zprofile]	already exists"
[ -e $HOME/.zshrc ] || ln -s $(eval echo "$ZSH_CONFIG/.zshrc") $HOME/.zshrc && echo "Log: <warning>	|zsh:ln:check|>flow[zshrc]	already exists"
echo "Log: <info>	|zsh:ln:check|	successful"
}

zsh-dump-rc() {
xdg-environment-refresh
echo "Log: <info>	|zsh:dump:rc|	init"
ZSH_CONFIG=$XDG_CONFIG_HOME/zsh
rm -rf $(eval echo "$ZSH_CONFIG")
mkdir -p $(eval echo "$ZSH_CONFIG")
cat > $(eval echo "$ZSH_CONFIG/.zshrc") <<EOL
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
# -- EXTENSIONS
EOL
echo "Log: <info>	|zsh:dump:rc|>flow[z-write]	successful"
source $(eval echo "$ZSH_CONFIG/.zshrc") && echo "Log:	<info>	|root:source:check|>flow[zshrc] successful"
zsh-ln-refresh

#[homebrew] ext #########################################
command -v brew &> /dev/null && { (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> $HOME/.zshrc && wait; }
}

#########################################################

SETUP() {
zsh-dump-rc		# initialise zsh
zsh-paths-refresh	# initialise xdg infrastructure
homebrew-install	# checkin homebrew
}

#########################################################
SETUP