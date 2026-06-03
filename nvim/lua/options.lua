-- lua/options.lua

local opt = vim.opt

opt.number = true
opt.relativenumber = true

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true

opt.termguicolors = true
opt.mouse = "a"
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.updatetime = 250
opt.timeoutlen = 500

opt.splitright = true
opt.splitbelow = true

opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"

opt.swapfile = false
opt.backup = false

opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

opt.showmode = false
opt.showcmd = false
opt.ruler = false
