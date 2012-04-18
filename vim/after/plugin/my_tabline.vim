
hi TabLineTitle term=bold cterm=bold ctermfg=23 ctermbg=231

function! TabLineHeading()
    let heading = '%#TabLineTitle#'
    let heading .= ' Tabs '
    return heading
endfunction

hi TabLineCloseStart term=bold cterm=bold ctermfg=250 ctermbg=none
hi TabLineClose term=bold cterm=bold ctermfg=23 ctermbg=250

function! TabLineClosing()
    let closing = '%#TabLineCloseStart#'
    let closing .= nr2char(0x25c0)
    let closing .= '%999X'
    let closing .= '%#TabLineClose#'
    let closing .= ' Close '
    return closing
endfunction

function! TabPathname(number)
    let l:index = a:number - 1
    if len(s:pathnames) < a:number
        let l:pathname = substitute(getcwd(), "/.*jharvey", "\~", "")
        call insert(s:pathnames, l:pathname, l:index)
    else
        let l:pathname = s:pathnames[l:index]
    endif
    return l:pathname
endfunction

function! TabFilename(number)
     let bufferlist = tabpagebuflist(a:number)
     let windownum = tabpagewinnr(a:number)
     let buffernum = bufferlist[windownum - 1]
     let filename = bufname(buffernum)
     let buffertype = getbufvar(buffernum, 'buftype')
     if buffertype == 'nofile'
         if filename =~ '\/.'
             let filename = substitute(filename, '.*\/\ze.', '', '')
         endif
     else
         let filename = fnamemodify(filename, ':p:t')
     endif
     if filename == ''
         let filename = '[No Name]'
     endif
     return filename
endfunction

hi TabFocusStart term=bold cterm=bold ctermfg=250 ctermbg=31
hi TabFocusFirstStart term=bold cterm=bold ctermfg=231 ctermbg=31
hi TabFocus term=bold cterm=bold ctermfg=231 ctermbg=31
hi TabFocusCloseStart term=bold cterm=bold ctermfg=231 ctermbg=31
hi TabFocusClose term=bold cterm=bold ctermfg=23 ctermbg=231
hi TabFocusFillStart term=bold cterm=bold ctermfg=231 ctermbg=black

function! TabWithFocusClosing(number)
    let closing = '%#TabFocusCloseStart#'
    let closing .= '◀'
    let closing .= '%#TabFocusClose#'
    let closing .='%' . a:number . 'X X %X'
    if a:number == tabpagenr('$')
        let closing .= '%#TabFocusFillStart#'
        let closing .= '▶'
    endif
    return closing
endfunction

function! TabWithFocus(number)
    let focus = '%' . a:number . 'T'
    let focus .= (a:number == 1 ? '%#TabFocusFirstStart#' : '%#TabFocusStart#')
    let focus .= '▶'
    let focus .= '%#TabFocus#'
    let focus .= ' ' . a:number . ' ' . nr2char(0x276f) . ' '
    let focus .= TabPathname(a:number)
    let focus .= '%m '
    let focus .= TabWithFocusClosing(a:number)
    return focus
endfunction


hi TabNoFocusStart term=bold cterm=bold ctermfg=250 ctermbg=24
hi TabNoFocusFirstStart term=bold cterm=bold ctermfg=231 ctermbg=24
hi TabNoFocus term=bold cterm=bold ctermfg=117 ctermbg=24
hi TabNoFocusCloseStart term=bold cterm=bold ctermfg=250 ctermbg=24
hi TabNoFocusClose term=bold cterm=bold ctermfg=23 ctermbg=250
hi TabNoFocusFillStart term=bold cterm=bold ctermfg=250 ctermbg=none

function! TabWithoutFocusClosing(number)
    let closing = '%#TabNoFocusCloseStart#'
    let closing .= nr2char(0x25c0)
    let closing .= '%#TabNoFocusClose#'
    let closing .='%' . a:number . 'X x %X'
    if a:number == tabpagenr('$')
        let closing .= '%#TabNoFocusFillStart#'
        let closing .= '▶'
    endif
    return closing
endfunction

function! TabWithoutFocus(number)
    let nofocus = '%' . a:number . 'T'
    let nofocus .= ((a:number == 1) || ((a:number - 1) == tabpagenr()) ? '%#TabNoFocusFirstStart#' : '%#TabNoFocusStart#')
    let nofocus .= '▶'
    let nofocus .= '%#TabNoFocus#'
    let nofocus .= ' ' . a:number . ' ' . nr2char(0x276f) . ' '
    let nofocus .= TabPathname(a:number)
    let nofocus .= ' '
    let nofocus .= TabWithoutFocusClosing(a:number)
    return nofocus
endfunction


hi TabLineFill term=bold cterm=bold ctermfg=236 ctermbg=none

let s:pathnames = []
if exists("+showtabline")
    function! MyTabLine()
        let s = TabLineHeading()
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            if i == t
                let s .= TabWithFocus(i)
            else
                let s .= TabWithoutFocus(i)
            endif
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        "let s .= TabLineClosing()
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
endif

