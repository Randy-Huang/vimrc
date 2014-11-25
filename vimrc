""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
                                                                                           "
" File_Name__: vimrc                                                                       "
" Abstract___:                                                                             "
" Author_____: Randy Huang <randy.hunang@gmail.com>                                        "
" Version____: 3.0                                                                         "
" Last_Change: November 18, 2014                                                           "
" Licence____:                                                                             "
"                                                                                          "
" Sections:										   "
"    -> INSTALL VUNDLE AUTOMATICALLY							   "
"    -> GENERAL SETTINGS								   "
"	- VIM User Interface                                                               "
"	- Ignore Files When Completion                                                     "
"	- TAB Settings									   "
"	- Disable Sound Errors								   "
"	- Colors Settings                     						   "
"	- Status Line									   "
"	- C/C++ Specific Settings							   "
"    -> USEFUL SHORTCUTS								   "
"    -> PROGRAMMING SHORTCUTS								   "
"    -> ENCODING SETTINGS								   "
"    -> VUNDLE SETTINGS SECTION								   "
"    -> PLUGINS SETTINGS SECTION							   "
"                                                                                          "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" ==========================================================================================
" ========================= INSTALL VUNDLE AUTOMATICALLY ===================================
" ==========================================================================================
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
    echo "Installing Vundle.."
    echo ""
    silent !mkdir -p ~/.vim/bundle
    silent !git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    let iCanHazVundle=0
endif


" ==========================================================================================
" ================================= GENERAL SETTINGS =======================================
" ==========================================================================================
" =============================== VIM User Interface =======================================
set bs=2                " allow backspacing over everything in insert mode
set history=1000	" keep 1000 lines of command line history
set ruler		" show the cursor position all the time
set autoread		" auto read when file is changed from outside
set nu			" enable line number
set hlsearch		" search highlighting
set cursorline      	" highlight current line
set clipboard=unnamed	" yank to the system register (*) by default
set showmatch		" cursor shows matching ) and }
set showmode		" show current mode
set wildchar=<TAB>	" start wild expansion in the command line using <TAB>
set wildmenu            " wild char completion menu
set autoindent		" auto indentation
set incsearch		" incremental search
set nobackup		" no *~ backup files
set copyindent		" copy the previous indentation on autoindenting
set ignorecase		" ignore case when searching
set smartcase		" ignore case if search pattern is all lowercase, case-sensitive otherwise
set mouse=a             " all previous modes
set nowrap              " not to break line
set hidden              " when switch buffer not to warn except exist Vim
set updatetime=500      " update after 500ms later
autocmd! bufwritepost .vimrc source ~/.vimrc	" auto reload vimrc when editing it

" =========================== Ignore Files When Completion==================================
" Enable enhanced command line completion.
set wildmenu wildmode=list:full

" Ignore these filenames during enhanced command line completion.
set wildignore+=*.aux,*.out,*.toc                   " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif                   " binary images
set wildignore+=*.luac                              " Lua byte code
set wildignore+=*.o,*.obj,*.exe,*.manifest          " compiled object files
set wildignore+=*.pyc                               " Python byte code
set wildignore+=*.spl                               " compiled spelling word lists
set wildignore+=*.swp                               " Vim swap files
set wildignore+=*.zip                               " compression files
set wildignore+=*/tmp/*	                            " tmp files
set wildignore+=*.dll,*.so                          " shared library

" ================================== TAB Settings ==========================================
set smarttab			" insert tabs on the start of a line according to context
set expandtab       	        " replace <TAB> with spaces
set softtabstop=4                       
set shiftwidth=4
au FileType Makefile set noexpandtab

" ============================= Disable Sound Errors =====================================
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" ================================== Colors Settings =======================================
syntax on				" enable syntax highlighting

set background=dark 
set t_Co=256                            " 256 color mod
colorscheme solarized     	        " terminal color settings

if has("gui_running")			" Set colors and fonts when running in GUI mode
    set guifont=Osaka-Mono:h20
    set background=dark 
    set guioptions-=T
    set guioptions+=e
    set guitablabel=%M\ %t
    highlight CursorLine guibg=#003853 ctermbg=24 gui=none cterm=none
endif

set ffs=unix,dos,mac 		        " Use Unix as the standard file type

" =================================== Status Line ==========================================
set laststatus=2
set statusline=\ %{HasPaste()}%<%-15.25(%f%)%m%r%h\ %w\ \ 
set statusline+=\ \ \ [%{&ff}/%Y] 
set statusline+=\ \ \ %<%20.30(%{hostname()}:%{CurDir()}%)\ 
set statusline+=%=%-10.(%l,%c%V%)\ %p%%/%L

function! CurDir()
    let curdir = substitute(getcwd(), $HOME, "~", "")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return '[PASTE]'
    else
        return ''
    endif
endfunction

" ============================= C/C++ Specific Settings ====================================
autocmd FileType c,cpp,cc  set cindent comments=sr:/*,mb:*,el:*/,:// cino=>s,e0,n0,f0,{0,}0,^-1s,:0,=s,g0,h1s,p2,t0,+2,(2,)20,*30	


