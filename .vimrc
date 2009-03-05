set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
"behave mswin

colorscheme rubyblue
set guifont=Monaco:h10:cDEFAULT

" general stuff

set incsearch
set ignorecase
set smartcase
set history=100
set shiftwidth=4
set tabstop=4
set expandtab


" initialise formatting

set number
set autoindent smartindent
syntax on

if exists("+guioptions") 
    set guioptions-=T
endif

" auto-complete PHP tags (Ctrl-X Ctrl-K)

set dictionary=~/php.dictionary
set filetype=php

source C:\Program Files\Vim\vimfiles\plugin\php-doc.vim
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR> 

inoremap {<CR>  {<CR>}<Esc>O<space><space><space><space>

" ________________________________________________________________________
" Other stuff

set showmode
set showcmd
set autoread
set smarttab
filetype on
filetype indent on
filetype plugin on
compiler php
set foldcolumn=2

set mouse=a
set mousehide
map <MouseMiddle> <Esc>"*p

winpos 1000 50
set lines=25
set columns=100

" ---------------------------------------------------------------------------
" status line
set laststatus=2
if has('statusline')
        function! SetStatusLineStyle()
                let &stl="%f %y "                       .
                        \"%([%R%M]%)"                   .
                        \"%#StatusLineNC#%{&ff=='unix'?'':&ff.'\ format'}%*" .
                        \"%{'$'[!&list]}"               .
                        \"%{'~'[&pm=='']}"              .
                        \"%="                           .
                        \"#%n %l/%L,%c%V "              .
                        \""
        endfunc
        call SetStatusLineStyle()

        if has('title')
                set titlestring=%t%(\ [%R%M]%)
        endif

endif