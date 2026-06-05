# dotfiles

Modular configuration files for development environment.

## Contents

- `nvim/` - Neovim configuration with lazy.nvim, telescope, treesitter
- `i3/` - i3 window manager config with rofi launcher
- `zshrc` - Zsh configuration with vi-mode and history settings
- `libinput-gestures.conf` - Touchpad gestures

## Quick Install

```bash
git clone https://github.com/liagha/dots.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

## Modular Installation

Install specific components only:

```bash
make nvim    # Neovim only
make i3      # i3 only
make zsh     # Zsh only
```

## Manual Installation

Each module can be symlinked individually:

```bash
# Neovim
ln -sf ~/.dotfiles/nvim ~/.config/nvim

# i3
ln -sf ~/.dotfiles/i3 ~/.config/i3

# Zsh
ln -sf ~/.dotfiles/zshrc ~/.zshrc

# libinput
ln -sf ~/.dotfiles/libinput-gestures.conf ~/.config/libinput-gestures.conf
```

## Requirements

- **Neovim**: v0.9+ with `lazy.nvim` (auto-installed)
- **i3**: i3-gaps, rofi, feh, picom, polybar
- **Zsh**: zsh, fzf, zoxide, bat, eza
- **Gestures**: libinput-gestures

## Package Installation

Arch Linux:
```bash
sudo pacman -S git zsh neovim i3-wm rofi picom feh polybar alacritty tmux fzf ripgrep fd bat eza zoxide nodejs npm
```

Ubuntu/Debian:
```bash
sudo apt install git zsh neovim i3 rofi picom feh polybar alacritty tmux fzf ripgrep fd-find bat eza zoxide nodejs npm
```

## Backups

Existing configs are backed up to `~/.dotfiles_backup_YYYYMMDD_HHMMSS/` before symlinking.

## Uninstall

Remove symlinks (config backups preserved):
```bash
make clean
```

## License

MIT
```
