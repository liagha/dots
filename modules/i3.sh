#!/usr/bin/env bash
DOT_DIR="${DOT_DIR:-$HOME/.dotfiles}"
I3_SRC="$DOT_DIR/i3"
I3_DST="$HOME/.config/i3"

backup_config() {
    if [ -e "$I3_DST" ] && [ ! -L "$I3_DST" ]; then
        mv "$I3_DST" "$I3_DST.backup.$(date +%s)"
        echo "Backed up existing i3 config"
    fi
}

install_i3() {
    if ! command -v i3 >/dev/null 2>&1; then
        echo "i3 not installed"
        return 1
    fi
    
    backup_config
    rm -rf "$I3_DST"
    ln -sf "$I3_SRC" "$I3_DST"
    
    if command -v i3-msg >/dev/null 2>&1; then
        i3-msg reload 2>/dev/null || true
    fi
    
    echo "i3 setup complete"
}

install_i3
