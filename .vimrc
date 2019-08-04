set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'w0rp/ale'
Plug 'vim-airline/vim-airline'
Plug 'tomasiser/vim-code-dark'
Plug 'tpope/vim-dispatch'
Plug 'jiangmiao/auto-pairs'
Plug 'francoiscabrol/ranger.vim'
Plug 'mattn/emmet-vim'
Plug 'rust-lang/rust.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'lervag/vimtex'
Plug 'sirver/ultisnips'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'chrisbra/Colorizer'
Plug 'OmniSharp/omnisharp-vim'
Plug 'ambv/black'
call plug#end()

syntax on

set number
set tabstop=4
set incsearch
set hlsearch
set shiftwidth=2
set wildmenu
set noshowmode
set smartcase
set splitbelow
set splitright

colorscheme codedark

" Latex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
set conceallevel=2
let g:tex_conceal='abdmgs'

" UltiSnips
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<s-tab>'
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'

" Map yank buffer to system clipboards
set clipboard=unnamed,unnamedplus
highlight EndOfBuffer ctermfg=bg ctermbg=bg

" Omnisharp
let g:ale_linters = {
\ 'cs': ['OmniSharp']
\}

" Use the stdio version of OmniSharp-roslyn:
let g:OmniSharp_server_stdio = 1
let g:OmniSharp_server_path = '/home/tojatos/.omnisharp/run'

set signcolumn=yes
set updatetime=100

sign define OmniSharpCodeActions text=
" highlight OmniSharpCodeActions ctermbg=NONE ctermfg=yellow

augroup OSCountCodeActions
  autocmd!
  autocmd FileType cs set signcolumn=yes
  autocmd CursorHold *.cs call OSCountCodeActions()
augroup END

function! OSCountCodeActions() abort
  if bufname('%') ==# '' || OmniSharp#FugitiveCheck() | return | endif
  if !OmniSharp#IsServerRunning() | return | endif
  let opts = {
  \ 'CallbackCount': function('s:CBReturnCount'),
  \ 'CallbackCleanup': {-> execute('sign unplace 99')}
  \}
  call OmniSharp#CountCodeActions(opts)
endfunction

function! s:CBReturnCount(count) abort
  if a:count
    let l = getpos('.')[1]
    let f = expand('%:p')
    execute ':sign place 99 line='.l.' name=OmniSharpCodeActions file='.f
  endif
endfunction
" syn region    cBlock        start="{" end="}" transparent fold
let g:OmniSharp_selector_ui = 'fzf'
nnoremap <Leader><Leader> :OmniSharpGetCodeActions<CR>

augroup omnisharp_commands
    autocmd!
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
augroup END

" bash like completion
set wildmode=longest,list,full

" automatic folding
set foldmethod=indent

" remaps
" Remap leader to space
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"
let maplocalleader = "\<Space>"

nnoremap <Leader>j :FZF<Return>

nnoremap <Leader>g :Gstatus<Return>
nnoremap <Leader>q :q<Return>

" Disable arrow movement, resize splits instead.
nnoremap  <Up>     :resize    +2<CR>
nnoremap  <Down>   :resize    -2<CR>
nnoremap  <Left>   :vertical  resize  +2<CR>
nnoremap  <Right>  :vertical  resize  -2<CR>
