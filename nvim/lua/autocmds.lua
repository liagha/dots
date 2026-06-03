-- lua/autocmds.lua

local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

local run_commands = {
    rust = {
        run = "cargo run",
        build = "cargo build",
        test = "cargo test",
        check = "cargo check",
    },
    c = {
        build = function()
            local file = vim.fn.expand("%")
            local out = vim.fn.expand("%:r")
            return string.format("gcc -Wall -Wextra -O2 %s -o %s", file, out)
        end,
        run = function()
            return "./" .. vim.fn.expand("%:r")
        end,
    },
    cpp = {
        build = function()
            local file = vim.fn.expand("%")
            local out = vim.fn.expand("%:r")
            return string.format("g++ -std=c++20 -Wall -Wextra -O2 %s -o %s", file, out)
        end,
        run = function()
            return "./" .. vim.fn.expand("%:r")
        end,
    },
    zig = {
        run = "zig build run",
        build = "zig build",
        test = "zig build test",
    },
    python = {
        run = "python3 %",
    },
    go = {
        run = "go run .",
        build = "go build .",
        test = "go test ./...",
    },
    javascript = {
        run = "node %",
    },
    typescript = {
        run = "npx ts-node %",
    },
    java = {
        run = "java %",
        build = "javac %",
    },
    lua = {
        run = "lua %",
    },
    sh = {
        run = "bash %",
    },
    c3 = {
        run = "c3c run %",
        build = "c3c build %",
    },
}

local function setup_terminal(buf, cmd)
    vim.cmd("wa")
    vim.cmd("botright split | terminal " .. cmd)
    local term_buf = vim.api.nvim_get_current_buf()
    vim.bo[term_buf].buflisted = false
    vim.keymap.set("t", "<Esc><Esc>", function()
        vim.api.nvim_win_close(0, true)
    end, { buffer = term_buf })
    vim.keymap.set("n", "q", function()
        vim.api.nvim_buf_delete(term_buf, { force = true })
    end, { buffer = term_buf })
    vim.keymap.set("t", "<C-w>", function()
        vim.api.nvim_win_close(0, true)
    end, { buffer = term_buf, noremap = true })
end

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
        local commands = run_commands[args.match]
        if not commands then return end

        local buf = args.buf
        local opts = { buffer = buf }

        for name, cmd in pairs(commands) do
            local final = type(cmd) == "function" and cmd() or cmd
            if final then
                vim.keymap.set("n", "<leader>" .. name:sub(1, 1), function()
                    setup_terminal(buf, final)
                end, { buffer = buf, desc = name:gsub("^%l", string.upper) })
            end
        end

        vim.keymap.set("n", "<leader>x", function()
            local file = vim.fn.expand("%")
            vim.ui.input({ prompt = "Command on " .. file .. ": " }, function(input)
                if input and #input > 0 then
                    setup_terminal(buf, input .. " " .. file)
                end
            end)
        end, { buffer = buf, desc = "Shell command on file" })
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
    end,
})

local pairs_map = {
    ["("] = { "(", ")" },
    [")"] = { "(", ")" },
    ["["] = { "[", "]" },
    ["]"] = { "[", "]" },
    ["{"] = { "{", "}" },
    ["}"] = { "{", "}" },
    ["'"] = { "'", "'" },
    ["`"] = { "`", "`" },
    ["<"] = { "<", ">" },
    [">"] = { "<", ">" },
}

for char, pair in pairs(pairs_map) do
    vim.keymap.set("x", char, string.format('c%s%s<Esc>P', pair[1], pair[2]),
        { desc = "Surround with " .. pair[1] .. pair[2] })
end

vim.api.nvim_create_autocmd("VimEnter", {
    group = group,
    callback = function()
        local dirs = {}
        for i = 1, vim.fn.argc() do
            local path = vim.fn.fnamemodify(vim.fn.argv(i - 1), ":p")
            if vim.fn.isdirectory(path) == 1 then
                table.insert(dirs, path)
            end
        end
        if #dirs == 0 then return end
        vim.schedule(function()
            for _, dir in ipairs(dirs) do
                require("oil").open(dir)
            end
            if vim.fn.argc() == #dirs then
                vim.cmd("only")
            end
        end)
    end,
})
