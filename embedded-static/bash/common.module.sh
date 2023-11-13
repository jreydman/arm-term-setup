logger() { printf "($SH_SCRIPT_DIR)|Log: <%s>\t|%s|\t%s\n" "$1" "$2" "$3"; }
logger:flow() { printf "($SH_SCRIPT_DIR)|Log: <%s>\t|%s|>flow[%s]\t%s\n" "$1" "$2" "$3" "$4"; }

environments_check() { # $1[env_names] $[env_default_values]
  env_vars=("${!1}")
  default_values=("${!2}")
  for ((i=0; i<${#env_vars[@]}; i++)); do
    env_var="${env_vars[$i]}"
    default_value="${default_values[$i]}"
    if eval "[ -z \${$env_var+x} ]"; then
      eval "export $env_var='$default_value'"
      logger:flow info "$FUNCNAME:$env_var" ${!env_var} "successful"
    else logger:flow warning "$FUNCNAME:$env_var" ${!env_var} "already exists"
    fi
  done
}

paths_check() { # $1[env_name_paths] $2"force"?
logger info "$FUNCNAME" init
env_vars=("${!1}")
for env_name_path in "${env_vars[@]}"; do
path=$(eval echo "\${$env_name_path}")
if [ -d "$path" ] && [ -z "$2" ]; then logger:flow warning "$FUNCNAME:$env_name_path" ${path} "already exists";
elif [ -d "$path" ] && [ ! -z "$2" ]; then rm -rf "$path"; mkdir -p "$path"; logger:flow info "$FUNCNAME<force>:$env_name_path" ${path} successful;
else mkdir -p "$path"; logger:flow info "$FUNCNAME:$env_name_path" ${path} successful;
fi
done
logger info "$FUNCNAME" successful
}