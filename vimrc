" URL: http://vim.wikia.com/wiki/Example_vimrc
" Authors: http://vim.wikia.com/wiki/Vim_on_Freenode
" Description: A minimal, but feature rich, example .vimrc. If you are a
"              newbie, basing your first .vimrc on this file is a good choice.
"              If you're a more advanced user, building your own .vimrc based
"              on this file is still a good idea.

"------------------------------------------------------------
" Features {C[MaD[MaD{{1
"
" These options and commands enable some very useful features in Vim, that
" no user should have to live without.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents.  Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" Enable syntax highlighting
syntax on

" UTF-8 encoding
set encoding=utf-8


"------------------------------------------------------------
" Must have options {{{1
"
" These are highly recommended options.

" One of the most important options to activate. Allows you to switch from an
" unsaved buffer without saving it first. Also allows you to keep an undo
" history for multiple files. Vim will complain if you try to quit without
" saving, and swap files will keep you safe if your computer crashes.
set hidden

" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window for multiple buffers, and/or:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu

" Show partial commands in the last line of the screen
set showcmd

" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set nohlsearch

" Modelines have historically been a source of security vulnerabilities.  As
" such, it may be a good idea to disable them and use the securemodelines
" script, <http://www.vim.org/scripts/script.php?script_id=1876>.
" set nomodeline



"------------------------------------------------------------
" Usability options {{{1
"
" These are options that users frequently set in their .vimrc. Some of them
" change Vim's behaviour in ways which deviate from the true Vi way, but
" which are considered to add usability. Which, if any, of these options to
" use is very much a personal preference, but they are harmless.

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell.  If visualbell is set, and
" this line is also included, vim will neither flash nor beep.  If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>


"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 2 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab
set tabstop=4

" Indentation settings for using hard tabs for indent. Display tabs as
" two characters wide.
"set shiftwidth=2
"set tabstop=2


"------------------------------------------------------------
" Mappings {{{1
"
" Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

"jj as return to normal mode
map! jj <Esc>

"grep
function! LocalGrep(text)
    exec "lvimgrep /" . a:text . "/j **"
    lopen
endfunction
map <F4> call LocalGrep(expand("<cword>"))
"map <F4> :execute "lvimgrep /" . expand("<cword>") . "/j **" <Bar> lopen<CR>
"map! <F4> <Esc>:execute "lvimgrep /" . expand("<cword>") . "/j **" <Bar> lopen<CR>
command! -nargs=1 Lgrep call LocalGrep(<f-args>)


"go to definition
"map <F3> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
"map <F3> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

"toggle for quickfix and location list menus
function! GetBufferList()
  redir =>buflist
  silent! ls
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec('botright '.a:pfx.'open')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nmap <silent> <leader>l :call ToggleList("Location List", 'l')<CR>
nmap <silent> <leader>e :call ToggleList("Quickfix List", 'c')<CR>

"------------------------------------------------------------

" automatically change to the directory of the current file
" set autochdir

" default to no line wrapping
set nowrap

" don't automatically resize windows
set noequalalways

" set font
set guifont=Monospace\ 9

"set highlighting for bash vi mode
au BufRead,BufNewFile bash-fc-* set filetype=sh

"----------------------------------------------------------
"Configure the cursor
if &term =~ "xterm\\|rxvt"
    " use an orange cursor in insert mode
    let &t_SI = "\<Esc>]12;orange\x7"
    " use a red cursor otherwise
    let &t_EI = "\<Esc>]12;red\x7"
    silent !echo -ne "\033]12;red\007"
    " reset cursor when vim exits
    autocmd VimLeave * silent !echo -ne "\033]12;gray\007"
    " use \003]12;gray\007 for gnome-terminal
endif

"------------------------------------------------------------
"folding settings
set foldmethod=syntax
set foldnestmax=1
set foldenable
set foldlevel=0
set foldcolumn=1

"---------------------------------------------------------
"Window management
"set winheight=20
"set winminheight=20
set winwidth=40
set winminwidth=40
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>
imap <C-w> <C-o><C-w>
set autowrite
set autowriteall
set showtabline=2

"---------------------------------------------------------
"Pathogen
call pathogen#infect() 
call pathogen#helptags()

"-----------------------------------------------------------
"MiniBufferExplorer
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1 
let g:miniBufExplorerMoreThanOne=1
let g:miniBufExplorerMaxSize=1

"----------------------------------------------------------
"FSwitch - goto header/source file
map <F6> :FSHere<CR>
map! <F6> <Esc>:FSHere<CR>
au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '.,../include,./include'
au! BufEnter *.hpp let b:fswitchdst = 'cpp' | let b:fswitchlocs = '.,../src,..'
au! BufEnter *.h let b:fswitchdst = 'cpp' | let b:fswitchlocs = '.,../src,..'

"---------------------------------------------------------
"TagBar
map <F8> :TagbarToggle<CR>
map! <F8> <Esc>:TagbarToggle<CR>

