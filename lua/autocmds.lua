local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Tab leave tracking for last tab functionality
autocmd('TabLeave', {
  pattern = '*',
  callback = function()
    vim.g.lasttab = vim.fn.tabpagenr()
  end
})

-- File type specific settings
autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = '*.hbs',
  command = 'set syntax=mustache'
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.py',
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.js', '*.ts', '*.scss', '*.yaml', '*.yml', '*.vue' },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.rs',
  callback = function()
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt.syntax = 'rust'
  end
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.go',
  callback = function()
    vim.opt_local.expandtab = false
  end
})

-- Netrw configuration to show current path
autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    -- Show the banner with current directory
    vim.g.netrw_banner = 1
    -- Normal list style (not tree view)
    vim.g.netrw_liststyle = 0
    -- Open files in same window
    vim.g.netrw_browse_split = 0
    -- Set width of netrw to 25% of window
    vim.g.netrw_winsize = 25
  end
})

-- Custom commands
vim.api.nvim_create_user_command('Gblame', 'Git blame', {}) 