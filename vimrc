" .VIMRC
" ~~~~~~~
" vim: foldmethod=marker
" start-up {{{1
if &compatible
    set nocompatible
endif

" plugins {{{1
" install vim-plug first
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" packages
call plug#begin('~/.vim/plugged')
" mine @ github
Plug 'jmharvey/vim-template'
" other @ github
Plug 'sjl/gundo.vim'
Plug 'w0rp/ale'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-tbone'
Plug 'tpope/vim-projectionist'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'bkad/CamelCaseMotion'
Plug 'vim-scripts/argtextobj.vim'
Plug 'majutsushi/tagbar'
Plug 'flazz/vim-colorschemes'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'altercation/vim-colors-solarized'
Plug 'mileszs/ack.vim'
Plug 'kshenoy/vim-signature'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/promptline.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'christoomey/vim-tmux-navigator'
if version > 704 || (version == 704 && has("patch1578"))
    Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang_completer' }
endif
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'gregsexton/gitv'
Plug 'airblade/vim-gitgutter'
Plug 'iberianpig/tig-explorer.vim'
call plug#end()

" termdebug
if has("packages")
    packadd termdebug
endif

" YouCompleteMe {{{2
let g:ycm_global_ycm_extra_conf = '~/dev/.ycm_extra_conf.py'
let g:ycm_autoclose_preview_window_after_insertion = 1
nnoremap <F2> :YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>jd :YcmCompleter GoTo<CR>
set completeopt-=preview

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
let g:airline_powerline_fonts=0
let g:airline_left_set=' '
let g:airline_right_set=' '
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline_theme = 'tomorrow'

"Promptline {{{2
" sections (a, b, c, x, y, z, warn) are optional
let g:promptline_preset = {
        \'a' : [ '$VIMODE' ],
        \'b' : [ promptline#slices#user() ],
        \'c' : [ promptline#slices#host() ],
        \'y' : [ promptline#slices#cwd() ],
        \'z' : [ promptline#slices#vcs_branch(), promptline#slices#git_status(), promptline#slices#jobs()],
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
let g:promptline_powerline_symbols = 0

autocmd VimEnter * PromptlineSnapshot! ~/.promptline.sh airline

"Tmuxline {{{2
" to disable powerline symbols
let g:tmuxline_powerline_symbols = 0
let g:tmuxline_separators = {
    \ 'left' : '',
    \ 'left_alt': '|',
    \ 'right' : '',
    \ 'right_alt' : '|',
    \ 'space' : ' '}
"Gundo {{{2
let g:gundo_right=1
map <F9> :GundoToggle<CR>
map! <F9> <Esc>:GundoToggle<CR>

" fzf {{{2
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>a :Ag<CR>
nnoremap <leader>t :BTags<CR>

"Ack {{{2
let g:ackprg="/home/jharvey/scripts/ack -H --nocolor --nogroup --column"

"Dispatch {{{2
" set compile command in project .vimrc
nnoremap <leader>mc :Dispatch g:local#cmake_command<CR>
nnoremap <leader>mm :Dispatch g:local#make_command<CR>
nnoremap <leader>mt :Dispatch g:local#test_command<CR>
nnoremap <leader>mf :Dispatch g:local#test_command . " --gtest_filter="

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
set splitbelow
set splitright

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
au BufWritePost *.c,*.cpp,*.h silent! !ctags -R --exclude='*.js'&
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --exclude='*.js' .<CR><CR>
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

" source project specific settings{{{2
set exrc
set secure
