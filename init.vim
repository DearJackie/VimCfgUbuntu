"
" customized vim/nvim configuration file for linux, tested in Ubuntu
" Jackie CAI
" Jul. 5 2024 - Initial version
" Oct. 17 2025 - remove the default configuration session to make sure it can
"                renamed to init.vim used by neovim.
"
" NOTE:
" According to the help menu (see :help $MYVIMRC), vim will look for a user
" vimrc in specific places.
" It look first for ~/.vimrc and then for ~/.vim/vimrc.
" Vim stops searching after the first one found.
" Vim will set automatically the $MYVIMRC environment variable to the location
" of the vimrc used.
" for neovim, the configuration is ~/.config/nvim/init.vim


"""""""""""""""""""""""customization settings begins""""""""""""""""""""""""""""""""""

" show status bar, indicating different information
set ruler

" show cursor line for current line
"set cursorline

" show line number in the left side of the editor
set number

" make sure L is to bottom and H to top
set scrolloff=0

" show column limit
set colorcolumn=80

" to avoid automatical wrapping when editing text: break into new line after 120 chars
set textwidth=80

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
set tabstop=4 " Number of spaces that a <Tab> in the file counts for
set shiftwidth=4 " Number of spaces to use for each step of (auto)indent
set expandtab " Use spaces instead of tabs

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

" enable fold by default
set foldmethod=syntax
set foldlevel=100
set foldclose=all

" set the register '+' as the default(unamed), thus each time
" when yank(y) or paste(p), Vim will use system clipboard '+'
if has('clipboard')
  set clipboard=unnamedplus
endif

" enable 'find' recursively in current working directory (pwd)
set path+=**

" enable ripgrep by default, replacing "vim/vimgrep" by "ripgrep", which is much faster
" this is default in nvim.
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
nmap <leader>ccd           :cd %:p:h<CR>    " change to the directory of the currently open file for all windows
nmap <leader>lcd           :lcd %:p:h<CR>   " change to the directory of the currently open file for the current window
nmap <leader>bd            :bd <CR>         " close the current buffer, buffer is put into unlisted list
nmap <leader>bw            :bw <CR>         " close the current buffer, buffer is swiped
nmap <leader>co            :botright copen <CR>         " open quickfix window on the right
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
map <leader>lo :NERDTreeFind <cr>   " View the current buffer in NERDTree
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
let g:gutentags_project_root = ['.tags']

" generate databases in my cache directory, prevent gtags files polluting my project
"let g:gutentags_cache_dir = expand('~/.tagscache')
let g:gutentags_cache_dir = expand(getcwd().'/.tags')

" change focus to quickfix window after search (optional).
let g:gutentags_plus_switch = 1

" shortkey to create a root marker for gutentags tags generating, make sure to go to the required directory before running this command
"nmap <leader>rtags   :!mkdir -p .tags<CR><CR>

" manual update tags update (Gutentags), both ctags and gtags(in a separate folder
" this command only available when a recognicable file is open
nmap <leader>tup   :GutentagsUpdate<CR>/nvimi
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
" find any symbol by inputs
noremap <leader>fs :GscopeFind g 

" find the word symbol under cursor
noremap <F7> :GscopeFind g <C-R><C-W><CR> 

" }}}  end of Gutentags
"
" F1 reserved by vim and many applications for help 

" short key to replace windows line ending ^M to linux line ending
noremap <F2> :%s/\r//g <CR>

" short key to replace word under cursor 
noremap <F3> :%s/<C-R><C-W>/

"noremap <F4> :
"
"noremap <F5> :
"
"noremap <F6> :
"
" F7 for Gscope plugin defined above

" F8 for TagbarToggle plugin defined above

" define a short key to use rg in vim to search strings(word)
nnoremap <F9> :Rg <C-R><C-W><CR>

" define a short key to search files in the current directory using FZF
nnoremap <F10> :Files <CR>

" F11 reserved by windows powershell terminal and most IDEs for full screen

"noremap <F12> :

" insert new line after current line without leaving normal mode
nnoremap <leader>o o<ESC>

" insert new line before current line without leaving normal mode
nnoremap <leader>O O<ESC>

" define a short key to search files in the open buffer list using FZF
nnoremap <leader>ls :Buffers <CR>

" settings of curosr shapes 
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
" Line cursor in Insert lhll
let &t_SI = "\e[6 q"
" Block cursor in Normal mode \e[6 q
let &t_EI = "\e[2 q"
" blinking block cursor in Replace mode
let &t_SR = "\e[1 q"

"""""""""""""""""""end of plugin""""""""""""""""""""""""""""""""""""""


