set nocompatible

set autoindent
set smartindent

set vb t_vb=

syntax off

" Searching *******************************************************************
set hlsearch   " highlight search
set incsearch  " incremental search, search as you type
set ignorecase " Ignore case when searching 
set smartcase  " Ignore case when searching lowercase

filetype plugin on

set background=dark 
" set cursorline " highlight current line

"set number " turn on line numbers
"set numberwidth=5 " We are good up to 99999 lines

set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]

:imap jk <Esc>
:imap kj <Esc>


