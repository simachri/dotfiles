" Good guide: https://blog.siddharthkannan.in/vim/configuration/2019/11/02/format-list-pat-and-vim/
" Prevent automatic leader insertion after using the gq command for reformatting:
" - the default regex is ^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:
"   see /usr/share/vim/vim82/ftplugin/markdown.vim
" - added the \s* in the middle:
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*[-*+]\\s\\+\\\|^\\[^\\ze[^\\]]\\+\\]:

"q	Allow formatting of comments with "gq".
"	Note that formatting will not change blank lines or lines containing
"	only the comment leader.  A new paragraph starts after such a line,
"	or when the comment leader changes.
"r	Automatically insert the current comment leader after hitting
"	<Enter> in Insert mode.
"o	Automatically insert the current comment leader after hitting 'o' or
	"'O' in Normal mode.
"t	Auto-wrap text using textwidth
"       is always set by: /usr/share/vim/vim82/ftplugin/markdown.vim
" setlocal fo-=t fo-=q fo-=r
setlocal formatoptions=Mwjlnt

" Prevent jumping to beginning of line when insertin a '#'.
" See also: ~/.config/nvim/plugged/vim-markdown/indent/markdown.vim
set indentkeys=


""""""""""""""""""""""""""""""""""""""
" Allow folding
" Source: https://stackoverflow.com/a/4677454
""""""""""""""""""""""""""""""""""""""
function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
    return "=" 
endfunction
au BufEnter *.md setlocal foldexpr=MarkdownLevel()  
au BufEnter *.md setlocal foldmethod=expr   

""""""""""""""""""""""""""""""""""""""
" Keymaps
""""""""""""""""""""""""""""""""""""""
" "Find header", previously "Find tags"
noremap <buffer> <Leader>fh :TagbarOpenAutoClose<CR>
" "Toggle checkbox ([Jack]box :))"
function! ToggleCb(option)
  let currLineText = getline(".")
  " If an option is given, evaluate it directly.
  if a:option == "done"
    call setline(".", substitute(currLineText, "- [.*\\]", "- [X]", ""))
    return
  elseif a:option == "open"
    call setline(".", substitute(currLineText, "- [.*\\]", "- [ ]", ""))
    return
  elseif a:option == "up"
    call setline(".", substitute(currLineText, "- [.*\\]", "- [^]", ""))
    return
  endif

  " If checkbox is empty: Check it.
  let replacedText = substitute(currLineText, "- [ \\]", "- [X]", "")
  if currLineText != replacedText
    " Replace text.
    call setline(".", replacedText)
    return
  endif

  " If checkbox is checked: Set to invalid.
  let replacedText = substitute(currLineText, "- [X\\]", "- [-]", "")
  if currLineText != replacedText
    " Replace text.
    call setline(".", replacedText)
    return
  endif

  " If checkbox is invalid: Set to follow-up.
  let replacedText = substitute(currLineText, "- [-\\]", "- [^]", "")
  if currLineText != replacedText
    " Replace text.
    call setline(".", replacedText)
    return
  endif

  " If checkbox is set to follow-up: Clear it.
  let replacedText = substitute(currLineText, "- [^\\]", "- [ ]", "")
  if currLineText != replacedText
    " Replace text.
    call setline(".", replacedText)
    return
  endif

  " No checkbox available yet. Add one.
  normal I- [ ] 
endfunction
command ToggleCheckBox call ToggleCb('')
command SetCheckBoxDone call ToggleCb('done')
command SetCheckBoxOpen call ToggleCb('open')
command SetCheckBoxUp call ToggleCb('up')
nnoremap <buffer> <silent> <Leader>tjn :ToggleCheckBox<CR>
nnoremap <buffer> <silent> <Leader>tjd :SetCheckBoxDone<CR>
nnoremap <buffer> <silent> <Leader>tjo :SetCheckBoxOpen<CR>
nnoremap <buffer> <silent> <Leader>tju :SetCheckBoxUp<CR>
