set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Bundle 'gmarik/Vundle.vim'

Bundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}

Bundle 'scrooloose/nerdtree'

Bundle 'jistr/vim-nerdtree-tabs'

Bundle 'klen/python-mode'

Bundle 'kien/ctrlp.vim'

Bundle 'Valloric/YouCompleteMe'

Bundle 'davidhalter/jedi-vim'

Bundle 'airblade/vim-gitgutter'

Bundle 'tpope/vim-surround'

Bundle 'tpope/vim-commentary'

Bundle 'HTML-AutoCloseTag'

Bundle 'tpope/vim-fugitive'

Bundle 'flazz/vim-colorschemes'

Bundle 'xolox/vim-misc'

Bundle 'xolox/vim-colorscheme-switcher'

Plugin 'fisadev/vim-isort'

Bundle 'taglist.vim'

Bundle 'terryma/vim-multiple-cursors'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

augroup vimrc_autocmds
    autocmd!
    " highlight characters past column 80
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%120v.*/
    autocmd FileType python set nowrap
    augroup END

set nu

" Powerline setup
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9
set laststatus=2

" Python-mode
" Activate rope
" Keys:
" K             Show python docs
" <Ctrl-Space>  Rope autocomplete
" <Ctrl-c>g     Rope goto definition
" <Ctrl-c>d     Rope show documentation
" <Ctrl-c>f     Rope find occurrences
" <Leader>b     Set, unset breakpoint (g:pymode_breakpoint enabled)
" [[            Jump on previous class or function (normal, visual, operator
" modes)
" ]]            Jump on next class or function (normal, visual, operator
" modes)
" [M            Jump on previous class or method (normal, visual, operator
" modes)
" ]M            Jump on next class or method (normal, visual, operator
" modes)
let g:pymode_rope = 0
let g:pymode_rope_autoimport = 0

" Documentation
" let g:pymode_doc = 1
" let g:pymode_doc_key = 'K'

"Linting
let g:pymode_lint = 1
let g:pymode_lint_on_fly = 1
let g:pymode_lint_checkers = ["pylint"]
let g:pymode_lint_checker = "pylint"
let g:pymode_lint_write = 1
let g:pymode_lint_message = 1

" Support virtualenv
let g:pymode_virtualenv = 1

" Enable breakpoints plugin
let g:pymode_breakpoint = 1
let g:pymode_breakpoint_bind = '<leader>b'

" syntax highlighting
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
let g:pymode_syntax_space_errors = g:pymode_syntax_all

" Don't autofold code
let g:pymode_folding = 0

" Jedi-vim configuration
let g:jedi#show_call_signatures = 0 
let g:jedi#popup_select_first = 0

set autoread


if executable('ag')
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""' 
endif
let g:ctrlp_switch_buffer = 'ET'

set hidden
set incsearch
set hlsearch
colorscheme busierbee
nnoremap <F2> :NERDTreeTabsToggle<CR>
nnoremap <F3> :TlistToggle<CR>
nnoremap <C-t> :tabnew<CR>
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabprev<CR>
nnoremap tk  :tabnext<CR>
nnoremap tl  :tablast<CR>
nnoremap tn  :tabnext<Space>
" Switch to last active tab
let g:lasttab = 1
nmap tt :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

nnoremap ap  :PymodeLintAuto<CR>
nmap <leader>h *N
nnoremap <Leader>s :%s/\<<C-r><C-w>\>//g<Left><Left>
nnoremap cc :let @/ = ""<cr>
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
