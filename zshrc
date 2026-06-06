HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt APPEND_HISTORY    
setopt SHARE_HISTORY      
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE   
setopt HIST_REDUCE_BLANKS   
setopt INC_APPEND_HISTORY    
setopt AUTO_CD        
setopt EXTENDED_GLOB 
setopt INTERACTIVE_COMMENTS    
setopt PROMPT_SUBST           

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''
export CLICOLOR=1

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey -v
KEYTIMEOUT=1

bindkey -M viins '^[[A' up-line-or-beginning-search
bindkey -M viins '^[OA' up-line-or-beginning-search
bindkey -M viins '^[[B' down-line-or-beginning-search
bindkey -M viins '^[OB' down-line-or-beginning-search
bindkey -M vicmd '^[[A' up-line-or-beginning-search
bindkey -M vicmd '^[OA' up-line-or-beginning-search
bindkey -M vicmd '^[[B' down-line-or-beginning-search
bindkey -M vicmd '^[OB' down-line-or-beginning-search

bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word

function zle-keymap-select {
    case $KEYMAP in
        vicmd) echo -ne '\e[2 q';;
        viins|main) echo -ne '\e[5 q';;
    esac
}
zle -N zle-keymap-select

function zle-line-init {
    zle -K viins
    echo -ne '\e[5 q'
}
zle -N zle-line-init

function zle-line-finish {
    echo -ne '\e[5 q'
}
zle -N zle-line-finish

autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '(%b)'
precmd() {
    vcs_info
}
PROMPT='%F{252}%1~%f %F{245}${vcs_info_msg_0_}%f '

alias c='clear && printf "\033[3J"'
alias clear='clear && printf "\033[3J"'
alias ls='ls --color=auto'
alias ll='ls -lha'
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh --cmd cd)"
fi

if command -v fzf >/dev/null 2>&1; then
  if [[ -f "$(brew --prefix 2>/dev/null)/opt/fzf/shell/key-bindings.zsh" ]]; then
    source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"
    source "$(brew --prefix)/opt/fzf/shell/completion.zsh"
  elif [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
  elif [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
    source /usr/local/opt/fzf/shell/key-bindings.zsh
    source /usr/local/opt/fzf/shell/completion.zsh
  fi
fi

export PATH="$HOME/.local/bin:$PATH"
