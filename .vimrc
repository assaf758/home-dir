if !has('nvim')
  set nocompatible
endif 

filetype indent plugin on   " load plugins and set indentation per file type
syn on

fun! SetupPlug()
call plug#begin('~/.vim/plugged')
Plug 'benmills/vimux',
Plug 'bernh/pss.vim',
Plug 'https://github.com/vim-scripts/renamer.vim',
Plug 'maxbrunsfeld/vim-yankstack',
Plug 'bling/vim-airline',
Plug 'flazz/vim-colorschemes',
Plug 'tpope/vim-commentary',
Plug 'tpope/vim-unimpaired',
Plug 'godlygeek/tabular',
Plug 'tpope/vim-repeat',
Plug 'LustyJuggler',
Plug 'tpope/vim-vinegar',
Plug 'wesleyche/SrcExpl',
Plug 'majutsushi/tagbar',
Plug 'tpope/vim-rsi',
Plug 'terryma/vim-expand-region',
Plug 'christoomey/vim-tmux-navigator',
Plug 'moll/vim-bbye',
Plug 'wincent/terminus',
Plug 'tpope/vim-abolish',
Plug 'moll/vim-bbye',
Plug 'MattesGroeger/vim-bookmarks',
Plug 'bogado/file-line',
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': 'yes \| ./install' },
Plug 'junegunn/fzf.vim',
Plug 'FelikZ/ctrlp-py-matcher',
Plug 'Shougo/deoplete.nvim',
Plug 'morhetz/gruvbox',
Plug 'Lokaltog/vim-easymotion',
Plug 'morhetz/gruvbox',

" Plug 'vim-scripts/EvalSelection.vim',
"Plug 'CSApprox',
"Plug 'AndrewRadev/splitjoin.vim',
"\'UltiSnips',
"\'github:gcmt/wildfire.vim',
"\'github:ardagnir/vimbed',
"\'github:tpope/vim-fugitive',
"\'github:Lokaltog/vim-powerline',
"\'AsyncCommand', - requires +clientserver
"\'github:Valloric/YouCompleteMe',
"\'github:ervandew/supertab',
"\'github:gcmt/wildfire.vim',
"'taglist',
call plug#end()
endfun

" Cscope **********************************************************************
func! Cscope()
if has("cscope")
    set csprg=/usr/bin/cscope
    set cst       " <C-]> will use both cscope and ctag results 
    set csto=0    " Search defintion in cscope first , and if nothing found search tag
    set nocsverb
    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
    if has('quickfix')
        set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif
endif

"find refs to C symbol under cursor
nmap g<C-\> :cs find s <C-R>=expand("<cword>")<CR><CR>  
"find def of M symbol under cursor
nmap g<C-]> :cs find g <C-R>=expand("<cword>")<CR><CR>  
"find file under cursor
nmap g<C-f> :cs find f <C-R>=expand("<cfile>")<CR><CR>

" note that "-" and "_" are interchangable when mapping with ctrl
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR> 
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i <C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endfunc!

cnoreabbrev <expr> csu
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? '!cscope -Rbq'  : 'csu')
cnoreabbrev <expr> csa
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs add'  : 'csa')
cnoreabbrev <expr> csf
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs find' : 'csf')
cnoreabbrev <expr> csk
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs kill' : 'csk')
cnoreabbrev <expr> csr
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs reset' : 'csr')
cnoreabbrev <expr> css
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs show' : 'css')
cnoreabbrev <expr> csh
      \ ((getcmdtype() == ':' && getcmdpos() <= 4)? 'cs help' : 'csh')

" Help functions **************************************************************

" ex command for toggling hex mode - define mapping if desired
command! -bar Hexmode call ToggleHex()
" helper function to toggle hex mode
function! ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" Solve backspace ignored issue
func! Backspace()
  if col('.') == 1
    if line('.')  != 1
      return  "\<ESC>kA\<Del>"
    else
      return ""
    endif
  else
    return "\<Left>\<Del>"
  endif
endfunc!

" Find the hostname - using my own "proprietry" method
fun! Hosttype()
  let hostname = system("cat ~/hostname.txt")	
  return hostname
endfun!

