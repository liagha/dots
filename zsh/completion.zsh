autoload -Uz compinit
compinit -d "${ZDOTDIR:-$HOME/.config/zsh}/.zcompdump"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose no
zstyle ':completion:*' format '%F{245}%d%f'
zstyle ':completion:*:descriptions' format '%F{245}%d%f'
zstyle ':completion:*:warnings' format '%F{245}no matches%f'
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' completer _extensions _complete _approximate _correct _prefix
zstyle ':completion:*' list-max 10

zstyle ':completion:*:functions' ignored-patterns '_*'

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}#git-}

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZDOTDIR:-$HOME/.config/zsh}/cache"

zmodload zsh/complist

bindkey -M viins '^I' menu-complete
bindkey -M viins '^[[Z' reverse-menu-complete

bindkey -M menuselect '^[' undo
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^[[Z' reverse-menu-complete

export CLICOLOR=1