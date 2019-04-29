" Gvim configuration file
" Maintainer:	Jackie CAI <caihuaqin@126.com>
" Last change:	2019 Mar 18
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"     for MS-DOS and Win32:  $VIM\_vimrc
"
" When started as "evim", evim.vim will already have done these settings.

if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

"set t_Co = 256

" In many terminal emulators the mouse works just fine.  By enabling it you
" can position the cursor, Visually select and scroll with the mouse.
if has('mouse')
  set mouse=""  " diable mouse
endif

" Switch syntax highlighting on when the terminal has colors or when using the
" GUI (which always has colors).
if &t_Co > 2 || has("gui_running")
  " Revert with ":syntax off".
  syntax on

  " I like highlighting strings inside C comments.
  " Revert with ":unlet c_comment_strings".
  let c_comment_strings=1
endif


" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":augroup vimStartup | au! | augroup END"
  augroup vimStartup
    au!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif

  augroup END

endif " has("autocmd")

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If set (default), this may break plugins (but it's backward
  " compatible).
  set nolangremap
endif

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" Function to redirect EX command outputs to a new window 
function! RedirMessages(msgcmd, destcmd)
"
" Captures the output generated by executing a:msgcmd, then places this
" output in the current buffer.
"
" If the a:destcmd parameter is not empty, a:destcmd is executed
" before the output is put into the buffer. This can be used to open a
" new window, new tab, etc., before :put'ing the output into the
" destination buffer.
"
" Examples:
"
"   " Insert the output of :registers into the current buffer.
"   call RedirMessages('registers', '')
"
"   " Output :registers into the buffer of a new window.
"   call RedirMessages('registers', 'new')
"
"   " Output :registers into a new vertically-split window.
"   call RedirMessages('registers', 'vnew')
"
"   " Output :registers to a new tab.
"   call RedirMessages('registers', 'tabnew')
"
" Commands for common cases are defined immediately after the
" function; see below.
"
    " Redirect messages to a variable.
    "
    redir => message

    " Execute the specified Ex command, capturing any messages
    " that it generates into the message variable.
    "
    silent execute a:msgcmd

    " Turn off redirection.
    "
    redir END

    " If a destination-generating command was specified, execute it to
    " open the destination. (This is usually something like :tabnew or
    " :new, but can be any Ex command.)
    "
    " If no command is provided, output will be placed in the current
    " buffer.
    "
    if strlen(a:destcmd) " destcmd is not an empty string
        silent execute a:destcmd
    endif

    " Place the messages in the destination buffer.
    "
    silent put=message

endfunction

" Create commands to make RedirMessages() easier to use interactively.
" Here are some examples of their use:
"
"   :BufMessage registers
"   :WinMessage ls
"   :TabMessage echo "Key mappings for Control+A:" | map <C-A>
"
command! -nargs=+ -complete=command BufMessage call RedirMessages(<q-args>, ''       )
command! -nargs=+ -complete=command WinMessage call RedirMessages(<q-args>, 'new'    )
command! -nargs=+ -complete=command TabMessage call RedirMessages(<q-args>, 'tabnew' )


" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler	    	" show the cursor position all the time
set showcmd	     	" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

set number      " show line number
set noautochdir " do not change directory when open files, buffers
set nobackup
set noswapfile
set nowrap      " do not wrap long lines
set hlsearch    " hilight search
set ignorecase  " search case insensitive
set smartcase   " When 'ignorecase' and 'smartcase' are both on, if a pattern contains an uppercase letter, it is case sensitive, otherwise, it is not. For example, /The would find only "The", while /the would find "the" or "The" etc.
" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif
set nowrapscan  " do not wrap around for search
set showmatch   " show matching bracket
set autoindent
set smartindent
set tabstop=4
set clipboard+=unnamed  " share the default registers with system clipboard
set noundofile          " no persistent undo file: .un~
set laststatus=2        " last window always has a status line
set statusline=%F\ %h%w%m%r\ %=%{getcwd()}\ %=%(%l,%c%V\ %=\ %P%)
set foldmethod=syntax   " enable foldering by Syntax
set foldnestmax=20      "
set nofoldenable        " no fold when open a file
set foldlevel=10        " 
set cursorline
set splitbelow          " new window locates below
set splitright          " new window locates right 

" foldmethod for vim file is marker
autocmd FileType vim setlocal foldmethod=marker

" open all folds when open a file
"autocmd BufRead * normal zR

colorscheme tomorrow-night

if has("gui_running")
"    colorscheme tomorrow-night
    set mousehide		" Hide the mouse when typing text, only works in GUI
    set guioptions-=T   " Hide Toolbar
    set guioptions-=m   " Hide Menubar
    set guioptions-=L
    set guioptions-=r
    set guioptions-=b
    set guioptions-=e   " default tab style instead of gui style
    if has("gui_win32")
        set guifont=Consolas:h12:cANSI
    else
  
    endif
endif

" set third party programs path into PATH before Windows dir, in case GNU
" win32 has the same program as Windows, it will take in advance
let thirdpartypath=$HOME.'/.vim/'.'thirdparty'
let $PATH=thirdpartypath.':'.$PATH
let ctagspath=thirdpartypath.'/'.'ctags'
let $PATH=ctagspath.':'.$PATH
let cscopepath=thirdpartypath.'/'.'cscope'
let $PATH=cscopepath.':'.$PATH

" key mappings
let mapleader=" "          " one space as the map leader
"nmap <C-tab>               :bn <CR>
nmap <leader>e             :e $MYVIMRC <CR>
nmap <silent> <leader>cmd  :!start cmd /k cd %:p:h<cr>  " open a CMD under the current directory
" open a terminal under the current directory
nmap <leader>term          :let $VIM_DIR=expand('%:p:h')<CR> :terminal<CR>cd $VIM_DIR<CR>
nmap <leader>git           :!start "c:\Program Files\Git\git-bash.exe" <cr>  " open a git shell under the current directory
nmap <leader>gitext        :!start "c:\Work\Tools\GitExtensions\GitExtensions.exe" <CR>  " open git extension gui
nmap <leader>h             :nohlsearch<CR>  " clear highlights after search
nmap <leader>cd            :cd %:p:h<CR>    " change to the directory of the currently open file for all windows
nmap <leader>lcd           :lcd %:p:h<CR>   " change to the directory of the currently open file for the current window
nmap <leader>bd            :bd <CR>         " close the current buffer, buffer is put into unlisted list
nmap <leader>bw            :bw <CR>         " close the current buffer, buffer is swiped
nmap <leader>co            :copen <CR>         " open quickfix window
nmap <leader>cn            :cnext <CR>         " jump to next error
nmap <leader>cp            :cprevious <CR>     " jump to previous error

" move cursor in INSERT mode: alt + direction key
"inoremap <M-j> <Down>
"inoremap <M-k> <Up>
"inoremap <M-h> <left>
"inoremap <M-l> <Right>

" Don't use Ex mode, use Q for formatting.
" Revert with ":unmap Q".
"map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

function! AddSearchPath()
    silent !clear
	let thiscwd = getcwd()
    let searchpath=substitute(thiscwd, '\', '/', 'g')
	let allpath=searchpath."/**"
	" pass the current working directory as the argument to the option 'path'
   let &path='.,' . allpath 
endfunction
" add the current working directory as search path for 'gf' etc.
nmap <silent><leader>path         :call AddSearchPath() <CR>

" Plugins {{{
" ------Netrw ------- {{{
" Netrw
"let g:netrw_liststyle=3  " View type is Tree
"autocmd FileType netrw setl bufhidden=delete "wipe
"nmap <F10> :Lexplore <cr> 
" }}} end of Netrw

" ------NERDTree ------- {{{
let g:NERDTreeQuitOnOpen = 1 "automatically close NerdTree when you open a file
let g:NERDTreeWinPos = "right"
map <leader>o :NERDTreeFind <cr>   " View the current buffer in NERDTree
nmap <F10>    :NERDTreeToggle <cr> 

" Check if NERDTree is open or active
"function! s:IsNERDTreeOpen()        
"  return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName) != -1)
"endfunction
"
"" Call NERDTreeFind iff NERDTree is active, current window contains a modifiable
"" file, and we're not in vimdiff
"function! s:SyncTree()
"  if &modifiable && s:IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
"    NERDTreeFind
"   " wincmd p   " switch cursor back to previous window
"  wincmd l   " assume the NERDTree is on the left side by default
"  endif
"endfunction

" Highlight currently open buffer in NERDTree
"autocmd BufEnter * call s:SyncTree()

" }}} end of NERDTree 

" ------Ctags ------- {{{
set tags=./tags;,tags;         " look for "tags" file in the current directory and working directory then upward until "/"(root directory); 

function! CreateCtags()
    silent !clear
	let s:cwd = getcwd()
	" pass the current working directory as the argument to the batch file
    execute "!start cmd /k create_ctags.sh " . s:cwd 
endfunction

" Be sure to set the current working directory(:cd xxx) to the root of the source code project before the operation
"autocmd BufWritePost !start cmd /k create_ctags.bat        " update ctags file in the background once the source code is modified
noremap <leader>ctags :call CreateCtags()<CR>  " Create ctags file in the background mannually
" }}} end of Ctags

" ------Cscope ------- {{{
set cscopetag   " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t' and search cscope tag first
set csto=0      " check cscope for definition of a symbol before checking ctags: set to 1, if you want the reverse search order.
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-,g-,f-   " enable quickfix for cscope, note that this will automatically jump to 1st match all the time

function! CreateCscopeTags()
    silent !clear
	let s:cwd = getcwd()
	" pass the current working directory as the argument to the batch file
    execute "term create_cscopetags.sh " . s:cwd
    "execute "!xterm bash create_cscopetags.sh " . s:cwd
endfunction

" Be sure to set the current working directory(:cd xxx) to the root of the source code project before the operation
"autocmd BufWritePost !start cmd /k create_cscopetags.bat     " update cscope tags file in the background once the source code is modified
" update cscope tags file mannually
nmap <leader>css :call CreateCscopeTags()<CR>
nmap <leader>csa :cs add cscope.out <CR>                      " Add the cscope database
nmap <leader>cfa :cs find a <C-R>=expand("<cword>")<CR><CR>	  " Find assignments to symbol under cursor *
nmap <leader>cfc :cs find c <C-R>=expand("<cword>")<CR><CR>	  " Find functions calling function under cursor *
nmap <leader>cfd :cs find d <C-R>=expand("<cword>")<CR><CR>   " Find functions called by function under cursor *
nmap <leader>cfe :cs find e <C-R>=expand("<cword>")<CR><CR>	  " Find egrep pattern under cursor
nmap <leader>cff :cs find f <C-R>=expand("<cfile>")<CR><CR>	  " Find this file *
nmap <leader>cfg :cs find g <C-R>=expand("<cword>")<CR><CR>	  " Find defintion under cursor *
nmap <leader>cfi :cs find i <C-R>=expand("<cfile>")<CR><CR> " Find files #include this file *
nmap <leader>cfs :cs find s <C-R>=expand("<cword>")<CR><CR>	  " Find symbol under cursor *
nmap <leader>cft :cs find t <C-R>=expand("<cword>")<CR><CR>	  " Find text string under cursor
" }}} end of Cscope

" ------Tagbar ------- {{{
let g:tagbar_left=1            " tagbar windown locates on the left
let g:tagbar_autofocus=1       " cursor will move to tagbar window when it's opened
let g:tagbar_autoclose=1       " close tagbar automatically when selected one tag
nmap <F8> :TagbarToggle <cr> 
" }}}  end of Tagbar
"
" ------gitgutter ------- {{{
" The delay is governed by vim's updatetime option; the default value is 4000, i.e. 4 seconds, but I suggest reducing it to around 100ms
set updatetime=100
" define key mapping to show all changes in the buffer
nmap <C-F10> :GitGutterFold <cr>
" }}}
"
" }}}  end of Plugins

