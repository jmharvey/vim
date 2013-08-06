" .VIMRC
" ~~~~~~~
" vim: foldmethod=marker

" general {{{1
" Source the vimrc file after saving it {{{2
if has("autocmd")
   autocmd bufwritepost .vimrc source $MYVIMRC
endif

" misc {{{2
set nocompatible
filetype indent plugin on
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
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>
"nmap <silent> <C-=> :wincmd =<CR>
"nmap <silent> <C--> :wincmd _<CR>
"nmap <silent> <C-|> :wincmd |<CR>
set winminheight=0
set winheight=1

"Colour Schemes {{{2
set t_Co=256
set background=dark
colorscheme custom_kellys

" set font {{{2
set guifont=Monospace\ 8

"set highlighting for bash vi mode {{{2
au BufRead,BufNewFile bash-fc-* set filetype=sh

"set CMakeCommon.txt to to have cmake filetype
au BufRead,BufNewFile CMakeCommon.txt set filetype=cmake

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

" plugins {{{1
"Pathogen {{{2
call pathogen#infect()
call pathogen#helptags()

"FSwitch - goto header/source file {{{2
map <F6> :FSHere<CR>
map! <F6> <Esc>:FSHere<CR>
au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '.,../include,./include/,./include/*,./include/*/*'
au! BufEnter *.hpp let b:fswitchdst = 'cpp' | let b:fswitchlocs = '.,../src,..,./src/*,src/*/*'
au! BufEnter *.h let b:fswitchdst = 'cpp' | let b:fswitchlocs = '.,../src,..,./src/*,./src/*/*'

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

"clang complete {{{2
let g:clang_use_library=1
let g:clang_library_path="/usr/local/lib"
let g:clang_complete_copen=1
let g:clang_snippets=1
let g:clang_trailing_placeholder=1
let g:clang_user_options='-std=c++11'
let g:clang_complete_macros=1
let g:clang_complete_patterns=1
map <F2>  :call g:ClangUpdateQuickFix()<CR>
set completeopt-=preview

"PowerLine {{{2
let g:Powerline_symbols="compatible"

"Command-T {{{2
nnoremap <silent> <Leader>f :CommandT<CR>
nnoremap <silent> <Leader>b :CommandTBuffer<CR>
let g:CommandTMaxHeight=50
set wildignore+=*.o,*.so

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

"CamelCaseMovement {{{2
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

"Conque Terminal {{{2
let g:ConqueTerm_Color=2
let g:ConqueTerm_InsertOnEnter=1
let g:ConqueTerm_CloseOnEnd=1
let g:ConqueTerm_CWInsert=1
let g:ConqueTerm_SendVisKey ='<Leader>sp'
let g:ConqueTerm_ToggleKey = '<Leader>st'
let g:ConqueTerm_TERM = 'xterm'

nnoremap <silent> <Leader>sh :botright sp<CR>:resize 20<CR>:ConqueTerm zsh<CR>

"eclim {{{2
let g:EclimCSearchSingleResult='lopen'
let g:EclimCHierarchyDefaultAction='vsplit'
"let g:EclimProjectTreeAutoOpen=1
let g:EclimProjectTreeExpandPathOnOpen=1

"SuperTab {{{2
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = "<c-x><c-u>"
let g:SuperTabClosePreviewOnPopupClose = 1


"Syntastic {{{2
let g:syntastic_mode_map = { 'mode': 'active',
            \ 'active_filetypes': ['ruby', 'php'],
            \ 'passive_filetypes': ['cpp'] }

"Ack {{{2
let g:ackprg="/home/jharvey/scripts/ack -H --nocolor --nogroup --column"

"QuickHL {{{2
nmap <Leader>h <Plug>(quickhl-toggle)
xmap <Leader>h <Plug>(quickhl-toggle)
nmap <Leader>H <Plug>(quickhl-reset)
xmap <Leader>H <Plug>(quickhl-reset)
nnoremap <silent> <Leader>j :QuickhlMatchAuto<CR>
nnoremap <silent> <Leader>J :QuickhlMatchNoAuto<CR>:QuickhlMatchClear<CR>

