.PHONY: help install nvim i3 zsh clean

help:
	@echo "Available commands:"
	@echo "  make install  - Full dotfiles installation"
	@echo "  make nvim     - Install Neovim config only"
	@echo "  make i3       - Install i3 config only"
	@echo "  make zsh      - Install zshrc only"
	@echo "  make clean    - Remove symlinks (keep backups)"

install:
	@./install.sh

nvim:
	@./modules/nvim.sh

i3:
	@./modules/i3.sh

zsh:
	@./modules/zsh.sh

clean:
	@find ~/.config -maxdepth 1 -type l -name "nvim" -delete 2>/dev/null || true
	@find ~/.config -maxdepth 1 -type l -name "i3" -delete 2>/dev/null || true
	@rm -f ~/.zshrc 2>/dev/null || true
	@echo "Symlinks removed. Backups preserved in ~/*.backup.*"
