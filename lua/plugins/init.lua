return {
    -- Debugger
    'puremourning/vimspector',

    -- LSP and completion
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Automatically install LSPs to stdpath for neovim
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',

            -- Useful status updates for LSP
            { 'j-hui/fidget.nvim',       opts = {} },

            -- Additional lua configuration, makes nvim stuff amazing!
            'folke/neodev.nvim',
        },
        config = function()
            require('config.lsp')
        end,
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its associated nvim-cmp source
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',

            -- Adds a number of user-friendly snippets
            'rafamadriz/friendly-snippets',
        },
        config = function()
            require('config.completion')
        end,
    },

    -- Formatting
    {
        'stevearc/conform.nvim',
        opts = {},
        config = function()
            require('config.formatting')
        end,
    },

    -- Theme
    'navarasu/onedark.nvim',

    -- Status line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('config.lualine')
        end,
    },

    -- File explorer
    'tpope/vim-vinegar',

    -- Modern file explorer
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- Declare a global function to retrieve the current directory
            function _G.get_oil_winbar()
                local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
                local dir = require("oil").get_current_dir(bufnr)
                if dir then
                    return vim.fn.fnamemodify(dir, ":~")
                else
                    -- If there is no current directory (e.g. over ssh), just show the buffer name
                    return vim.api.nvim_buf_get_name(0)
                end
            end

            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
                columns = {
                    "icon",
                    "size",
                    "mtime",
                },
                win_options = {
                    signcolumn = "no",
                    cursorcolumn = false,
                    foldcolumn = "0",
                    spell = false,
                    list = true,
                    conceallevel = 3,
                    concealcursor = "nvic",
                    winbar = "%!v:lua.get_oil_winbar()",
                },
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-v>"] = "actions.select_vsplit",
                    ["<C-x>"] = "actions.select_split",
                    ["<C-t>"] = "actions.select_tab",
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = "actions.close",
                    ["<C-l>"] = "actions.refresh",
                    ["-"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["`"] = "actions.cd",
                    ["~"] = "actions.tcd",
                    ["g."] = "actions.toggle_hidden",
                },
                watch_for_changes = true,
                use_default_keymaps = true,
                prompt_save_on_select_new_entry = true,
                delete_to_trash = true,
            })
            vim.keymap.set("n", "<leader>-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
            
            -- Create autocmd to show quick help in statusline
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "oil",
                callback = function()
                    vim.wo.statusline = "%#Comment# [<CR>]Open [<C-v>]VSplit [<C-x>]Split [-]Up [g?]Help [<C-c>]Close %*"
                end,
            })
        end,
    },

    -- Git integration
    {
        'lewis6991/gitsigns.nvim',
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require('config.gitsigns')
        end,
    },
    'tpope/vim-fugitive',

    -- Editing utilities
    -- 'tpope/vim-commentary', -- Removed: Using native gc in Neovim 0.10+
    {
        'kylechui/nvim-surround',
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                keymaps = {
                    insert = "<C-g>s",
                    insert_line = "<C-g>S",
                    normal = "ys",
                    normal_cur = "yss",
                    normal_line = "yS",
                    normal_cur_line = "ySS",
                    visual = "S",
                    visual_line = "gS",
                    delete = "ds",
                    change = "cs",
                    change_line = "cS",
                },
            })
        end,
    },

    -- Language support
    'mustache/vim-mustache-handlebars',
    'leafgarland/typescript-vim',

    -- Navigation
    'christoomey/vim-tmux-navigator',

    -- Tmux integration
    'edkolev/tmuxline.vim',

    -- Node.js support
    'moll/vim-node',

    {
        "zbirenbaum/copilot.lua",
        lazy = false,
        priority = 1000,
        build = ":Copilot auth",
        opts = {
            panel = { enabled = false },
            suggestion = {
                enabled = true, -- Enable virtual text suggestions
                auto_trigger = true,
                hide_during_completion = true,
                debounce = 75,
                keymap = {
                    accept = "<c-j>", -- Keep your preferred keybinding
                    accept_word = false,
                    accept_line = false,
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<C-]>",
                },
            },
            filetypes = {
                yaml = false,
                markdown = false,
                help = false,
                gitcommit = false,
                gitrebase = false,
                hgcommit = false,
                svn = false,
                cvs = false,
                ["."] = false,
            },
            telemetry = {
                telemetryLevel = "off", -- Keep telemetry disabled
            },
            copilot_node_command = 'node',
            server_opts_overrides = {},
        },
    },

    -- Claude Code integration
    {
        "greggh/claude-code.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require('config.claude-code')
        end,
    },

    -- Python utilities
    'fisadev/vim-isort',

    -- Base64 encoding
    'christianrondeau/vim-base64',

    -- Telescope and dependencies
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        cmd = 'Telescope',
        keys = {
            { '<C-p>',      '<cmd>Telescope find_files<cr>' },
            { '<C-b>',      '<cmd>Telescope buffers<cr>' },
            { '<leader>ff', '<cmd>Telescope live_grep<cr>' },
            { '<leader>fg', '<cmd>Telescope git_files<cr>' },
            { '<leader>fh', '<cmd>Telescope help_tags<cr>' },
        },
        config = function()
            require('config.telescope')
        end,
    },

    -- Telescope UI Select
    'nvim-telescope/telescope-ui-select.nvim',

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('config.treesitter')
        end,
    },

    -- Icons
    'nvim-tree/nvim-web-devicons',

    -- Mini.icons (modern icon provider)
    {
        'echasnovski/mini.icons',
        version = false,
        config = function()
            require('mini.icons').setup()
        end,
    },

    -- Note taking
    {
        'epwalsh/obsidian.nvim',
        ft = "markdown",
        config = function()
            require('config.obsidian')
        end,
    },


    -- Better diagnostics UI
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        cmd = { "Trouble", "TroubleToggle" },
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer Diagnostics (Trouble)" },
            { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols (Trouble)" },
            { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
            { "<leader>xL", "<cmd>Trouble loclist toggle<cr>",                            desc = "Location List (Trouble)" },
            { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix List (Trouble)" },
        },
        opts = {},
    },

    -- Automatic indent detection
    {
        "NMAC427/guess-indent.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("guess-indent").setup()
        end,
    },

    -- Better folding
    {
        'kevinhwang91/nvim-ufo',
        dependencies = 'kevinhwang91/promise-async',
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require('ufo').setup({
                provider_selector = function(bufnr, filetype, buftype)
                    return { 'treesitter', 'indent' }
                end,
            })
            vim.o.foldcolumn = '0'
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            -- Keymaps for folding
            vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
        end,
    },
}
