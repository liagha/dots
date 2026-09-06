#!/usr/bin/env bash
set -euo pipefail

resolve() {
    local p="$1"
    if command -v readlink >/dev/null 2>&1; then
        p="$(readlink -f "$p" 2>/dev/null || printf '%s\n' "$p")"
    fi
    printf '%s\n' "$p"
}

SCRIPT_DIR="$(cd "$(dirname "$(resolve "${BASH_SOURCE[0]}")")" && pwd -P)"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

usage() {
    cat <<'EOF'
Usage: install.sh [--clean]

Installs dotfiles from this repo into ~/.config and ~/.zshrc.
Existing files are moved into a dots-backup-<stamp> dir first;
the 3 newest backup dirs are kept, older ones are pruned.

Options:
  --clean   delete all dots-backup-* dirs (run once the config works)
  --help    show this help
EOF
}

clean_backups() {
    local d removed=0
    for d in "$XDG_CONFIG_HOME"/dots-backup-*; do
        if [[ -d "$d" ]]; then
            rm -rf "$d"
            printf '  [removed] %s\n' "$d"
            removed=$((removed+1))
        fi
    done
    printf 'Removed %d backup dir(s).\n' "$removed"
}

install_item() {
    local src="$1" dst="$2" name="$3"
    if [[ ! -e "$src" ]]; then
        printf '  [skip] %s (not in repo)\n' "$name"
        return
    fi
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

prune_backups() {
    local keep="${1:-3}" count=0
    find "$XDG_CONFIG_HOME" -maxdepth 1 -type d -name 'dots-backup-*' 2>/dev/null \
        | sort -r \
        | while IFS= read -r d; do
            count=$((count+1))
            if [[ $count -gt $keep ]]; then
                rm -rf "$d"
                printf '  [prune] %s\n' "$d"
            fi
        done
}

case "${1:-}" in
    --help|-h)
        usage
        exit 0
        ;;
    --clean)
        clean_backups
        exit 0
        ;;
    '')
        ;;
    *)
        printf 'Unknown option: %s\n' "$1" >&2
        usage >&2
        exit 1
        ;;
esac

STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$XDG_CONFIG_HOME/dots-backup-$STAMP"

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

prune_backups 3
echo "Done."
echo "Overwritten files are under $BACKUP_DIR; run $0 --clean once you confirm everything works."