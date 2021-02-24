syntax on

set backspace=indent,eol,start " make backspace working in insert mode

set nowrap           " do not automatically wrap on load
set formatoptions-=t " do not automatically wrap text when typing

set completeopt-=preview

"Replace tab with 2 spaces
set tabstop=2 shiftwidth=2 expandtab

"Highlight search
set hlsearch

"Set misspelled highlight format
hi SpellBad guibg=#ff2929 ctermbg=224

"Navigate between tabs in vim
nnoremap tn :tabnew<Space>
nnoremap tk :tabnext<CR>
nnoremap tj :tabprev<CR>
nnoremap th :tabfirst<CR>
nnoremap tl :tablast<CR>

"Use two spaces for toml and yaml files
autocmd FileType *.yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType *.toml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType *.flake8 setlocal ts=2 sts=2 sw=2 expandtab

"Enable copying and paste from system clipboard
set clipboard=unnamedplus

"Auto complete brackets
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

set nu
set number relativenumber
set spell spelllang=en_us
set rtp+=$HOME/.local/lib/python3.8/site-packages/powerline/bindings/vim/
set encoding=UTF-8
set laststatus=2
set t_Co=256

call plug#begin('~/.vim/plugged')
Plug 'markonm/traces.vim'
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'davidhalter/jedi-vim'
Plug 'raimondi/delimitmate'
Plug 'govim/govim'
call plug#end()

map <C-n> :NERDTreeToggle<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
au BufRead, BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

"Syntastic configs
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
"let python_highlight_all=1

filetype plugin indent on

set autowrite

let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"

let g:go_auto_type_info = 1

function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>r  <Plug>(go-run)
autocmd FileType go nmap <leader>t  <Plug>(go-test)
au filetype go inoremap <buffer> . .<C-x><C-o>

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

