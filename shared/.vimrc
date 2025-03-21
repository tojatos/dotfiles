set nocompatible

if has('win32')
  " set shell=pwsh.exe\ -nologo
  set rtp+=~/.vim
  set encoding=utf-8
  set termguicolors " fix gui colors on Windows
endif

" Vim plug automatic install ---------------------- {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  if has('win32')
    silent ! powershell -Command "
      \   New-Item -Path $HOME\.vim -Name autoload -Type Directory -Force;
      \   Invoke-WebRequest
      \   -Uri 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
      \   -OutFile $HOME\.vim\autoload\plug.vim
      \ "
  else
    silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  endif
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}
"
let g:polyglot_disabled = ['latex']

call plug#begin('~/.vim/plugged')
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-dispatch'
Plug 'lervag/vimtex'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --no-fish --no-bash --all --no-update-rc' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'chrisbra/Colorizer'
Plug 'sheerun/vim-polyglot' " language pack (syntax highlighting for jenkinsfile for example)
Plug 'janko/vim-test'
Plug 'machakann/vim-swap'
Plug 'rkitover/vimpager'
call plug#end()

syntax on

silent! colorscheme codedark

" Sets ---------------------- {{{
" set number
" set relativenumber
set tabstop=4
set incsearch
set hlsearch
set shiftwidth=2
set wildmenu
set noshowmode
set ignorecase
set smartcase
set splitbelow
set splitright
set expandtab
set conceallevel=2

" Map yank buffer to system clipboards
set clipboard=unnamed,unnamedplus
silent! highlight EndOfBuffer ctermfg=bg ctermbg=bg

" Bash like completion
set wildmode=longest,list,full

" Automatic folding
set foldmethod=indent

" Undo setup
set undofile                " Save undos after file closes
set undodir=$HOME/.vim/undo " where to save undo histories
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

if !isdirectory(&undodir)
    call mkdir(&undodir)
endif
" }}}
" Latex ---------------------- {{{
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmgs'
let g:vimtex_compiler_latexmk = {
        \ 'options' : [
        \   '-pdf' ,
        \   '-shell-escape' ,
        \   '-verbose' ,
        \   '-file-line-error',
        \   '-synctex=1' ,
        \   '-interaction=nonstopmode' ,
        \ ],
        \}
" }}}
" Vimscript file settings ---------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}
" Remaps ---------------------- {{{
" Remap leader to space
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

nnoremap <Leader>j :FZF<Return>
nnoremap <Leader>n :cnext<Return>
nnoremap <Leader>p :cprevious<Return>
nnoremap <Leader>g :Gstatus<Return>
nnoremap <Leader>q :q<Return>
nnoremap <leader>N :setlocal number!<cr>

" Disable arrow movement, resize splits instead.
nnoremap <Up>     :resize    +2<CR>
nnoremap <Down>   :resize    -2<CR>
nnoremap <Left>   :vertical  resize  +2<CR>
nnoremap <Right>  :vertical  resize  -2<CR>

" Replace without overwriting buffer
vnoremap <s-p> "_dP

" Edit .vimrc
nnoremap <Leader>ve :vsplit $MYVIMRC<CR>
" Source .vimrc
nnoremap <Leader>vs :source $MYVIMRC<CR>

function ShowCommand(command)
  execute 'bot term'.a:command
  setlocal nonumber
  setlocal norelativenumber
endfunction
" Run ./run.sh and show output in split
nnoremap <Leader>m :call ShowCommand('./run.sh %')<CR>
" Run ./test.sh and show output in split
nnoremap <Leader>n :call ShowCommand('./test.sh')<CR>
" }}}

command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   { 'dir': systemlist('git rev-parse --show-toplevel')[0] }, <bang>0)
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

if !has('win32')
  " prevent vim from clearing clipboard on exit
  autocmd VimLeave * call system("xsel -ib", getreg('+'))
endif

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif

autocmd BufRead,BufNewFile *Jenkinsfile set ft=Jenkinsfile

" Show whitespaces at the end of lines
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
