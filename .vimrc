set nocompatible

" call pathogen first
call pathogen#infect()

set t_Co=256
colorscheme mustang

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

set number
set autoindent smartindent
syntax on

" Other stuff

set showmode
set showcmd
set autoread
set smarttab
set foldcolumn=2
filetype on
filetype indent on
filetype plugin on

" Enable python omnicompletion (Requires PYSMELLTAGS)
autocmd FileType python setlocal omnifunc=pysmell#Complete
set completeopt=menuone,longest,preview

" Some mappings
nnoremap <M-Right> :bnext<CR>
nnoremap <M-Left> :bprev<CR>
nnoremap <C-M-d> :bdel<CR>
nnoremap <C-M-t> :TlistToggle<CR>
nnoremap <M-o> :CommandT<CR>
nnoremap <M-l> :MRU<CR>
nnoremap <M-q> :qall

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

" Vam setup
fun! SetupVAM()
      " YES, you can customize this vam_install_path path and everything still works!
      let vam_install_path = expand('$HOME') . '/.vim/vim-addons'
      exec 'set runtimepath+='.vam_install_path.'/vim-addon-manager'

      " * unix based os users may want to use this code checking out VAM
      " * windows users want to use http://mawercer.de/~marc/vam/index.php
      "   to fetch VAM, VAM-known-repositories and the listed plugins
      "   without having to install curl, unzip, git tool chain first
      " -> BUG [4] (git-less installation)
      if !filereadable(vam_install_path.'/vim-addon-manager/.git/config') && 1 == confirm("git clone VAM into ".vam_install_path."?","&Y\n&N")
        " I'm sorry having to add this reminder. Eventually it'll pay off.
        call confirm("Remind yourself that most plugins ship with documentation (README*, doc/*.txt). Its your first source of knowledge. If you can't find the info you're looking for in reasonable time ask maintainers to improve documentation")
        exec '!p='.shellescape(vam_install_path).'; mkdir -p "$p" && cd "$p" && git clone --depth 1 git://github.com/MarcWeber/vim-addon-manager.git'
        " VAM run helptags automatically if you install or update plugins
        exec 'helptags '.fnameescape(vam_install_path.'/vim-addon-manager/doc')
      endif

      " Example drop git sources unless git is in PATH. Same plugins can
      " be installed form www.vim.org. Lookup MergeSources to get more control
      " let g:vim_addon_manager['drop_git_sources'] = !executable('git')

      call vam#ActivateAddons(['snipmate-snippets', 'github:tpope/vim-surround'], {'auto_install' : 0})
      " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})
      "  - look up source from pool (<c-x><c-p> complete plugin names):
      "    ActivateAddons(["foo",  ..
      "  - name rewritings: 
      "    ..ActivateAddons(["github:foo", .. => github://foo/vim-addon-foo
      "    ..ActivateAddons(["github:user/repo", .. => github://user/repo
      " Also see section "2.2. names of addons and addon sources" in VAM's documentation
endfun
call SetupVAM()
