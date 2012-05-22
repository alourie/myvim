set nocompatible
source $VIMRUNTIME/mswin.vim
behave mswin

" call pathogen first
"call pathogen#infect()

set background=dark
"colorscheme vilight
colorscheme solarized
set guifont=Ubuntu\ Mono\ 15

" general stuff

set incsearch
set ignorecase
set smartcase
set history=100
set shiftwidth=4
set tabstop=4
set expandtab
set hidden


" initialise formatting

set number
set autoindent smartindent
syntax on

if exists("+guioptions") 
    set guioptions-=T
    set guioptions-=m
endif

" ________________________________________________________________________
" Other stuff

set showmode
set showcmd
set autoread
set nosmarttab
set foldcolumn=2
filetype on
filetype indent on
filetype plugin on

set mouse=a
set mousehide
map <MouseMiddle> <Esc>"*p

nnoremap <M-Right> :bnext<CR>
nnoremap <M-Left> :bprev<CR>
nnoremap <Leader>d :bdel<CR>
nnoremap <C-M-t> :TlistToggle<CR>
nnoremap <M-o> :CommandT<CR>
nnoremap <Leader>q :SaveSession<CR>:qall

winpos 100 50
set lines=55
set columns=200

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

function! GuiTabLabel()
    " add the tab number
    let label = '['.tabpagenr()

    " modified since the last save?
    let buflist = tabpagebuflist(v:lnum)
    for bufnr in buflist
    	if getbufvar(bufnr, '&modified')
    		let label .= '*'
    		break
    	endif
    endfor

    " count number of open windows in the tab
    let wincount = tabpagewinnr(v:lnum, '$')
    if wincount > 1
    	let label .= ', '.wincount
    endif
    let label .= '] '

    " add the file name without path information
    let n = bufname(buflist[tabpagewinnr(v:lnum) - 1])
    let label .= fnamemodify(n, ':t')

    return label
endfunction

set guitablabel=%{GuiTabLabel()}

let g:miniBufExplMapWindowNavVim = 1 
let g:miniBufExplMapWindowNavArrows = 1 
let g:miniBufExplMapCTabSwitchBufs = 1 
let g:miniBufExplModSelTarget = 1 

let Tlist_GainFocus_On_ToggleOpen = 1
set fdc=1
