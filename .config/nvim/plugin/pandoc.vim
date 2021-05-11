let g:pandoc#spell#enabled = 0
let g:pandoc#syntax#conceal#blacklist = [ "atx", "inlinecode", "image" ]
"let g:pandoc#syntax#conceal#cchar_overrides = {"atx" : "λ"}
let g:pandoc#syntax#conceal#cchar_overrides = {"footnote" : "^"}
let g:pandoc#syntax#conceal#urls = 0
let g:pandoc#syntax#codeblocks#embeds#langs = ["java", "vim", "abap", "python" ]
" Prevent <Leader>g* mappings, see here: /home/xi3k/.config/nvim/plugged/vim-pandoc/autoload/pandoc/keyboard/links.vim
let g:pandoc#keyboard#use_default_mappings = 0 
let g:pandoc#syntax#style#emphases = 1
let g:pandoc#syntax#style#use_definition_lists = 0