" ==========================================================================================
" ================================= USEFUL SHORTCUTS =======================================
" ==========================================================================================
" ================================= Leader Settings ========================================
" The most things is mapleader have to put in any mappings up the settings
let mapleader=","
let g:mapleader=","

" ================================ General Settings ========================================
nmap <leader>r :call Replace()<CR>		" replace the current word in all opened buffers

" ================================ QuickFix Mapping ========================================
nmap <unique> <F3> :call QFixToggle(1)<CR>  " open the error console
nmap <unique> <leader>co :colder<CR>        " display older error list       
nmap <unique> <leader>cn :cnewer<CR>        " display newer error list
nmap <unique> <leader>[ :cprevious<CR>      " move to the previous error
nmap <unique> <leader>] :cnext<CR>          " move to the next error
command! -bang -nargs=? QFix call QFixToggle(<bang>0)

function! QFixToggle(forced)
    if exists("g:qfix_win") && a:forced != 0
        cclose
    else
        if exists("g:my_quickfix_win_height")
            execute "copen ".g:my_quickfix_win_height
        else
            copen
        endif
    endif
endfunction

augroup QFixToggle
    autocmd!
    autocmd BufWinEnter quickfix let g:qfix_win = bufnr("$")
    autocmd BufWinLeave * if exists("g:qfix_win") && expand("<abuf>") == g:qfix_win | unlet! g:qfix_win | endif
augroup END

" ================================ Grep Key Mapping ========================================
" Enable to fast to search the highlight word with mouse arrow in current file
nmap <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>

" =============================== Move Around Splits =======================================
" Move function
nmap <C-J> <C-W>j       	" move to the below split 
nmap <C-K> <C-W>k       	" move to the above split 
nmap <C-H> <C-W>h        	" move to the left split 
nmap <C-L> <C-W>l	        " move to the right split  

" Split display windown size
nmap <unique> <leader>h <C-W>_
nmap <unique> <leader>j <C-W><BAR>
set wmw=0                     	" set the min width of a window to 0 so we can maximize others 
set wmh=0                     	" set the min height of a window to 0 so we can maximize others

" ================================= TAB Shortcuts ==========================================
" move around tabs. conflict with the original screen top/bottom
" comment them out if you want the original H/L
map <S-H> gT			" go to prev tab 
map <S-L> gt			" go to next tab
map <C-t><C-t> :tabnew<CR>	" new tab
map <C-t><C-w> :tabclose<CR> 	" close tab

" ========================== Turn Off Search Highlighting ==================================
nmap <leader>// :nohl<CR>

" ===================================== Paste Mode =========================================
" ,p toggles paste mode
nmap <leader>p :set paste!<BAR>set paste?<CR>

" ================================ Keys for Command Line ===================================
" Bash like keys for the command line
cnoremap <C-A>      <Home>
cnoremap <C-E>      <End>
cnoremap <C-K>      <C-U>

" ==================================== Visual Mode =========================================
" allow multiple indentation/deindentation in visual mode
vnoremap < <gv
vnoremap > >gv

" ============================== Change Working Directory ==================================
" :cd. change working directory to that of the current file
cmap cd. lcd %:p:h

" ============================== Write Restructured Text ===================================
" Writing Restructured Text (Sphinx Documentation)
" Ctrl-u 1:    underline Parts w/ #'s
noremap  <C-u>1 yyPVr#yyjp
inoremap <C-u>1 <esc>yyPVr#yyjpA
" Ctrl-u 2:    underline Chapters w/ *'s
noremap  <C-u>2 yyPVr*yyjp
inoremap <C-u>2 <esc>yyPVr*yyjpA
" Ctrl-u 3:    underline Section Level 1 w/ ='s
noremap  <C-u>3 yypVr=
inoremap <C-u>3 <esc>yypVr=A
" Ctrl-u 4:    underline Section Level 2 w/ -'s
noremap  <C-u>4 yypVr-
inoremap <C-u>4 <esc>yypVr-A
" Ctrl-u 5:    underline Section Level 3 w/ ^'s
noremap  <C-u>5 yypVr^
inoremap <C-u>5 <esc>yypVr^A

