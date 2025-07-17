require("nvim-treesitter.configs").setup({
  ensure_installed = { 
    "markdown", "rust", "markdown_inline", "python", 
    "javascript", "typescript", "vim", "lua", "terraform", "go" 
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}) 