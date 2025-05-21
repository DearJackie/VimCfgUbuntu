"
" customized vim configuration file for linux, tested in Ubuntu
" Jackie CAI
" Jul. 5 2024 - Initial version
"
" NOTE:
" According to the help menu (see :help $MYVIMRC), vim will look for a user
" vimrc in specific places.
" It look first for ~/.vimrc and then for ~/.vim/vimrc.
" Vim stops searching after the first one found.
" Vim will set automatically the $MYVIMRC environment variable to the location
" of the vimrc used.

"""""""""""""""""""""""default configuration""""""""""""""""""""""""""""""""""
" load default configuration before doing any customization
" source $VIMRUNTIME/defaults.vim
"
" Thi is a copy of the default vimrc file for v9.1 in Ubuntu, this is to
" ensure consistence.
"
" The default vimrc file.
"
" Maintainer:	The Vim Project <https://github.com/vim/vim>
" Last change:	2023 Aug 10
" Former Maintainer:	Bram Moolenaar <Bram@vim.org>
"
" This is loaded if no vimrc file was found.
" Except when Vim is run with "-u NONE" or "-C".
" Individual settings can be reverted with ":set option&".
" Other commands can be reverted as mentioned below.

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Bail out if something that ran earlier, e.g. a system wide vimrc, does not
" want Vim to use these default values.
if exists('skip_defaults_vim')
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
" Avoid side effects when it was already reset.
if &compatible
  set nocompatible
endif

" When the +eval feature is missing, the set command above will be skipped.
" Use a trick to reset compatible only when the +eval feature is missing.
silent! while 0
  set nocompatible
silent! endwhile

" Allow backspacing over everything in insert mode.
set backspace=indent,eol,start

set history=200		" keep 200 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set wildmenu		" display completion matches in a status line

set ttimeout		" time out for key codes
set ttimeoutlen=100	" wait up to 100ms after Esc for special key

" Show @@@ in the last line if it is truncated.
set display=truncate

" Show a few lines of context around the cursor.  Note that this makes the
" text scroll if you mouse-click near the start or end of the window.
set scrolloff=5

" Do incremental searching when it's possible to timeout.
if has('reltime')
  set incsearch
endif

" Do not recognize octal numbers for Ctrl-A and Ctrl-X, most users find it
" confusing.
set nrformats-=octal

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries.
if has('win32')
  set guioptions-=t
endif

" Don't use Q for Ex mode, use it for formatting.  Except for Select mode.
" Revert with ":unmap Q".
map Q gq
sunmap Q

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
inoremap <C-U> <C-G>u<C-U>

" Only do this part when Vim was compiled with the +eval feature.
if 1

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  " Revert with ":filetype off".
  filetype plugin indent on

  " Put these in an autocmd group, so that you can revert them with:
  " ":autocmd! vimStartup"
  augroup vimStartup
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim), for a commit or rebase message
    " (likely a different one than last time), and when using xxd(1) to filter
    " and edit binary files (it transforms input files back and forth, causing
    " them to have dual nature, so to speak)
    autocmd BufReadPost *
      \ let line = line("'\"")
      \ | if line >= 1 && line <= line("$") && &filetype !~# 'commit'
      \      && index(['xxd', 'gitrebase'], &filetype) == -1
      \ |   execute "normal! g`\""
      \ | endif

  augroup END

  " Quite a few people accidentally type "q:" instead of ":q" and get confused
  " by the command line window.  Give a hint about how to get out.
  " If you don't like this you can put this in your vimrc:
  " ":autocmd! vimHints"
  augroup vimHints
    au!
    autocmd CmdwinEnter *
	  \ echohl Todo |
	  \ echo gettext('You discovered the command-line window! You can close it with ":q".') |
	  \ echohl None
  augroup END

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

"""""""""""""""""""""""customization settings begins""""""""""""""""""""""""""""""""""

" show status bar, indicating different information
set ruler

" show cursor line for current line
set cursorline

" show line number in the left side of the editor
set number

" make sure L is to bottom and H to top
set scrolloff=0

" show column limit
set colorcolumn=80

" to avoid automatical wrapping when editing text
set textwidth=120

" new window locates right
set splitright

" new window locates below 
set splitbelow

