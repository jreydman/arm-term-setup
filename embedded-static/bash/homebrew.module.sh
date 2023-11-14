# if [ -z "$HOMEBREW_PREFIX" ]; then HOMEBREW_PREFIX="/opt/homebrew"; fi
APM=$HOMEBREW_PREFIX/bin/brew

homebrew:uninstall() { 
logger info "$FUNCNAME" init
rm -rf $(eval echo $HOMEBREW_PREFIX)
rm -rf $(eval echo $HOMEBREW_REPOSITYRY)
rm -rf $(eval echo $HOMEBREW_CACHE)
rm -rf $(eval echo $HOMEBREW_TEMP)
export PATH=$(echo $PATH | tr ':' '\n' | grep -v $(eval echo $HOMEBREW_PREFIX)/bin | tr '\n' ':')
export PATH=$(echo $PATH | tr ':' '\n' | grep -v $(eval echo $HOMEBREW_PREFIX)/sbin | tr '\n' ':')
logger info "$FUNCNAME" successful
}

homebrew:install() {
logger info $FUNCNAME init
echo echo "HOMEBREW_PREFIX=$HOMEBREW_PREFIX"
if command -v brew &> /dev/null; then
  logger:flow warning "$FUNCNAME" "already exists"; return
fi
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $HOMEBREW_PREFIX
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
logger info $FUNCNAME successful
}

homebrew:source() {
logger info $FUNCNAME init
echo "eval \"\$(${HOMEBREW_PREFIX}/bin/brew shellenv)\"" >> $__shell_cfg
logger info $FUNCNAME successful
}

homebrew:override() {
logger info $FUNCNAME init
utils=(
"git"
"zsh"
)

for utility in ${utils[@]}; do
$APM install $(eval echo $utility) &
done
wait
logger info $FUNCNAME successful
}

homebrew:bootstrap() {
logger info "$FUNCNAME" init
homebrew:install
$APM update && $APM doctor && logger:flow info "$FUNCNAME" "update" "successful"
homebrew:source
homebrew:override
logger info "$FUNCNAME" successful
}