" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %"
autocmd! bufwritepost .gvimrc source %"

set nocompatible
set encoding=utf-8

" general stuff

set incsearch
set ignorecase
set smartcase
set history=100
set shiftwidth=4
set tabstop=4
set expandtab
set hidden
set nobackup
set noswapfile


" initialise formatting

" Don't fold on start
set nofoldenable

set number
set autoindent smartindent
syntax on

" Other stuff

set showmode
set showcmd
set autoread
set smarttab
filetype on
filetype indent on
filetype plugin on

" Enable python omnicompletion (Requires PYSMELLTAGS)
autocmd FileType python setlocal omnifunc=pysmell#Complete
set completeopt=menuone,longest,preview

vnoremap < <gv
vnoremap > >gv

ab bz Bug-Url: https://bugzilla.redhat.com

" Some mappings
nnoremap <Leader>n :bnext<CR>
nnoremap <Leader>b :bprev<CR>
nnoremap <Leader>d :bdel<CR>
nnoremap <Leader>q :bdel!
nnoremap <M-Right> :bnext<CR>
nnoremap <M-Left> :bprev<CR>
nnoremap <C-M-t> :TlistToggle<CR>
nnoremap <M-o> :CtrlP<CR>
nnoremap <M-l> :CtrlPMRU<CR>
nnoremap <F8> :PyLint<CR>

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

" Powerline fancy
"let g:Powerline_symbols = 'fancy'

" Don't run pylint on each save
let g:pymode_lint_write = 0
let g:pymode_options_fold = 0

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
  call vam#ActivateAddons(['snipmate-snippets',
              \         'github:Lokaltog/vim-powerline',
              \         'github:jiangmiao/auto-pairs',
              \         'github:scrooloose/syntastic',
              \         'github:klen/python-mode',
              \         'github:altercation/vim-colors-solarized',
              \         'github:tpope/vim-fugitive',
              \         'github:fs111/pydoc.vim',
              \         'github:davidhalter/jedi-vim',
              \         'github:vim-scripts/taglist.vim.git',
              \         'github:vim-scripts/TaskList.vim.git',
              \         'github:vim-scripts/AutoComplPop.git',
              \         'github:vim-scripts/ScrollColors.git',
              \         'github:fholgado/minibufexpl.vim.git',
              \         'github:kien/ctrlp.vim.git',
              \         'github:vim-scripts/Efficient-python-folding.git',
              \         'github:godlygeek/csapprox.git',
              \          ], {'auto_install' : 1})
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
    set hlsearch
    let g:solarized_termcolors=16
    colorscheme lucius
else
    set guifont=Ubuntu\ Mono\ 14
    set guioptions-=T
    set guioptions-=m

    set mouse=a
    set mousehide
    map <MouseMiddle> <Esc>"*p

    winpos 100 50
    set lines=55
    set columns=200
    colorscheme solarized
endif

"colorscheme mustang
""colorscheme solarized
