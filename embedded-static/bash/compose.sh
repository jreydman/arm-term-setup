homebrew-install() {
echo "Log:	<info>	|homebrew:install|	init"
command -v brew &> /dev/null && echo "Log:	<warning>	|homebrew:install| already exists" || /bin/bash -i -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &
wait
echo "Log:	<info>	|homebrew:install| successful"
}

zsh-paths-refresh() {
echo "Log: <info>	|zsh:paths:check|	init"
[ -d $ZSH ] || mkdir -p $ZSH && echo "Log:	<warning>	|zsh:paths:check|>flow[DATA]	already exists"
[ -d $ZSH_CONFIG ] || mkdir -p $ZSH_CONFIG && echo "Log:	<warning>	|zsh:paths:check|>flow[CONFIG]	already exists"
[ -d $ZSH_CACHE ] || mkdir -p $ZSH_CACHE && echo "Log:	<warning>	|zsh:paths:check|>flow[CACHE]	already exists"
[ -d $ZSH_TEMP ] || mkdir -p $ZSH_TEMP && echo "Log:	<warning>	|zsh:paths:check|>flow[TEMP]	already exists"
echo "Log: <info>	|zsh:paths:check|	successful"
}

zsh-ln-refresh() {
echo "Log: <info>	|zsh:ln:check|	init"
[ -e $HOME/.zprofile ] || ln -s $ZSH_CONFIG/.zprofile $HOME/.zprofile && echo "Log: <warning>	|zsh:ln:check|>flow[zprofile]	already exists"
echo "Log: <info>	|zsh:ln:check|	successful"
}