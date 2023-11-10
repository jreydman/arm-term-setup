# run func prompt for upload [homebrew]
brew-install() {
echo "Log:	<info>	|homebrew installation|	init"
command -v brew &> /dev/null && echo "Log:	<warning>	|homebrew installation| already exists" || /bin/bash -i -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" &
wait
echo "Log:	<info>	|homebrew installation| successful"
}