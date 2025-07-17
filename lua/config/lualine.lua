require('lualine').setup({
  options = {
    theme = 'onedark', -- equivalent to durant theme
    icons_enabled = true,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {
      {
        function()
          -- Get the relative path
          local path = vim.fn.expand('%:.')
          if path == '' then
            return '[No Name]'
          end
          -- Add modified indicator
          if vim.bo.modified then
            path = path .. ' ●'
          end
          -- Add readonly indicator
          if vim.bo.readonly then
            path = path .. ' '
          end
          return path
        end,
        color = {},
      },
      -- LSP integration
      {
        function()
          local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
          if #buf_clients == 0 then
            return ''
          end
          local buf_client_names = {}
          for _, client in pairs(buf_clients) do
            if client.name ~= 'null-ls' then
              table.insert(buf_client_names, client.name)
            end
          end
          return '[' .. table.concat(buf_client_names, ', ') .. ']'
        end,
        color = { fg = '#ffffff' },
      }
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' }
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {}
  },
  extensions = { 'fugitive', 'nvim-tree' }
}) 