" set style of status line
" %F(Full file path)
" %m(Shows + if modified - if not modifiable)
" %r(Shows RO if readonly)
" %<(Truncate here if necessary)
" \ (Space Separator)
" %=(Right align)
" %l(Line number)
" %v(Column number)
" %L(Total number of lines)
" %p(How far in file we are percentage wise)
" %%(Percent sign)
set statusline=%F\ %h%w%m%r\ %=%{getcwd()}\ %=%(Ln:%l/%L,Col:%c%V\ %=\ %P%)

" always show status line
set laststatus=2

" never wrap long lines when displaying long lines
set nowrap

" set tab width
set tabstop=4

" show tab in text, show trailing space
set listchars=tab:>-,trail:.
"set list

" set shift width to to align with tab stops
set shiftwidth=4

" enable file type plugin, indent and auto completion
filetype plugin indent on

" the matching parenthesis for special languages.
" Only character pairs are allowed that are different,
" thus you cannot jump between two double quotes.
set mps+=<:>
" au FileType c,cpp,java set mps+==:;

" ignore case sensitive search by default for / and ?
set ignorecase

" highlight matching results
set hlsearch

" never wrap scanning the searching pattern
set nowrapscan

" enable increament search
set incsearch

" smart ident 
set autoindent
set smartindent

" show matching brackets when typing
set showmatch

" matching time is in n*1/10 seconds
set matchtime=5

" do not change directory when open files, buffers
set noautochdir

" never generate backup file
set nobackup

set noswapfile 

" mamke sure the session file can be used by both windows and unix like system
" never generate swap file
set noswapfile 

" mamke sure the session file can be used by both windows and unix like system
set sessionoptions+=unix,slash

" set the register '+' as the default(unamed), thus each time
" when yank(y) or paste(p), Vim will use system clipboard '+'
if has('clipboard')
  set clipboard=unnamedplus
endif

" enable copy-on-select
"if has('gvim')
"  set setguioptions+=a 
"endif

" enable 'find' recursively in current working directory (pwd)
set path+=**

" enable ripgrep by default, replacing "vim/vimgrep" by "ripgrep", which is much faster
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden
set grepformat=%f:%l:%c:%m

" Enable fzf default vim scripts which located in fzf package, default location by installing from github
" is .fzf
set rtp+=~/.fzf

""""""""""""""""""end of customization setting"""""""""""""""""""""""""""""""""""""""


""""""""""""""""""start of plugin"""""""""""""""""""""""""""""""""""""""
" be sure to install ctags and gtags
"
" customized color scheme by plugins
"colorscheme tomorrow-night
colorscheme elflord  
"
" key mappings
let mapleader=" "          " one space as the map leader
nmap <leader>nb            :bn <CR> " Ctrl-Tab not working in terminal, but can work in Gvim.
nmap <leader>e             :e $MYVIMRC <CR>
let $vimtips_file=fnamemodify($MYVIMRC, ":s?vimrc?vimtips.txt?:p")  
nmap <leader>vt            :e $vimtips_file<CR> " short key to vim tips file
let $linuxtips_file=fnamemodify($MYVIMRC, ":s?vimrc?linuxtips.txt?:p")  
nmap <leader>lt            :e $linuxtips_file <CR> " short key to linux tips file

" open a merminal under the current directory, using "term" command directly
" nmap <leader>term          :let $VIM_DIR=expand('%:p:h')<CR> :terminal<CR>cd $VIM_DIR<CR> 
nmap <leader>h             :nohlsearch<CR>  " clear highlights after search
nmap <leader>cd            :cd %:p:h<CR>    " change to the directory of the currently open file for all windows
nmap <leader>lcd           :lcd %:p:h<CR>   " change to the directory of the currently open file for the current window
nmap <leader>bd            :bd <CR>         " close the current buffer, buffer is put into unlisted list
nmap <leader>bw            :bw <CR>         " close the current buffer, buffer is swiped
nmap <leader>co            :copen <CR>         " open quickfix window
nmap <leader>cc            :cclose <CR>        " close quickfix window
nmap <leader>cn            :cnext <CR>         " jump to next error
nmap <leader>cp            :cprevious <CR>     " jump to previous error

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
" Revert with ":iunmap <C-U>".
" inoremap <C-U> <C-G>u<C-U>