function! RangeChooser()
    let temp = tempname()
    " The option "--choosefiles" was added in ranger 1.5.1. Use the next line
    " with ranger 1.4.2 through 1.5.0 instead.
    "exec 'silent !ranger --choosefile=' . shellescape(temp)
    exec 'silent terminal ranger --choosefiles=' . termescape()(temp)
    if !filereadable(temp)
        redraw!
        " Nothing to read.
        return
    endif
    let names = readfile(temp)
    if empty(names)
        redraw!
        " Nothing to open.
        return
    endif
    " Edit the first item.
    exec 'edit ' . fnameescape(names[0])
    " Add any remaning items to the arg list/buffer list.
    for name in names[1:]
        exec 'argadd ' . fnameescape(name)
    endfor
    redraw!
endfunction

fun! My_mappings()
  redir! > ~/vim_maps.txt
  verbose map
  verbose map!
  redir END
  e ~/vim_maps.txt
endfun!
"******************************************************************************
"              Main
"******************************************************************************
call SetupPlug()

let layout = system("layout.sh")
" change the mapleader from \ to <space>
let mapleader = "\<space>"  

let g:ycm_server_keep_logfile = 1
let g:ycm_server_log_level = 'debug'

call yankstack#setup()

"if layout ==# "us(workman)\n"
if 1
  nmap ; :
  vmap ; :
  "with this remapping I lost commands t,e,k
  "left/right is done with h/t
  nnoremap t l
  vnoremap t l
  nnoremap n j
  vnoremap n j
  nnoremap e k
  vnoremap e k
  nnoremap k n
  nnoremap K N
  ":imap ii <Esc>
  " Use E in normal mode to add blank line below the current line
  nnoremap E 0i<C-M><ESC>k
  "easier navigation between split windows
  "nnoremap <c-n> <c-y>
  "nnoremap <c-e> <c-w>k
  "nnoremap <c-h> <c-w>h
  " lost <c-t>:
  "nnoremap <c-t> <c-w>l

  " easier navigation between split windows
  let g:tmux_navigator_no_mappings = 1
  nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <c-n> :TmuxNavigateDown<cr>
  nnoremap <silent> <c-e> :TmuxNavigateUp<cr>
  nnoremap <silent> <c-t> :TmuxNavigateRight<cr>
  nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

else
  "with this remapping I lost ;
  nnoremap ; :
  :imap jk <Esc>
  " Use K in normal mode to add blank line below the current line
  nnoremap K 0i<C-M><ESC>k

  " easier navigation between split windows
  nnoremap <c-j> <c-w>j
  nnoremap <c-k> <c-w>k
  nnoremap <c-h> <c-w>h
  nnoremap <c-l> <c-w>l
endif
 
nnoremap <silent> <leader>Ev :e ~/.vimrc<cr>
nnoremap <silent> <leader>Ed :e ~/Dropbox/Draft/vim.txt<cr>
nnoremap <silent> <leader>Eb :e ~/.bashrc<cr>
nnoremap <silent> <leader>Sv :source $MYVIMRC<cr>
nnoremap <silent> <leader>map :silent call My_mappings()<cr>
nnoremap <silent> <leader>w :w<cr>
nnoremap Y y$

" Add ranger as a file chooser in vim
" ":RangerChooser" or the keybinding "<leader>r".  Once you select one or more
" files, press enter and ranger will quit again and vim will open the selected
" files.
command! -bar RangerChooser call RangeChooser()
nnoremap <leader>r :<C-U>RangerChooser<CR>

" Return indent (all whitespace at start of a line), converted from
" tabs to spaces if what = 1, or from spaces to tabs otherwise.
" When converting to tabs, result has no redundant spaces.
function! Indenting(indent, what, cols)
  let spccol = repeat(' ', a:cols)
  let result = substitute(a:indent, spccol, '\t', 'g')
  let result = substitute(result, ' \+\ze\t', '', 'g')
  if a:what == 1
    let result = substitute(result, '\t', spccol, 'g')
  endif
  return result
endfunction

" Convert whitespace used for indenting (before first non-whitespace).
" what = 0 (convert spaces to tabs), or 1 (convert tabs to spaces).
" cols = string with number of columns per tab, or empty to use 'tabstop'.
" The cursor position is restored, but the cursor will be in a different
" column when the number of characters in the indent of the line is changed.
function! IndentConvert(line1, line2, what, cols)
  let savepos = getpos('.')
  let cols = empty(a:cols) ? &tabstop : a:cols
  execute a:line1 . ',' . a:line2 . 's/^\s\+/\=Indenting(submatch(0), a:what, cols)/e'
  call histdel('search', -1)
  call setpos('.', savepos)
