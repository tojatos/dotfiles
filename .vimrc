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
Plugin 'junegunn/fzf'
" Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/syntastic'
Plugin 'pseewald/vim-anyfold'
Plugin 'jiangmiao/auto-pairs'
Plugin 'francoiscabrol/ranger.vim'
Plugin 'mattn/emmet-vim'
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
" set noesckeys
" inoremap <Space><Space> <Esc>/<++><Enter>"_c4l
nnoremap Y y$
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"
nnoremap <Leader>j :FZF<Return>
autocmd FileType html,php nnoremap <Leader>ht i<!DOCTYPE html><Return><html><Return><head><Return><title></title><Return></head><Return></html><Esc>kk$FeT>i
autocmd FileType html,php nnoremap <Leader>1 i<h1></h1><Esc>FeT>i
autocmd FileType html,php nnoremap <Leader>2 i<h2></h2><Esc>FeT>i
autocmd FileType html,php nnoremap <Leader>3 i<h3></h3><Esc>FeT>i
autocmd FileType html,php nnoremap <Leader>4 i<h4></h4><Esc>FeT>i
colorscheme codedark

"let g:ale_cs_mcsc_assemblies = [
"	 \'/opt/Unity/Editor/Data/Managed/UnityEngine/UnityEngine.dll',
"		  \]
   " \ '~/NKM/obj/Debug',
"let g:airline#extensions#ale#enabled = 1
"let g:OmniSharp_server_path = '/home/tojatos/omnisharp-http/omnisharp/OmniSharp.exe'
"let g:OmniSharp_server_use_mono = 1
"let g:syntastic_cs_checkers = ['code_checker']
"augroup omnisharp_commands
"    autocmd!
"
"    " Synchronous build (blocks Vim)
"    "autocmd FileType cs nnoremap <buffer> <F5> :wa!<CR>:OmniSharpBuild<CR>
"    " Builds can also run asynchronously with vim-dispatch installed
"    autocmd FileType cs nnoremap <buffer> <Leader>b :wa!<CR>:OmniSharpBuildAsync<CR>
"    " Automatic syntax check on events (TextChanged requires Vim 7.4)
"    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
"
"    " Automatically add new cs files to the nearest project on save
"    autocmd BufWritePost *.cs call OmniSharp#AddToProject()
"
"    " Show type information automatically when the cursor stops moving
"    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
"
"    " The following commands are contextual, based on the cursor position.
"    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
"    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
"    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
"    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>
"
"    " Finds members in the current buffer
"    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>
"
"    " Cursor can be anywhere on the line containing an issue
"    autocmd FileType cs nnoremap <buffer> <Leader>x  :OmniSharpFixIssue<CR>
"    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
"    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
"    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
"    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
"    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>
"
"
"    " Navigate up and down by method/property/field
"    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
"    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>
"augroup END
"" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
"nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
"" Run code actions with text selected in visual mode to extract method
"xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>
"
"" Rename with dialog
"nnoremap <Leader>nm :OmniSharpRename<CR>
"nnoremap <F2> :OmniSharpRename<CR>
"" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
"command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")
"
"" Force OmniSharp to reload the solution. Useful when switching branches etc.
"nnoremap <Leader>rl :OmniSharpReloadSolution<CR>
"nnoremap <Leader>cf :OmniSharpCodeFormat<CR>
"" Load the current .cs file to the nearest project
"nnoremap <Leader>tp :OmniSharpAddToProject<CR>
"
"" Start the omnisharp server for the current solution
"nnoremap <Leader>ss :OmniSharpStartServer<CR>
"nnoremap <Leader>sp :OmniSharpStopServer<CR>
"
"" Add syntax highlighting for types and interfaces
"nnoremap <Leader>th :OmniSharpHighlightTypes<CR>
"
"" Enable snippet completion
"" let g:OmniSharp_want_snippet=1


let anyfold_activate=0
let anyfold_fold_comments=1
set foldlevel=1
