#########################################################
# 		OVERWRITE -- [protected]		#
#-------------------------------------------------------#
# [alterworld] term dumper				#
# author: 		<pikj.reyderman@gmail.com>	#
# specification: 	XDG				#
# root manual: 		https://shorturl.at/fjAB3	#
#########################################################

export ROOT=/
export DATE=$(date +'20%y-%m-%d')
export DATETIME=$(date)

# -- observer[XDG]
export XDG_DATA_HOME=$HOME/Library				# -- observer-point
export XDG_CONFIG_HOME=$HOME/Library/Preferences		# -- observer-point
export XDG_CACHE_HOME=$HOME/Library/Caches			# -- observer-point
export XDG_RUNTIME_DIR=$HOME/Library/Caches/TemporaryItems	# -- observer-point
# -- end-observer[XDG]

# override zsh shell app root dir 
export ZSH=$XDG_DATA_HOME/zsh
export ZSH_CONFIG=$XDG_CONFIG_HOME/zsh
export ZSH_CACHE=$XDG_CACHE_HOME/zsh
export ZSH_TEMP=$XDG_RUNTIME_DIR/zsh


# override homebrew package manager paths
export HOMEBREW_REPOSITORY=$XDG_DATA_HOME/homebrew
export HOMEBREW_PREFIX=$XDG_CONFIG_HOME/homebrew
export HOMEBREW_CACHE=$XDG_CACHE_HOME/homebrew
export HOMEBREW_TEMP=$XDG_RUNTIME_DIR/homebrew