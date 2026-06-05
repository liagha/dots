#!/usr/bin/env bash
DOT_DIR="${DOT_DIR:-$HOME/.dotfiles}"
ZSHRC_SRC="$DOT_DIR/zshrc"
ZSHRC_DST="$HOME/.zshrc"

backup_config() {
    if [ -f "$ZSHRC_DST" ] && [ ! -L "$ZSHRC_DST" ]; then
        mv "$ZSHRC_DST" "$ZSHRC_DST.backup.$(date +%s)"
        echo "Backed up existing zshrc"
    fi
}

install_zsh() {
    if ! command -v zsh >/dev/null 2>&1; then
        echo "zsh not installed"
        return 1
    fi
    
    backup_config
    rm -f "$ZSHRC_DST"
    ln -sf "$ZSHRC_SRC" "$ZSHRC_DST"
    
    if [[ "$SHELL" != *"zsh"* ]]; then
        chsh -s "$(which zsh)"
        echo "Default shell changed to zsh"
    fi
    
    echo "zsh setup complete"
}

install_zsh
