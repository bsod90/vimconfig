local keymap = vim.keymap.set

-- General mappings
keymap('n', '<C-t>', ':tabnew<CR>')
keymap('n', '<C-p>', '<cmd>Telescope find_files<cr>')
keymap('n', '<C-b>', '<cmd>Telescope buffers<cr>')
keymap('n', '<leader>ff', '<cmd>Telescope live_grep<cr>')
keymap('n', '<leader>fg', '<cmd>Telescope git_files<cr>')
keymap('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')

-- Vimspector mappings
keymap('n', '<leader>vs', '<Plug>VimspectorContinue')
keymap('n', '<leader>vb', '<Plug>VimspectorToggleBreakpoint')
keymap('n', '<Leader>di', '<Plug>VimspectorBalloonEval')
keymap('x', '<Leader>di', '<Plug>VimspectorBalloonEval')

-- Obsidian mappings
keymap('n', '<leader>n', '<cmd>:ObsidianQuickSwitch<cr>')
keymap('n', '<leader>w', '<cmd>:ObsidianWorkspace<cr>')

-- Tab navigation
keymap('n', 'th', ':tabfirst<CR>')
keymap('n', 'tj', ':tabprev<CR>')
keymap('n', 'tk', ':tabnext<CR>')
keymap('n', 'tl', ':tablast<CR>')
keymap('n', 'tn', ':tabnext<Space>')

-- Last tab functionality
keymap('n', 'tt', function()
    vim.cmd('tabn ' .. vim.g.lasttab)
end)

-- Utility mappings
keymap('n', 'ap', function() vim.lsp.buf.format({ async = true }) end)
keymap('n', '<Leader>s', ':%s/\\<<C-r><C-w>\\>//g<Left><Left>')
keymap('n', 'cc', function() vim.fn.setreg('/', '') end)
keymap('n', 'gp', '`[' .. vim.fn.strpart(vim.fn.getregtype(), 0, 1) .. '`]', { expr = true })
keymap('n', '<Leader>d', vim.lsp.buf.definition)
keymap('n', '<Leader>b', '<cmd>Telescope buffers<cr>')
keymap('c', 'w!!', 'w !sudo tee % >/dev/null')

-- File save shortcuts
keymap('n', 'WW', ':wall<CR>')
keymap('n', 'WQ', ':wqall!<CR>')
keymap('n', 'QQ', ':qall!<CR>')

-- Copy to system clipboard
keymap('v', 'Y', '"+y<Esc>', { silent = true })

-- Claude Code Chat
keymap('n', 'FF', ':ClaudeCode<CR>')

-- Telescope LSP mappings
keymap('n', '<space><space>', '<cmd>Telescope commands<CR>', { silent = true })
keymap('n', '<space>a', '<cmd>Telescope diagnostics<CR>', { silent = true })
keymap('n', '<space>b', '<cmd>Telescope diagnostics bufnr=0<CR>', { silent = true })
keymap('n', '<space>c', '<cmd>Telescope commands<CR>', { silent = true })
keymap('n', '<space>l', '<cmd>Telescope loclist<CR>', { silent = true })
keymap('n', '<space>o', '<cmd>Telescope lsp_document_symbols<CR>', { silent = true })
keymap('n', '<space>w', '<cmd>Telescope lsp_workspace_symbols<CR>', { silent = true })
keymap('n', '<space>r', '<cmd>Telescope lsp_references<CR>', { silent = true })
keymap('n', '<space>gs', '<cmd>Telescope git_status<CR>', { silent = true })

keymap('n', '<leader>f<space>', function()
    require('telescope.builtin').live_grep({ default_text = vim.fn.expand('<cword>') })
end)
