" 
"  ██▒   █▓ ██▓ ███▄ ▄███▓ ██▀███   ▄████▄  
" ▓██░   █▒▓██▒▓██▒▀█▀ ██▒▓██ ▒ ██▒▒██▀ ▀█  
"  ▓██  █▒░▒██▒▓██    ▓██░▓██ ░▄█ ▒▒▓█    ▄ 
"   ▒██ █░░░██░▒██    ▒██ ▒██▀▀█▄  ▒▓▓▄ ▄██▒
"    ▒▀█░  ░██░▒██▒   ░██▒░██▓ ▒██▒▒ ▓███▀ ░
"    ░ ▐░  ░▓  ░ ▒░   ░  ░░ ▒▓ ░▒▓░░ ░▒ ▒  ░
"    ░ ░░   ▒ ░░  ░      ░  ░▒ ░ ▒░  ░  ▒   
"      ░░   ▒ ░░      ░     ░░   ░ ░        
"       ░   ░         ░      ░     ░ ░      
"      ░                           ░        

" Add Plugins
call plug#begin('~/.vim/plugged')

" Skyfall Colorscheme
Plug 'rishikanthc/skyfall-vim'

" Lightline
Plug 'itchyny/lightline.vim'
" Lightline Bufferline
Plug 'mengelbrecht/lightline-bufferline'

" NerdTree
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle' }

" NerdCommenter
Plug 'preservim/nerdcommenter'

" ALE
Plug 'dense-analysis/ale'

" Rainbow Parentheses
Plug 'luochen1990/rainbow'

" Goyo
Plug 'junegunn/goyo.vim'
" Limelight
Plug 'junegunn/limelight.vim'

" VimDevicons
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Theme Settings
set t_Co=256
syntax enable
colorscheme lena

let g:rainbow_active = 1
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'skyfall',
      \ 'component': { 'close': 'ﮊ ' },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'active': {
      \   'left': [ [ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok'  ], [ 'mode', 'paste' ], [ 'readonly', 'gitbreanch' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ ['close'] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
      \ }
set showtabline=2

" Remove Compatibility fir Vi
set nocompatible
set noshowmode

" Prevents security Bugs found in Vim 7
set modelines=0

" Limelight specific theme setting
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Setup Goyo with Limelight
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" General Recommended Settings 
filetype plugin indent on
set encoding=utf-8
set clipboard=unnamedplus

set relativenumber
set undofile

" Tab Settings
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

" Key bindings

" Remap ESC
inoremap jk <ESC>

" Remap leader key to Spacebar
let mapleader = ","

" Case Sensitive settings for search
set ignorecase
set smartcase

" Clear Previous Search easily
nnoremap <leader><space> :noh<cr>

" Use tab to move to matching parentheses
nnoremap <tab> %
vnoremap <tab> %

" Handle Long Lines
set wrap
set textwidth=79
set formatoptions=qrn1

" Disable Arrow Keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>

inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

nnoremap j gj
nnoremap k gk

" Vim autosave
au FocusLost * :wa

" Highlight text as we search
set hlsearch

" Leader Commands

" String tailing whitespace in file
nnoremap <leader>W :%s/\s\+$//<CR>:let @/=''<CR>

" Reselect text that was just pasted
nnoremap <leader>v V`]

" NerdTree Functionality
nnoremap <leader>n :NERDTreeToggle<CR>

" Enter Goyo Mode
nnoremap <leader>g :Goyo<CR>
" inoremap <leader>g <ESC>:Goyo<CR>

" Map Yankring Functionality to F3
nnoremap <silent> <F3> :YRShow<CR>
inoremap <silent> <F3> <ESC>:YRShow<CR>

" Split Windows

" Split Window Vertically and move to new one
nnoremap <leader>w <C-w>v<C-w>l

" Manage Window motion
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
