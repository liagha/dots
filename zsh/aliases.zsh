alias c='clear && printf "\033[3J"'
alias clear='clear && printf "\033[3J"'

alias ls='eza --icons --group-directories-first'
alias ll='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias la='eza -a --icons --group-directories-first'

alias grep='rg'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias lg='lazygit'

alias find='fd'

alias yq='yq --pretty-print'

extract() {
    case $1 in
        *.tar.bz2) tar xjf $1 ;;
        *.tar.gz) tar xzf $1 ;;
        *.tar.xz) tar xJf $1 ;;
        *.bz2) bunzip2 $1 ;;
        *.rar) unrar x $1 ;;
        *.gz) gunzip $1 ;;
        *.tar) tar xf $1 ;;
        *.tbz2) tar xjf $1 ;;
        *.tgz) tar xzf $1 ;;
        *.zip) unzip $1 ;;
        *.Z) uncompress $1 ;;
        *.7z) 7z x $1 ;;
        *) echo "'$1' cannot be extracted" ;;
    esac
}

cd() {
    builtin cd "$@" && ls
}

mkcd() { mkdir -p "$1" && cd "$1" }

ports() { ss -tulanp | grep "$1" }

alias df='duf'
alias du='dust'
alias ps='procs'

alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'