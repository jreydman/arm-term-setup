#!/bin/bash
set -e
echo "[work]SYSINFO: "$($SHELL --version 2>&1 | head -n 1)"|$HOSTNAME:$HOSTTYPE:$OSTYPE|$$"
SH_SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
. $SH_SCRIPT_DIR/common.module.sh


#########################################################
# 	OVERRIDE -- XDG/default endpoints		#
#-------------------------------------------------------#
# XDG_DATA_HOME=$HOME/Library				#
# XDG_CONFIG_HOME=$HOME/Library/Preferences		#
# XDG_CACHE_HOME=$HOME/Library/Caches			#
# XDG_RUNTIME_DIR=$HOME/Library/Caches/TemporaryItems	#
#-------------------------------------------------------#

OVERRIDE_CONF=$SH_SCRIPT_DIR/override.conf
XDG_ENVIRONMENTS=("XDG_DATA_HOME" "XDG_CONFIG_HOME" "XDG_CACHE_HOME" "XDG_RUNTIME_DIR")
XDG_DEFAULT_VALUES=("$HOME/.local/share" "$HOME/.config" "$HOME/.cache" "$HOME/.tmp")
XDG_MODULES=()
MODULE_ENVS=()

RC_SHELL=zsh
__shell=$(echo "$RC_SHELL" | tr '[:lower:]' '[:upper:]')
RC_PROFILE_FILE=.zprofile
RC_FILE=.zshrc
RC_ENV_FILE=.zshenv
#########################################################

xdg_module_uninstall() { # $1"modulename"
return
}

xdg_module_check() { # $1"force"?
logger info "$FUNCNAME" init
process_module() {
local module="$1"
XDG_MODULES+=("$module")
shift
current_path_defaults=()
for xdg_env in "${XDG_ENVIRONMENTS[@]}"; do
  current_path_defaults+=("${!xdg_env}/$module")
done
current_env_names=()
while [ $# -gt 0 ]; do
MODULE_ENVS+=($1)
current_env_names+=("$1")
if [ -n "$1" ] && [ -n "$2" ]; then
 export "$1"="$(eval echo $2)"
fi
shift 2
done
environments_check "current_env_names[@]" "current_path_defaults[@]"
paths_check "current_env_names[@]"
}
while IFS='=' read -r variable value; do
if [[ ! "$variable" =~ ^\s*# ]]; then
  if [[ $variable == \[*\] ]]; then
    if [ "${#variables[@]}" -gt 0 ]; then process_module "$current_module" "${variables[@]}"; fi
    current_module="${variable:1}"; current_module="${current_module%]}"; variables=()
    else variables+=("$variable" "$value"); 
    fi
  fi
done < "$OVERRIDE_CONF"
if [ "${#variables[@]}" -gt 0 ]; then process_module "$current_module" "${variables[@]}"; fi
logger info "$FUNCNAME" successful
}

rc_source() {
source $(eval echo $HOME/$RC_FILE) &&
logger:flow info "$FUNCNAME" $RC_FILE successful
}

rc_ln_refresh() {
logger info "$FUNCNAME" init
links=("$RC_FILE" "$RC_PROFILE_FILE")
for link in "${links[@]}"; do
if [[ -e "$HOME/$link" ]];
 then logger:flow warning "$FUNCNAME" "$link" "already exists"
 continue
fi
ln -s "$(eval echo "\$${__shell}_CONFIG/\$link")" "$(eval echo $HOME/$link)" &&
logger:flow info "$FUNCNAME" "$link" created
done
rc_source
logger info "$FUNCNAME" successful
}

rc_dump() {
logger info $FUNCNAME init
echo $ZSH_CONFIG
__shell_cfg="$(eval echo "\$${__shell}_CONFIG/\$RC_FILE")"
echo $__shell_cfg

if [[ ! -e "$(eval echo "\$${__shell}_CONFIG/\$RC_PROFILE_FILE")" ]]; then
touch "$(eval echo "\$${__shell}_CONFIG/\$RC_PROFILE_FILE")"
logger:flow info "$FUNCNAME<rc-write>" $RC_PROFILE_FILE successful
else logger:flow info "$FUNCNAME<rc-write>" $RC_PROFILE_FILE "already exists"
fi

cat > $__shell_cfg <<EOL
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
export SHELL_VERSION=\$($SHELL --version 2>&1 | head -n 1)

# -- observer[XDG]
export XDG_DATA_HOME=$XDG_DATA_HOME	# -- observer-point
export XDG_CONFIG_HOME=$XDG_CONFIG_HOME		# -- observer-point
export XDG_CACHE_HOME=$XDG_CACHE_HOME		# -- observer-point
export XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR		# -- observer-point
# -- end-observer[XDG]

#########################################################
# -- MODULE ENV -- [protected]
EOL
for env_var in "${MODULE_ENVS[@]}"; do
    value=$(printenv "$env_var")
    if [ -n "$value" ]; then echo "export $env_var=$value" >> $__shell_cfg; fi
done
echo "# -- MODULE BOOTSTRAP -- [protected]" >> $__shell_cfg;
for module_name in "${XDG_MODULES[@]}"; do
echo $module_name
if [[ ! -f $(eval echo $SH_SCRIPT_DIR/$module_name.module.sh) ]]; then continue; fi
. $(eval echo $SH_SCRIPT_DIR/$module_name.module.sh)
$module_name:bootstrap
done

logger info $FUNCNAME successful
}

# -- OVERRIDE -- [protected] > rcprofile
#########################################################
SETUP() {
environments_check "XDG_ENVIRONMENTS[@]" "XDG_DEFAULT_VALUES[@]"
paths_check "XDG_ENVIRONMENTS[@]"
xdg_module_check
rc_dump
rc_ln_refresh
}
#########################################################
SETUP
logger:flow info $FUNCNAME close successful
# clear && printf '\e[3J'
# cat $HOME/$RC_FILE
exit 0