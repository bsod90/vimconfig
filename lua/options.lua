-- Basic vim settings
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.laststatus = 2
vim.opt.synmaxcol = 0
vim.opt.autoread = true
vim.opt.syntax = 'on'
vim.opt.hidden = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wildignore = '*.swp,*.bak,*.pyc,*.class'
vim.opt.title = true
vim.opt.wildmenu = true
vim.opt.wildmode = 'list:longest,full'
-- Folding now handled by nvim-ufo plugin
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldenable = false
vim.opt.spelllang = 'en_us'
vim.opt.termguicolors = true
vim.opt.conceallevel = 1
vim.opt.encoding = 'utf-8'
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.signcolumn = 'yes'
-- vim.opt.winborder = 'rounded'

-- Plugin variables
vim.g.mustache_abbreviations = 1
vim.g.typescript_indent_disable = 1
vim.g.lasttab = 1
vim.g.vimspector_enable_mappings = 'HUMAN'

-- Copilot configuration
vim.g.copilot_no_tab_map = true

-- Netrw configuration
vim.g.netrw_banner = 1          -- Show banner with current directory
vim.g.netrw_liststyle = 0       -- Normal view (not tree)
vim.g.netrw_altv = 1            -- Open splits to the right
vim.g.netrw_winsize = 25        -- Set width to 25%
vim.g.netrw_keepdir = 0         -- Keep current directory and browsing directory synced

-- Theme configuration
vim.g.onedark_config = {
  style = 'cool',
}
vim.cmd('colorscheme onedark') 