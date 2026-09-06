-- lua/keymaps.lua

local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })

map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

map("n", "gf", "<cmd>e <cfile><CR>", { desc = "Go to file under cursor" })
map("n", "gF", "<cmd>tab e <cfile><CR>", { desc = "Go to file in new tab" })
map("n", "<C-o>", "<C-o>", { desc = "Jump back" })
map("n", "<C-i>", "<C-i>", { desc = "Jump forward" })

map("n", "<leader>so", function()
    vim.cmd("so")
    vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Source config" })

map("n", "<leader>st", function()
    vim.cmd("belowright split | terminal")
end, { desc = "Open terminal" })

map("n", "<leader>j", "<cmd>cnext<CR>", { desc = "Next quickfix" })
map("n", "<leader>k", "<cmd>cprev<CR>", { desc = "Prev quickfix" })

map({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<leader>Y", '"+Y', { desc = "Copy line to system clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map("n", "<leader>P", '"+P', { desc = "Paste before from system clipboard" })

map("n", "<leader>od", function()
    vim.ui.input({ prompt = "Open directory: ", default = vim.fn.getcwd(), completion = "dir" }, function(input)
        if input and #input > 0 then
            vim.cmd("edit " .. vim.fn.fnameescape(input))
        end
    end)
end, { desc = "Open directory" })

map("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })