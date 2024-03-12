" Speci/afy a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')

Plug 'puremourning/vimspector'

Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'navarasu/onedark.nvim'

Plug 'vim-airline/vim-airline'

Plug 'vim-airline/vim-airline-themes'

Plug 'tpope/vim-vinegar'

Plug 'lewis6991/gitsigns.nvim'

Plug 'tpope/vim-commentary'

Plug 'tpope/vim-fugitive'

Plug 'mustache/vim-mustache-handlebars'

Plug 'christoomey/vim-tmux-navigator'

Plug 'edkolev/tmuxline.vim'

Plug 'rking/ag.vim'

Plug 'jason0x43/vim-js-indent'

Plug 'fatih/vim-go'

Plug 'moll/vim-node'

Plug 'rust-lang/rust.vim'

Plug 'tpope/vim-surround'

Plug 'vim-scripts/taglist.vim'

Plug 'github/copilot.vim'

Plug 'fisadev/vim-isort'

Plug 'https://github.com/leafgarland/typescript-vim.git'

Plug 'christianrondeau/vim-base64'

Plug 'nvim-lua/plenary.nvim'

Plug 'nvim-telescope/telescope.nvim'

Plug 'fannheyward/telescope-coc.nvim'

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'nvim-tree/nvim-web-devicons'

Plug 'epwalsh/obsidian.nvim'

" Initialize plugin system
call plug#end()

set updatetime=500
set nu
set mouse=a
" Airline setup
set laststatus=2
let g:airline_powerline_fonts = 1
" let g:airline_theme = "jellybeans"
let g:airline_theme = "durant"
set synmaxcol=0
set autoread
syntax on
set hidden
set incsearch
set hlsearch
set expandtab
set shiftwidth=4
set tabstop=4
set ignorecase
set smartcase
set wildignore=*.swp,*.bak,*.pyc,*.class
set title
set wildmenu
set wildmode=list:longest,full
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set nofoldenable
set spelllang=en_us
set termguicolors
set conceallevel=1
" May need for vim (not neovim) since coc.nvim calculate byte offset by count
" utf-8 byte sequence.
set encoding=utf-8
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup
" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300
" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes


let g:onedark_config = {
    \ 'style': 'cool',
\}
colorscheme onedark

nnoremap <F3> :TlistToggle<CR>
nnoremap <C-t> :tabnew<CR>
" nnoremap <C-p> :GFiles<CR>
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <C-b> <cmd>Telescope buffers<cr>
nnoremap <leader>ff <cmd>Telescope live_grep<cr>
nnoremap <leader>fg <cmd>Telescope git_files<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nnoremap <leader>n <cmd>:ObsidianQuickSwitch<cr>
nnoremap <leader>w <cmd>:ObsidianWorkspace<cr>

nnoremap th  :tabfirst<CR>
nnoremap tj  :tabprev<CR>
nnoremap tk  :tabnext<CR>
nnoremap tl  :tablast<CR>
nnoremap tn  :tabnext<Space>
" Switch to last active tab
let g:lasttab = 1
nmap tt :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

let g:autopep8_disable_show_diff=1
nnoremap ap :call CocAction('format')
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap cc :let @/ = ""<cr>
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
nnoremap <Leader>d <Plug>(coc-definition)
nnoremap <Leader>b <cmd>Telescope buffers<cr>
cmap w!! w !sudo tee % >/dev/null

let g:mustache_abbreviations = 1
autocmd BufNewFile,BufRead *.hbs set syntax=mustache

autocmd BufRead,BufNewFile   *.py setlocal tabstop=4
autocmd BufRead,BufNewFile   *.py setlocal shiftwidth=4
autocmd BufRead,BufNewFile   *.js,*.ts,*.scss,*.yaml,*.yml,*.vue setlocal shiftwidth=2
autocmd BufRead,BufNewFile   *.js,*.ts,*.scss,*.yaml,*.yml,*.vue setlocal tabstop=2
autocmd BufRead,BufNewFile   *.go setlocal noexpandtab

let g:typescript_indent_disable = 1

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-m> coc#refresh()

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

vnoremap <silent> Y "+y<Esc>

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>fo  <Plug>(coc-format-selected)
nmap <leader>fo  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json,python setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

hi CocInlayHint guifg=Gray ctermfg=Gray

command! Gblame Git blame

" Coc-telescope

lua << EOF
require("telescope").setup({
  extensions = {
    coc = {
        theme = 'ivy',
        prefer_locations = true, 
    }
  },
})
require('telescope').load_extension('coc')
EOF

nnoremap <silent> <space><space> <cmd>Telescope commands<CR>

nnoremap <silent> <space>a       <cmd>Telescope coc diagnostics<CR>
nnoremap <silent> <space>b       <cmd>Telescope coc diagnostics --current-buf<CR>
nnoremap <silent> <space>c       <cmd>Telescope coc commands<CR>
nnoremap <silent> <space>e       <cmd>Telescope coc extensions<CR>
nnoremap <silent> <space>l       <cmd>Telescope coc locations<CR>
nnoremap <silent> <space>o       <cmd>Telescope coc document_symbols<CR>
nnoremap <silent> <space>w       <cmd>Telescope coc workspace_symbols<CR>

nnoremap <expr> <leader>f<space> ':Telescope live_grep<cr>' . expand('<cword>')


" Copilot shortcut
nnoremap <Leader>cp :Copilot panel<CR>
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
let g:copilot_no_tab_map = v:true

" Obsidian

lua << EOF
require("obsidian").setup({
  workspaces = {
    {
      name = "cube",
      path = "~/Documents/Obsidian Vault",
    },
    --[[
    {
      name = "no-vault",
      path = function()
        -- alternatively use the CWD:
        -- return assert(vim.fn.getcwd())
        return assert(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
      end,
      overrides = {
        notes_subdir = vim.NIL,  -- have to use 'vim.NIL' instead of 'nil'
        new_notes_location = "current_dir",
        templates = {
          subdir = vim.NIL,
        },
        disable_frontmatter = true,
      }
    }
    --]]
  }
})
require("nvim-treesitter.configs").setup({
  ensure_installed = { "markdown", "markdown_inline", "python", "javascript", "typescript", "vim", "lua", ... },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})
EOF

" Gitsigns
lua << EOF
require('gitsigns').setup()
EOF
