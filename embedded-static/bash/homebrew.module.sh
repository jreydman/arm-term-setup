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
if command -v brew &> /dev/null; then
    logger:flow warning "$FUNCNAME" "already exists"; return
fi
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $(eval echo $HOMEBREW_PREFIX) && wait
logger info $FUNCNAME successful
}

homebrew:environment() {
logger info $FUNCNAME init
echo "eval \"\$(${HOMEBREW_PREFIX}/bin/brew shellenv)\"" >> $__shell_cfg
logger info $FUNCNAME successful
}

homebrew:bootstrap() {
logger info "$FUNCNAME" init
homebrew:install
homebrew:environment
logger info "$FUNCNAME" successful
}