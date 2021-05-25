-- https://github.com/hrsh7th/nvim-compe
vim.o.completeopt = "menuone,noselect"

-- Trigger completion from current string.
vim.api.nvim_set_keymap("i", "<C-Space>", "compe#complete()", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('<CR>')", { noremap = true,  expr = true, silent = true })
-- Go back to the string before entering completion.
vim.api.nvim_set_keymap("i", "<C-E>", "compe#close('<C-e>')", { noremap = true,  expr = true, silent = true })

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    luasnip = true;
    vsnip = false;
    ultisnips = false;
  };
}

