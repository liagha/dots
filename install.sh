#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$XDG_CONFIG_HOME/dots-backup-$STAMP"

install_item() {
    local src="$1" dst="$2" name="$3"
    if [[ -e "$dst" ]] && diff -rq "$src" "$dst" >/dev/null 2>&1; then
        printf '  [skip] %s (identical)\n' "$name"
        return
    fi
    if [[ -e "$dst" ]]; then
        local rel="${dst#$HOME/}"
        local bak="$BACKUP_DIR/$rel"
        mkdir -p "$(dirname "$bak")"
        mv "$dst" "$bak"
        printf '  [backup] %s -> %s\n' "$name" "$bak"
    fi
    mkdir -p "$(dirname "$dst")"
    cp -r "$src" "$dst"
    printf '  [install] %s\n' "$name"
}

echo "Installing dotfiles from $SCRIPT_DIR"

if command -v zsh >/dev/null 2>&1; then
    echo "[zsh]"
    install_item "$SCRIPT_DIR/zshrc" "$HOME/.zshrc" "zshrc"
    install_item "$SCRIPT_DIR/zsh" "$XDG_CONFIG_HOME/zsh" "zsh config"
fi

if command -v nvim >/dev/null 2>&1; then
    echo "[nvim]"
    install_item "$SCRIPT_DIR/nvim" "$XDG_CONFIG_HOME/nvim" "nvim config"
fi

if command -v sway >/dev/null 2>&1; then
    echo "[sway]"
    install_item "$SCRIPT_DIR/sway" "$XDG_CONFIG_HOME/sway" "sway config"
fi

if command -v i3status-rs >/dev/null 2>&1; then
    echo "[i3status-rust]"
    install_item "$SCRIPT_DIR/i3status-rust" "$XDG_CONFIG_HOME/i3status-rust" "i3status-rust config"
fi

echo "Done."
echo "Anything overwritten was backed up under $BACKUP_DIR"