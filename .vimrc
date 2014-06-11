" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %"

" Python-specific stuff
autocmd FileType python set cc=79
"autocmd BufWritePre *.py :%s/\s\+$//e

set nocompatible
set encoding=utf-8
set scrolloff=1
set sidescrolloff=5
set display+=lastline

" general stuff

set incsearch
set hlsearch
set ignorecase
set smartcase
set smartindent
set history=100
set shiftwidth=4
set tabstop=4
set shiftround
set expandtab
set hidden
set nobackup
set noswapfile
set undofile


" initialise formatting

" Don't fold on start
set nofoldenable

set number
set autoindent
syntax on

" Other stuff

set showmode
set showcmd
set autoread
set smarttab
filetype on
filetype indent on
filetype plugin on

set listchars+=eol:¬
set backspace=indent,eol,start

set completeopt=menuone,longest,preview

vnoremap < <gv
vnoremap > >gv

" For some reason home and end keys are not mapping properly.
" Home key
"imap <esc>OH <esc>0i
"cmap <esc>OH <home>
"nmap <esc>OH 0
"" End key
"nmap <esc>OF $
"imap <esc>OF <esc>$a
"cmap <esc>OF <end>

" Some mappings
map <Leader>n :set number!<CR>
nnoremap <Leader>l :set list!<CR>
nnoremap <Leader>D :MBEbd<CR>
nnoremap <Leader>q :qall!
nnoremap <M-l> :bnext<CR>
nnoremap <M-h> :bprev<CR>
nnoremap <C-M-t> :TlistToggle<CR>
nnoremap <F8> :PyLint<CR>
nnoremap :W :w
nnoremap :Q :q
nnoremap <PAGEUP> <C-u>
nnoremap <PAGEDOWN> <C-d>
map <C-Down> <C-W>j
map <C-Up> <C-W>k
map <C-Right> <C-W>l
map <C-Left> <C-W>h

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo
function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END


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

" MiniBufExpl setup
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" Gain focus on class browser on open
let Tlist_GainFocus_On_ToggleOpen = 1

" Powerline stuff
"let g:Powerline_symbols = 'fancy'

" Jedi stuff
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#popup_on_dot = 0
let g:jedi#popup_select_first = 0
let g:jedi#goto_definition_command = "<leader>g"

" Sane Ignore For ctrlp
let g:ctrlp_working_mode = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
  \ 'file': '\v\.(java|jpeg|png|pyc|jar)$',
  \ }

" Syntastic
let g:syntastic_enable_signs = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_auto_jump = 0

fun! EnsureVamIsOnDisk(vam_install_path)
  " windows users may want to use http://mawercer.de/~marc/vam/index.php
  " to fetch VAM, VAM-known-repositories and the listed plugins
  " without having to install curl, 7-zip and git tools first
  " -> BUG [4] (git-less installation)
  let is_installed_c = "isdirectory(a:vam_install_path.'/vim-addon-manager/autoload')"
  if eval(is_installed_c)
    return 1
  else
    if 1 == confirm("Clone VAM into ".a:vam_install_path."?","&Y\n&N")
      " I'm sorry having to add this reminder. Eventually it'll pay off.
      call confirm("Remind yourself that most plugins ship with ".
                  \"documentation (README*, doc/*.txt). It is your ".
                  \"first source of knowledge. If you can't find ".
                  \"the info you're looking for in reasonable ".
                  \"time ask maintainers to improve documentation")
      call mkdir(a:vam_install_path, 'p')
      execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.shellescape(a:vam_install_path, 1).'/vim-addon-manager'
      " VAM runs helptags automatically when you install or update
      " plugins
      exec 'helptags '.fnameescape(a:vam_install_path.'/vim-addon-manager/doc')
    endif
    return eval(is_installed_c)
  endif
endfun

fun! SetupVAM()
  " Set advanced options like this:
  " let g:vim_addon_manager = {}
  " let g:vim_addon_manager['key'] = value
  "     Pipe all output into a buffer which gets written to disk
  " let g:vim_addon_manager['log_to_buf'] =1

  " Example: drop git sources unless git is in PATH. Same plugins can
  " be installed from www.vim.org. Lookup MergeSources to get more control
  " let g:vim_addon_manager['drop_git_sources'] = !executable('git')
  " let g:vim_addon_manager.debug_activation = 1

  " VAM install location:
  let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
  if !EnsureVamIsOnDisk(vam_install_path)
    echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
    return
  endif
  exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

  " Tell VAM which plugins to fetch & load:
  call vam#ActivateAddons([
              \         'github:Lokaltog/vim-powerline',
              \         'github:jiangmiao/auto-pairs',
              \         'github:altercation/vim-colors-solarized',
              \         'github:tpope/vim-fugitive',
              \         'github:tpope/vim-unimpaired',
              \         'github:fholgado/minibufexpl.vim',
              \         'github:scrooloose/syntastic',
              \         'github:scrooloose/nerdtree',
              \         'github:fs111/pydoc.vim',
              \         'github:vim-scripts/taglist.vim',
              \         'github:vim-scripts/TaskList.vim',
              \         'github:kien/ctrlp.vim',
              \         'github:vim-scripts/Efficient-python-folding',
              \         'github:nvie/vim-flake8',
              \         'github:davidhalter/jedi-vim',
              \         'github:Valloric/YouCompleteMe',
              \         'github:hynek/vim-python-pep8-indent',
              \         'github:ardagnir/united-front',
              \         'github:terryma/vim-multiple-cursors',
              \          ], {'auto_install' : 1})
              "\         'snipmate-snippets',
              "\         'github:klen/python-mode',
              "\         'github:alourie/Conque-Shell',
              "\         'github:vim-scripts/AutoComplPop',
"              \         'github:vim-scripts/ScrollColors',
  " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

  " Addons are put into vam_install_path/plugin-name directory
  " unless those directories exist. Then they are activated.
  " Activating means adding addon dirs to rtp and do some additional
  " magic

  " How to find addon names?
  " - look up source from pool
  " - (<c-x><c-p> complete plugin names):
  " You can use name rewritings to point to sources:
  "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
  "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
  " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun

call SetupVAM()
" experimental [E1]: load plugins lazily depending on filetype, See
" NOTES
" experimental [E2]: run after gui has been started (gvim) [3]
" option1:  au VimEnter * call SetupVAM()
" option2:  au GUIEnter * call SetupVAM()
" See BUGS sections below [*]
" Vim 7.0 users see BUGS section [3]

" Colors are set here, because we only bring them in SetupVAM
set t_Co=256
set background=dark
if !has("gui_running")
    ""set t_Co=16
    "colorscheme distinguished
    colorscheme solarized
else
    set guioptions-=T
    set guioptions-=m
    set guioptions-=r
    set guifont=Droid\ Sans\ Mono\ 14

    set mouse=a
    set mousehide
    map <MouseMiddle> <Esc>"*p

    set lines=45
    set columns=110
    colorscheme solarized
endif
