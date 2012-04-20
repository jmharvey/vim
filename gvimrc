" remove most gui decoration
set guioptions=aci

" remove annoying gui visual bell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

" set the cursor
highlight Cursor guibg=red
highlight iCursor guibg=orange
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait500
