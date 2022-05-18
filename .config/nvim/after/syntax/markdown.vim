" Note: The syntax highlighting is defined in ~/.config/nvim/plugged/nvim-markdown/syntax/markdown.vim
" See also: [Vim Colorscheme Solutions](Vim__Colorscheme__Solutions.md#md-italic)
" See Colorscheme.md for the respective colors.
" Make bold text simply bold without color change.
highlight htmlBold gui=bold
" Make an URL label purple.
highlight link mkdLink Underlined
" Make an URL light grey.
highlight link mkdURL Comment
" Make an URL label orange.
"highlight link mkdLink htmlArg
"" Make an URL purple.
"highlight link mkdURL Underlined
" Make the [ ] ( ) of a URL green
highlight link mkdDelimiter Statement
" Color italic text orange
highlight htmlItalic guifg=#b58900
" Color the ATX ### headers in lighter grey
highlight link mkdHeading Comment
"" Color H1 headlines/header in orange
"highlight htmlH1 ctermfg=2 guifg=#cd6a46 term=bold gui=bold cterm=bold
" Color H2 headlines/header in blue
highlight htmlH2 ctermfg=2 guifg=#268bd2 term=bold gui=bold cterm=bold
" highlight htmlH2 ctermfg=2 guifg=#507da9 term=bold gui=bold cterm=bold
" Color H3 headlines/header in darker green
highlight htmlH3 ctermfg=2 guifg=#607266 term=bold gui=bold cterm=bold
" Color H4 headlines/header in green/grey
highlight htmlH4 ctermfg=2 guifg=#889792 term=bold gui=bold cterm=bold
" Color H5 headlines/header in green/grey
highlight htmlH5 ctermfg=2 guifg=#889792 term=bold gui=bold cterm=bold

"" Disable syntax highlighting in insert mode.
"autocmd InsertEnter *.md se syn=off
"autocmd InsertLeave *.md se syn=on

" Using treesitter 
" https://www.reddit.com/r/neovim/comments/rg97j4/comment/hoje1mg/?utm_source=share&utm_medium=web2x&context=3
" Title: blue
highlight TSTitle guifg=#268bd2 gui=bold
" Title: red
"highlight TSTitle guifg=#cd6a46 gui=bold
highlight TSLiteral guifg=#2aa198
" Punctuations: green
highlight TSPunctSpecial guifg=#859900
"" Punctuations: blue
"highlight TSPunctSpecial guifg=#268bd2
"" Punctuations: red
"highlight TSPunctSpecial guifg=#cd6a46
"" Punctuations: grey
"highlight TSPunctSpecial guifg=#889792 
highlight TSURI gui=italic guifg=#93a1a1
highlight TSStringEscape guifg=#2aa198
" Italic: Orange
highlight TSEmphasis guifg=#b58900
"" Italic: Green
" highlight TSEmphasis guifg=#859900
highlight TSTextReference guifg=#6c71c4
"" Bold: green
"highlight TSStrong gui=bold guifg=#859900

