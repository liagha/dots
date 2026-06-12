local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.lsp.config.hover = { border = "single" }
vim.lsp.config.signature_help = { border = "single" }
vim.diagnostic.config({ float = { border = "single" } })

local telescope_keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>",  desc = "Live grep" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>",    desc = "Buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>",  desc = "Help tags" },
}

require("lazy").setup({
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = telescope_keys,
        config = function()
            require("telescope").setup({
                defaults = {
                    preview = { treesitter = false },
                },
            })
            for _, key in ipairs(telescope_keys) do
                vim.keymap.set("n", key[1], key[2], { desc = key.desc })
            end
        end,
    },

    {
        "stevearc/oil.nvim",
        keys = {
            { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
        },
        config = function()
            require("oil").setup({
                default_file_explorer = false,
                delete_to_trash = true,
                skip_confirm_for_simple_edits = true,
                view_options = { show_hidden = true },
                columns = { "icon", "permissions", "size", "mtime" },
                float = { padding = 2 },
                keymaps = {
                    ["q"]    = "actions.close",
                    ["<CR>"] = "actions.select",
                    ["-"]    = "actions.parent",
                    ["_"]    = "actions.open_cwd",
                },
            })
        end,
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("which-key").setup({
                icons = { rules = false },
                spec = {
                    { "<leader>f", group = "find" },
                    { "<leader>g", group = "git" },
                    { "<leader>h", group = "harpoon" },
                    { "<leader>o", group = "open" },
                    { "<leader>s", group = "swap/source/terminal" },
                    { "<leader>d", group = "debug" },
                    { "<leader>y", group = "yank" },
                    { "<leader>p", group = "paste" },
                },
            })
        end,
    },

    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
        },
        keys = {
            { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file tree" },
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                window = {
                    mappings = { ["<leader>e"] = "close_window" },
                },
                filesystem = {
                    filtered_items = {
                        visible = true,
                        hide_dotfiles = false,
                    },
                },
                default_component_configs = {
                    indent = {
                        with_markers = false,
                        with_expanders = false,
                    },
                    icon = {
                        folder_closed = "",
                        folder_open = "",
                        folder_empty = "",
                        folder_empty_open = "",
                        default = "",
                    },
                    git_status = {
                        symbols = {
                            added     = "+",
                            modified  = "~",
                            deleted   = "-",
                            renamed   = ">",
                            untracked = "?",
                            ignored   = "",
                            unstaged  = "",
                            staged    = "",
                            conflict  = "!",
                        },
                    },
                },
            })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = "BufReadPre",
        keys = {
            { "]h",         desc = "Next hunk" },
            { "[h",         desc = "Prev hunk" },
            { "<leader>hs", desc = "Stage hunk" },
            { "<leader>hu", desc = "Undo stage hunk" },
            { "<leader>hp", desc = "Preview hunk" },
            { "<leader>hb", desc = "Blame line" },
        },
        config = function()
            local gs = require("gitsigns")
            gs.setup()
            vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Next hunk" })
            vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })
            vim.keymap.set({ "n", "v" }, "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
            vim.keymap.set({ "n", "v" }, "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
            vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
            vim.keymap.set("n", "<leader>hb", gs.blame_line, { desc = "Blame line" })
        end,
    },

    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp     = require("cmp")
            local luasnip = require("luasnip")

            local words_before = function()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            local kind_labels = {
                Text          = "txt",  Method      = "mtd",  Function      = "fn",
                Constructor   = "ctor", Field       = "fld",  Variable      = "var",
                Class         = "cls",  Interface   = "ifc",  Module        = "mod",
                Property      = "prp",  Unit        = "unt",  Value         = "val",
                Enum          = "enum", Keyword     = "kw",   Snippet       = "snp",
                Color         = "clr",  File        = "fil",  Reference     = "ref",
                Folder        = "fld",  EnumMember  = "enm",  Constant      = "cst",
                Struct        = "stc",  Event       = "evt",  Operator      = "opr",
                TypeParameter = "tpr",
            }

            cmp.setup({
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                window = {
                    completion = cmp.config.window.bordered({
                        border = "single",
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset = -1,
                        side_padding = 0,
                    }),
                    documentation = cmp.config.window.bordered({
                        border = "single",
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        max_width = 60,
                        max_height = 15,
                        col_offset = -1,
                        side_padding = 0,
                    }),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"]     = cmp.mapping.abort(),
                    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                    { name = "path" },
                }),
                formatting = {
                    fields = { "kind", "abbr", "menu" },
                    format = function(entry, item)
                        item.kind = kind_labels[item.kind] or ""
                        item.menu = entry.source.name
                        return item
                    end,
                },
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({ { name = "cmdline" } }),
            })
        end,
    },

    {
        "mfussenegger/nvim-dap",
        keys = {
            { "<leader>db", desc = "Toggle breakpoint" },
            { "<leader>dc", desc = "Continue" },
        },
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        config = function()
            local dap    = require("dap")
            local dapui  = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
            dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
            dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
        end,
    },

    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua        = { "stylua" },
                    rust       = { "rustfmt" },
                    python     = { "black" },
                    javascript = { "prettier" },
                    typescript = { "prettier" },
                    markdown   = { "prettier" },
                    odin       = { "odinfmt" },
                    c3         = { "c3fmt" },
                },
                format_on_save = {
                    lsp_fallback = true,
                    async        = false,
                    timeout_ms   = 1000,
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("nvim-treesitter").setup({
                ensure_install = {
                    "c", "cpp", "rust", "python", "go",
                    "javascript", "typescript",
                    "zig", "java", "bash", "odin", "c3",
                    "d", "markdown", "markdown_inline",
                },
            })

            vim.treesitter.language.register("markdown", "markdown")

            vim.api.nvim_create_autocmd("FileType", {
                pattern  = "lua",
                callback = function(args)
                    pcall(vim.treesitter.stop, args.buf)
                end,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        lazy = false,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            local select = require("nvim-treesitter-textobjects.select")
            local move   = require("nvim-treesitter-textobjects.move")
            local swap   = require("nvim-treesitter-textobjects.swap")

            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
                move   = { set_jumps = true },
            })

            local objects = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
                ["aa"] = "@parameter.outer",
                ["ia"] = "@parameter.inner",
                ["ab"] = "@block.outer",
                ["ib"] = "@block.inner",
                ["al"] = "@loop.outer",
                ["il"] = "@loop.inner",
                ["ai"] = "@conditional.outer",
                ["ii"] = "@conditional.inner",
            }

            for key, query in pairs(objects) do
                vim.keymap.set({ "x", "o" }, key, function()
                    select.select_textobject(query, "textobjects")
                end)
            end

            local next_start = {
                ["]f"] = "@function.outer",
                ["]c"] = "@class.outer",
                ["]a"] = "@parameter.inner",
            }
            local prev_start = {
                ["[f"] = "@function.outer",
                ["[c"] = "@class.outer",
                ["[a"] = "@parameter.inner",
            }

            for key, query in pairs(next_start) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    move.goto_next_start(query, "textobjects")
                end)
            end
            for key, query in pairs(prev_start) do
                vim.keymap.set({ "n", "x", "o" }, key, function()
                    move.goto_previous_start(query, "textobjects")
                end)
            end

            vim.keymap.set({ "n", "x" }, "<leader>sn", function()
                swap.swap_next("@parameter.inner", "textobjects")
            end)
            vim.keymap.set({ "n", "x" }, "<leader>sp", function()
                swap.swap_previous("@parameter.inner", "textobjects")
            end)
        end,
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ha", desc = "Harpoon add" },
            { "<leader>hh", desc = "Harpoon menu" },
            { "<leader>1",  desc = "Harpoon file 1" },
            { "<leader>2",  desc = "Harpoon file 2" },
            { "<leader>3",  desc = "Harpoon file 3" },
            { "<leader>4",  desc = "Harpoon file 4" },
        },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
            vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add" })
            vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
            vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
            vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
            vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
            vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
        end,
    },
})
