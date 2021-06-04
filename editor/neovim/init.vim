" set formatoptions+=o " auto insert current comment leader
" set formatoptions-=r " but not after <enter>
" set formatoptions-=t " no autowrap

set nowrap
set wildmode=list:longest

" Set my swap file directory
" Make my swap location if it doesn't exist
if !isdirectory("/tmp/vimswap")
  call mkdir("/tmp/vimswap", "p")
endif

set directory=/tmp/vimswap//

" Change cursor in iTerm on insert
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.nvim/plugged')

Plug 'LnL7/vim-nix'
Plug 'benekastah/neomake'
Plug 'mattn/emmet-vim'
Plug 'neovimhaskell/haskell-vim'
Plug 'kien/ctrlp.vim'
Plug 'Shougo/deoplete.nvim'
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'vim-crystal/vim-crystal'
Plug 'Raku/vim-raku'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Te he
" Plug 'alex-ren/org.ats-lang.toolats', { 'rtp': 'org.ats-lang.toolats.vim' }

" OMG
" Plug 'ndmitchell/ghcid', { 'rtp': 'plugins/nvim' }
Plug 'Mercury-Language/mercury', { 'rtp': 'vim', 'do': 'make install' }

call plug#end()

syntax on
filetype on
filetype plugin indent on

" Python Provider
let g:python3_host_prog = '/usr/local/bin/python3'

" wrap to 80 for some file types
au BufRead,BufNewFile *.md,Changelog setlocal textwidth=80
" vim-airline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
set laststatus=2

"NERDTree Settings
map <C-t> :NERDTreeToggle<CR>
" Setup Neomake to run on every write
autocmd! BufWritePost * Neomake

" Raichoo Haskell-Vim Settings
let g:haskell_enable_quantification = 1
let g:haskell_enable_recursivedo = 1
let g:haskell_enable_arrowsyntax = 1
let g:haskell_enable_pattern_synonyms = 1
let g:haskell_enable_typeroles = 1
let g:haskell_enable_static_pointers = 1

map <silent> <Leader>e :Errors<CR>

" CtrlP Settings
set wildignore+=*/dist/**
set wildignore+=*/vendor/**

if executable('ag')
  " Use Ag for the greppening
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

" GHC-MOD Settings
" Reload
" map <silent> tu :call GHC_BrowseAll()<CR>
" Type Lookup
" map <silent> tw :call GHC_ShowType(1)<CR>

" Ctrl-P Info
set runtimepath^=~/.nvim/plugged/ctrlp.vim

" Tabstop size
set smarttab
set expandtab
set number
set tabstop=2
set shiftwidth=2
set softtabstop=2
set completeopt=longest,menuone

" Prettiness
" set background = "dark"
" colorscheme molokai
" let g:molokai_original = 1

let mapleader = ","
         
" MAPS AND WHATNOT
inoremap jk <esc>
nnoremap <leader><leader> <C-^>
nnoremap <leader>aa :Ag<space>
nnoremap <leader>s <C-w>v<C-w>w:A<cr> " Split with alternate
nnoremap <C-j> :cn<cr>
nnoremap <C-k> :cp<cr>
nnoremap <cr> :noh<cr>
nnoremap <Space> :wa<cr>

" Escape 'Terminal' mode to 'Normal'
tnoremap <leader>e <C-\><C-n>

" Haskell funz
nnoremap <leader>al ggO{-#<space>LANGUAGE<space><space>#-}<left><left><left><left><C-x><C-o>
