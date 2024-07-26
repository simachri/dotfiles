set scl=auto
" Set minimal line number column width.
set numberwidth=6
" Do not use automatic wrapping as the Jira syntax
" takes over linebreakes into the rendered result.
" Use warpping instead.
"" Automatically wrap on textwidth.
"set fo+=t
set wrap
set tw=0
" Disable wrap marging as this will insert line breaks.
set wrapmargin=0

" Make text italic.
nmap <buffer><silent> <leader>mi ysiW_
" Make text bold.
nmap <buffer><silent> <leader>mb ysiW*
" Make text code.
nmap <buffer><silent> <leader>mc ysiW}l.

