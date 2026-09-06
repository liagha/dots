local cargo_bin = vim.fn.expand("~/.cargo/bin")
if vim.fn.isdirectory(cargo_bin) == 1 then
    vim.env.PATH = cargo_bin .. ":" .. vim.env.PATH
end

local erg_root = vim.fn.expand("~/.erg")
if vim.fn.isdirectory(erg_root) == 1 then
    vim.env.ERG_PATH = erg_root
end

vim.diagnostic.config({
    virtual_text = {
        prefix  = "",
        spacing = 4,
    },
    signs            = true,
    underline        = true,
    update_in_insert = false,
    severity_sort    = true,
    float = {
        border = "single",
        source = "always",
    },
})

local signs = { Error = "E", Warn = "W", Hint = "H", Info = "I" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local lsp_attach = function(_, bufnr)
    local opts = { buffer = bufnr }
    vim.keymap.set("n", "gd",         vim.lsp.buf.definition,    opts)
    vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,   opts)
    vim.keymap.set("n", "gi",         vim.lsp.buf.implementation,opts)
    vim.keymap.set("n", "gr",         vim.lsp.buf.references,    opts)
    vim.keymap.set("n", "K",          vim.lsp.buf.hover,         opts)
    vim.keymap.set("n", "<C-k>",      vim.lsp.buf.signature_help,opts)
    vim.keymap.set("n", "gl",         vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,  opts)
    vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,  opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,        opts)
    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
    end, opts)
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local function setup(name, config)
    local cmd        = config.cmd or { name }
    local executable = type(cmd) == "table" and cmd[1] or cmd
    if vim.fn.executable(executable) ~= 1 then return end
    pcall(function()
        vim.lsp.config(name, vim.tbl_extend("keep", config, {
            on_attach    = lsp_attach,
            capabilities = capabilities,
        }))
        vim.lsp.enable(name)
    end)
end

setup("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders=true",
        "--log=error",
    },
    filetypes    = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
    init_options = { fallbackFlags = { "-std=c17" } },
})

setup("rust_analyzer", {
    cmd       = { "rust-analyzer" },
    filetypes = { "rust" },
    settings  = {
        ["rust-analyzer"] = {
            cargo       = { allFeatures = true },
            checkOnSave = false,
            diagnostics = { enable = true },
        },
    },
    root_markers = { "Cargo.toml" },
})

setup("pylyzer", {
    cmd       = { "pylyzer", "--server" },
    filetypes = { "python" },
    settings  = {
        python = {
            diagnostics     = true,
            inlayHints      = true,
            smartCompletion = true,
            checkOnType     = false,
        },
    },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git", "Pipfile" },
})

setup("ruff", {
    cmd          = { "ruff", "server" },
    filetypes    = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    init_options = {
        settings = {
            configurationPreference = "filesystemFirst",
            lint    = { enable = true },
            format  = { enable = true },
        },
    },
})

setup("lua_ls", {
    cmd       = { "lua-language-server" },
    filetypes = { "lua" },
    settings  = {
        Lua = {
            runtime     = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } },
            workspace   = {
                library        = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = { enable = false },
        },
    },
})

setup("serve_d", {
    cmd       = { "serve-d" },
    filetypes = { "d" },
    root_markers = { "dub.json", "dub.sdl", ".git" },
})

setup("marksman", {
    cmd       = { "marksman", "server" },
    filetypes = { "markdown" },
    root_markers = { ".marksman.toml", ".git" },
})

setup("ols", {
    cmd       = { "ols" },
    filetypes = { "odin" },
    root_markers = { ".git" },
})

setup("c3lsp", {
    cmd       = { "c3lsp" },
    filetypes = { "c3" },
    root_markers = { ".git" },
})