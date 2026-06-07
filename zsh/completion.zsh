# ~/.config/zsh/completion.zsh

autoload -Uz compinit && compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' format '%F{245}%d%f'
zstyle ':completion:*:descriptions' format '%F{245}%d%f'
zstyle ':completion:*:messages' format '%F{245}%d%f'
zstyle ':completion:*:warnings' format '%F{red}no matches%f'
zstyle ':completion:*:corrections' format '%F{yellow}%d (errors: %e)%f'
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' special-dirs true
zstyle ':completion:*' completer _extensions _complete _approximate

zstyle ':completion:*:functions' ignored-patterns '_*'

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}#git-}

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZDOTDIR:-$HOME/.config/zsh}/cache"

zmodload zsh/complist

bindkey -M menuselect '^[' undo
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char

export CLICOLOR=1
