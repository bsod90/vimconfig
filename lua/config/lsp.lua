-- Set up neodev for better lua_ls integration
require('neodev').setup()

-- Function to create a custom hover handler with borders
local function custom_hover_handler(_, result, ctx, config)
    config = config or {}
    config.border = config.border or "rounded"
    config.title = config.title or "Hover"
    config.focusable = true -- Make focusable so it can receive key events
    config.close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre" }

    -- Call the original handler
    local bufnr, winnr = vim.lsp.handlers.hover(_, result, ctx, config)

    -- Add ESC keymap to close the window if it was created
    if winnr and vim.api.nvim_win_is_valid(winnr) then
        vim.keymap.set('n', '<Esc>', function()
            if vim.api.nvim_win_is_valid(winnr) then
                vim.api.nvim_win_close(winnr, true)
            end
        end, { buffer = bufnr, nowait = true, silent = true })
    end

    return bufnr, winnr
end

-- Function to create a custom signature help handler with borders
local function custom_signature_help_handler(_, result, ctx, config)
    config = config or {}
    config.border = config.border or "rounded"
    config.title = config.title or "Signature Help"
    config.focusable = true -- Make focusable so it can receive key events
    config.close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertCharPre" }

    -- Call the original handler
    local bufnr, winnr = vim.lsp.handlers.signature_help(_, result, ctx, config)

    -- Add ESC keymap to close the window if it was created
    if winnr and vim.api.nvim_win_is_valid(winnr) then
        vim.keymap.set('n', '<Esc>', function()
            if vim.api.nvim_win_is_valid(winnr) then
                vim.api.nvim_win_close(winnr, true)
            end
        end, { buffer = bufnr, nowait = true, silent = true })
    end

    return bufnr, winnr
end

-- Set up Mason and automatically install LSP servers
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        'ts_ls',         -- TypeScript/JavaScript (updated from tsserver)
        'jsonls',        -- JSON
        'html',          -- HTML
        'pyright',       -- Python
        'ruff',          -- Python linting (updated from ruff_lsp)
        'eslint',        -- JavaScript/TypeScript linting
        'rust_analyzer', -- Rust
        'gopls',         -- Go
        'lua_ls',        -- Lua
    },
    automatic_enable = true,
    automatic_installation = true,
})

local keymap = vim.keymap.set
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- LSP settings helper function
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Buffer local mappings
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- Navigation
    keymap('n', 'gd', vim.lsp.buf.definition, bufopts)
    keymap('n', 'gD', vim.lsp.buf.declaration, bufopts)
    keymap('n', 'gi', vim.lsp.buf.implementation, bufopts)
    keymap('n', 'gy', vim.lsp.buf.type_definition, bufopts)
    keymap('n', 'gr', vim.lsp.buf.references, bufopts)

    -- Documentation with custom borders (Neovim 0.11 compatible)
    keymap('n', 'K', function()
        local params = vim.lsp.util.make_position_params()
        vim.lsp.buf_request(0, 'textDocument/hover', params, custom_hover_handler)
    end, bufopts)

    keymap('n', '<C-k>', function()
        local params = vim.lsp.util.make_position_params()
        vim.lsp.buf_request(0, 'textDocument/signatureHelp', params, custom_signature_help_handler)
    end, bufopts)

    -- Code actions
    keymap('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    keymap('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    keymap('x', '<leader>ca', vim.lsp.buf.code_action, bufopts)

    -- Formatting
    keymap('n', '<leader>fo', function() vim.lsp.buf.format { async = true } end, bufopts)
    keymap('x', '<leader>fo', function() vim.lsp.buf.format { async = true } end, bufopts)

    -- Diagnostics
    keymap('n', '[g', vim.diagnostic.goto_prev, bufopts)
    keymap('n', ']g', vim.diagnostic.goto_next, bufopts)
    keymap('n', '<leader>e', vim.diagnostic.open_float, bufopts)
    keymap('n', '<leader>q', vim.diagnostic.setloclist, bufopts)

    -- Workspace management
    keymap('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    keymap('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    keymap('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)

    -- Document highlight
    if client.server_capabilities.documentHighlightProvider then
        local highlight_group = augroup('LspDocumentHighlight', { clear = false })
        autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            group = highlight_group,
            callback = function()
                -- Check if any client attached to this buffer supports document highlights
                local clients = vim.lsp.get_clients({ bufnr = bufnr })
                for _, c in pairs(clients) do
                    if c.server_capabilities.documentHighlightProvider then
                        vim.lsp.buf.document_highlight()
                        return
                    end
                end
            end,
        })
        autocmd('CursorMoved', {
            buffer = bufnr,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
        })
    end
    
    -- Enable inlay hints if supported
    if client.supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
end

-- Add cmp_nvim_lsp capabilities settings to lspconfig
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Configure individual LSP servers
local lspconfig = require('lspconfig')

-- TypeScript with better duplicate prevention
lspconfig.ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    single_file_support = false,  -- Prevent starting in single files without a project
    root_dir = require('lspconfig.util').root_pattern('tsconfig.json', 'jsconfig.json', 'package.json'),
    -- Prevent multiple instances
    on_init = function(client)
        client.config.flags = client.config.flags or {}
        client.config.flags.allow_incremental_sync = true
    end,
})

-- JSON
lspconfig.jsonls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- HTML
lspconfig.html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Python
lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

