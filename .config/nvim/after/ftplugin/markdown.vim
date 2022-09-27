" 21-1-16: Disable conceal which improves performance for Vim markdown files.
" 21-10-27: Running in WSL: Enable it again.
let g:vim_markdown_conceal=2
let g:vim_markdown_conceal_code_blocks = 1
" " Only conceal in 'normal' and 'command' mode
" set concealcursor=nc
let g:vim_markdown_strikethrough = 1
" Do not add extra indents when pressing 'o' or 'O' in a list.
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

"" Disable relative line numbers.
"setlocal nonumber norelativenumber
"" Set width of sign column to 1.
"set scl=yes:1
" Disable sign column.
set scl=no
" Set minimal line number column width.
set numberwidth=6

""""""""""""""""""""""""""""""""""""""
" Keymaps
""""""""""""""""""""""""""""""""""""""
" Unmap the plugin mapping of nvim-markdown 'follow link' which causes in normal mode 
" that the word under the cursor is transformed into a URL.
nmap <buffer><CR> <CR>
" Make text italic.
nmap <buffer><silent> <leader>mi ysiW_
" Make text bold.
nmap <buffer><silent> <leader>mb ysiW_.
" 21-12-29: Is remapped further below.
" Use ge in markdown files to follow link and open in horizontal split.
nmap <buffer><silent> ge m':call <sid>EditUrlUnderCursor()<cr>
" Use gs in markdown files to follow link and open in vertical split.
nmap <buffer><silent> gs m'<C-W>v:call <sid>EditUrlUnderCursor()<cr>
" Disable [c and ]c as they interfere with diffmode mappings when diffing a markdown 
" file.
nmap <buffer> [c [c
nmap <buffer> ]c ]c
nmap <buffer><silent> [u <Plug>Markdown_MoveToCurHeader
nmap <buffer><silent> [p <Plug>Markdown_MoveToParentHeader
" Paste image: 'ferrine/md-img-paste.vim'
nmap <buffer> <leader>pi :call mdip#MarkdownClipboardImage()<CR>
" Remove the "insert checkbox" keymapping
inoremap <buffer> <C-k> <C-k>
" Remove/overwrite the "make link" keymapping
nnoremap <buffer> <silent><C-k> :set paste<CR>m`O<Esc>``:set nopaste<CR>
" Remove the behaviour when pressing 'Enter' or 'o'/'O' or <C-i>.
inoremap <buffer> <CR> <CR>
nnoremap <buffer> o o
nnoremap <buffer> O O
nnoremap <buffer> <TAB> <TAB> " also fixes <C-i> as this translates to <TAB>
" Currently not used: Create a full anchor link
"autocmd FileType markdown nnoremap <Leader>al qdq:s/<a id="\zs.*\ze"><\/a>/\=setreg('d', 
"submatch(0))/n<CR>
"                  \:let @+="[".substitute(substitute(substitute(@%, "__", " ", "g"), 
"                  "_", " ", "g"), ".md", "", "")."]
"                  \(".@%."#".@d.")"<CR>
"                  \:nohlsearch<CR>
" 'Add anchor'
nnoremap <Leader>aa o<a id=""></a><Esc>5hi
" 'Get anchor' link without the filename as the link description.
" 1. Clear register d
" 2. Search for the anchor in the current line, that is, <a id="anchor-name"></a> and 
"    match
"    everything in the double quotes.
" 3. Yank the match to register d.
" 4. Disable highlighting of search results.
nnoremap <Leader>ga qdq:s/<a id="\zs.*\ze"><\/a>/\=setreg('y', submatch(0))/n<CR>
                  \:let @x=expand('%:r')<CR>
                  \:nohlsearch<CR>
                  \:echo('Anchor copied to clipboard.')<CR>
                  "\:let @+="(".expand('%:r')."#".@d.")"<CR>

" Remap the folding to standard za
" https://github.com/ixru/nvim-markdown/blob/master/ftplugin/markdown.vim
nmap <buffer> za <cmd>lua require("markdown").normal_tab()<CR>
" Toggle outline
" noremap <buffer> <Leader>to :TagbarToggle<CR>
" https://github.com/ixru/nvim-markdown
noremap <buffer> <Leader>fo :Toc<CR>/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Take over functionality to jump to anchor from the old plugin.
" https://github.com/plasticboy/vim-markdown/blob/master/ftplugin/markdown.vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:FindCornerOfSyntax(lnum, col, step)
    let l:col = a:col
    let l:syn = synIDattr(synID(a:lnum, l:col, 1), 'name')
    while synIDattr(synID(a:lnum, l:col, 1), 'name') ==# l:syn
        let l:col += a:step
    endwhile
    return l:col - a:step
endfunction
function! s:FindCornersOfSyntax(lnum, col)
    return [<sid>FindLeftOfSyntax(a:lnum, a:col), <sid>FindRightOfSyntax(a:lnum, a:col)]
endfunction
function! s:FindRightOfSyntax(lnum, col)
    return <sid>FindCornerOfSyntax(a:lnum, a:col, 1)
endfunction
function! s:FindLeftOfSyntax(lnum, col)
    return <sid>FindCornerOfSyntax(a:lnum, a:col, -1)
endfunction
function! s:FindNextSyntax(lnum, col, name)
    let l:col = a:col
    let l:step = 1
    while synIDattr(synID(a:lnum, l:col, 1), 'name') !=# a:name
        let l:col += l:step
    endwhile
    return [a:lnum, l:col]
endfunction
function! s:Markdown_GetUrlForPosition(lnum, col)
    let l:lnum = a:lnum
    let l:col = a:col
    let l:syn = synIDattr(synID(l:lnum, l:col, 1), 'name')

    if l:syn ==# 'mkdInlineURL' || l:syn ==# 'mkdURL' || l:syn ==# 'mkdLinkDefTarget'
        " Do nothing.
    elseif l:syn ==# 'mkdLink'
        let [l:lnum, l:col] = <sid>FindNextSyntax(l:lnum, l:col, 'mkdURL')
        let l:syn = 'mkdURL'
    elseif l:syn ==# 'mkdDelimiter'
        let l:line = getline(l:lnum)
        let l:char = l:line[col - 1]
        if l:char ==# '<'
            let l:col += 1
        elseif l:char ==# '>' || l:char ==# ')'
            let l:col -= 1
        elseif l:char ==# '[' || l:char ==# ']' || l:char ==# '('
            let [l:lnum, l:col] = <sid>FindNextSyntax(l:lnum, l:col, 'mkdURL')
        else
            return ''
        endif
    else
        return ''
    endif

    let [l:left, l:right] = <sid>FindCornersOfSyntax(l:lnum, l:col)
    return getline(l:lnum)[l:left - 1 : l:right - 1]
endfunction
" We need a definition guard because we invoke 'edit' which will reload this
" script while this function is running. We must not replace it.
if !exists('*s:EditUrlUnderCursor')
    function s:EditUrlUnderCursor()
        let l:url = s:Markdown_GetUrlForPosition(line('.'), col('.'))
        if l:url != ''
            if get(g:, 'vim_markdown_autowrite', 0)
                write
            endif
            let l:anchor = ''
            if get(g:, 'vim_markdown_follow_anchor', 0)
                let l:parts = split(l:url, '#', 1)
                if len(l:parts) == 2
                    let [l:url, l:anchor] = parts
                    let l:anchorexpr = get(g:, 'vim_markdown_anchorexpr', '')
                    if l:anchorexpr != ''
                        let l:anchor = eval(substitute(
                            \ l:anchorexpr, 'v:anchor',
                            \ escape('"'.l:anchor.'"', '"'), ''))
                    endif
                endif
            endif
            if l:url != ''
                let l:ext = ''
                if get(g:, 'vim_markdown_no_extensions_in_markdown', 0)
                    " use another file extension if preferred
                    if exists('g:vim_markdown_auto_extension_ext')
                        let l:ext = '.'.g:vim_markdown_auto_extension_ext
                    else
                        let l:ext = '.md'
                    endif
                endif
                let l:url = fnameescape(fnamemodify(expand('%:h').'/'.l:url.l:ext, ':.'))
                let l:editmethod = ''
                " determine how to open the linked file (split, tab, etc)
                if exists('g:vim_markdown_edit_url_in')
                  if g:vim_markdown_edit_url_in == 'tab'
                    let l:editmethod = 'tabnew'
                  elseif g:vim_markdown_edit_url_in == 'vsplit'
                    let l:editmethod = 'vsp'
                  elseif g:vim_markdown_edit_url_in == 'hsplit'
                    let l:editmethod = 'sp'
                  else
                    let l:editmethod = 'edit'
                  endif
                else
                  " default to current buffer
                  let l:editmethod = 'edit'
                endif
                execute l:editmethod l:url
            endif
            if l:anchor != ''
                silent! execute '/'.l:anchor
            endif
        else
            echomsg 'The cursor is not on a link.'
        endif
    endfunction
endif

"""""""""""""""""""""""""""""""""""""""""
" Treesitter: Implement 'ge' - go to URL
"""""""""""""""""""""""""""""""""""""""""
"" Is implemented in ../../lua/plugin/markdown-enhancements.lua
"command! MarkdownJumpToURL lua require'plugin.markdown-enhancements'.jump_to_file_with_anchor() 
"nmap <buffer> <silent> ge :MarkdownJumpToURL<CR>


" Current buffer fuzzy find
nnoremap <buffer><silent> <leader>fm :lua require('telescope.builtin').current_buffer_fuzzy_find({default_text='^## ', prompt_title="Find header"})<cr>