" =============================== Other Useful Shortcuts ===================================
" Tip #382: Search for <cword> and replace with input() in all open buffers 
fun! Replace() 
    let s:word = input("Replace " . expand('<cword>') . " with:") 
    :exe 'bufdo! %s/\<' . expand('<cword>') . '\>/' . s:word . '/ge' 
    :unlet! s:word 
endfun 

" Restore cursor to file position in previous editing session
" Return to last edit position when opening files 
autocmd  BufReadPost * 
    \ if line("'\"") > 0 | if line("'\"") <= line("$") |
    \ exe("norm '\"") |
    \ else | exe "norm $" |
    \ endif | endif
	
" Remember info about open buffers on close		
set viminfo='10,\"100,:20,%,n~/.viminfo


" ==========================================================================================
" ============================ PROGRAMMING SHORTCUTS =======================================
" ==========================================================================================
" Ctrl-[ jump out of the tag stack (undo Ctrl-])
map <C-[> <ESC>:po<CR>

" ,g generates the header guard
map <leader>g :call IncludeGuard()<CR>
fun! IncludeGuard()
    let basename = substitute(bufname(""), '.*/', '', '')
    let guard = '_' . substitute(toupper(basename), '\.', '_', "H")
    call append(0, "#ifndef " . guard)
    call append(1, "#define " . guard)
    call append( line("$"), "#endif // for #ifndef " . guard)
endfun

" Enable omni completion. (Ctrl-X Ctrl-O)
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType java set omnifunc=javacomplete#Complete
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType cpp set omnifunc=cppcomplete#CompleteCPP
autocmd FileType c set omnifunc=ccomplete#Complete
au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main

" Use syntax complete if nothing else available
if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
    \ if &omnifunc == "" |
    \     setlocal omnifunc=syntaxcomplete#Complete |
    \ endif
endif

" Disable doc preview in omnicomplete
set cot-=preview 

" Make CSS omnicompletion work for SASS and SCSS
autocmd BufNewFile,BufRead *.scss             set ft=scss.css
autocmd BufNewFile,BufRead *.sass             set ft=sass.css


" ==========================================================================================
" =============================== ENCODING SETTINGS ========================================
" ==========================================================================================
set encoding=utf-8                                  
set termencoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,big5,gb2312,latin1

fun! ViewUTF8()
    set encoding=utf-8                                  
    set termencoding=big5
endfun

fun! UTF8()
    set encoding=utf-8                                  
    set termencoding=big5
    set fileencoding=utf-8
    set fileencodings=ucs-bom,big5,utf-8,latin1
endfun

fun! Big5()
    set encoding=big5
    set encoding=big5
    set fileencoding=big5
endfun


" ==========================================================================================
" =========================== VUNDLE SETTINGS SECTION ======================================
" ==========================================================================================
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/vundle
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')

" =============================== Plugin Management ========================================
" Utility
Plugin 'gmarik/vundle'              " let Vundle manage Vundle, required
Plugin 'L9'                         " vim-script library
Plugin 'AutoClose'                  " insert matching bracket, paren, brace or quote
Plugin 'AutoComplPop'               " automatically opens popup menu for completions
Plugin 'taglist.vim'                " source code browser (supports C/C++, java, perl, python, etc)
Plugin 'The-NERD-tree'              " a tree explorer plugin for navigating the filesystem
Plugin 'SrcExpl'                    " a source code explorer
Plugin 'fakeclip'                   " pseudo clipboard register for non-GUI version of Vim
Plugin 'neocomplcache'              " ultimate auto completion system for Vim
Plugin 'cscope.vim'                 " create cscope database and connect to existing proper database automatically.
Plugin 'Trinity'                    " build the trinity of srcexpl, taglist, NERD_tree, conflict with Winmanager
Plugin 'Tagbar'                     " display tags of the current file ordered by scope
Plugin 'TabBar'                     " plugin to add tab bar (derived from miniBufExplorer)
Plugin 'EasyMotion'                 " Vim motions on speed
Plugin 'Tabular'                    " Vim script for text filtering and alignment
Plugin 'jreybert/vim-mark'          " highlight several words in different colors simultaneously
Plugin 'lookupfile'	            " Lookup files using Vim7 ins-completion
Plugin 'genutils'                   " General utility functions
Plugin 'ctrlp.vim'	            " Fuzzy file, buffer, MRU, and tag finder with regexp support.
Plugin 'bling/vim-airline'          " Lean & mean status/tabline for vim that's light as air
Plugin 'tpope/vim-fugitive'         " display git branch (airline git other plugin)
Plugin 'a.vim'	                    " alternate files quickly (.c --> .h etc)
Plugin 'EasyGrep'	            " fast and easy find and replace across multiple files

" Syntaxi
Plugin 'c.vim'                      " C/C++ IDE. Write and run programs. Insert statements, idioms, comments etc.

" Color Scheme
Plugin 'wombat256.vim'	        " wombat for 256 color xterms
Plugin 'Solarized'              " Beautiful dual light/dark, selective contrast, GUI/256/16 colorscheme

" Not Use Plgin (Maybe other similar plugin seems to be more useful)
" Plugin 'FuzzyFinder'                " buffer/file/command/tag/etc explorer with fuzzy matching
" Plugin 'The-NERD-tree'              " a tree explorer plugin for navigating the filesystem
" Plugin 'Lokaltog/vim-powerline'     " allow you to create better-looking, more functional vim statuslines
" Plugin 'fholgado/minibufexpl.vim'   " elegant buffer explorer - takes very little screen space
" ============================= End Plugin Management ======================================

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" To ignore plugin indent changes, instead use:
" filetype plugin on

" Brief help:
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins

" Install configured bundles: (1) & (2)
" (1) Launch vim and run, type:
" 	:PluginInstall
" (2) To install from command line:
" 	vim +PluginInstall +qall

" ======================== Install Plugins Automatically ===================================
" if iCanHazVundle == 0
"  echo "Installing Bundles, please ignore key map error messages"
"  echo ""
"  :PluginInstall
"  :qall
" endif


" ==========================================================================================
" ========================== PLUGINS SETTINGS SECTION ======================================
" ==========================================================================================
" ================================= Taglist Plugin =========================================
nnoremap <silent> <F7> :TlistToggle<CR>                                                        
let g:Tlist_WinWidth=40               " the taglist width                                    
let g:Tlist_WinHeight=100             " the taglist height                                   
let g:Tlist_Enable_Fold_Column=1      " dispaly the fold column 
let g:Tlist_Display_Prototype=1	    " show the prototype                                 
let g:Tlist_Auto_HighLight_Tag=1      " automatically highlight the current tag in the taglist 
let g:Tlist_Exit_OnlyWindow=1         " close vim if the taglist the only window               
let g:Tlist_File_Fold_Auto_Close=1    " close tag folds for inactive buffers
let g:Tlist_Use_Right_Window=0        " open the vertically split taglist window on the left side. 
let g:Tlist_Show_One_File=1           " display the tags for only one file in the taglist window
let g:Tlist_Use_SingleClick=1	    " press click one time to tag location, default is 0 (twice)
let g:Tlist_Process_File_Always=0     " close continuous refresh tags
let g:Tlist_Ctags_Cmd="/usr/local/bin/ctags" " set Ctags PATH

" ================================= Cscope Plugin ==========================================
" Auto update database
function CSBuild()
    if exists("s:CSCOPE_DB_EXIST")
        silent cscope kill 0
        echohl Title | echom 'Update...' | echohl None
        let SRC_ROOT = CsGetDBpath() 
        silent exe 'cd '. SRC_ROOT
        call CsGenDB()
        
"       Back to work directory
"       silent exe 'cd '. s:CURDIR
        echohl Title | echom 'Update DB: '. s:CSCOPE_DB | echohl None
    else
        echohl WarningMsg | echom 'No cscope database!!!' | echohl None
        let buildnow = input('Would you want to build an new DB?(y/N)')
        if toupper(buildnow) == 'Y'
            let s:CSCOPE_DB = getcwd() . '/cscope.out'
            let s:CSCOPE_DB_EXIST = 1
            call CsGenDB()
            echohl Title | echom 'Build new DB: '. s:CSCOPE_DB | echohl None
        endif
    endif
endf

function CsGenDB()
    silent !find . -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.java" -o -name "*.mk" > "/tmp/.cs_db"
    silent !cscope -bkq -i "/tmp/.cs_db"
    silent !ctags -R --exclude=.svn --exclude=.git
    silent exe 'cs add '. s:CSCOPE_DB
    :redraw!
endf

function CsGetDBpath()
    return '/'. join(split(s:CSCOPE_DB, '/')[0:-2], '/') 
endf

" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim... 
if has("cscope")

""""""""""""" Standard cscope/vim boilerplate
"   cscope bin PATH
    set csprg=/usr/bin/cscope

"   use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
"   set cscopetag

"   check cscope for definition of a symbol before checking ctags: set to 1
"   if you want the reverse search order.
    set csto=0
    set cst
    set nocsverb

"   Add the database pointed to by environment variable 
    let s:CURDIR = getcwd()
    let s:CSCOPE_DB = getcwd()
""  while (getcwd() != '/')
"       echo 'Try search: '.getcwd()
""      if filereadable("cscope.out")
""          let s:CSCOPE_DB_EXIST = 1
""          let s:CSCOPE_DB = getcwd() . "/cscope.out"
""          silent exe 'cs add '. s:CSCOPE_DB
""          break 
""      endif
"           Look for parent folder
""          silent cd ..
""  endwhile

    if !exists("s:CSCOPE_DB_EXIST")
        silent exe 'cd '. s:CURDIR
    endif 
    
    set csverb

"   Use QuickFix to display cscope search results according parameters
    set cscopequickfix=s-,g-,c-,d-,t-,e-,f-,i-  

"   Show msg when any other cscope db added
    set cscopeverbose  

""""""""""""" My cscope/vim key mappings
"   The following maps all invoke one of the following cscope search types:
"   's'   symbol: find all references to the token under cursor
"   'g'   global: find global definition(s) of the token under cursor
"   'c'   calls:  find all calls to the function name under cursor
"   't'   text:   find all instances of the text under cursor
"   'e'   egrep:  egrep search for the word under cursor
"   'f'   file:   open the filename under cursor
"   'i'   includes: find files that include the filename under cursor
"   'd'   called: find functions that function under cursor calls

" Below are three sets of the maps: one set that just jumps to your
" search result, one that splits the existing vim window horizontally and
" diplays your search result in the new window, and one that does the same
" thing, but does a vertical split instead (vim 6 only).

" I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
" unlikely that you need their default mappings (CTRL-\'s default use is
" as part of CTRL-\ CTRL-N typemap, which basically just does the same
" thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
" If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
" of these maps to use other keys.  One likely candidate is 'CTRL-_'
" (which also maps to CTRL-/, which is easier to type).  By default it is
" used to switch between Hebrew and English keyboard mode.

" All of the maps involving the <cfile> macro use '^<cfile>$': this is so
" that searches over '#include <time.h>" return only references to
" 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
" files that contain 'time.h' as part of their name).

" To do the first type of search, hit 'CTRL-\', followed by one of the
" cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
" search will be displayed in the current window.  You can use CTRL-T to
" go back to where you were before the search.  

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

" (Note: earlier versions of vim may not have the :scs command, but it
" can be simulated roughly via:
"    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>	

"    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>	
"    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>	
"    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>	
"    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>	
"    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>	
"    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>	
"    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>	
"    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>	

" Hitting CTRL-space *twice* before the search type does a vertical 
" split instead of a horizontal one (vim 6 and up only)

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
" By default Vim will only wait 1 second for each keystroke in a mapping.
" You may find that too short with the above typemaps.  If so, you should
" either turn off mapping timeouts via 'notimeout'.
"   set notimeout 
" Or, you can keep timeouts, by uncommenting the timeoutlen line below,
" with your own personal favorite value (in milliseconds):

"   set timeoutlen=4000
" Either way, since mapping timeout settings by default also set the
" timeouts for multicharacter 'keys codes' (like <F1>), you should also
" set ttimeout and ttimeoutlen: otherwise, you will experience strange
" delays as vim waits for a keystroke after you hit ESC (it will be
" waiting to see if the ESC is actually part of a key code like <F1>).

"   set ttimeout 
" personally, I find a tenth of a second to work well for key code
" timeouts. If you experience problems and have a slow terminal or network
" connection, set it higher.  If you don't set ttimeoutlen, the value for
" timeoutlent (default: 1000 = 1 second, which is sluggish) is used.

"   set ttimeoutlen=100

" Reload cscope DB or create new one
    :command -nargs=0 CSBuild :call CSBuild()
"    nmap <leader>rb :call CSBuild()<CR>
endif

" ================================ Triniry Plugin ==========================================
" Triniry + Source Explorer + TagList + NERD Tree
nmap <F5>  :TrinityToggleAll<CR>		" open all the three plugins on the same time
nmap <F6>  :TrinityToggleSourceExplorer<CR>	" open the srcexpl.vim separately
nmap <F7>  :TrinityToggleTagList<CR>		" open the taglist.vim separately
nmap <F8>  :TrinityToggleNERDTree<CR>		" open the NERD_tree.vim separately

" ============================= Source Explorer Plugin ===================================== 
nmap <F6> :SrcExplToggle<CR> 		" the switch of the Source Explorer                                   
let g:SrcExpl_winHeight=8 		" set the height of Source Explorer window 
let g:SrcExpl_refreshTime=100  	        " set 100 ms for refreshing the Source Explorer
let g:SrcExpl_jumpKey="<ENTER>" 	" set <Enter> key to jump into the exact definition context
let g:SrcExpl_gobackKey="<SPACE>"	" set <Space> key for back from the definition context 
    
" In order to avoid conflicts, the Source Explorer should know what plugins 
" except itself are using buffers. And you need add their buffer names into 
" below listaccording to the command ":buffers!"                            
let g:SrcExpl_pluginList = [ 
    \ "__Tag_List__", 
    \ "_NERD_tree_", 
    \ "Source_Explorer"
    \ ] 

" Enable/Disable the local definition searching, and note that this is not  
" guaranteed to work, the Source Explorer doesn't check the syntax for now. 
" It only searches for a match with the keyword according to command 'gd'   
let g:SrcExpl_searchLocalDef=1 

" Do not let the Source Explorer update the tags file when opening           
let g:SrcExpl_isUpdateTags=0 
    
" Use 'Exuberant Ctags' with '--sort=foldcase -R .' or '-L cscope.files' to 
" create/update a tags file                                                
""let g:SrcExpl_updateTagsCmd="ctags --sort=foldcase -R ." 

" ================================ c.vim (C/C++ IDE) ======================================= 
" To enable the tools for cmake or doxygen
let g:C_UseTool_cmake='yes' 
let g:C_UseTool_doxygen='yes' 

" ======================================== Tagbar ========================================== 
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_left=1
let g:tagbar_singleclick=1
let g:tagbar_autoshowtag=1 
let g:tagbar_show_visibility=1
let g:tagbar_ctags_bin="/usr/local/bin/ctags"

" ======================================== Mark ============================================ 
let g:mwDefaultHighlightingPalette = 'extended' " switch to a richer palette of up to 18 colors
let g:mwDefaultHighlightingNum = 9              " Additional colors up to 9
nmap <silent> <unique> <leader>hh <Plug>MarkSet
vmap <silent> <unique> <leader>hh <Plug>MarkSet
nmap <silent> <unique> <leader>hc <Plug>MarkClear
vmap <silent> <unique> <leader>hc <Plug>MarkClear
nmap <silent> <unique> <leader>hr <Plug>MarkRegex
vmap <silent> <unique> <leader>hr <Plug>MarkRegex 

" ================================== Powerline (vim) ========================================
" let g:Powerline_symbols='fancy'                 " enable fancy symbol in powerline
" let g:Powerline_colorscheme='solarized256'      " set powerline colorscheme
" set fillchars+=stl:\ ,stlnc:\                   " disable statusline fillchars

" ====================================== Airline ============================================
let g:airline_powerline_fonts=1                   " enable powerline fonts
let g:airline#extensions#tabline#enabled=1        " enable tabline
let g:airline#extensions#tabline#left_sep=''      " separator symbol used in current buffer for tabline
let g:airline#extensions#tabline#left_alt_sep='|' " separator symbol used in not active buffer for tabline
let g:airline#extensions#tabline#buffer_nr_show=1 " display buffer number in tabilne
let g:airline_theme='dark'                        " airline color theme
nnoremap [b :bp<CR>
nnoremap ]b :bn<CR>

" ================================== The NERD_tree ==========================================
nmap <silent> <F8> :NERDTreeToggle<CR>
let g:NERDTreeSortOrder=  ['\/$', '\.java$', '\.c$', '\.cpp$', '\.h$', '*']     " sort the nodes in the tree
let g:NERDTreeWinSize=30              " set the windown size when the NERD tree is opend
let g:NERDTreeWinPos="right"          " put the NERD tree right window
let g:NERDTreeShowHidden=1            " display hidden on startup
let g:NERDTreeMinimalUI=1             " disable display of the 'Bookmarks' label and 'Press ? for help' text
let g:NERDTreeAutoDeleteBuffer=1      " auto delete the file associated with buffer
let g:NERDTreeShowBookmarks=1         " display the bookmarks table on startup
let g:NERDTreeHighlightCursorline=1   " highlight the current cursor line
let g:NERDTreeQuitOnOpen=1            " close the tree windown after opening a file
let g:NERDTreeCaseSensitiveSort=0     " tell the NERD tree whether to be case sensitive or not when sorting nodes
let g:NERDChristmasTree=1             " tell the NERD tree to make itself colorful and pretty
let g:NERDTreeChDirMode=2             " except that the CWD is changed whenever the tree root is changed
function! NTFinderP()
    "" Check if NERDTree is open
    if exists("t:NERDTreeBufName")
        let s:ntree = bufwinnr(t:NERDTreeBufName)
    else
        let s:ntree = -1
    endif
    if (s:ntree != -1)
        "" If NERDTree is open, close it.
        :NERDTreeClose
    else
        "" Try to open a :Rtree for the rails project
        if exists(":Rtree")
            "" Open Rtree (using rails plugin, it opens in project dir)
            :Rtree
        else
            "" Open NERDTree in the file path
            :NERDTreeFind
        endif
    endif
endfunction

" =======[M@/G]============================== TabBar ==============================================
let g:Tb_MaxSize=3                  " TabBar window display size
let g:Tb_TabWra=1                   " let tab dispaly context can change Line

" ================================== FuzzyFinder ============================================
" map <leader>F :FufFile<CR>  
" map <leader>f :FufTaggedFile<CR>     
" map <leader>g :FufTag<CR>       
" map <leader>b :FufBuffer<CR>

" ===================================== CtrlP ===============================================
let g:ctrlp_clear_cache_on_exit=0               " not to clean up cache after vim
let g:ctrlp_mruf_max=500                        " set the number of recently opend files 
" Enlarge cache index file numbers to prevent lost file when in the process of search; 0 is
" not to restrict file numbers:
let g:ctrlp_max_files=0         
let g:ctrlp_working_path_mode='rw'
" Speed up index file search
let g:ctrlp_user_command={
    \ 'types': {
        \ 1: ['.git', 'cd %s && git ls-files -c -o --exclude-standard'],
        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
    \ 'fallback': 'find %s -type f'
    \ }
" Ingore not useful files when in search files
let g:ctrlp_custom_ignore={                   
    \ 'dir': '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(log|jpg|png|jpeg|o|a|ko|so|obj|dll|exe)$',
    \ 'link': '',
    \ }

" ==================================== Ctags ===============================================
""set tags=tags   " set tags file existed diectory path (tags' current directory path)
""set autochdir   " set working dircetory of curren file be edited is the current working dircetory in Vim

" ==================================== Gtags ===============================================
" This plugin installed without using vundle, adn I put gtags.vim and gtags-cscope.cim to 
" ~/.vim/bundle/gtags/plugin from /usr/local/share/gtags. 
function! s:GtagsCscope_GtagsRoot()
    let s:global_command = "global"
    let cmd = s:global_command . " -pq"
    let cmd_output = system(cmd)
    return strpart(cmd_output, 0, strlen(cmd_output) - 1)
endfunction

function! s:GtagsCscope()
    " Get gtagsroot directory.
    let gtagsroot = s:GtagsCscope_GtagsRoot()
    if (!empty(gtagsroot))"
        " Load gtags-cscope.
        set csprg=gtags-cscope
"       let s:command = "cs add " . gtagsroot . "/GTAGS"
        let s:option = ''
"       if g:GtagsCscope_Ignore_Case == 1
        let s:option = s:option . 'C'
"       endif
"       if g:GtagsCscope_Absolute_Path == 1
        let s:option = s:option . 'a'
"       endif
"       if g:GtagsCscope_Keep_Alive == 1
        let s:option = s:option . 'i'
"       endif
        if s:option != ''
"       let s:command = s:command . ' . -' . s:option
        endif

        set nocscopeverbose
"       let s:command = "cs add " . gtagsroot . "/GTAGS" . ' . -' . 'i' . 'a' . 'C'
        let s:command = "cs add " . gtagsroot . "/GTAGS" . ' . -' . 'i' . 'a'
        exe s:command
        set cscopeverbose

"       Key mapping
"       if g:GtagsCscope_Auto_Map == 1
"       The following key mappings are derived from 'cscope_maps.vim'.
"       (The 'd' command is not implemented in gtags-cscope.)
"       Normal command
        nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"       Using 'CTRL-spacebar', the result is displayed in new horizontal window.
    endif
endfunction

function! UpdateGtags(f)
    let dir = fnamemodify(a:f, ':p:h')
    exe 'silent !cd ' . dir . ' && global -u &> /dev/null &'
endfunction

" windowdir
" Gets the directory for the file in the current window
" Or the current working dir if there isn't one for the window.
" Use tr to allow that other OS paths, too
function! s:windowdir()
    if winbufnr(0) == -1
        let unislash = getcwd()
    else
        let unislash = fnamemodify(bufname(winbufnr(0)), ':p:h')
    endif
    return tr(unislash, '\', '/')
endfunction

" Find_in_parent
" find the file argument and returns the path to it.
" Starting with the current working dir, it walks up the parent folders
" until it finds the file, or it hits the stop dir.
" If it doesn't find it, it returns "Nothing"
function! s:Find_in_parent(fln,flsrt,flstp)
    let here = a:flsrt
    while ( strlen( here) > 0 )
        if filereadable( here . "/" . a:fln )
            return here
        endif
        let fr = match(here, "/[^/]*$")  
        if fr == -1
            break
        endif
        let here = strpart(here, 0, fr)
        if here == a:flstp
            break
        endif
    endwhile
    return "Nothing"
endfunction

" In the following function is to replace autoload_cscope.vim
" Unload_csdb
" drop cscope connections.
function! s:Unload_csdb()
    if exists("b:csdbpath")
        if cscope_connection(3, "out", b:csdbpath)
            let save_csvb = &csverb
            set nocsverb
            exe "cs kill " . b:csdbpath
            set csverb
            let &csverb = save_csvb
        endif
    endif
endfunction

" Cycle_csdb
" cycle the loaded cscope db.
function! s:Cycle_csdb()
    if exists("b:csdbpath")
        if cscope_connection(3, "out", b:csdbpath)
            return
"           it is already loaded. don't try to reload it.
        endif
    endif
    let newcsdbpath = s:Find_in_parent("cscope.out",s:windowdir(),$HOME)
"   echo "Found cscope.out at: " . newcsdbpath
"   echo "Windowdir: " . s:windowdir()
    if newcsdbpath != "Nothing"
        let b:csdbpath = newcsdbpath
        if !cscope_connection(3, "out", b:csdbpath)
            let save_csvb = &csverb
"           set nocsverb
            set csverb
            exe "cs add " . b:csdbpath . "/cscope.out " . b:csdbpath
            let &csverb = save_csvb
        endif
    else 
"       No cscope database, undo things. (someone rm-ed it or somesuch)
        call s:Unload_csdb()
    endif
endfunction

" If GTAGS is existed, then use gtags-cscope
" If GTAGS is not existed, then use cscope
function! SelectCscopeDb()
    set nocscopeverbose				"suppress 'duplicate connection' error
    let gtagsroot = s:GtagsCscope_GtagsRoot()
    if (!empty(gtagsroot))
        set cscopeprg=gtags-cscope
        let s:command = "cs add " . gtagsroot . "/GTAGS" . ' . -' . 'i' . 'a'
        exe s:command
"       When save file and then update automatically gtags
"       au BufWritePost *.[ch] call UpdateGtags(expand('<afile>'))
"       au BufWritePost *.[ch]pp call UpdateGtags(expand('<afile>'))
"       au BufWritePost *.[ch]xx call UpdateGtags(expand('<afile>'))
"       au BufWritePost *.java call UpdateGtags(expand('<afile>'))
"       au BufWritePost *.cc call UpdateGtags(expand('<afile>'))
    else
        set csprg=/usr/bin/cscope
"       Use both cscope and ctag
        set cscopetag
"       Use cscope for definition search first
        set cscopetagorder=0
        let g:autocscope_menus=0
        set cscopetagorder=0
"       Auto toggle the menu
        augroup autoload_cscope
        au!
        au BufEnter *.[chly]  call <SID>Cycle_csdb()
        au BufEnter *.cc      call <SID>Cycle_csdb()
        au BufEnter *.cpp     call <SID>Cycle_csdb()
        au BufEnter *.java    call <SID>Cycle_csdb()
        au BufUnload *.[chly] call <SID>Unload_csdb()
        au BufUnload *.cc     call <SID>Unload_csdb()
        au BufUnload *.cpp     call <SID>Unload_csdb()
        au BufUnload *.java    call <SID>Unload_csdb()
        augroup END
        nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
    endif
"   set cscopequickfix=c-,d-,e-,f-,g0,i-,s-,t-
"   Resolve both cscope and tag when they co-existed, 
"   lead to <C-]> key map sometimes can not normanal operation 
"   that the bug exist
    nmap <C-]> :tj <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
    set cscopeverbose
endfunc

autocmd FileType c,cpp,java,python call SelectCscopeDb()
command! -nargs=0 GtagsCscope call s:GtagsCscope()

" ============================== EasyGrep ==================================================
let g:EasyGrepCommand=0          " use vimgrep:0, grepprg:1
let g:EasyGrepRecursive=1        " recursive searching
let g:EasyGrepIgnoreCase=1       " specifies the case sensitivity of searches, note that 
                                 " this can be further overrided for vimgrep searches with \c and \C.
" Specifies a list of file patterns that will be excluded from the search
let g:EasyGrepFilesToExclude="Python, PHP, *.bak, *cscope.*, *.a, *.o, *.bak"
let g:EasyGrepMode=0             " EasyGrepMode and default=0. Specifies the mode in which to start;
" 0- All files; 1- Open Buffers; 2- Track the current extension; 3- Use custom, on demand set of extensions






" ==========================================================================================










