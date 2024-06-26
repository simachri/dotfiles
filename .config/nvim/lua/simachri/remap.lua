vim.g.mapleader = " "

-- Move lines up or down
-- Use 'x' mode instead of 'v' to not interfere when inserting a link (URL) through
-- snippets and the link name starts with a capital letter j or k.
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "gx", ":call system('www-browser <C-r><C-a>')<CR>", { silent = true })

-- Do not override the buffer when pasting.
-- https://stackoverflow.com/a/3837845
vim.keymap.set("x", "<Leader>p", '"_dP')

-- Prevent <leader><CR> to convert the word under cursor into a link (for some reason).
vim.keymap.set("n", "<Leader><CR>", "<Esc>")

-- -- Keymap to sync syntax highlighting again if it is broken.
-- -- See :h redrawtime
-- vim.keymap.set("n", "<Leader>e", "mx:e<CR>:syntax sync fromstart<CR>`x", { silent = true })

-- Jump to alternate file.
vim.keymap.set("n", "<C-e>", ":b#<CR>")

-- Undo breakpoints
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", "!", "!<c-g>u")
vim.keymap.set("i", "?", "?<c-g>u")

-- Jumplist mutations when doing relative movement of more than five lines.
vim.keymap.set("n", "k", "(v:count > 5 ? \"m'\" . v:count : \"\") . 'k'", { expr = true })
vim.keymap.set("n", "j", "(v:count > 5 ? \"m'\" . v:count : \"\") . 'j'", { expr = true })

-- Keep the screen centered when using n & N for cycling through search results.
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")

-- Close all buffers.
-- The :silent! is used to omit the error message when
-- terminals are running: E89
vim.keymap.set("n", "<C-w>c", ":silent! %bd<CR>", { silent = true })

-- Let Y yank to end of line instead of entire line.
vim.keymap.set("n", "Y", "y$")

-- Insertion of blank lines
vim.keymap.set("n", "<C-j>", ":set paste<CR>m`o<Esc>``:set nopaste<CR>", { silent = true })
vim.keymap.set("n", "<C-k>", ":set paste<CR>m`O<Esc>``:set nopaste<CR>", { silent = true })
vim.keymap.set("x", "<C-j>", "my<Esc>`>o<Esc>gv`y", { silent = true })
vim.keymap.set("x", "<C-k>", "my<Esc>`<O<Esc>gv`y", { silent = true })

-- Replace word word under cursor
vim.keymap.set("n", "<Leader>rr", ':%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>', { silent = true })
-- Replace selection
vim.keymap.set("v", "<Leader>rr", '"sy:%s/<C-r>s//gI<Left><Left><Left>', { silent = true })

-- Remap the join lines J command, such that the cursor remains at the position
-- https://stackoverflow.com/questions/9505198/join-two-lines-in-vim-without-moving-cursor
vim.keymap.set("n", "J", ":let p=getpos('.')<bar>join<bar>call setpos('.', p)<cr>", { silent = true })

-- Yank the full filepath into the clipboard.
vim.keymap.set("n", "<Leader>yp", ":let @+=expand('%:p')<CR>")

-- Location list: Next and previous
vim.keymap.set("n", "<Leader>ln", ":lnext<CR>")
vim.keymap.set("n", "<Leader>lp", ":lprev<CR>")

-- Quickfix list: Next and previous
vim.keymap.set("n", "<Leader>qn", ":lnext<CR>")
vim.keymap.set("n", "<Leader>qp", ":lprev<CR>")

vim.keymap.set("n", "Q", "<nop>")

-- Toggle highlighting of search hits.
vim.keymap.set("n", "<Leader>th", ":set hlsearch!<CR>", { silent = true })

function OpenScratchBuffer()
    -- Check if a scratch buffer already exists.
    if vim.fn.bufnr("scratch") ~= -1 then
      vim.cmd("e scratch")
      return
    else
      vim.cmd([[
        noswapfile hide enew
        file scratch
        setlocal buftype=nofile
        setlocal bufhidden=hide
        setlocal tw=0
        setlocal ft=markdown
        ]])
    end
end
vim.api.nvim_set_keymap('n', '<Leader>i', ':lua OpenScratchBuffer()<CR>', { noremap = true, silent = true })

vim.cmd([[
    function! ToggleCb(option)
      let currLineText = getline(".")
      " If an option is given, evaluate it directly.
      if a:option == "done"
        call setline(".", substitute(currLineText, "- [.*\\]", "- [x]", ""))
        return
      elseif a:option == "open"
        call setline(".", substitute(currLineText, "- [.*\\]", "- [ ]", ""))
        return
      elseif a:option == "up"
        call setline(".", substitute(currLineText, "- [.*\\]", "- [^]", ""))
        return
      endif

      " If checkbox is empty: Check it.
      let replacedText = substitute(currLineText, "- [ \\]", "- [x]", "")
      if currLineText != replacedText
        " Replace text.
        call setline(".", replacedText)
        return
      endif

      " If checkbox is checked: Set to invalid.
      let replacedText = substitute(currLineText, "- [x\\]", "- [-]", "")
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
    nnoremap <silent> <Leader>tct :ToggleCheckBox<CR>
    nnoremap <silent> <Leader>tcd :SetCheckBoxDone<CR>
    nnoremap <silent> <Leader>tco :SetCheckBoxOpen<CR>
    nnoremap <silent> <Leader>tcu :SetCheckBoxUp<CR>
]])
