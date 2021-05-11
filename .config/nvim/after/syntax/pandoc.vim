" Remove character '/' from the keyword list sucht that a string between two '/'
" is considered a 'word'.
set iskeyword-=/

"" Hide header symbols #
"" Original: /home/xi3k/.config/nvim/plugged/vim-pandoc-syntax/syntax/pandoc.vim
"" call s:WithConceal('atx', 'syn match pandocAtxStart /#/ contained containedin=pandocAtxHeaderMark', 'conceal cchar='.s:cchars['atx'])
"syn match AtxStart /# / contained containedin=pandocAtxHeader conceal

syn match pandocAtxHeader /\(\%^\|<.\+>.*\n\|^\s*\n\)\@<=#\{1}.*\n/ contains=pandocEmphasis,pandocStrong,pandocNoFormatted,pandocLaTeXInlineMath,pandocEscapedDollar,@Spell,pandocAmpersandEscape,pandocReferenceLabel,pandocReferenceURL display
" Make the # of the first level header red instead of green
highlight link pandocAtxStart pandocAtxHeader

" Color H2 headlines/header in blue
highlight pandocAtxHeader2 ctermfg=2 guifg=#268bd2 term=bold gui=bold cterm=bold
highlight pandocAtxHeaderMark2 ctermfg=2 guifg=#268bd2 term=bold gui=bold cterm=bold
syn match pandocAtxHeader2 /\(\%^\|<.\+>.*\n\|^\s*\n\)\@<=#\{2}.*\n/ contains=pandocEmphasis,pandocStrong,pandocNoFormatted,pandocLaTeXInlineMath,pandocEscapedDollar,@Spell,pandocAmpersandEscape,pandocReferenceLabel,pandocReferenceURL display
" syn match pandocAtxHeaderMark2 /\(^#\{1,6} \|\\\@<!#\+\(\s*.*$\)\@=\)/ contained containedin=pandocAtxHeader2 conceal
syn match pandocAtxHeaderMark2 /\(^#\{1,6} \|\\\@<!#\+\(\s*.*$\)\@=\)/ contained containedin=pandocAtxHeader2

" Color H3 headlines/header in darker green
highlight pandocAtxHeader3 ctermfg=2 guifg=#607266 term=bold gui=bold cterm=bold
highlight pandocAtxHeaderMark3 ctermfg=2 guifg=#607266 term=bold gui=bold cterm=bold
syn match pandocAtxHeader3 /\(\%^\|<.\+>.*\n\|^\s*\n\)\@<=#\{3}.*\n/ contains=pandocEmphasis,pandocStrong,pandocNoFormatted,pandocLaTeXInlineMath,pandocEscapedDollar,@Spell,pandocAmpersandEscape,pandocReferenceLabel,pandocReferenceURL display
" syn match pandocAtxHeaderMark3 /\(^#\{1,6} \|\\\@<!#\+\(\s*.*$\)\@=\)/ contained containedin=pandocAtxHeader3 conceal
syn match pandocAtxHeaderMark3 /\(^#\{1,6} \|\\\@<!#\+\(\s*.*$\)\@=\)/ contained containedin=pandocAtxHeader3

" Color H4 headlines/header in green/grey
highlight pandocAtxHeader4 ctermfg=2 guifg=#889792 term=bold gui=bold cterm=bold
highlight pandocAtxHeaderMark4 ctermfg=2 guifg=#889792 term=bold gui=bold cterm=bold
syn match pandocAtxHeader4 /\(\%^\|<.\+>.*\n\|^\s*\n\)\@<=#\{4}.*\n/ contains=pandocEmphasis,pandocStrong,pandocNoFormatted,pandocLaTeXInlineMath,pandocEscapedDollar,@Spell,pandocAmpersandEscape,pandocReferenceLabel,pandocReferenceURL display
" syn match pandocAtxHeaderMark4 /\(^#\{1,6} \|\\\@<!#\+\(\s*.*$\)\@=\)/ contained containedin=pandocAtxHeader4 conceal
syn match pandocAtxHeaderMark4 /\(^#\{1,6} \|\\\@<!#\+\(\s*.*$\)\@=\)/ contained containedin=pandocAtxHeader4

" Make links work in ordered lists
" Original: /home/xi3k/.config/nvim/plugged/vim-pandoc-syntax/syntax/pandoc.vim
syn match pandocListItem /^\s*(\?\(\d\+\|\l\|\#\|@\)[.)].*$/ nextgroup=pandocListItem,pandocLaTeXMathBlock,pandocLaTeXInlineMath,pandocEscapedDollar,pandocDelimitedCodeBlock,pandocListItemContinuation contains=@Spell,pandocEmphasis,pandocStrong,pandocNoFormatted,pandocStrikeout,pandocSubscript,pandocSuperscript,pandocStrongEmphasis,pandocStrongEmphasis,pandocPCite,pandocICite,pandocCiteKey,pandocReferenceLabel,pandocReferenceURL,pandocLaTeXCommand,pandocLaTeXMathBlock,pandocLaTeXInlineMath,pandocEscapedDollar,pandocAutomaticLink,pandocFootnoteDef,pandocFootnoteBlock,pandocFootnoteID,pandocAmpersandEscape skipempty display

" Make an URL label orange.
highlight link pandocReferenceLabel htmlArg
" highlight link pandocOperator Underlined
" highlight link pandocReferenceURL Label
" Make italic text green
highlight pandocEmphasis ctermfg=9 guifg=#859900
