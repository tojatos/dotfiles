set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugin 'scrooloose/nerdcommenter'
" Plugin 'scrooloose/syntastic'

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
set number
" set relativenumber

" Syntascic settings
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" 
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
syntax on
set tabstop=4
set incsearch
set hlsearch
set shiftwidth=2
" set noesckeys
" inoremap <Space><Space> <Esc>/<++><Enter>"_c4l
autocmd FileType html inoremap ;ht <!DOCTYPE html><Return><html><Return><head><Return><title></title><Return></head><Return></html><Esc>kk$FeT>i
autocmd FileType html inoremap ;1 <h1></h1><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;2 <h2></h2><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;3 <h3></h3><Space><++><Esc>FeT>i
autocmd FileType html inoremap ;4 <h4></h4><Space><++><Esc>FeT>i
