nnoremap <silent> <buffer> <cr> :CSearchContext<cr>
compiler gcc

"color column
let &l:colorcolumn=join(range(1,120),",")
highlight ColorColumn ctermbg=234 guibg=#262626
