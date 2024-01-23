" 'text' became 'markup'
" 'punctuation.special' became 'markup.list'
" see https://github.com/nvim-treesitter/nvim-treesitter/pull/5831

" Literals: Cyan
highlight @markup.literal guifg=#2aa198
" Italic: Orange
highlight @markup.emphasis guifg=#b58900
" Bold
highlight @markup.strong gui=bold
" Punctuation symbols
highlight @markup.special guifg=#268bd2
highlight @punctuation.delimiter guifg=#93a1a1

highlight @markup.reference guifg=#6c71c4
highlight @markup.uri gui=italic guifg=#93a1a1
