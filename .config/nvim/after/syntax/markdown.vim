" Literals: Cyan
highlight @text.literal guifg=#2aa198
" Italic: Orange
highlight @text.emphasis guifg=#b58900
" Bold
highlight @text.strong gui=bold
" Punctuation symbols
highlight @punctuation.special guifg=#268bd2
highlight @punctuation.delimiter guifg=#93a1a1

highlight @text.reference guifg=#6c71c4
highlight @text.uri gui=italic guifg=#93a1a1

" Color the ATX ### headers in lighter grey
highlight @md.header_marker guifg=#93a1a1 gui=italic,nocombine
" Color H1 headlines/header in red
highlight @md.h1_text ctermfg=2 guifg=#cd6a46 term=bold gui=bold cterm=bold
" Color H2 headlines/header in blue
highlight @md.h2_text ctermfg=2 guifg=#268bd2 term=bold gui=bold cterm=bold
" Color H3 headlines/header in darker green
highlight @md.h3_text ctermfg=2 guifg=#607266 term=bold gui=bold cterm=bold
" Color H4 headlines/header in green/grey
highlight @md.h4_text ctermfg=2 guifg=#889792 term=bold gui=bold cterm=bold
" Color H5 headlines/header in green/grey
highlight @md.h5_text ctermfg=2 guifg=#889792 term=bold gui=bold cterm=bold