lspconfig.ruff.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- ESLint
lspconfig.eslint.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    -- Only attach to projects that have ESLint configured
    root_dir = function(fname)
        local root_pattern = require('lspconfig.util').root_pattern

        -- Look for ESLint config files first
        local eslint_config_root = root_pattern(
            '.eslintrc',
            '.eslintrc.js',
            '.eslintrc.cjs',
            '.eslintrc.yaml',
            '.eslintrc.yml',
            '.eslintrc.json',
            'eslint.config.js'
        )(fname)

        if eslint_config_root then
            return eslint_config_root
        end

        -- If no ESLint config found, check if package.json has eslint dependency
        local package_json_root = root_pattern('package.json')(fname)
        if package_json_root then
            local package_json_path = package_json_root .. '/package.json'
            local ok, package_data = pcall(vim.fn.readfile, package_json_path)
            if ok and package_data then
                local package_content = table.concat(package_data, '\n')
                -- Check if eslint is in dependencies or devDependencies
                if package_content:match('"eslint"') then
                    return package_json_root
                end
            end
        end

        -- Don't attach if no ESLint setup found
        return nil
    end,
    settings = {
        validate = 'on',
        packageManager = 'npm',
        useESLintClass = false,
        experimental = {
            useFlatConfig = false
        },
        workingDirectories = { mode = 'auto' }
    }
})

-- Rust
lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Go
lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Lua
lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
        },
    },
})

-- Diagnostic configuration
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
            [vim.diagnostic.severity.INFO] = " ",
        }
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = 'rounded',
        source = 'always',
        focusable = false,
    },
})

-- Auto-show diagnostics on hover
local function has_floating_window()
    for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.api.nvim_win_get_config(winid).relative ~= '' then
            return true
        end
    end
    return false
end

local function show_diagnostics_on_hover()
    -- Don't show if there's already a floating window
    if has_floating_window() then
        return
    end

    -- Get diagnostics for current line
    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(0, { lnum = line })

    -- Only show if there are diagnostics on this line
    if #diagnostics > 0 then
        vim.diagnostic.open_float({
            scope = 'line',
            focusable = false,
            close_events = { 'CursorMoved', 'CursorMovedI', 'BufHidden', 'InsertCharPre' }
        })
    end
end

-- Set up autocmd for automatic diagnostic hover
local diagnostic_hover_group = augroup('DiagnosticHover', { clear = true })
autocmd({ 'CursorHold' }, {
    group = diagnostic_hover_group,
    callback = show_diagnostics_on_hover,
    desc = 'Show diagnostics on hover when no other float is present'
})

-- Commands
-- vim.api.nvim_create_user_command('Format', function() vim.lsp.buf.format({ async = true }) end, {})
vim.api.nvim_create_user_command('OR', function()
    vim.lsp.buf.code_action({
        context = { only = { 'source.organizeImports' }, diagnostics = {} },
        apply = true,
    })
end, {})

-- Debug command to check active LSP clients
vim.api.nvim_create_user_command('LspInfo', function()
    local clients = vim.lsp.get_clients()
    local current_buf = vim.api.nvim_get_current_buf()
    local buf_clients = vim.lsp.get_clients({ bufnr = current_buf })
    
    print(string.format("Total active LSP clients: %d", #clients))
    print(string.format("Clients attached to current buffer: %d", #buf_clients))
    print("---")
    
    for _, client in pairs(buf_clients) do
        print(string.format("  %s (id: %d, root: %s)", 
            client.name, 
            client.id, 
            client.config.root_dir or "none"))
    end
end, { desc = "Show LSP client information" })

-- More robust duplicate LSP prevention
local attached_buffers = {}

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local bufnr = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        
        -- Track attached LSPs per buffer
        if not attached_buffers[bufnr] then
            attached_buffers[bufnr] = {}
        end
        
        -- Check if this LSP type is already attached to this buffer
        local lsp_type = client.name
        local root_dir = client.config.root_dir or vim.fn.getcwd()
        
        -- For TypeScript/JavaScript files, be extra careful
        if lsp_type == "ts_ls" or lsp_type == "eslint" then
            -- Check all active clients for this buffer
            local active_clients = vim.lsp.get_clients({ bufnr = bufnr })
            
            for _, existing_client in pairs(active_clients) do
                if existing_client.name == lsp_type and existing_client.id ~= client.id then
                    -- If we already have this LSP type attached, stop the new one
                    vim.notify(string.format("Preventing duplicate %s attachment to buffer %d", lsp_type, bufnr), vim.log.levels.DEBUG)
                    vim.schedule(function()
                        client.stop()
                    end)
                    return
                end
            end
        end
        
        -- Store this client info
        attached_buffers[bufnr][lsp_type] = {
            client_id = client.id,
            root_dir = root_dir
        }
    end,
})

-- Clean up tracking when buffer is deleted
vim.api.nvim_create_autocmd("BufDelete", {
    callback = function(args)
        attached_buffers[args.buf] = nil
    end,
})

-- Also prevent multiple LSP clients from starting for the same root directory
vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
        local bufnr = args.buf
        local filetype = vim.bo[bufnr].filetype
        
        -- Only check TypeScript/JavaScript files
        if filetype == "typescript" or filetype == "typescriptreact" or 
           filetype == "javascript" or filetype == "javascriptreact" then
            
            vim.schedule(function()
                local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "ts_ls" })
                
                -- If we have more than one ts_ls client, keep only the first one
                if #clients > 1 then
                    vim.notify(string.format("Found %d ts_ls clients for buffer %d, keeping only one", #clients, bufnr), vim.log.levels.DEBUG)
                    for i = 2, #clients do
                        clients[i].stop()
                    end
                end
            end)
        end
    end,
})
