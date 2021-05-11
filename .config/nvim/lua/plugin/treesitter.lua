-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'python', 'go', 'lua', 'java'}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  --ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
  indent = {
    enable = true,              -- false will disable the whole extension
  },
  incremental_selection = {
    enable = true,              -- false will disable the whole extension
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

