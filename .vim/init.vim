if !has('nvim')
  set nocompatible
endif 

filetype plugin indent on   " load plugins and set indentation per file type
" syn on

fun! SetupPlug()
call plug#begin('~/.config/nvim/plugged')
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
" Plug 'terryma/vim-expand-region'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Lokaltog/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'machakann/vim-highlightedyank'

Plug 'rbgrouleff/bclose.vim' " required by ranger.vim
Plug 'francoiscabrol/ranger.vim'

Plug 'tpope/vim-vinegar'
Plug 'wesleyche/SrcExpl'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'bbchung/gtags.vim'
Plug 'assaf758/gtags-cscope' "forked from 'multilobyte/gtags-cscope' to hide failure to find gtag file
Plug 'mhinz/vim-grepper'
Plug 'kana/vim-altr'

Plug 'tpope/vim-fugitive'
Plug 'jreybert/vimagit'
Plug 'tpope/vim-rhubarb'

Plug 'majutsushi/tagbar'
Plug 'moll/vim-bbye'
Plug 'bogado/file-line'
Plug 'benekastah/neomake'
Plug 'skywind3000/asyncrun.vim'
Plug 'godlygeek/tabular'
Plug 'wellle/targets.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-rsi'
Plug 'benmills/vimux'
Plug 'tpope/vim-repeat'
Plug 'wincent/terminus'
Plug 'kopischke/vim-fetch'
Plug 'lambdalisue/suda.vim'

" Plug 'airblade/vim-rooter'

" Plug 'roxma/nvim-yarp'
" Plug 'ncm2/ncm2'
" Plug 'ncm2/ncm2-pyclang'
" Plug 'ncm2/ncm2-jedi'
" Plug 'ncm2/ncm2-ultisnips'
" Plug 'ncm2/ncm2-bufword'
" Plug 'ncm2/ncm2-path'
" Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }

" Plug 'natebosch/vim-lsc'
" Plug 'ajh17/VimCompletesMe'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'm-pilia/vim-ccls'

Plug 'vim-scripts/renamer.vim'
Plug 'Olical/vim-enmasse'
Plug 'vim-scripts/ReplaceWithRegister'

" consider with later version of neovim, or keep lightline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'itchyny/lightline.vim'

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'NLKNguyen/papercolor-theme'
Plug 'flazz/vim-colorschemes'

Plug 'NLKNguyen/c-syntax.vim'
" Plug 'justinmk/vim-syntax-extra'
Plug 'aklt/plantuml-syntax'
" taskpaper syntax and todo handling
Plug 'davidoc/taskpaper.vim'

" markdown
" using my own fork, for trying to solve toc md support
" Plug 'mzlogin/vim-markdown-toc'
Plug 'assaf758/vim-markdown-toc'
Plug 'vim-voom/VOoM'
" Plug 'plasticboy/vim-markdown'
Plug 'jtratner/vim-flavored-markdown'
" support for restructuredtext. riv.vim has an issue when pressing enter
Plug 'coddingtonbear/riv.vim'
Plug 'Rykka/InstantRst'

"messes view - create lcd 
" dont create lcd in views in ~/.local/share/nvim/view/
" https://stackoverflow.com/questions/18205941/fold-settings-seem-to-screw-up-vims-pwd-in-certain-circumstances
Plug 'kopischke/vim-stay'

" until pr https://github.com/vimwiki/vimwiki/pull/296 (for markdown toc) is accepted
Plug 'vimwiki/vimwiki', {'branch' : 'dev'}
"Plug 'mzlogin/vimwiki'

Plug 'simnalamburt/vim-mundo'

" retry with later version of neovim
" Plug 'Shougo/unite.vim'
" Plug 'hewes/unite-gtags'

Plug 'kynan/dokuvimki', {'on': 'DokuVimKi'}

" disabled due to bug in ruby interation (i raised on neovim)
" Plug 'LustyJuggler'


function! RunPython(match)
  python print vim.eval("a:match")*3
  return ""
endfunction
" the below will run the python function on every line mathing aaa
" :%s/aaa\(.*\)/\=submatch(0) . RunPython(submatch(1))


