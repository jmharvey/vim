" .VIMRC
" ~~~~~~~
" vim: foldmethod=marker
" start-up {{{1
if has('vim_starting')
    set nocompatible
    set rtp+=~/.vim/bundle/neobundle.vim/
endif

" plugins {{{1
"NeoBundle {{{2
filetype off
" set vundle path
call neobundle#begin(expand('~/.vim/bundle/'))
" bundles 
" mine @ github
NeoBundle 'jmharvey/vim-template'
" vim-scripts @ github
NeoBundle 'argtextobj.vim'
NeoBundle 'AsyncCommand'
NeoBundle 'Conque-GDB'
NeoBundle 'camelcasemotion'
NeoBundle 'Tasklist.vim'
NeoBundle 'The-NERD-Commenter'
NeoBundle 'The-NERD-tree'
NeoBundle 'quickrun'
NeoBundle 'YankRing.vim'
NeoBundle 'ZoomWin'
" other @ github
NeoBundle 'sjl/gundo.vim'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'tpope/vim-commentary'
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-unimpaired'
NeoBundle 'tpope/vim-eunuch'
NeoBundle 'tpope/vim-endwise'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-tbone'
NeoBundle 'int3/vim-extradite'
NeoBundle 'derekwyatt/vim-fswitch'
NeoBundle 'spiiph/vim-space'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'flazz/vim-colorschemes'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'mileszs/ack.vim'
NeoBundle 'proyvind/Cpp11-Syntax-Support'
NeoBundle 'kshenoy/vim-signature'
NeoBundle 't9md/vim-quickhl'
NeoBundle 'bling/vim-airline'
NeoBundle 'edkolev/promptline.vim'
NeoBundle 'edkolev/tmuxline.vim'
NeoBundle 'funorpain/vim-cpplint'
NeoBundle 'christoomey/vim-tmux-navigator'
NeoBundle 'Valloric/YouCompleteMe'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'rhysd/vim-clang-format'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'gregsexton/gitv'
NeoBundle 'airblade/vim-gitgutter'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }

call neobundle#end()
filetype indent plugin on
NeoBundleCheck

" YouCompleteMe {{{2
let g:ycm_global_ycm_extra_conf = '~/dev/.ycm_extra_conf.py'
nnoremap <F2> :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" Clang Format {{{2
let g:clang_format#code_style = 'google'
let g:clang_format#style_options = {
            \ "AccessModifierOffset" : -4,
            \ "AllowShortIfStatementsOnASingleLine" : "false",
            \ "AlwaysBreakTemplateDeclarations" : "true",
            \ "BinPackParameters" : "false",
            \ "Standard" : "C++11",
            \ "BreakConstructorInitializersBeforeComma" : "false",
            \ "ColumnLimit" : "140",
            \ "IndentWidth" : "4",
            \ "TabWidth" : "4",
            \ "UseTab" : "Never",
            \ "IndentCaseLabels" : "false",
            \ "NamespaceIndentation" : "None",
            \ "AllowAllParametersOfDeclarationOnNextLine" : "true",
            \ "BreakBeforeBraces" : "Allman"}

" Unite {{{2
" file settings
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
nnoremap <leader>f :<C-u>Unite -no-split -buffer-name=files   -start-insert file_rec/async:!<cr>
nnoremap <leader>t :<C-u>Unite -no-split -buffer-name=tags    -start-insert tag<cr>
nnoremap <leader>r :<C-u>Unite -no-split -buffer-name=mru     file_mru<cr>
nnoremap <leader>o :<C-u>Unite -no-split -buffer-name=outline outline<cr>
nnoremap <leader>b :<C-u>Unite -no-split -buffer-name=buffer  buffer<cr>

" yank settings
let g:unite_source_history_yank_enable = 1
nnoremap <leader>y :<C-u>Unite -no-split -buffer-name=yank    -resume history/yank<cr>

" ag mappings
let g:unite_source_grep_command='ag'
let g:unite_source_grep_default_opts = '--nocolor --nogroup'
let g:unite_source_grep_recursive_opt = ''
noremap <silent> <Leader>sa :Unite grep:.::<C-R><C-w><CR>
noremap <silent> <Leader>sf :Unite grep:%::<C-r><C-w><CR>
noremap <silent> <Leader>ss :Unite grep:.<CR>

" Custom mappings for the unite buffer
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
    " Play nice with supertab
    let b:SuperTabDisabled=1
    " Enable navigation with control-j and control-k in insert mode
    imap <buffer> <C-j>   <Plug>(unite_select_next_line)
    imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction

"FSwitch - goto header/source file {{{2
map <F6> :FSHere<CR>
map! <F6> <Esc>:FSHere<CR>
au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '.,../include,./include/,./include/*,./include/*/*,../include/*,../include/*/*,../../include/,../../include/*,../../include/*/*'
au! BufEnter *.hpp let b:fswitchdst = 'cpp' | let b:fswitchlocs = '.,../src,..,./src/*,src/*/*,../../src,../../src/*,../../src/*/*'
au! BufEnter *.h let b:fswitchdst = 'cpp' | let b:fswitchlocs = '.,../src,..,./src/*,src/*/*,../../src,../../src/*,../../src/*/*'

