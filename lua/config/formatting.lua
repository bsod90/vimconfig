-- Helper function to check if prettier is configured in the project
local function has_prettier_config()
    local prettier_configs = {
        '.prettierrc',
        '.prettierrc.json',
        '.prettierrc.yml',
        '.prettierrc.yaml',
        '.prettierrc.js',
        '.prettierrc.cjs',
        '.prettierrc.mjs',
        'prettier.config.js',
        'prettier.config.cjs',
        'prettier.config.mjs',
    }

    -- Check for prettier config files
    for _, config in ipairs(prettier_configs) do
        if vim.fn.findfile(config, '.;') ~= '' then
            return true
        end
    end

    -- Check package.json for prettier config or dependency
    local package_json = vim.fn.findfile('package.json', '.;')
    if package_json ~= '' then
        local ok, package_data = pcall(vim.fn.readfile, package_json)
        if ok and package_data then
            local package_content = table.concat(package_data, '\n')
            -- Check if prettier is in dependencies, devDependencies, or has config
            if package_content:match('"prettier"') or package_content:match('"prettierrc"') then
                return true
            end
        end
    end

    return false
end

-- Smart formatter selection for JS/TS files
local function js_ts_formatters()
    if has_prettier_config() then
        -- Project has prettier configured, use both eslint and prettier
        return { "eslint_d", "prettier" }
    else
        -- No prettier config, use only eslint to avoid conflicts
        return { "eslint_d" }
    end
end

require('conform').setup({
    formatters_by_ft = {
        javascript = js_ts_formatters,
        typescript = js_ts_formatters,
        typescriptreact = js_ts_formatters,
        javascriptreact = js_ts_formatters,
        json = function()
            -- Only use prettier for JSON if project has prettier configured
            return has_prettier_config() and { "prettier" } or {}
        end,
        html = { "prettier" },
        css = { "prettier" },
        python = { "ruff_format", "ruff_fix" },
        rust = { "rustfmt" },
        go = { "gofmt" },
        lua = { "stylua" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
    -- Configure formatters
    formatters = {
        eslint_d = {
            condition = function(ctx)
                -- Only use eslint_d if there's an eslint config
                return vim.fn.findfile('.eslintrc', '.;') ~= ''
                    or vim.fn.findfile('.eslintrc.js', '.;') ~= ''
                    or vim.fn.findfile('.eslintrc.json', '.;') ~= ''
                    or vim.fn.findfile('eslint.config.js', '.;') ~= ''
            end,
        },
        prettier = {
            condition = function(ctx)
                -- Only use prettier if project has prettier configured
                return has_prettier_config()
            end,
        },
    },
})

vim.api.nvim_create_user_command('Format', function() require("conform").format({ async = true, lsp_fallback = true }) end, {})

