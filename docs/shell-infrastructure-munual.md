# Shell infrastructure

> Frame extension: [___ZSH___](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)

> System package manager: [___Brew___](https://github.com/ohmyzsh/ohmyzsh)

## Schema of catalogs [_executable_]

| ***Endpoint***                              	| ***Description***                                           	| ***Environment***    	| ext 	|
|---------------------------------------------	|-------------------------------------------------------------	|----------------------	|-----	|
| /usr/                                       	| dependency reuse shared directory                           	|         $USR         	|  ✳️  	|
| ~/                                          	| home directory of active user                               	|         $HOME        	|  🅿️  	|
| $HOME/Library/[ __app-name__ ]/             	| directory for external apps                                 	|    $XDG_DATA_HOME    	|  ✳️  	|
| $HOME/Library/Preferences/[ __app-name__ ]/ 	| directory for app configs                                   	|   $XDG_CONFIG_HOME   	|  ✳️  	|
| $HOME/Library/Caches/[ __app-name__ ]/      	| directory for app caches                                    	|    $XDG_CACHE_HOME   	|  ✳️  	|
| $HOME/Library/Temporary/[ __app-name__ ]/   	| directory for app temp files                                	|   $XDG_RUNTIME_DIR   	|  ✳️  	|
| $XDG_DATA_HOME/zsh-shell/                   	| directory of ___app___ shell frame extension                	|         $ZSH         	|  ✳️  	|
| $XDG_DATA_HOME/homebrew/                    	| directory of ___app___ ___system package manager___         	| $HOMEBREW_REPOSITORY 	|  ✳️  	|
| $XDG_CONFIG_HOME/homebrew/                  	| directory of ___configs___ for ___system package manager___ 	|   $HOMEBREW_PREFIX   	|  ✳️  	|
| $XDG_CACHE_HOME/homebrew/                   	| directory of ___caches___ for ___system package manager___  	|    $HOMEBREW_CACHE   	|  ✳️  	|

---

## Relations

* [Version control](version-control-managers-manual.md)
* [Shell configuration](shell-configuration-manual.md)