call plug#end()
endfun

function! Layout_for_log()
    " execute "vertical" (winwidth(0)-10)."split"
    execute "vertical" (31)."split"
    setlocal virtualedit=all " global config
    " left window config
    0
    set scrollbind
    " right window config
    wincmd l
    set scrollbind
    set nostartofline
    set norelativenumber
    set nonumber
endfunction
command! -bar LayoutLog call Layout_for_log()

function! LayoutCoding()
    topleft split
    only
    set noscrollbind
    set virtualedit=
    set startofline
    set number
    set relativenumber
    copen
    resize 10
    set norelativenumber
    set number
    wincmd k
endfunction
command! -bar LayoutCoding call LayoutCoding()

" fun! ShowMaps2()
" redir! > ~/vim_maps.txt
" verbose map
" verbose map!
" redir END
" e ~/vim_maps.txt
" endfun!

function! ShowMaps()
  let old_reg = getreg("a")          " save the current content of register a
  let old_reg_type = getregtype("a") " save the type of the register as well
  try
      redir @a                           " redirect output to register a
      " Get the list of all key mappings silently, satisfy "Press ENTER to continue"
      silent map | call feedkeys("\<CR>")    
      redir END                          " end output redirection
      vnew                               " new buffer in vertical window
      put a                              " put content of register
      " Sort on columns 1-14 as keys
      %!sort --key=1,14                  
  finally                                " Execute even if exception is raised
      call setreg("a", old_reg, old_reg_type) " restore register a
  endtry
endfunction
command! -bar ShowMaps call ShowMaps()

function! SetMarkdownOptions()
    setlocal ts=2
    setlocal filetype=ghmarkdown
    setlocal spell
    silent loadview
endfunction

" Cscope **********************************************************************
func! Cscope()
    if has("cscope")
        let g:GtagsCscope_Auto_Load = 1
        " let g:GtagsCscope_Auto_Update = 1 // block ui
        set nocsverb
        set csverb
        if has('quickfix')
            set cscopequickfix=s-,c-,d-,i-,t-,e-
        endif
        " set csprg=gtags-cscope
        " set cst       " <C-]> will use both cscope and ctag results
        " set csto=0    " Search defintion in cscope first , and if nothing found search tag
        " add any database in current directory
        " if filereadable("cscope.out")
        "     cs add cscope.out
        " " else add database pointed to by environment
        " elseif $CSCOPE_DB != ""
        "     cs add $CSCOPE_DB
        " endif

        " let g:gutentags_modules = ['gtags_cscope']
        " let g:gutentags_project_root = ['file_list.in']

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
    endif
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

function! s:get_visual_selection()
" Why is this not a built-in Vim script function?!
let [lnum1, col1] = getpos("'<")[1:2]
let [lnum2, col2] = getpos("'>")[1:2]
let lines = getline(lnum1, lnum2)
let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
let lines[0] = lines[0][col1 - 1:]
return join(lines, "\n")
endfunction

function! Append_register_clipboard()
let @+ = @+."\n".s:get_visual_selection()
endfunction

"              Main
"******************************************************************************
call SetupPlug()

let layout = system("layout.sh")
" change the mapleader from \ to <space>
let mapleader = "\<space>"

let g:ycm_server_keep_logfile = 1
let g:ycm_server_log_level = 'debug'

"if layout ==# "us(workman)\n"
if 1
nmap ; :
vmap ; :
"with this remapping I lost commands t,e,k
"left/right is done with h/t
noremap t l
noremap n j
noremap e k
" noremap h - unneeded - h is used the same (qwerty/workman) for left move

