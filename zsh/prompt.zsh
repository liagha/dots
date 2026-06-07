autoload -Uz vcs_info
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:git:*' actionformats '(%b|%a)'

precmd() {
    vcs_info
}

PROMPT='%F{cyan}[${VI_MODE}]%f %F{252}%1~%f %F{245}${vcs_info_msg_0_}%f '
