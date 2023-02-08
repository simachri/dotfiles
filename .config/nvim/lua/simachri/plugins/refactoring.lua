-- https://github.com/ThePrimeagen/refactoring.nvim
return {
    {
        'ThePrimeagen/refactoring.nvim',
        dpeendencies = {
            'nvim-telescope/telescope.nvim',
        },
        opts = {
            prompt_func_return_type = {
                go = true,
                cpp = true,
                c = true,
                java = true,
            },
            prompt_func_param_type = {
                go = true,
                cpp = true,
                c = true,
                java = true,
            },
        },
        keys = {
          { '<leader>rm', '<Esc><Cmd>lua require("refactoring").refactor("Extract Function")<CR>', mode = 'v', {noremap = true, silent = true, expr = false} },
          { '<leader>rn', '<Esc><Cmd>lua require("refactoring").refactor("Extract Function To File")<CR>', mode = 'v', {noremap = true, silent = true, expr = false} },
          { '<leader>rv', '<Esc><Cmd>lua require("refactoring").refactor("Extract Variable")<CR>', mode = 'v', {noremap = true, silent = true, expr = false} },
          { '<leader>ri', '<Esc><Cmd>lua require("refactoring").refactor("Inline Variable")<CR>', mode = 'v', {noremap = true, silent = true, expr = false} },
          -- Extract block doesn't need visual mode
          { '<leader>rb', '<Cmd>lua require("refactoring").refactor("Extract Block")<CR>', {noremap = true, silent = true, expr = false} },
          -- vim.api.nvim_set_keymap("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], {noremap = true, silent = true, expr = false})
          -- Inline variable can also pick up the identifier currently under the cursor without visual mode
          { '<leader>ri', '<Cmd>lua require("refactoring").refactor("Inline Variable")<CR>', {noremap = true, silent = true, expr = false} },
          -- remap to open the Telescope refactoring menu in visual mode
          { '<leader>rr', '<Esc><cmd>lua require("telescope").extensions.refactoring.refactors()<CR>', mode = 'v', { noremap = true } },
      },
  }
}