endfunction
command! -nargs=? -range=% Space2Tab call IndentConvert(<line1>,<line2>,0,<q-args>)
command! -nargs=? -range=% Tab2Space call IndentConvert(<line1>,<line2>,1,<q-args>)
command! -nargs=? -range=% RetabIndent call IndentConvert(<line1>,<line2>,&et,<q-args>)


" fix meta-keys which generate <Esc>a .. <Esc>z
" https://github.com/maxbrunsfeld/vim-yankstack/wiki/Linux-terminal-configurations-for-correct-meta-key-handling
let c='a'
while c <= 'z'
  exec "set <M-".toupper(c).">=\e".c
  exec "imap \e".c." <M-".toupper(c).">"
  let c = nr2char(1+char2nr(c))
endw

" open quickfix window
copen 

" underline current line with =
nnoremap <leader>1 yypVr=
nnoremap <leader>2 yypVr-

" test search object. 
vnoremap <silent> s //e<C-r>=&selection=='exclusive'?'+1':''<CR><CR>
    \:<C-u>call histdel('search',-1)<Bar>let @/=histget('search',-1)<CR>gv
omap s :normal vs<CR>

" Toggle hex mode
nnoremap <Leader>H :Hexmode<CR>

"Copy & paste to system clipboard with <Space>p and <Space>y:
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Provide buffer delete which does not close the window
nnoremap <leader>bd :Bdelete<CR>

" Fast buffer selection
nnoremap <leader>l :ls<CR>:pwd<CR>:b<Space>

" tab-completion similar to bash.
" When you type the first tab hit will complete as much as possible, the second
" tab hit will provide a list, the third and subsequent tabs will cycle through
" completion options so you can complete the file without further keys
set wildmode=longest,list,full
set wildmenu

" set gui_font for gvim:
if has("gui_running")
  set guioptions-=T  "remove toolbar
  if has("gui_gtk2")
    set guifont=Inconsolata\ for\ Powerline\ 12
  elseif has("gui_win32")
    set guifont=Consolas:h11:cANSI
  endif
endif

set laststatus=2   " Always show the statusline
if !has('nvim')
  set encoding=utf-8 " Necessary to show Unicode glyphs
endif

set vb t_vb=  " No beeps

" Fix home/end key in all modes
map <esc>OH <home>
cmap <esc>OH <home>
imap <esc>OH <home>
map <esc>OF <end>
cmap <esc>OF <end>
imap <esc>OF <end>

" Searching *******************************************************************
set hlsearch   " highlight search
set incsearch  " incremental search, search as you type
set ignorecase " Ignore case when searching
set smartcase  " Ignore case when searching lowercase
nnoremap <silent> <leader>q :nohlsearch<CR>

" Cursor *******************************************************************
set cursorline 	" highlight current line
highlight Cursor guifg=white guibg=black
highlight iCursor guifg=white guibg=steelblue
set guicursor=n-v-c:block-Cursor
set guicursor+=i:block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait10

" Viewing  *******************************************************************
set number 	" turn on line numbers
nnoremap <silent> <leader>n :set number! number?<cr>
set numberwidth=5 " We are good up to 99999 lines
nnoremap <leader>G :echo expand('%:p')<cr>
syntax enable
nnoremap <silent> <leader>s :if exists("g:syntax_on") <Bar>
	\   syntax off <Bar>
	\ else <Bar>
	\   syntax enable <Bar>
	\ endif <CR>
"set statusline=%t[%{strlen(&fenc)?&fenc:'none'},%{&ff}]%h%m%r%y%=%c,%l/%L\ %P
"set statusline=%t       "tail of the filename
"set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
"set statusline+=%{&ff}] "file format
"set statusline+=%h      "help file flag
"set statusline+=%#error# "switch to error highligh
"set statusline+=%m      "modified flag
"set statusline+=%*       "switch back to normal statusline highlight
"set statusline+=%r      "read only flag
"set statusline+=%y      "filetype
"set statusline+=%=      "left/right separator
"set statusline+=%c,     "cursor column
"set statusline+=%l/%L   "cursor line/total lines
"set statusline+=\ %P    "percent through file

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Colorscheme **************
colorscheme gruvbox
set background=dark
" highlight DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=white 
" highlight DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black 
" highlight DiffText term=reverse cterm=bold ctermbg=gray ctermfg=black 
" highlight DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black