function! AddSearchPath()
    silent !clear
	let thiscwd = getcwd()
    let searchpath=substitute(thiscwd, '\', '/', 'g')
	let allpath=searchpath."/**"
	" pass the current working directory as the argument to the option 'path'
   let &path='.,' . allpath 
endfunction
" add the current working directory as search path for 'gf' etc.
nmap <leader>path         :call AddSearchPath() <CR>

" ------NERDTree ------- {{{
let g:NERDTreeQuitOnOpen = 1 "automatically close NerdTree when you open a file
let g:NERDTreeWinPos = "right"
map <leader>o :NERDTreeFind <cr>   " View the current buffer in NERDTree
nmap <C-F10>    :NERDTreeToggle <cr> 
"
"" Check if NERDTree is open or active
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
"" Highlight currently open buffer in NERDTree
"autocmd BufEnter * call s:SyncTree()
"
" }}} end of NERDTree 

" ------Cscope ------- {{{
set cscopetag   " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t' and search cscope tag first
set csto=0      " check cscope for definition of a symbol before checking ctags: set to 1, if you want the reverse search order.
set cscopequickfix=s-,c-,d-,i-,t-,e-,a-,g-,f-   " enable quickfix for cscope, note that this will automatically jump to 1st match all the time

" }}} end of Cscope

" ------Tagbar ------- {{{
"  this plugin displays the tags in a separate window
let g:tagbar_left=1            " tagbar windown locates on the left
let g:tagbar_autofocus=1       " cursor will move to tagbar window when it's opened
let g:tagbar_autoclose=1       " close tagbar automatically when selected one tag
nmap <F8> :TagbarToggle <cr> 
" }}}  end of Tagbar
"
" ------Gutentags and Gutentags_plus ------- {{{
" enable logs
"let g:gutentags_trace = 1

" enable both ctags and gtags module
let g:gutentags_modules = ['ctags', 'gtags_cscope']

"let g:gutentags_define_advanced_command = 1

" config project root markers, besides VCS markers such as .git, .svn etc.
let g:gutentags_project_root = ['.root']

" generate databases in my cache directory, prevent gtags files polluting my project
let g:gutentags_cache_dir = expand('~/.tagscache')

" change focus to quickfix window after search (optional).
let g:gutentags_plus_switch = 1

" shortkey to create a root marker for gutentags tags generating, make sure to go to the required directory before running this command
nmap <leader>rtags   :!mkdir -p .root<CR><CR>

" manual update tags update (Gutentags), both ctags and gtags(in a separate folder
" this command only available when a recognicable file is open
nmap <leader>tup   :GutentagsUpdate<CR>

" Gutentags_plus; GscopeFind {querytype} {name}
" disable the default keymaps by if wan:
" let g:gutentags_plus_nomap = 1
" default keymap 	                                                    desc
"noremap <leader>cs :GscopeFind s <C-R><C-W><cr>                       " Find symbol (reference) under cursor
"noremap <leader>cg :GscopeFind g <C-R><C-W><cr>                       " Find symbol definition under cursor
"noremap <leader>cd :GscopeFind c <C-R><C-W><cr>                       " Functions called by this function
"noremap <leader>cc :GscopeFind t <C-R><C-W><cr>                       " Functions calling this function
"noremap <leader>ct :GscopeFind e <C-R><C-W><cr>                       " Find text string under cursor
"noremap <leader>ce :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>      " Find egrep pattern under cursor
"noremap <leader>cf :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>      " Find file name under cursor
"noremap <leader>ci :GscopeFind d <C-R><C-W><cr>                       " Find files #including the file name under cursor
"noremap <leader>ca :GscopeFind a <C-R><C-W><cr>                       " Find places where current symbol is assigned
"noremap <leader>cz :GscopeFind z <C-R><C-W><cr>                       " Find current word in ctags database

" define a short command to find any symbol in Command mode instead of GscopeFind to find symbol definition
noremap <leader>fs :GscopeFind g 
noremap <F7> :GscopeFind g 

" }}}  end of Gutentags
"
"
"""""""""""""""""""end of plugin""""""""""""""""""""""""""""""""""""""


