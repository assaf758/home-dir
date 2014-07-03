set nocompatible
filetype indent plugin on   " load plugins and set indentation per file type
syn on

" VAM *********************************************************************************
fun! EnsureVamIsOnDisk(plugin_root_dir)
  let vam_autoload_dir = a:plugin_root_dir.'/vim-addon-manager/autoload'
  if isdirectory(vam_autoload_dir)
    return 1
  else
    if 1 == confirm("Clone VAM into ".a:plugin_root_dir."?","&Y\n&N")
      " I'm sorry having to add this reminder. Eventually it'll pay off.
      call confirm("Remind yourself that most plugins ship with ".
                  \"documentation (README*, doc/*.txt). It is your ".
                  \"first source of knowledge. If you can't find ".
                  \"the info you're looking for in reasonable ".
                  \"time ask maintainers to improve documentation")
      call mkdir(a:plugin_root_dir, 'p')
      execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '.
                  \       shellescape(a:plugin_root_dir, 1).'/vim-addon-manager'
      " VAM runs helptags automatically when you install or update
      " plugins
      exec 'helptags '.fnameescape(a:plugin_root_dir.'/vim-addon-manager/doc')
    endif
    return isdirectory(vam_autoload_dir)
  endif
endfun

fun! SetupVAM()
  " Set advanced options like this:
  " let g:vim_addon_manager = {}
  " let g:vim_addon_manager.key = value
  "     Pipe all output into a buffer which gets written to disk
  " let g:vim_addon_manager.log_to_buf =1

  " Example: drop git sources unless git is in PATH. Same plugins can
  " be installed from www.vim.org. Lookup MergeSources to get more control
  " let g:vim_addon_manager.drop_git_sources = !executable('git')
  " let g:vim_addon_manager.debug_activation = 1

  " VAM install location:
  let plugin_root_dir = expand('$HOME/.vim/vim-addons')
  if !EnsureVamIsOnDisk(plugin_root_dir)
    echohl ErrorMsg | echomsg "No VAM found!" | echohl NONE
    return
  endif
  let &rtp.=(empty(&rtp)?'':',').plugin_root_dir.'/vim-addon-manager'

  " Tell VAM which plugins to fetch & load:
  let xx = Hosttype()
  if xx ==# "ASSAF-LAP\n"
	echo 1
	call vam#ActivateAddons(['Solarized',], {'auto_install' : -1})
        inoremap <BS> <c-r>=Backspace()<CR>
  elseif xx ==# "assaf-lap-debian64\n"
 	call vam#ActivateAddons(['Conque_Shell','Solarized','ctrlp'], {'auto_install' : -1})
        python from powerline.ext.vim import source_plugin; source_plug
  elseif xx ==# "a10\n" || xx ==# "hlinux\n"
	call vam#ActivateAddons(['Conque_Shell',
	\'Solarized',
	\'github:benmills/vimux',
	\'github:godlygeek/tabular',
	\'github:wesleyche/SrcExpl',
	\'github:bernh/pss.vim',
	\'renamer',
        \'LustyJuggler',
        \'CSApprox',
	\'github:flazz/vim-colorschemes',
	\'github:tpope/vim-commentary',
	\'github:tpope/vim-repeat',
	\'github:wincent/Command-T',
        \'github:tpope/vim-unimpaired',
        \'github:bling/vim-airline',
        \'github:tpope/vim-vinegar',
        \'github:majutsushi/tagbar',
        \], {'auto_install' : -1})
  else
	"echo "default"
  endif
endfun

	"\'github:Lokaltog/vim-powerline',
	"\'github:Lokaltog/vim-easymotion',
	"\'AsyncCommand', - requires +clientserver
	"\'github:Valloric/YouCompleteMe',
	"\'github:ervandew/supertab',
        "\'github:gcmt/wildfire.vim',
        "'taglist',
"
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

"find C symbol
nmap g<C-\> :cs find s <C-R>=expand("<cword>")<CR><CR>  
"find this definition 
nmap g<C-]> :cs find g <C-R>=expand("<cword>")<CR><CR>  

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

"******************************************************************************
"              Main
"******************************************************************************
nnoremap ; :
let mapleader = ","  " change the mapleader from \ to ,
:imap jk <Esc>

nnoremap <silent> <leader>ev :e $MYVIMRC<cr>
nnoremap <silent> <leader>ed :e ~/Dropbox/Draft/vim.md<cr>
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>

" underline current line with =
nnoremap <leader>1 yypVr=
nnoremap <leader>2 yypVr-

" Provide buffer delete which does not close the window
nnoremap <leader>d :bp<bar>sp<bar>bn<bar>bd<CR>

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

"**** Needed also for Powerline ************
"using the python installer, not the vim-plugin manager
"source ~/.vim/vim-addons/github-Lokaltog-powerline/powerline/ext/vim/source_plugin.vim
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs
set t_Co=256 " Explicitly tell Vim that the terminal supports 256 colors


" run VAM package manger
let g:additional_addon_dirs = ['/home/assaf/.vim/manual-addons']
call SetupVAM()

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

" Viewing  *******************************************************************
set cursorline 	" highlight current line
set nowrap 	" no line wrapping
set number 	" turn on line numbers
nnoremap <silent> <leader>n :set number! number?<cr>
set numberwidth=4 " We are good up to 9999 lines
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

" Colorscheme **************
let g:solarized_termtrans = 1
if has('gui_running')
    set background=light
else
    set background=dark
endif
"colorscheme solarized
"colorscheme evening
"colorscheme fog2
colorscheme simple256
highlight DiffAdd term=reverse cterm=bold ctermbg=green ctermfg=white 
highlight DiffChange term=reverse cterm=bold ctermbg=cyan ctermfg=black 
highlight DiffText term=reverse cterm=bold ctermbg=gray ctermfg=black 
highlight DiffDelete term=reverse cterm=bold ctermbg=red ctermfg=black


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

" use k in normal mode to add blank line below this line
nnoremap K 0i<C-M><ESC>k
" Press Ctrl-J whenever you want to split a line
nnoremap <leader>j i<CR><ESC>k$
" Copy full pathname of current buffer to the unmamed register
nnoremap cpp :let @" = expand("%") . ":" . line(".") . ":" . getline(".")<CR>

set nobackup		" no backup files
set noswapfile		" nor swapfiles
set history=1000        " remember more commands and search history
set undolevels=1000     " use many muchos levels of undo
set title               " change the terminal's title (no effect under tmux / gui)

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

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

" Command-T config ********************************************
" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>
let g:CommandTFileScanner="find"
let g:CommandTMaxFiles=50000
nnoremap <leader>f :CommandTFlush<cr>\|:CommandT<cr>
nnoremap <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
" The below does not work. Use Ctrl-p?
" nnoremap <silent> <Leader>c :CommandTTag<CR>
" Command-T uses vim's wildignore to set a comma seperated list of globs to ignore in listings
set wildignore+=*.o,*.obj,.git,.svn

" Build and run go program hello.go on specific tmux window
nnoremap <F5> :silent !tmux send-keys -t 'kernel-dev':go.1 'go run golang_tour.go' C-m <CR>

