vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("options")
require("keymaps")
require("autocmds")
require("colors")
require("statusline")
require("plugins")
require("lsp")
