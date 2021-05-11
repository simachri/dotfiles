" Note: The syntax highlighting is defined in ~/.config/nvim/plugged/vim-markdown/syntax/markdown.vim
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


