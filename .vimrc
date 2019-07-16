set nocompatible
call plug#begin('~/.vim/plugged')
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-dispatch'
"Plug 'scrooloose/syntastic'
Plug 'pseewald/vim-anyfold'
Plug 'jiangmiao/auto-pairs'
Plug 'francoiscabrol/ranger.vim'
Plug 'mattn/emmet-vim'
Plug 'rust-lang/rust.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'lervag/vimtex'
Plug 'sirver/ultisnips'
"Plug 'Rip-Rip/clang_complete'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
"Plug 'yuttie/comfortable-motion.vim'
call plug#end()
set number

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
let maplocalleader = "\<Space>"
nnoremap <Leader>j :FZF<Return>
"nnoremap <Leader>l :w<Return>:silent :!pdflatex %<Return><C-L>
autocmd FileType html,php nnoremap <Leader>ht i<!DOCTYPE html><Return><html><Return><head><Return><title></title><Return></head><Return></html><Esc>kk$FeT>i
autocmd FileType html,php nnoremap <Leader>1 i<h1></h1><Esc>FeT>i
autocmd FileType html,php nnoremap <Leader>2 i<h2></h2><Esc>FeT>i
autocmd FileType html,php nnoremap <Leader>3 i<h3></h3><Esc>FeT>i
autocmd FileType html,php nnoremap <Leader>4 i<h4></h4><Esc>FeT>i
colorscheme codedark

let anyfold_activate=0
let anyfold_fold_comments=1
set foldlevel=1

"let g:syntastic_cpp_compiler_options = ' -std=c++11'

let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=2
let g:tex_conceal='abdmgs'

let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'

" Disable arrow movement, resize splits instead.
nnoremap  <Up>     :resize    +2<CR>
nnoremap  <Down>   :resize    -2<CR>
nnoremap  <Left>   :vertical  resize  +2<CR>
nnoremap  <Right>  :vertical  resize  -2<CR>
set clipboard=unnamed,unnamedplus
highlight EndOfBuffer ctermfg=bg ctermbg=bg

set mouse=a