"TagBar {{{2
map <F8> :TagbarToggle<CR>
map! <F8> <Esc>:TagbarToggle<CR>
let g:tagbar_width=45

"NERD Tree {{{2
map <F7> :NERDTreeToggle<CR>
map! <F7> <Esc>:NERDTreeToggle<CR>
let NERDTreeIgnore=['\.o$', '\~$']
let NERDTreeShowBookmarks=1
let NERDTreeWinSize=45
let NERDTreeDirArrows=1
let NERDTreeWinPos='right'
let NERDTreeHijackNetrw=1

"NERD Commenter {{{2
map <F5> <Leader>c<Space>


"Airline {{{2
let g:airline_powerline_fonts=1
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'tomorrow'

"Promptline {{{2
" sections (a, b, c, x, y, z, warn) are optional
let g:promptline_preset = {
        \'a' : [ '$VIMODE' ],
        \'b' : [ promptline#slices#cwd() ],
        \'c' : [ promptline#slices#vcs_branch(), promptline#slices#git_status(), promptline#slices#jobs()],
        \'y' : [ promptline#slices#user() ],
        \'z' : [ promptline#slices#host() ],
        \'warn' : [ promptline#slices#last_exit_code()] }

" available slices:
"
" promptline#slices#cwd() - current dir, truncated to 3 dirs. To configure: promptline#slices#cwd({ 'dir_limit': 4 })
" promptline#slices#vcs_branch() - branch name only. by default only git branch is enabled. Use promptline#slices#vcs_branch({ 'hg': 1, 'svn': 1}) to enable check for svn and mercurial branches. Note that always checking if inside a branch slows down the prompt
" promptline#slices#last_exit_code() - display exit code of last command if not zero
" promptline#slices#jobs() - display number of shell jobs if more than zero
" promptline#slices#battery() - display battery percentage (on OSX and linux) only if below 10%. Configure the threshold with promptline#slices#battery({ 'threshold': 25 })
" promptline#slices#host()
" promptline#slices#user()
" promptline#slices#python_virtualenv() - display which virtual env is active (empty is none)
" promptline#slices#git_status() - count of commits ahead/behind upstream, count of modified/added/unmerged files, symbol for clean branch and symbol for existing untraced files
"
" any command can be used in a slice, for example to print the output of whoami in section 'b':
"       \'b' : [ '$(whoami)'],
"
" more than one slice can be placed in a section, e.g. print both host and user in section 'a':
"       \'a': [ promptline#slices#host(), promptline#slices#user() ],
"
" to disable powerline symbols
" `let g:promptline_powerline_symbols = 0`

autocmd VimEnter * PromptlineSnapshot! ~/.shell_prompt.sh airline

"Gundo {{{2
let g:gundo_right=1
map <F9> :GundoToggle<CR>
map! <F9> <Esc>:GundoToggle<CR>

"AyncCommand {{{2
set makeprg=/home/jharvey/scripts/make.sh

function! AsyncRunTests()
    let cmd = "./run_tests.sh
    let title = "Install"
    call asynccommand#run(cmd, asynchandler#quickfix("%f", ""))
endfunction
command! AsyncInstall call AsyncInstall()

nnoremap <silent> <Leader>mm :AsyncMake "make"<CR>
nnoremap <silent> <Leader>mn :AsyncMake "make clean && ./configure && make"<CR>
nnoremap <silent> <Leader>mc :AsyncMake "make clean && cmake . && make"<CR>
nnoremap <silent> <Leader>mi :AsyncInstall<CR>


"TaskList {{{2
let g:tlWindowPosition = 1
map <leader>X <Plug>TaskList

"Fugitive {{{2


"Conque Terminal {{{2
let g:ConqueTerm_Color=2
let g:ConqueTerm_InsertOnEnter=1
let g:ConqueTerm_CloseOnEnd=1
let g:ConqueTerm_CWInsert=1
let g:ConqueTerm_SendVisKey ='<Leader>sp'
let g:ConqueTerm_ToggleKey = '<Leader>st'
let g:ConqueTerm_TERM = 'xterm'

nnoremap <silent> <Leader>sh :botright sp<CR>:resize 20<CR>:ConqueTerm zsh<CR>

" Conque GDB {{{2
let g:ConqueGdb_Leader = '<Leader>g'

"Syntastic {{{2
let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_aggregate_errors = 1
let g:syntastic_auto_loc_list=1
autocmd InsertLeave *.hpp,*.cpp,*.ipp SyntasticCheck cpplint

"Ack {{{2
let g:ackprg="/home/jharvey/scripts/ack -H --nocolor --nogroup --column"

"QuickHL {{{2
nmap <Leader>h <Plug>(quickhl-toggle)
xmap <Leader>h <Plug>(quickhl-toggle)
nmap <Leader>H <Plug>(quickhl-reset)
xmap <Leader>H <Plug>(quickhl-reset)
nnoremap <silent> <Leader>j :QuickhlMatchAuto<CR>
nnoremap <silent> <Leader>J :QuickhlMatchNoAuto<CR>:QuickhlMatchClear<CR>


"QuickRun {{{2
let g:quickrun_config = {}
let g:quickrun_config.cpp = {
            \   'type': 'cpp/clang++',
            \   'command': '/usr/local/bin/clang++',
            \   'exec': ['%c %o %s -o %s:p:r', '%s:p:r %a'],
            \   'tempfile': '%{tempname()}.cpp',
            \   'hook/sweep/files': ['%S:p:r'],
            \ }

"YankRing {{{2
let g:yankring_history_dir='$HOME/.vim/tmp'

"CppLint {{{2
autocmd FileType cpp map <buffer> <F4> :call Cpplint()<CR>
autocmd BufWritePost *.hpp,*.cpp,*.ipp call Cpplint()


" user settings {{{1
" misc {{{2
syntax on
set encoding=utf-8

set hidden
set wildmenu
set showcmd
set nohlsearch

set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set cinoptions=N-s
set nostartofline
set ruler
set laststatus=2
set confirm
set visualbell
set t_vb=
set mouse=a
set ttymouse=sgr
set cmdheight=2
set number
set notimeout ttimeout ttimeoutlen=200

set pastetoggle=<F11>
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

let g:clipbrdDefaultReg = '*'
"map! jj <Esc>
noremap ; :
noremap , ;

set shiftwidth=4
set softtabstop=4
set expandtab
set tabstop=4

map Y y$
nnoremap <C-L> :nohl<CR><C-L>

"grep {{{2
function! LocalGrep(text)
    exec "lvimgrep /" . a:text . "/j **"
    lopen
endfunction
map <F4> call LocalGrep(expand("<cword>"))
"map <F4> :execute "lvimgrep /" . expand("<cword>") . "/j **" <Bar> lopen<CR>
"map! <F4> <Esc>:execute "lvimgrep /" . expand("<cword>") . "/j **" <Bar> lopen<CR>
command! -nargs=1 Lgrep call LocalGrep(<f-args>)


"go to definition {{{2
"map <F3> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
"map <F3> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

"set path for jump to include {{{2
set path=$PWD/**,/projects/AlgoServer/**,/projects/AlgoUtils/**,/projects/**,/repository/**

"toggle for quickfix and location list menus {{{2
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

" window mgmt {{{2
set nowrap
set noequalalways
"nmap <silent> <C-h> :wincmd h<CR>
"nmap <silent> <C-j> :wincmd j<CR>
"nmap <silent> <C-k> :wincmd k<CR>
"nmap <silent> <C-l> :wincmd l<CR>
"nmap <silent> <C-=> :wincmd =<CR>
"nmap <silent> <C--> :wincmd _<CR>
"nmap <silent> <C-|> :wincmd |<CR>
set winminheight=0
set winheight=1

"Colour Schemes {{{2
set t_Co=256
set background=light
"colorscheme custom_kellys
colorscheme Tomorrow

" set font {{{2
set guifont=Terminess\ Powerline\ 8

"set CMakeCommon.txt to to have cmake filetype {{{2
au BufRead,BufNewFile CMakeCommon.txt set filetype=cmake

" highlight trailing whitespace {{{2
match Todo /\s\+$/

"Configure the cursor {{{2
if &term =~ "xterm\\|rxvt"
    " use an orange cursor in insert mode
    let &t_SI = "\<Esc>]12;orange\x7"
    " use a red cursor otherwise
    let &t_EI = "\<Esc>]12;red\x7"
    silent !echo -ne "\033]12;red\007"
    " reset cursor when vim exits
    autocmd VimLeave * silent !echo -ne "\033]12;gray\007"
endif
if &term =~ "screen-256color"
    autocmd VimEnter * silent !echo -ne "\033Ptmux;\033\033]12;red\033\\"
    " use an orange cursor in insert mode
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;orange\x7\<Esc>\\"
    " use a red cursor otherwise
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]12;red\x7\<Esc>\\"
    " reset cursor when vim exits
    autocmd VimLeave * silent !echo -ne "\033Ptmux;\033\033]12;red\033\\"
endif

set cursorline
hi CursorLine ctermbg=230 guibg=#303030

"folding settings {{{2
"set foldmethod=syntax
"set foldnestmax=1
"set foldenable
"set foldlevel=0
"set foldcolumn=2

"ctags {{{2
" map <ctrl>+F12 to generate ctags for current folder:
au BufWritePost *.c,*.cpp,*.h silent! !ctags -R &
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR><CR>
" add current directory's generated tags file to available tags
set tags+=./tags;/
set tags+=~/config/vim/vim/tags/stl.tags

" cpp syntax {{{2
let c_no_curly_error=1

" color column {{{2
" only set for cpp files (so moved to ftplugin
"let &colorcolumn=join(range(1,120),",")
"highlight ColorColumn ctermbg=234 guibg=#262626

" create non-existant directories on file write{{{2
function s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
        let dir=fnamemodify(a:file, ':h')
        if !isdirectory(dir)
            call mkdir(dir, 'p')
        endif
    endif
endfunction
augroup BWCCreateDir
    autocmd!
    autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

