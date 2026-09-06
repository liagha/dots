if command -v fzf >/dev/null 2>&1; then
    if [[ -f /usr/share/fzf/key-bindings.zsh ]]; then
        { source /usr/share/fzf/key-bindings.zsh; source /usr/share/fzf/completion.zsh; } 2>/dev/null
    elif [[ -f /usr/local/opt/fzf/shell/key-bindings.zsh ]]; then
        { source /usr/local/opt/fzf/shell/key-bindings.zsh; source /usr/local/opt/fzf/shell/completion.zsh; } 2>/dev/null
    fi

    export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --no-bold'
    export FZF_CTRL_R_OPTS='--preview "echo {} | head -1" --preview-window=down:1'
    export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --color=always {} 2>/dev/null || head -50 {}"'
    export FZF_ALT_C_OPTS='--preview "eza --tree --level=2 {}"'
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
fi