" use k/K to search next
nnoremap k n
nnoremap K N
" search keyword under cursor using kyeword program
noremap <leader> K
" Use E in normal mode to add blank line above the current line
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
" Use K in normal mode to add blank line above the current line
"nnoremap <silent>K call feedkeys("O\<Ctrl-[>")
let @o="O"
nnoremap <silent>K @o

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
endif

nnoremap <silent> <leader>Ev :e $MYVIMRC<cr>
nnoremap <silent> <leader>Ed :e ~/Dropbox/Draft/vim.txt<cr>
nnoremap <silent> <leader>Eb :e ~/.bashrc<cr>
nnoremap <silent> <leader>Sv :source $MYVIMRC<cr>
nnoremap <silent> <leader>map :silent call ShowMaps()<cr>
nnoremap <silent> <leader>w :w<cr>
nnoremap <silent> <leader>4 :resize 40<cr>
nnoremap <silent> <leader>cd :cd $IGZ_ZEEK \| :pwd<cr>

nnoremap <silent> <leader>cd :cd $IGZ_ZEEK \| :pwd<cr>
nnoremap <silent> <leader>H :LayoutCoding<CR>
nnoremap <silent> <leader>H1 :copen \| :resize 10 \| :wincmd k<cr>
nnoremap <silent> <leader>H2 :copen \| :resize 10 \| :wincmd k \| :vsplit<cr>
nnoremap <Leader>log :LayoutLog<CR>

nnoremap <Leader>tab :Tabularize \,<CR>

nnoremap Y y$

" Once you select one or more files, press enter and ranger will quit again and vim will open the selected files.
let g:ranger_map_keys = 0
nnoremap <silent> <leader>ra :Ranger<CR>

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

copen
wincmd k

" underline current line with =
nnoremap <leader>1 yypVr=
nnoremap <leader>2 yypVr-

" Toggle hex mode
nnoremap <Leader>qm :Hexmode<CR>

"Copy & paste to system clipboard with <Space>p and <Space>y:
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" disable mapping of bclose (blcose is only needed for ranger plugin)
let g:bclose_no_plugin_maps = 1
" Provide buffer delete which does not close the window
nnoremap <leader>Bd :Bdelete<CR>
nnoremap <leader>BD :Bdelete!<CR>


nnoremap <leader>bF :%!fgrep '<c-r>=expand("<cword>")<cr>'
nnoremap <leader>bf :%!fgrep '<c-r>+'<CR>

" Fast buffer selection
" nnoremap <leader>B :ls<CR>:pwd<CR>:b<Space>

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
set inccommand=nosplit "show effects of command as you type
set ignorecase " Ignore case when searching
set smartcase  " Ignore case when searching lowercase
nnoremap <silent> <leader>qh :nohlsearch<CR>

" Colorscheme **************
set fillchars+=vert:\ 

let g:gruvbox_vert_split='gray'

let g:gruvbox_italic=1
colorscheme gruvbox
set background=dark


" Cursor *******************************************************************
set cursorline 	" highlight current line
highlight Cursor guifg=white guibg=black
highlight iCursor guifg=white guibg=steelblue

" turn on 24bit colors
set termguicolors
" cursor shape at input mode
set guicursor=n-v:block-Cursor/lCursor-blinkon0,i-ci-c:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor


" Viewing  *******************************************************************
" turn on line numbers, relative
call LayoutCoding()
autocmd InsertEnter * :set number
autocmd InsertLeave * :set relativenumber
nnoremap <silent> <leader>n0 :set nonumber \| set nornu <cr>
nnoremap <silent> <leader>nn :set number \| set rnu!<cr>
nnoremap <silent> <leader>nr :set number \| : set rnu<cr>

" markdown syntax
hi link markdownError Normal  

" append to clipboard register
vnoremap <silent> <leader>ya+ :call Append_register_clipboard()<cr>

" turn on spell-checker for md files
autocmd BufRead,BufNewFile *.c,*.h,*.py setlocal spell
" complete from speller when doing ctrl-p/n 
set complete+=kspell
" ignore words that looks like code symbol
syn match myExCapitalWords +\<\w*[_0-9A-Z-]\w*\>+ contains=@NoSpell
" dont warn on sentence starting with non-capital letter
set spellcapcheck= 

" " automatically save/restore code block folds
" Useful for my Quick Notes feature in my tmuxrc
" augroup Notes
"     au BufWritePost,BufLeave,WinLeave ?* mkview
"     au BufReadPre ?* silent loadview
" augroup END
" au BufWinLeave * mkview
" au BufWinEnter * silent loadview<Paste>

"disabled due to some nvim bug
" autocmd BufWritePost *.py :Neomake flake8

"airline
let g:airline_powerline_fonts = 1



augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown call SetMarkdownOptions()
    au BufWinLeave *.md,*.markdown mkview
augroup END

set numberwidth=5 " We are good up to 99999 lines
nnoremap <leader>G :echo expand('%:p')<cr>
syntax enable
nnoremap <silent> <leader>qs :if exists("g:syntax_on") <Bar>
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



" tabs & indentation
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set smarttab      " insert tabs on the start of a line according to shiftwidth, not tabstop
set expandtab	  " Always expand tabs to corresponding number of spaces
set tabstop=4     " size of a hard tabstop char

" SuperRetab 8 - Change each 8 spaces to one tab. works on ranges.
:command! -nargs=1 -range SuperRetab <line1>,<line2>s/\v%(^ *)@<= {<args>}/\t/g

" toggle showing of whitespace chars
nnoremap <leader>qsp :set list! list?<cr>
set listchars=tab:→\ ,trail:·,nbsp:·,eol:¬

"""""""""""""""""""""
" edit config
"""""""""""""""""""""

" Solve paste issue
nnoremap \<F2> :set invpaste paste?<CR>
set pastetoggle=\<F2>
set showmode

set backspace=indent,eol,start  " backspace through everything in insert mode

" use gp to select last changed test (pasted or not), with same selection type
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'
" Press <leader>J  whenever you want to split a line
nnoremap <leader>J i<CR><ESC>k$

nnoremap - ddj0P
nnoremap _ dd<c-p>0P

imap <c-u> <esc>viwUi
nmap <c-u> viwU

" Echo current buffer's Full Pathname to the vim command line or clipboard
nnoremap <leader>efp :echo expand("%:p")<CR>
nnoremap <leader>cfp :let @+=expand("%:p")<CR>
" Echo current buffer's relative Pathname to the vim command line or clipboard
nnoremap <leader>erp :echo expand("%")<CR>
nnoremap <leader>crp :let @+=expand("%")<CR>
" Echo current buffer's Filename (tail) + Line number to the vim command line or clipboard
nnoremap <leader>elp :echo expand("%:t") . ':' . line(".")<CR>
nnoremap <leader>clp :let @+=expand("%:t") . ':' . line(".")<CR>
" Echo current buffer's Filename (tail) to the vim command line or clipboard
nnoremap <leader>enp :echo expand("%:t")<CR>
nnoremap <leader>cnp :let @+=expand("%:t")<CR>

set nobackup            " no backup files
set nowritebackup
set noswapfile		    " nor swapfiles
set history=1000        " remember more commands and search history
set undolevels=1000     " use many muchos levels of undo
set title               " change the terminal's title (no effect under tmux / gui)
set hidden	" allow switching from unsaved buffer
set cmdheight=2 " Better display for messages

" Allow calling sudo (to make file writeable) *after* you have edited the file
cmap w!! w !sudo tee % >/dev/null

"Quickfix (on top of imparied)
nmap [c :colder<CR>
nmap ]c :cnewer<CR>
" Press o (when in quickfix window) to show location without changeing focus
autocmd FileType qf nnoremap <buffer> o <CR><C-W><C-P>

call Cscope() " Do cscope config
"Configure Tagbar winodw display/hide
nnoremap <F9> :TagbarToggle<CR>
nnoremap <F8> :UndotreeToggle<cr>
nnoremap <F7> :VoomToggle markdown<cr>
nnoremap <F5> :AsyncRun make -C build/x86_64/Debug -j 6<cr>
nnoremap <F4> :MundoToggle<CR>
" Build and run go program hello.go on specific tmux window
" nnoremap <F5> :silent !tmux send-keys -t 'kernel-dev':go.1 'go run golang_tour.go' C-m <CR>

"undotree
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif

"vimwiki
let g:vimwiki_list = [{
    \ 'path': '~/Drive/assaf758@gmail.com/wiki',
    \ 'index': 'Home',
    \ 'syntax': 'markdown',
    \ 'ext': '.md',
    \ 'markdown_toc' : 1,
    \ 'auto_toc':1, 
    \ 'path_html': '~/wiki_site',
    \ 'custom_wiki2html': '~/scripts/wiki2html.sh'
    \ }]

:nmap <Leader>sw  <Plug>VimwikiIndex
:nmap <Leader>sdi <Plug>VimwikiDiaryIndex
:nmap <Leader>sd  <Plug>VimwikiMakeDiaryNote
:nmap <Leader>sdy <Plug>VimwikiMakeYesterdayDiaryNote
:nmap <Leader>sgr <Plug>VimwikiDiaryGenerateLinks
:nmap <Leader>st <Plug>VimwikiToggleListItem
:vmap <Leader>st <Plug>VimwikiToggleListItem
:nmap <Leader>sD <Plug>VimwikiDeleteLink
:nmap <Leader>sR <Plug>VimwikiRenameLink
:nmap <Leader>sz <Plug>VimwikiTabIndex
:nmap <Leader>sxxx1 <Plug>VimwikiUISelect
:nmap <Leader>sxxx2 <Plug>VimwikiGoto
let vimwiki_prevent_cr_remap = 1
let g:vimwiki_global_ext = 0
let g:vimwiki_folding = 'expr'
let g:vimwiki_auto_chdir = 0
let g:vimwiki_url_maxsave = 0

"folding
set viewoptions=cursor,folds,slash,unix

" netrw
"let g:netrw_keepdir=0  " let vim cdr follow netrw browser dir
" use gc to change vim cwd to the nerw dir


" neomake
nnoremap <leader>m :Neomake<cr>
 let &makeprg = 'make'

" bookmarks
highlight SignColumn ctermbg=black

" LustyJuggler
let g:LustyJugglerSuppressRubyWarning = 1

" double percentage sign in command mode is expanded
" to directory of current file - http://vimcasts.org/e/14
cnoremap %% <C-R>=expand('%:h').'/'<cr>

" FZF
"***********

" function! FzfWA()
"     only
"     copen
"     wincmd k 
"     resize 35
" endfunction
" nnoremap <silent> <leader>b :Buffers<cr> :call FzfWA()<CR>
" nnoremap <silent> <leader>f :execute 'Files' <bar> :call !FzfWA()<CR>
" let g:fzf_layout = { 'window': 'execute (tabpagenr()-1)."tabnew"' }

" nnoremap <leader>b :Buffers<cr> " disabled for now, using history <leader>h
nnoremap <leader>F :Files ../../..<cr>
nnoremap <leader>f :Files<cr>
nnoremap <leader>T :Tags<cr>
nnoremap <leader>e :History<cr>
nnoremap <leader>l :Lines<cr>
let $FZF_DEFAULT_COMMAND = 'ag -f --skip-vcs-ignores  -l -g ""'


" fugitive bindings
" nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gre :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>gau :Git add -u<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gl :Git! log --oneline<CR>
nnoremap <leader>gcf yiw <ESC>:Git commit --fixup=<C-r>"<CR>

" nnoremap <space>ga :Git add %:p<CR><CR>
" nnoremap <space>gs :Gstatus<CR>
" nnoremap <space>gc :Gcommit -v -q<CR>
" nnoremap <space>gt :Gcommit -v -q %:p<CR>
" nnoremap <space>gd :Gdiff<CR>
" nnoremap <space>ge :Gedit<CR>
" nnoremap <space>gr :Gread<CR>
" nnoremap <space>gw :Gwrite<CR><CR>
" nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
" nnoremap <space>gp :Ggrep<Space>
" nnoremap <space>gm :Gmove<Space>
" nnoremap <space>gb :Git branch<Space>
" nnoremap <space>go :Git checkout<Space>
" nnoremap <space>gps :Dispatch! git push<CR>
" nnoremap <space>gpl :Dispatch! git pull<CR>

"Vim-sneak
let g:sneak#s_next = 1

"Grepper
nnoremap <leader>gb :Grepper-buffer<CR>
nnoremap <leader>gr :Grepper<CR>
let g:grepper = {
    \ 'tools': ['pss','ag', 'pcregrep'],
    \ 'pss': {
    \   'grepprg':    'pss',
    \   'grepprgbuf': 'pss --nocolor --nobreak --noheading -u $* $.',
    \   'grepformat': '%f:%l:%m',
    \   'escape':     '\+*^$()[]',
    \ },
    \ 'pcregrep': {
    \   'grepprg':    'pcregrep -Mn',
    \   'grepformat': '%f:%l:%m',
    \   'escape':     '\+*^$()[]',
    \ }
    \}
" example:
" run :Grepper. enter in the pss prompt args, and the regex pattern enclosed in ''
" pss> --cc 'mds_(clear|get|set)_policy_(mount|last_in)'

" Set The Silver Searcher as our grep program
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" bind \ (backward slash) to grep shortcut
" command -nargs=+ -complete=file -bar Ag1 silent! grep! <args>|cwindow|redraw!
" nnoremap \ :Ag1<SPACE>

" open alternative files
nmap <leader>a  <Plug>(altr-forward)
nmap <leader>A  <Plug>(altr-back)
" iguazio 'classes in c' pattern
call altr#remove_all()
call altr#define('%.c','%.h','%_prv.h','%_nv.h', '%_nv_prv.h', '%.cc','%.hh')

" " expand_region 
" call expand_region#custom_text_objects({ 
"       \ "\/\\n\\n\<CR>": 1,  
"       \ 'a]' :1,  
"       \ 'ab' :1,  
"       \ 'aB' :1, 
"       \ 'ii' :0, 
"       \ 'ai' :0, 
"       \ })

" coc config

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300
" don't give |ins-completion-menu| messages.
set shortmess+=c
" always show signcolumns
"
set signcolumn=yes

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~ '\s'
    endfunction

    inoremap <silent><expr> <TAB>
		  \ pumvisible() ? "\<C-n>" :
		  \ <SID>check_back_space() ? "\<TAB>" :
		  \ coc#refresh()
" <CR> to confirm completion
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
" Remap keys for gotos

" conflicts with my config K N
nnoremap <silent> gaa :call <SID>show_documentation()<CR> 

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gre <Plug>(coc-references)

nmap <silent> gcch :CclsCallHierarchy<CR>
nmap <silent> gceh :CclsCalleeHierarchy<CR>
" configured by default:
" nmap <silent> <buffer> o    <Plug>(yggdrasil-toggle-node)
" nmap <silent> <buffer> <cr> <Plug>(yggdrasil-execute-node)
nnoremap <silent> <buffer> q :q<cr>nmap <silent> O <Plug>(yggdrasil-close-node)

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" rtags
let g:rtagsUseLocationList = 0

" magit
let g:magit_discard_untracked_do_delete = 1

" vimux config
let g:VimuxRunnerType = "window"
let g:VimuxUseNearest = 0

""deoplete config
"let g:deoplete#enable_at_startup = 0
"let g:deoplete#sources#clang#libclang_path="/usr/lib64/llvm/libclang.so"
"let g:deoplete#sources#clang#clang_header="/usr/include/clang/"

" rooter
let g:rooter_patterns = ['proj_file_list.in']
let g:rooter_change_directory_for_non_project_files = ''
" let rooter_silent_chdir = 1

" Command-T uses vim's wildignore to set a comma seperated list of globs to ignore in listings
set wildignore+=*.o,*.obj,.git,.svn
set tabstop=4     " size of a hard tabstop char

" plugin language bindings
let g:python_host_prog = '/home/assafb/.pyenv/versions/neovim2/bin/python'
let g:python3_host_prog = '/home/assafb/.pyenv/versions/neovim3/bin/python'
let g:ruby_host_prog = '/home/assafb/bin/neovim-ruby-host'


" disable soft-wrap (run after all plugins have ran)
autocmd VimEnter * set nowrap 