"TryIt {{{2
let g:tryit_dir = "$HOME/.vim/tryit"
nmap  <Leader>t <Plug>(tryit-this)
xmap  <Leader>t <Plug>(tryit-this)
nmap  <Leader>T <Plug>(tryit-ask)
xmap  <Leader>T <Plug>(tryit-ask)

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

"set efm=%*[^"]"%f"%*\D%l: %m,"%f"%*\D%l: %m,%-G%f:%l: (Each undeclared identifier is reported only once,%-G%f:%l: for each function it appears in.),%-GIn file included from %f:%l:%c:,%-GIn file included from %f:%l:%c\,,%-GIn file included from %f:%l:%c,%-GIn file included from %f:%l,%-G%*[ ]from %f:%l:%c,%-G%*[ ]from %f:%l:,%-G%*[ ]from %f:%l\,,%-G%*[ ]from %f:%l,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,"%f"\, line %l%*\D%c%*[^ ] %m,%D%*\a[%*\d]: Entering directory `%f',%X%*\a[%*\d]: Leaving directory `%f',%D%*\a: Entering directory `%f',%X%*\a: Leaving directory `%f',%DMaking %*\a in %f,%f|%l| %m
"set efm=%*[^\"]\"%f\"%*\D%l:\ %m,\"%f\"%*\D%l:\ %m,%-G%f:%l:\ (Each\ undeclared\ identifier\ is\ reported\ only\ once,%-G%f:%l:\ for\ each\ function\ it\ appears\ in.),%-GIn\ file\ included\ from\ %f:%l:%c:,%-GIn\ file\ included\ from\ %f:%l:%c\,,%-GIn\ file\ included\ from\ %f:%l:%c,%-GIn\ file\ included\ from\ %f:%l,%-G%*[\ ]from\ %f:%l:%c,%-G%*[\ ]from\ %f:%l:,%-G%*[\ ]from\ %f:%l\,,%-G%*[\ ]from\ %f:%l,%f:%l:%c:%m,%f(%l):%m,\ line\ %l%*\D%c%*[^\ ]\ %m,%D%*\a[%*\d]:\ Entering\ directory\ `%f',%X%*\a[%*\d]:\ Leaving\ directory\ `%f',%D%*\a:\ Entering\ directory\ `%f',%X%*\a:\ Leaving\ directory\ `%f',%DMaking\ %*\a\ in\ %f,%f|%l|\ %m
"set efm=%*[^"]"%f"%*\D%l: %m
"set efm="%f"%*\D%l: %m
"set efm=%-G%f:%l: (Each undeclared identifier is reported only once
"set efm=%-G%f:%l: for each function it appears in.)
"set efm=%-GIn file included from %f:%l:%c:
"set efm=%-GIn file included from %f:%l:%c\
"set efm=%-GIn file included from %f:%l:%c\
"set efm=%-GIn file included from %f:%l:%c
"set efm=%-GIn file included from %f:%l
"set efm=%-G%*[ ]from %f:%l:%c
"set efm=%-G%*[ ]from %f:%l:
"set efm=%-G%*[ ]from %f:%l\
"set efm=%-G%*[ ]from %f:%l
"set efm=%f:%l:%c:%m
"set efm=%f(%l):%m
"set efm=%f:%l:%m
"set efm="%f"\
"set efm= line %l%*\D%c%*[^ ] %m
"set efm=%D%*\a[%*\d]: Entering directory `%f'
"set efm=%X%*\a[%*\d]: Leaving directory `%f'
"set efm=%D%*\a: Entering directory `%f'
"set efm=%X%*\a: Leaving directory `%f'
"set efm=%DMaking %*\a in %f,%f|%l| %m

