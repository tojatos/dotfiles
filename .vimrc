set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Plugin 'w0rp/ale'
" Plugin 'OmniSharp/omnisharp-vim'
Plugin 'vim-airline/vim-airline'
Plugin 'tomasiser/vim-code-dark'
" Plugin 'valloric/youcompleteme'
Plugin 'tpope/vim-dispatch'
" Plugin 'junegunn/fzf'
" Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'pseewald/vim-anyfold'
Plugin 'jiangmiao/auto-pairs'
Plugin 'francoiscabrol/ranger.vim'
Plugin 'mattn/emmet-vim'
Plugin 'rust-lang/rust.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'lervag/vimtex'
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
" set number
set relativenumber

syntax on
set tabstop=4
set incsearch
set hlsearch
set shiftwidth=2
set wildmenu
set noshowmode
set smartcase
set splitbelow
set splitright
nnoremap Y y$
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"
nnoremap <Leader>j :FZF<Return>
nnoremap <Leader>l :w<Return>:silent :!pdflatex %<Return><C-L>
autocmd FileType html,php nnoremap <Leader>ht i<!DOCTYPE html><Return><html><Return><head><Return><title></title><Return></head><Return></html><Esc>kk$FeT>i
autocmd FileType html,php nnoremap <Leader>1 i<h1></h1><Esc>FeT>i
autocmd FileType html,php nnoremap <Leader>2 i<h2></h2><Esc>FeT>i
autocmd FileType html,php nnoremap <Leader>3 i<h3></h3><Esc>FeT>i
autocmd FileType html,php nnoremap <Leader>4 i<h4></h4><Esc>FeT>i
colorscheme codedark

let anyfold_activate=0
let anyfold_fold_comments=1
set foldlevel=1

let g:syntastic_cpp_compiler_options = ' -std=c++11'

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=1
let g:tex_conceal='abdmg'
" Disable arrow movement, resize splits instead.
nnoremap  <Up>     :resize    +2<CR>
nnoremap  <Down>   :resize    -2<CR>
nnoremap  <Left>   :vertical  resize  +2<CR>
nnoremap  <Right>  :vertical  resize  -2<CR>
