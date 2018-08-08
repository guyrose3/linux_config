" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set encoding=utf-8

" Vundle Configuration
filetype off                  " required

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
    exe "menu Foo.Bar :" . a:str
    emenu Foo.Bar
    unmenu Foo
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("Ag \"" . l:pattern . "\" " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" " alternatively, pass a path where Vundle should install plugins
" "call vundle#begin('~/some/path/here')
"
" Appearence
" ----------
" Solorizd colorscheme for vim
Plugin 'altercation/vim-colors-solarized'
" Vim Airline + Themes = status/tabline
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" Vim-Bufferline - Show buffers in the command bar

Plugin 'bling/vim-bufferline'
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
"TODO find another tool for syntax, this one colides with tmux navigation
"Plugin 'scrooloose/syntastic' 
Plugin 'kien/ctrlp.vim'
Plugin 'valloric/youcompleteme'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/peaksea'
Plugin 'airblade/vim-gitgutter'
Plugin 'danro/rename.vim'
Plugin 'KangOl/vim-pudb'
Plugin 'scrooloose/nerdcommenter'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'mileszs/ack.vim'
Plugin 'easymotion/vim-easymotion'
" " All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Appearance
" ==========

" # Set colorscheme
"
" Dedi's config
"colorscheme peaksea
"set background=dark

" Omer's config
set t_Co=256
if filereadable( expand("$HOME/.vim/bundle/vim-colors-solarized/README.mkd") )
    " let g:solarized_termcolors=16
    let g:solarized_termtrans=1
    " let g:solarized_visibility="low"
    set background=dark
    colorscheme solarized
endif

if filereadable( expand("$HOME/.vim/bundle/vim-airline-themes/README.mkd") )
    let g:airline_theme='solarized dark'
endif

" Highlight current line
set cursorline

" Directories
" ===========
set backupdir=~/.vim/backup/
set directory=~/.vim/swap/
set undodir=~/.vim/undo/
" The width of a TAB is set to 4. Still it is a \t. 
" It is just that Vim will interpret it to be having a width of 4.

set tabstop=4

" Indents will have a width of 4
" Sets the number of columns for a TAB
set softtabstop=4

" set shiftwidth to 4 for >> indentation of 4
set shiftwidth=4

" Expand TABs to spaces
set expandtab       

" highlight search
set hlsearch        

" line numbers 
set number          
" set relativenumber

" Disable line wrapping
set nowrap

" Turn on syntax highlighting
syntax enable 

"Leave hidden buffers open
set hidden  

" Reload files changed outside vim
set autoread

"by default Vim saves your last 8 commands.  We can handle more
set history=100 

" Enable file type detection and do language-dependent indenting.
filetype plugin indent on

" Make backspace behave in a sane manner.
set backspace=indent,eol,start

" Always show status line
set laststatus=2

" Ignore case sensitive when searching
set ic
set smartcase

" Open Nerd automatically on vim startup
"autocmd vimenter * NERDTree

"Key mapping
"""""""""""""
" set key as map leader
let mapleader = ","
let g:mapleader = ","
" Map buffer switching to Ctrl+tab
nnoremap <C-n> :bnext<CR>
nnoremap <C-m> :bprev<CR>
" Map Ctags go back in stack
"autocmd Filetype python nnoremap <leader>] :vsp<CR>:YcmCompleter GoToDefinition<CR>
autocmd Filetype python nmap <C-]> :YcmCompleter GoToDefinition<CR>
""autocmd Filetype python nmap <C-[> <C-O><CR>
""autocmd Filetype cpp    nnoremap <C-[> <C-T><CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :wq<CR>
"make jj do esc"
inoremap jj <Esc>

let g:ycm_global_ycm_extra_conf='~/.vim/bundle/youcompleteme/third_party/ycmd/examples/.ycm_extra_conf.py'

" pudb configuration
map <F2> :w<CR>:silent !pudb %<CR>:redraw!<CR>
map <F3> :! ipython %<CR>
""map <F4> :w <bar> execute '!pudb '.first_file<CR> :redraw!<CR>

" When you press <leader>r you can search and replace the selected text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>

" Macros
" """"""
:let @b='oimport ipdb; ipdb.set_trace()'

" bind <leader>a to Ack grep word under cursor TODO
nnoremap <leader>a :Ack!  "\b<C-R><C-W>\b"<CR>:cw<CR>

"" ctrlp.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|tox|ico|git|hg|svn))$'
let g:ctrlp_user_command = "find %s -type f | grep -Ev '"+ g:ctrlp_custom_ignore +"'"
let g:ctrlp_use_caching = 1
let g:ctrlp_working_path_mode = 'ra'

" The Silver Searcher
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  let g:ctrlp_use_caching = 0
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
"noremap <C-P> :CtrlP<CR>
noremap <leader>b :CtrlPBuffer<CR>
noremap <leader>m :CtrlPMRU<CR>
let g:ctrlp_map = '<leader>e'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'

" multiple times paste from last yank
xnoremap p pgvy

" grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db tags cscope.out'
let Grep_Skip_Dirs = '.git node_modules'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim           
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file contains some boilerplate settings for vim's cscope interface,
" plus some keyboard mappings that I've found useful.
"
" USAGE: 
" -- vim 6:     Stick this file in your ~/.vim/plugin directory (or in a
"               'plugin' directory in some other directory that is in your
"               'runtimepath'.
"
" -- vim 5:     Stick this file somewhere and 'source cscope.vim' it from
"               your ~/.vimrc file (or cut and paste it into your .vimrc).
"
" NOTE: 
" These key maps use multiple keystrokes (2 or 3 keys).  If you find that vim
" keeps timing you out before you can complete them, try changing your timeout
" settings, as explained below.
"
" Happy cscoping,
"
" Jason Duell       jduell@alumni.princeton.edu     2002/3/7
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has('cscope')

    " Standard cscope/vim boilerplate

    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
     set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out  
    " else add the database pointed to by environment variable 
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose  


    " My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.  
    "

    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>	


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	


    " Hitting CTRL-space *twice* before the search type does a vertical 
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>	
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout 
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout 
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

endif
