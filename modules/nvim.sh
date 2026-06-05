#!/usr/bin/env bash
DOT_DIR="${DOT_DIR:-$HOME/.dotfiles}"
NVIM_SRC="$DOT_DIR/nvim"
NVIM_DST="$HOME/.config/nvim"

backup_config() {
    if [ -e "$NVIM_DST" ] && [ ! -L "$NVIM_DST" ]; then
        mv "$NVIM_DST" "$NVIM_DST.backup.$(date +%s)"
        echo "Backed up existing nvim config"
    fi
}

install_neovim() {
    if ! command -v nvim >/dev/null 2>&1; then
        echo "Neovim not installed"
        return 1
    fi
    
    backup_config
    rm -rf "$NVIM_DST"
    ln -sf "$NVIM_SRC" "$NVIM_DST"
    
    nvim --headless "+Lazy! sync" +qa 2>/dev/null
    nvim --headless "+TSInstallSync all" +qa 2>/dev/null
    
    echo "Neovim setup complete"
}

install_neovim
