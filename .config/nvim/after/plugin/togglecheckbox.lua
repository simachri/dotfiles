vim.cmd([[
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
    nnoremap <silent> <Leader>tct :ToggleCheckBox<CR>
    nnoremap <silent> <Leader>tcd :SetCheckBoxDone<CR>
    nnoremap <silent> <Leader>tco :SetCheckBoxOpen<CR>
    nnoremap <silent> <Leader>tcu :SetCheckBoxUp<CR>
]])
