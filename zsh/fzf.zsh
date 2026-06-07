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

    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
    export FZF_CTRL_T_OPTS='--preview "bat --color=always {} 2>/dev/null || cat {}"'
    export FZF_ALT_C_OPTS='--preview "ls -la {}"'
fi
