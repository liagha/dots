command -v eza >/dev/null 2>&1 && alias ls='eza --icons --group-directories-first'

if command -v eza >/dev/null 2>&1; then
    alias ll='eza -la --icons --group-directories-first --git'
    alias lt='eza --tree --level=2 --icons'
    alias la='eza -a --icons --group-directories-first'
else
    alias ll='ls -lah'
    alias lt='ls -R'
    alias la='ls -A'
fi

if command -v nvim >/dev/null 2>&1; then
    alias v='nvim'
    alias vi='nvim'
    alias vim='nvim'
else
    alias v='vim'
    alias vi='vim'
fi

command -v rg      >/dev/null 2>&1 && alias grep='rg'
command -v fd      >/dev/null 2>&1 && alias find='fd'
command -v duf     >/dev/null 2>&1 && alias df='duf'
command -v dust    >/dev/null 2>&1 && alias du='dust'
command -v procs   >/dev/null 2>&1 && alias ps='procs'
command -v lazygit >/dev/null 2>&1 && alias lg='lazygit'
command -v yq      >/dev/null 2>&1 && alias yq='yq --pretty-print'

alias c='clear && printf "\033[3J"'
alias clear='clear && printf "\033[3J"'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

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

alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'