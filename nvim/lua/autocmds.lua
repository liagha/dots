-- lua/autocmds.lua

local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })

local ext_lang = {
    rs   = "rust",
    c    = "c",
    cpp  = "cpp",
    cc   = "cpp",
    cxx  = "cpp",
    py   = "python",
    go   = "go",
    js   = "javascript",
    ts   = "typescript",
    java = "java",
    lua  = "lua",
    sh   = "sh",
    zig  = "zig",
    c3   = "c3",
}

local run_commands = {
    rust = {
        run   = "cargo run",
        build = "cargo build",
        test  = "cargo test",
        check = "cargo check",
    },
    c = {
        build = "gcc -Wall -Wextra -O2 {file} -o {name}",
        run   = "./{name}",
    },
    cpp = {
        build = "g++ -std=c++20 -Wall -Wextra -O2 {file} -o {name}",
        run   = "./{name}",
    },
    zig = {
        run   = "zig build run",
        build = "zig build",
        test  = "zig build test",
    },
    python = {
        run = "python3 {file}",
    },
    go = {
        run   = "go run .",
        build = "go build .",
        test  = "go test ./...",
    },
    javascript = {
        run = "node {file}",
    },
    typescript = {
        run = "npx ts-node {file}",
    },
    java = {
        run   = "java {stem}",
        build = "javac {file}",
    },
    lua = {
        run = "lua {file}",
    },
    sh = {
        run = "bash {file}",
    },
    c3 = {
        run   = "c3c run {file}",
        build = "c3c build {file}",
    },
}

local slots = {
    r = "run",
    b = "build",
    t = "test",
    c = "check",
}

local function resolve(path)
    return {
        file = path,
        stem = vim.fn.fnamemodify(path, ":t"),
        name = vim.fn.fnamemodify(path, ":t:r"),
        ext  = vim.fn.fnamemodify(path, ":e"),
        dir  = vim.fn.fnamemodify(path, ":h"),
    }
end

local function substitute(template, vars)
    return (template:gsub("{(%w+)}", function(key)
        return vars[key] or ("{" .. key .. "}")
    end))
end

local function setup_terminal(cmd)
    vim.cmd("wa")
    vim.cmd("botright split | terminal " .. cmd)
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].buflisted = false
    vim.keymap.set("t", "<Esc><Esc>", function()
        vim.api.nvim_win_close(0, true)
    end, { buffer = buf })
    vim.keymap.set("n", "q", function()
        vim.api.nvim_buf_delete(buf, { force = true })
    end, { buffer = buf })
    vim.keymap.set("t", "<C-w>", function()
        vim.api.nvim_win_close(0, true)
    end, { buffer = buf, noremap = true })
end

local function prompt_run(template, vars)
    local default = template and substitute(template, vars) or ""
    vim.ui.input({ prompt = "$ ", default = default }, function(input)
        if not input or #input == 0 then return end
        setup_terminal(substitute(input, vars))
    end)
end

local function oil_vars()
    local oil   = require("oil")
    local entry = oil.get_cursor_entry()
    if not entry or entry.type ~= "file" then return nil end
    local path = oil.get_current_dir() .. entry.name
    return resolve(path)
end

local function oil_keymaps(buf)
    for key, action in pairs(slots) do
        vim.keymap.set("n", "<leader>" .. key, function()
            local vars = oil_vars()
            if not vars then return end
            local lang     = ext_lang[vars.ext]
            local commands = lang and run_commands[lang]
            local template = commands and commands[action]
            prompt_run(template, vars)
        end, { buffer = buf })
    end

    vim.keymap.set("n", "<leader>x", function()
        local vars = oil_vars()
        if not vars then return end
        prompt_run(nil, vars)
    end, { buffer = buf })
end

vim.api.nvim_create_autocmd("FileType", {
    group   = group,
    pattern = "oil",
    callback = function(args)
        oil_keymaps(args.buf)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args)
        if args.match == "oil" then return end
        local commands = run_commands[args.match]
        if not commands then return end

        local buf  = args.buf
        local path = vim.fn.expand("%:p")
        local vars = resolve(path)

        for key, action in pairs(slots) do
            local template = commands[action]
            if template then
                vim.keymap.set("n", "<leader>" .. key, function()
                    prompt_run(template, vars)
                end, { buffer = buf })
            end
        end

        vim.keymap.set("n", "<leader>x", function()
            local v = resolve(vim.fn.expand("%:p"))
            prompt_run(nil, v)
        end, { buffer = buf })
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group    = group,
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
    vim.keymap.set("x", char, string.format("c%s%s<Esc>P", pair[1], pair[2]),
        { desc = "Surround with " .. pair[1] .. pair[2] })
end

vim.api.nvim_create_autocmd("VimEnter", {
    group    = group,
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
