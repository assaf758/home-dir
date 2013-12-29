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
        python from powerline.ext.vim import source_plugin; source_plugin()
  elseif xx ==# "hlinux\n"
	call vam#ActivateAddons(['Conque_Shell',
	\'Solarized','github:wincent/Command-T','github:benmills/vimux','github:mileszs/ack.vim',
	\'github:godlygeek/tabular','github:wesleyche/SrcExpl','github:Lokaltog/vim-powerline',
	\'github:bernh/pss.vim','renamer','github:Lokaltog/vim-easymotion','github:flazz/vim-colorschemes',
	\], {'auto_install' : -1})
  else
	"echo "default"
  endif
endfun

" Cscope **********************************************************************
func! Cscope()
if has("cscope")
	set csprg=/usr/bin/cscope
	set csto=0
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable("cscope.out")
	    cs add cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
	    cs add $CSCOPE_DB
	endif
	set csverb
endif

map g<C-]> :cs find c <C-R>=expand("<cword>")<CR><CR>  "find calling functions
map g<C-\> :cs find s <C-R>=expand("<cword>")<CR><CR>  "find C symbol

nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-_>i :cs find i <C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
endfunc!

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
nnoremap <silent> <leader>sv :source $MYVIMRC<cr>

" underline current line with =
nnoremap <leader>1 yypVr=
nnoremap <leader>2 yypVr-

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

"**** Solorized config **************
let g:solarized_termtrans = 1
if has('gui_running')
    set background=light
else
    set background=dark
endif
"colorscheme solarized
colorscheme evening

" Searching *******************************************************************
set hlsearch   " highlight search
set incsearch  " incremental search, search as you type
set ignorecase " Ignore case when searching
set smartcase  " Ignore case when searching lowercase
nmap \q :nohlsearch<CR>

" Viewing  *******************************************************************
set cursorline 	" highlight current line
set nowrap 	" no line wrapping
set number 	" turn on line numbers
set numberwidth=4 " We are good up to 9999 lines
syntax enable

" tabs & indentation
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=8  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set smarttab      " insert tabs on the start of a line according to
                  " shiftwidth, not tabstop

" toggle showing of whitespace chars
nnoremap <leader>sp :set list! list?<cr>
set listchars=tab:→\ ,trail:·,nbsp:·,eol:¬

set hidden	" allow switching from unsaved buffer

" Solve paste issue
nnoremap \<F2> :set invpaste paste?<CR>
set pastetoggle=\<F2>
set showmode

set backspace=indent,eol,start  " backspace through everything in insert mode

" Use K in normal mode to add blank line below this line
nnoremap K 0i<C-M><ESC>k

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

"quick-fix mappings of for cprev/cnext
nnoremap <a-.> :cnext<CR>
nnoremap <a-,> :cprev<CR>

call Cscope() " Do cscope config

" Command-T config ********************************************
" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

map <leader>f :CommandTFlush<cr>\|:CommandT<cr>
map <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>

