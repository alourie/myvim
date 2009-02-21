filetype plugin on
set runtimepath+="/home/alex/.vim/after"

set guifont=monaco\ 14
colorscheme rubyblue
set ai

source ~/.vim/plugin/php-doc.vim
inoremap <C-P> <ESC>:call PhpDocSingle()<CR>i
nnoremap <C-P> :call PhpDocSingle()<CR>
vnoremap <C-P> :call PhpDocRange()<CR> 


source ~/.vim/plugin/snippetsEmu.vim
