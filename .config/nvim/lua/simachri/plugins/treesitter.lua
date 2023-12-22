-- https://github.com/nvim-treesitter/nvim-treesitter
return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdateSync',
        dependencies = {
            'windwp/nvim-ts-autotag',
            'nvim-treesitter/nvim-treesitter-context',
            'nvim-treesitter/nvim-treesitter-textobjects',
        },
        event = 'VeryLazy',
        config = function ()
            require'nvim-treesitter.configs'.setup {
                -- one of "all", "maintained" (parsers with maintainers), or a list of languages
                ensure_installed = {
                    'python',
                    'go',
                    'lua',
                    'javascript',
                    'typescript',
                    'css',
                    'markdown',
                    'markdown_inline',
                    'yaml',
                    'svelte',
                    'html',
                    'rust',
                },
                -- https://github.com/windwp/nvim-ts-autotag
                autotag = {
                    enable = true,
                },
                highlight = {
                    enable = true,              -- false will disable the whole extension
                    -- disable = {"markdown"}
                },
                indent = {
                    enable = true,
                    -- disable for go as it breaks indent when typing a colon, e.g. a := Type, see :set indentexpr?>
                    -- disable for typescript as it breaks indent when in a class method
                    disable = { "go", "typescript", "lua" }
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
                    lsp_interop = {
                        enable = true,
                        -- disable = {"markdown"},
                        border = 'none',
                        peek_definition_code = {
                            ["<leader>df"] = "@function.outer",
                            ["<leader>dF"] = "@class.outer"
                        }
                    },
                    move = {
                        enable = true,
                        disable = {"markdown", "markdown_inline"},
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]]"] = "@class.outer"
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]["] = "@class.outer"
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[["] = "@class.outer"
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[]"] = "@class.outer"
                        }
                    },
                    select = {
                        enable = true,
                        -- disable = {"markdown"},
                        lookahead = true,
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
        end,
    },

    {
        -- for HTML
        'windwp/nvim-ts-autotag',
        event = 'InsertEnter',
    },

    {
        'nvim-treesitter/playground',
        cmd = "TSPlaygroundToggle",
    },

    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        lazy = true,
    },

    {
        'nvim-treesitter/nvim-treesitter-context',
        lazy = true,
        opts = {
            enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
            max_lines = 7, -- How many lines the window should span. Values <= 0 mean no limit.
            trim_scope = 'inner', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
            patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                -- For all filetypes
                -- Note that setting an entry here replaces all other patterns for this entry.
                -- By setting the 'default' entry below, you can control which nodes you want to
                -- appear in the context window.
                default = {
                    'class',
                    'function',
                    'method',
                    -- 'for', -- These won't appear in the context
                    -- 'while',
                    -- 'if',
                    -- 'switch',
                    -- 'case',
                },
            -- Example for a specific filetype.
            -- If a pattern is missing, *open a PR* so everyone can benefit.
            --   rust = {
            --       'impl_item',
            --   },
            },
        },
    },
}
