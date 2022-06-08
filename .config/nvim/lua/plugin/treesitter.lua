-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
   --ensure_installed = {'python', 'go', 'lua', 'javascript', 'typescript', 'css' }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = {'python', 'go', 'lua', 'javascript', 'typescript', 'css', 'markdown', 'yaml'}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
   -- 22-4-19: Enabling 'markdown' is slow on large files in edit mode. Further
   -- investigation is required.
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

  -- Source: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  textobjects = {
    -- syntax-aware textobjects
    enable = true,
    disable = {"markdown"},
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer"
      }
    },
    keymaps = {
      ["iL"] = {
        -- you can define your own textobjects directly here
        go = "(function_definition) @function",
      },
      -- or you use the queries from supported languages with textobjects.scm
      ["af"] = "@function.outer",
      ["if"] = "@function.inner",
      ["aC"] = "@class.outer",
      ["iC"] = "@class.inner",
      ["ac"] = "@conditional.outer",
      ["ic"] = "@conditional.inner",
      ["ae"] = "@block.outer",
      ["ie"] = "@block.inner",
      ["al"] = "@loop.outer",
      ["il"] = "@loop.inner",
      ["is"] = "@statement.inner",
      ["as"] = "@statement.outer",
      ["ad"] = "@comment.outer",
      ["am"] = "@call.outer",
      ["im"] = "@call.inner"
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer"
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer"
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer"
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer"
      }
    },
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ---- Or you can define your own textobjects like this
        --["iF"] = {
          --python = "(function_definition) @function",
          --cpp = "(function_definition) @function",
          --c = "(function_definition) @function",
          --java = "(method_declaration) @function",
          --go = "(method_declaration) @function"
        --}
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner"
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner"
      }
    }
  }
}

