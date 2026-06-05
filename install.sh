#!/usr/bin/env bash
set -euo pipefail

DOT_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

log_info() { printf "\033[0;32m[INFO]\033[0m %s\n" "$1"; }
log_error() { printf "\033[0;31m[ERROR]\033[0m %s\n" "$1"; }
log_warn() { printf "\033[0;33m[WARN]\033[0m %s\n" "$1"; }

backup_file() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$BACKUP_DIR/$(dirname "$target" | sed "s|$HOME||")"
        mv "$target" "$BACKUP_DIR/$(dirname "$target" | sed "s|$HOME||")/"
        log_info "Backed up $target"
    fi
}

link_file() {
    local src="$1"
    local dst="$2"
    backup_file "$dst"
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    log_info "Linked $src -> $dst"
}

clone_repo() {
    if [ ! -d "$DOT_DIR" ]; then
        git clone https://github.com/liagha/dots.git "$DOT_DIR"
        log_info "Cloned dotfiles to $DOT_DIR"
    else
        log_warn "Dotfiles already exist at $DOT_DIR"
        read -p "Pull latest changes? (y/n) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git -C "$DOT_DIR" pull
        fi
    fi
}

install_packages() {
    local packages=(
        git zsh neovim i3-wm rofi picom feh polybar
        alacritty tmux fzf ripgrep fd bat eza zoxide
        nodejs npm python-pip go rust cargo
    )
    
    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -S --needed "${packages[@]}"
    elif command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y "${packages[@]}"
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y "${packages[@]}"
    else
        log_warn "No known package manager found. Install packages manually."
    fi
}

setup_shell() {
    if ! command -v zsh >/dev/null 2>&1; then
        log_error "zsh not installed"
        return 1
    fi
    
    if [[ "$SHELL" != *"zsh"* ]]; then
        chsh -s "$(which zsh)"
        log_info "Default shell changed to zsh"
    fi
}

setup_nvim() {
    local nvim_src="$DOT_DIR/nvim"
    local nvim_dst="$HOME/.config/nvim"
    
    if [ ! -d "$nvim_src" ]; then
        log_error "Neovim config not found at $nvim_src"
        return 1
    fi
    
    link_file "$nvim_src" "$nvim_dst"
    
    if command -v nvim >/dev/null 2>&1; then
        nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
        nvim --headless "+TSInstallSync all" +qa 2>/dev/null || true
        log_info "Neovim plugins installed"
    fi
}

setup_i3() {
    local i3_src="$DOT_DIR/i3"
    local i3_dst="$HOME/.config/i3"
    local i3status_dst="$HOME/.config/i3status"
    
    if [ ! -d "$i3_src" ]; then
        log_error "i3 config not found at $i3_src"
        return 1
    fi
    
    link_file "$i3_src" "$i3_dst"
    
    if [ -f "$i3_src/config" ] && ! grep -q "status_command" "$i3_dst/config"; then
        cat >> "$i3_dst/config" << 'EOF'

bar {
    status_command i3status
    position top
}
EOF
    fi
}

setup_scripts() {
    local scripts_dir="$HOME/.local/bin"
    mkdir -p "$scripts_dir"
    
    if [ -f "$DOT_DIR/i3/rofi-power-menu" ]; then
        cp "$DOT_DIR/i3/rofi-power-menu" "$scripts_dir/"
        chmod +x "$scripts_dir/rofi-power-menu"
        log_info "Installed rofi-power-menu"
    fi
}

setup_libinput() {
    if [ -f "$DOT_DIR/libinput-gestures.conf" ]; then
        local dst="$HOME/.config/libinput-gestures.conf"
        link_file "$DOT_DIR/libinput-gestures.conf" "$dst"
        
        if command -v libinput-gestures >/dev/null 2>&1; then
            libinput-gestures-setup start
            log_info "libinput gestures started"
        fi
    fi
}

main() {
    log_info "Starting dotfiles setup"
    
    clone_repo
    
    read -p "Install system packages? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        install_packages
    fi
    
    setup_shell
    setup_nvim
    setup_i3
    setup_scripts
    setup_libinput
    
    log_info "Setup complete!"
    log_info "Backup stored at: $BACKUP_DIR"
    log_info "Restart your shell or run 'exec zsh'"
    
    if [ -f "$DOT_DIR/zshrc" ]; then
        echo "" >> "$HOME/.zshrc"
        echo "# Source dotfiles zshrc" >> "$HOME/.zshrc"
        echo "source $DOT_DIR/zshrc" >> "$HOME/.zshrc"
        log_info "Added source line to ~/.zshrc"
    fi
}

main "$@"
