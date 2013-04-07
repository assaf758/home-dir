set nocompatible | filetype indent plugin on | syn on

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

fun! Hosttype()
  let hostname = system("cat ~/hostname.txt")	
  return hostname 
endfun!

fun! EnsureVamIsOnDisk(plugin_root_dir)
  " windows users may want to use http://mawercer.de/~marc/vam/index.php
  " to fetch VAM, VAM-known-repositories and the listed plugins
  " without having to install curl, 7-zip and git tools first
  " -> BUG [4] (git-less installation)
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
  "if $EMULATOR == "msys
  let xx = Hosttype() 
  if xx ==# "ASSAF-LAP\n"
	echo 1  
	call vam#ActivateAddons(['Solarized',], {'auto_install' : -1})
        inoremap <BS> <c-r>=Backspace()<CR>
  elseif xx ==# "assaf-lap-debian64\n"
 	call vam#ActivateAddons(['Conque_Shell','Solarized','ctrlp'], {'auto_install' : -1})
        python from powerline.ext.vim import source_plugin; source_plugin()
  elseif xx ==# "hlinux\n" 
	call vam#ActivateAddons(['Conque_Shell','Solarized','ctrlp'], {'auto_install' : -1})        
	python from powerline.ext.vim import source_plugin; source_plugin()
  elseif xx ==# "compass\n"
        call vam#ActivateAddons(['Conque_Shell','Solarized','ctrlp'], {'auto_install' : -1})
  else
	echo "default"  
  endif

  " sample: call vam#ActivateAddons(['pluginA','pluginB', ...], {'auto_install' : 0})

  " Addons are put into plugin_root_dir/plugin-name directory
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

"******************************************************************************
"              Main
"******************************************************************************
let mapleader = ","
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

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
    set guifont=Inconsolata\ for\ Powerline\ 14
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


" run package manger
call SetupVAM()

" No beeps
set vb t_vb=

" save swp files in designated dir
set backupdir=~/.vim/tmp,.
set directory=~/.vim/tmp,.


"**** Solorized config **************
let g:solarized_termtrans = 1 
"if has('gui_running')
"    set background=light
"else
"    set background=dark
"endif
colorscheme solarized

" Ctrlp config **********************
let g:ctrlp_cmd = 'CtrlPBuffer'


" Searching *******************************************************************
set hlsearch   " highlight search
set incsearch  " incremental search, search as you type
set ignorecase " Ignore case when searching 
set smartcase  " Ignore case when searching lowercase

set cursorline " highlight current line
set nowrap " no line wrapping
set number " turn on line numbers
set numberwidth=5 " We are good up to 99999 lines
syntax enable
set backspace=indent,eol,start  " backspace through everything in insert mode

:imap jk <Esc>
:imap kj <Esc>

" Solve paste issue

nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode


