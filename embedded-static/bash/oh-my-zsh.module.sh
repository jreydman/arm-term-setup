#!/bin/zsh
oh-my-zsh:install() {
logger info $FUNCNAME init
echo $ZDOTDIR
rm -r $(eval echo $ZDOTDIR)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --keep-zshrc --unattended --keep-zshrc
logger info $FUNCNAME successful
}

oh-my-zsh:source() {
logger info $FUNCNAME init
echo $__shell_cfg
echo "$(eval echo source $ZDOTDIR/.zshrc)" >> $__shell_cfg
echo $(eval echo ZSH_COMPDUMP=$ZSH_TEMP/pikj-configuration.dump) >> $__shell_cfg
logger info $FUNCNAME successful
}

oh-my-zsh:bootstrap() {
logger info "$FUNCNAME" init
oh-my-zsh:install
oh-my-zsh:source
logger info "$FUNCNAME" successful
}