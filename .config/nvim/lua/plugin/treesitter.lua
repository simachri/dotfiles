-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
   --ensure_installed = {'python', 'go', 'lua', 'javascript', 'typescript', 'css' }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {'python', 'go', 'lua', 'javascript', 'typescript', 'css', 'markdown', 'yaml'}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
   -- 22-1-4: Enabling 'markdown' is slow on large files. Further investigation is
   -- required.
    disable = {"markdown"}
  },
  indent = {
    enable = true,              -- false will disable the whole extension
    disable = { "go" }          -- disable for go as it somehow breaks indent when typing a colon, e.g. a := Type, see :set indentexpr?
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

