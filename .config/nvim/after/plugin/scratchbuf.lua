function OpenScratchBuffer()
    -- Check if a scratch buffer already exists.
    if vim.fn.bufnr("scratch") ~= -1 then
      vim.cmd("e scratch")
      return
    else
      vim.cmd([[
        "vsplit
        noswapfile hide enew
        setlocal buftype=nofile
        setlocal bufhidden=hide
        setlocal tw=0
        "setlocal ft=pandoc
        setlocal ft=markdown
        "lcd ~
        file scratch
        ]])
    end
end

vim.api.nvim_set_keymap('n', '<Leader>i', ':lua OpenScratchBuffer()<CR>', { noremap = true, silent = true })