"--------------------------------------------------------
"NERD Tree
map <F7> :NERDTreeToggle<CR>
map! <F7> <Esc>:NERDTreeToggle<CR>
let NERDTreeIgnore=['\.o$', '\~$']
let NERDTreeShowBookmarks=1
let NERDTreeWinSize=35
let NERDTreeDirArrows=1

"---------------------------------------------------------
"NERD Commenter
map <F5> <Leader>c<Space>

""--------------------------------------------------------
"" --- OmniCppComplete ---
"" -- required --
"set nocp " non vi compatible mode
"filetype plugin on " enable plugins
"" -- optional --
"" auto close options when exiting insert mode
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"set completeopt=menu,menuone
"" -- configs --
"let OmniCpp_MayCompleteDot = 1 " autocomplete with .
"let OmniCpp_MayCompleteArrow = 1 " autocomplete with ->
"let OmniCpp_MayCompleteScope = 1 " autocomplete with ::
"let OmniCpp_SelectFirstItem = 2 " select first item (but don't insert)
"let OmniCpp_NamespaceSearch = 2 " search namespaces in this and included files
"let OmniCpp_ShowPrototypeInAbbr = 1 " show function prototype (i.e. parameters) in popup windowlist

"------------------------------------------------------------
"ctags
" map <ctrl>+F12 to generate ctags for current folder:
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR>
" add current directory's generated tags file to available tags
set tags+=./tags;/
set tags+=~/tags/stl.tags

"-------------------------------------------------------
"clang complete
"let g:clang_use_library=1
"let g:clang_library_path="/usr/local/lib/"

"----------------------------------------------------
"PowerLine
let g:Powerline_symbols="unicode"

"---------------------------------------------------
"Command-T
nnoremap <silent> <Leader>f :CommandT<CR>
nnoremap <silent> <Leader>b :CommandTBuffer<CR>
let g:CommandTMaxHeight=50
set wildignore+=*.o,*.so

"-----------------------------------------------------------
"Colour Schemes
set t_Co=256
set background=dark
colorscheme custom_kellys

"-----------------------------------------------------------
"Gundo
map <F9> :GundoToggle<CR>
map! <F9> <Esc>:GundoToggle<CR>

"-----------------------------------------------------------
"AyncCommand
set makeprg=build.sh

function! AsyncInstall()
    let cmd = "./install_test.py"
    let title = "Install"
    call asynccommand#run(cmd, asynchandler#quickfix("%f", ""))
endfunction
command! AsyncInstall call AsyncInstall()

nnoremap <silent> <Leader>mm :AsyncMake "make"<CR>
nnoremap <silent> <Leader>mn :AsyncMake "make clean && ./configure && make"<CR>
nnoremap <silent> <Leader>mc :AsyncMake "make clean && cmake . && make"<CR>
nnoremap <silent> <Leader>mi :AsyncInstall<CR>


"----------------------------------------------------------------
"TaskList
let g:tlWindowPosition = 1

"---------------------------------------------------------------
"Fugitive

"------------------------------------------------------------------
"CamelCaseMovement
map w <Plug>CamelCaseMotion_w
map b <Plug>CamelCaseMotion_b
map e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
omap iw <Plug>CamelCaseMotion_iw
xmap iw <Plug>CamelCaseMotion_iw
omap ib <Plug>CamelCaseMotion_ib
xmap ib <Plug>CamelCaseMotion_ib
omap ie <Plug>CamelCaseMotion_ie
xmap ie <Plug>CamelCaseMotion_ie

"-------------------------------------------------------------------
"Conque Terminal
let g:ConqueTerm_Color=2
let g:ConqueTerm_InsertOnEnter=1
let g:ConqueTerm_CloseOnEnd=1
let g:ConqueTerm_CWInsert=1
let g:ConqueTerm_SendVisKey ='<Leader>sp'
let g:ConqueTerm_ToggleKey = '<Leader>st'

nnoremap <silent> <Leader>sh :botright sp<CR>:resize 20<CR>:ConqueTerm bash<CR>

"---------------------------------------------------------------
"eclim
let g:EclimCSearchSingleResult='lopen'
let g:EclimCHierarchyDefaultAction='vsplit'
"let g:EclimProjectTreeAutoOpen=1
let g:EclimProjectTreeExpandPathOnOpen=1

"-----------------------------------------------------------------
"SuperTab
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-u>"
let g:SuperTabClosePreviewOnPopupClose = 1

"-------------------------------------------------------------
"Project function
function! NewProjectTab(name)
    tablast
    tabe
    let l:dir = '~/projects/' . a:name
    exec "lcd " . l:dir
    NERDTree
    TagbarOpen
endfunction
command! -nargs=1 Ptab call NewProjectTab(<f-args>)
function! NewPathTab(path)
    tablast
    tabe
    exec "lcd " . a:path
    NERDTree
    TagbarOpen
endfunction
command! -nargs=1 Ltab call NewPathTab(<f-args>)

"------------------------------------------------------------
"Syntastic
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': ['ruby', 'php'],
            \ 'passive_filetypes': ['cpp'] }
