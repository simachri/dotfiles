" 21-1-16: Disable conceal which improves performance for Vim markdown files.
" 21-10-27: Running in WSL: Enable it again.
let g:vim_markdown_conceal=2
let g:vim_markdown_conceal_code_blocks = 1
" " Only conceal in 'normal' and 'command' mode
" set concealcursor=nc
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_no_extensions_in_markdown = 0
"" Add support for markdown files in tagbar.
"let g:tagbar_type_markdown = {
"    \ 'ctagstype': 'markdown',
"    \ 'ctagsbin' : '~/.config/nvim/plugged/markdown2ctags/markdown2ctags.py',
"    \ 'ctagsargs' : '-f - --sort=yes',
"    \ 'kinds' : [
"        \ 's:sections',
"        \ 'i:images'
"    \ ],
"    \ 'sro' : '|',
"    \ 'kind2scope' : {
"        \ 's' : 'section',
"    \ },
"    \ 'sort': 0,
"\ }
"" Add support for markdown (pandoc flavour) files in tagbar.
"" Source: https://stackoverflow.com/a/58768939
"let g:tagbar_type_pandoc = {
"    \ 'ctagstype': 'pandoc',
"    \ 'ctagsbin' : '~/.vim/plugged/markdown2ctags/markdown2ctags.py',
"    \ 'ctagsargs' : '-f - --sort=yes',
"    \ 'kinds' : [
"        \ 's:sections',
"        \ 'i:images'
"    \ ],
"    \ 'sro' : '|',
"    \ 'kind2scope' : {
"        \ 's' : 'section',
"    \ },
"    \ 'sort': 0,
"\ }

" Set {anchor} as the anchor expression - this is aligned with Pandoc's anchor mechanism.
" Note: When setting the anchor, use {#<anchor name>}, e.g. {#my-anchor} such that
" Pandoc omits the anchor in the heading when rendered.
" 2020-12-26 Changed to make it work with the GitHub markdown flavour style, that is,
" use <a id="<anchor>"></a> as an anchor. This has the following advantages:
" - No {#<anchor>} expressions displayed.
" - Yanking the anchor becomes quicker.
" let g:vim_markdown_anchorexpr = "'{#'.v:anchor.'}'"
let g:vim_markdown_anchorexpr = "'id=\"'.v:anchor.'\"'"

" Follow anchors with 'ge' in links that lack the markdown extension.
" This behaviour makes the links compatible when uploaded to Djanog wiki.
let g:vim_markdown_no_extensions_in_markdown = 1

" Set the syntax highlighting to work on larger fenced code blocks.
" 21-10-27: WSL has better performance. Disable it.
" let g:markdown_minlines = 50

" Create a complete anchor link of format [filename wo ext](#anchor-link)
" 1. Clear register d
" 2. Search for the anchor in the current line, that is, <a id="anchor-name"></a> and match
"    everything in the double quotes.
" 3. Yank the match to register d.
" 4. Disable highlighting of search results.
augroup MARKDOWN
  autocmd!
  " 'Get anchor' link without the filename as the link description.
  autocmd FileType markdown nnoremap <Leader>ga qdq:s/<a id="\zs.*\ze"><\/a>/\=setreg('y', submatch(0))/n<CR>
                    \:let @x=expand('%:r')<CR>
                    \:nohlsearch<CR>
                    \:echo('Anchor copied to clipboard.')<CR>
                    "\:let @+="(".expand('%:r')."#".@d.")"<CR>
  " Currently not used: Create a full anchor link
  "autocmd FileType markdown nnoremap <Leader>al qdq:s/<a id="\zs.*\ze"><\/a>/\=setreg('d', submatch(0))/n<CR>
  "                  \:let @+="[".substitute(substitute(substitute(@%, "__", " ", "g"), "_", " ", "g"), ".md", "", "")."]
  "                  \(".@%."#".@d.")"<CR>
  "                  \:nohlsearch<CR>
  " 'Add anchor'
  autocmd FileType markdown nnoremap <Leader>aa o<a id=""></a><Esc>5hi
  " Use ge in markdown files to follow link and open in horizontal split.
  autocmd FileType markdown nmap <buffer><silent> ge m'<Plug>Markdown_EditUrlUnderCursor
  " Use gs in markdown files to follow link and open in vertical split.
  autocmd FileType markdown nmap <buffer><silent> gs m'<C-W>v<Plug>Markdown_EditUrlUnderCursor
  autocmd FileType markdown nmap <buffer> <silent> [c <Plug>Markdown_MoveToCurHeader
  autocmd FileType markdown nmap <buffer> <silent> [p <Plug>Markdown_MoveToParentHeader
  " Paste image: 'ferrine/md-img-paste.vim'
  autocmd FileType markdown nmap <buffer><silent> <leader>pi :call mdip#MarkdownClipboardImage()<CR>
augroup END

" Follow anchors, that is, the `ge` command will jump to the anchor <file>#<anchor>.
let g:vim_markdown_follow_anchor=1
" Paste image: 'ferrine/md-img-paste.vim'
" there are some defaults for image directory and image name, you can change them
let g:mdip_imgdir = '.images'
let g:mdip_imgname = 'img'

" Convert an legacy anchor {#anchor} into a new anchor <a id="anchor"></a>.
" 1. Clear register f.
" 2. Search for the legacy anchor in the current line, that is, {#anchor-name} and match
"    everything between {# and }.
" 3. Yank the match to register f.
" 4. Delete the legacy anchor.
" 5. Go back to the previously visited location (otherwise we are at the first character 
"    in the line).
" 6. Insert a new anchor and paste the contents from register f.
" 7. Disable highlighting of search results.
nnoremap <Leader>ac qfq:s/{#\zs.*\ze}/\=setreg('f', submatch(0))/n<CR>
          \:s/{#.*}/<a id=\"<C-r>f\"><\/a>/<CR>
          \:nohlsearch<CR>

" 'Convert header' Convert a righ-aligned line to a second-level markdown header
nnoremap <Leader>ch ^xf`x0cw## <C-[>
" Markdown preview
" Use commands :MarkdownPreview and :MarkdownPreviewStop instead
" nmap <Leader>p <Plug>MarkdownPreviewToggle
let g:mkdp_browser = 'brave'
" For additional filetype settings regarding markdown see
" ~/.vim/after/ftplugin/markdown.vim

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

" Disable plugin folding as it dramatically slows down performance.
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_override_foldtext=1
let g:vim_markdown_folding_style_pythonic=0
let g:vim_markdown_folding_level = 4
" Allow folding
" Source: https://stackoverflow.com/a/4677454
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
" Toggle outline
" noremap <buffer> <Leader>to :TagbarToggle<CR>
" https://github.com/ixru/nvim-markdown
noremap <buffer> <Leader>to :Toc<CR>
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
nnoremap <buffer> <silent> <Leader>jn :ToggleCheckBox<CR>
nnoremap <buffer> <silent> <Leader>jd :SetCheckBoxDone<CR>
nnoremap <buffer> <silent> <Leader>jo :SetCheckBoxOpen<CR>
nnoremap <buffer> <silent> <Leader>ju :SetCheckBoxUp<CR>