" tabs & indentation
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set smarttab      " insert tabs on the start of a line according to
                  " shiftwidth, not tabstop
set expandtab	  " Always expand tabs to corresponding number of spaces

" toggle showing of whitespace chars
nnoremap <leader>sp :set list! list?<cr>
set listchars=tab:→\ ,trail:·,nbsp:·,eol:¬

set hidden	" allow switching from unsaved buffer

" Solve paste issue
nnoremap \<F2> :set invpaste paste?<CR>
set pastetoggle=\<F2>
set showmode

set backspace=indent,eol,start  " backspace through everything in insert mode

" use gp to select last changed test (pasted or not), with same selection type
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Press <leader>J  whenever you want to split a line
nnoremap <leader>J i<CR><ESC>k$
" Echo current buffer's Full Pathname to the vim command line 
nnoremap <leader>cfp :echo expand("%:p")<CR>
" Echo current buffer's Filename (tail) + Line number to the vim command line 
nnoremap <leader>cfl :echo expand("%:t") . ':' . line(".")<CR>

set nobackup		" no backup files
set noswapfile		" nor swapfiles
set history=1000        " remember more commands and search history
set undolevels=1000     " use many muchos levels of undo
set title               " change the terminal's title (no effect under tmux / gui)

" Allow calling sudo (to make file writeable) *after* you have edited the file
cmap w!! w !sudo tee % >/dev/null

"Quickfix (on top of imparied)
nmap [c :colder<CR>
nmap ]c :cnewer<CR>
" Press o (when in quickfix window) to show location without changeing focus
autocmd FileType qf nnoremap <buffer> o <CR><C-W><C-P>

call Cscope() " Do cscope config
"Configure Tagbar winodw display/hide
nmap <F9> :TagbarToggle<CR>

" netrw 
"let g:netrw_keepdir=0  " let vim cdr follow netrw browser dir
" use gc to change vim cwd to the nerw dir

" Completion menu
"set pumheight=15
set completeopt=menu,menuone
let g:SuperTabDefaultCompletionType = "context"

" YouCompleteMe config
" Do not display "Pattern not found" messages during YouCompleteMe completion
" Patch: https://groups.google.com/forum/#!topic/vim_dev/WeBBjkXE8H8
try
  set shortmess+=c
  catch /E539: Illegal character/
endtry

" bookmarks
highlight SignColumn ctermbg=black

" LustyJuggler
let g:LustyJugglerSuppressRubyWarning = 1

" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" FZF
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>F :Files<cr>
nnoremap <leader>f :Files apps/asm<cr>

" " CtrlP
" let g:ctrlp_working_path_mode = ''  "working dir equals vim working dir
" let g:ctrlp_max_files = 0  " No limit to amount of files to scan
" let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
"       \ --ignore .git
"       \ --ignore .svn
"       \ --ignore .hg
"       \ --ignore .DS_Store
"       \ --ignore "**/*.pyc"
"       \ -g ""'
" let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
" nnoremap <leader>b :CtrlPBuffer<cr>
" nnoremap <leader>f :CtrlP<cr>
" nnoremap <leader>m :CtrlPMixed<cr>

" expand_region 
call expand_region#custom_text_objects({ 
      \ "\/\\n\\n\<CR>": 1,  
      \ 'a]' :1,  
      \ 'ab' :1,  
      \ 'aB' :1, 
      \ 'ii' :0, 
      \ 'ai' :0, 
      \ })

" Command-T config ********************************************
" let g:CommandTFileScanner="find"
" let g:CommandTMaxFiles=50000
" nnoremap <leader>f :CommandTFlush<cr>\|:CommandT<cr>
" nnoremap <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
" The below does not work. Use Ctrl-p?
" nnoremap <silent> <Leader>c :CommandTTag<CR>
" Command-T uses vim's wildignore to set a comma seperated list of globs to ignore in listings
set wildignore+=*.o,*.obj,.git,.svn

" Build and run go program hello.go on specific tmux window
nnoremap <F5> :silent !tmux send-keys -t 'kernel-dev':go.1 'go run golang_tour.go' C-m <CR>

" disable soft-wrap (run after all plugins have ran)
autocmd VimEnter * set nowrap 
