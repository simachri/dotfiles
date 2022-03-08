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
    enable = false,              -- there are also issues with lua, so disable it.
    disable = { "go", "typescript" }  -- disable for go as it breaks indent when typing a colon, e.g. a := Type, see :set indentexpr?
                                      -- disable for typescript as it breaks indent when in a class method
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

