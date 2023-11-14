#!/bin/zsh
__ohmyzsh_cfg=$(eval echo $ZSH/.zshrc)

powerlevel10k:install() {
logger info $FUNCNAME init
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH/custom/themes/powerlevel10k"
logger info $FUNCNAME successful
}

powerlevel10k:source() {
logger info $FUNCNAME init
sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' $__ohmyzsh_cfg
logger info $FUNCNAME successful
}

powerlevel10k:bootstrap() {
logger info "$FUNCNAME" init
powerlevel10k:install
powerlevel10k:source
logger info "$FUNCNAME" successful
}