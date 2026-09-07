autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

precmd() {
    vcs_info
}

PROMPT='%F{cyan}[${VI_MODE}]%f %F{245}%m%f @ %F{252}%2~%f '
