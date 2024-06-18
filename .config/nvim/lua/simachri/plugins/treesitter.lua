-- https://github.com/nvim-treesitter/nvim-treesitter
return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdateSync",
		dependencies = {
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/nvim-treesitter-context",
			"nvim-treesitter/nvim-treesitter-textobjects",
			"andymass/vim-matchup",
		},
		event = "VeryLazy",
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")

			-- CDS Custom Parser
			-- https://github.com/cap-js-community/tree-sitter-cds/blob/main/docs/neovim-support.md#setup
			-- MANUAL STEP REQUIRED:
			-- 1. After each update, go to ~/Development/Neovim/tree-sitter-cds/
			-- 2. Run `./nvim/setup-nvim-treesitter.sh`
			local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
			parser_config.cds = {
				install_info = {
					-- local path or git repo
					-- (I prefer the git repo way such that I can easily swap machines but keep the config)
					url = "https://github.com/cap-js-community/tree-sitter-cds.git",
					branch = "main",
					-- Small note here, treesitters documentation doesn't tell you this but you actually
					-- need both the parser.c and the scanner.c files included here, otherwise it won't compile!
					files = { "src/parser.c", "src/scanner.c" },
				},
				filetype = "cds", -- if filetype does not match the parser name
			}

			treesitter.setup({
				-- one of "all", "maintained" (parsers with maintainers), or a list of languages
				ensure_installed = {
					"cds",
					"python",
					"go",
					"templ",
					"lua",
					"java",
					"javascript",
					"typescript",
					"css",
					"markdown",
					"markdown_inline",
					"yaml",
					"svelte",
					"html",
					"rust",
					"vimdoc",
				},
				highlight = {
					enable = true, -- false will disable the whole extension
					-- disable = {"markdown"}
				},
				indent = {
					enable = true,
					-- disable for go as it breaks indent when typing a colon, e.g. a := Type, see :set indentexpr?>
					-- disable for typescript as it breaks indent when in a class method
					disable = { "go", "typescript", "lua" },
				},
				incremental_selection = {
					enable = true, -- false will disable the whole extension
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
						border = "none",
						peek_definition_code = {
							["<leader>df"] = "@function.outer",
							["<leader>dF"] = "@class.outer",
						},
					},
					move = {
						enable = true,
						disable = { "markdown", "markdown_inline" },
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]f"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[]"] = "@class.outer",
						},
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
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},

				-- https://github.com/andymass/vim-matchup
				matchup = {
					enable = true, -- mandatory, false will disable the whole extension
					disable = {}, -- optional, list of language that will be disabled
					disable_virtual_text = true,
				},
			})

			-- https://github.com/vrischmann/tree-sitter-templ
			vim.filetype.add({
				extension = {
					templ = "templ",
				},
			})

			-- Markdown: Disable conceal of fenced code blocks
			-- Issue: https://github.com/nvim-treesitter/nvim-treesitter/issues/5751
			-- Solution: https://github.com/nvim-treesitter/nvim-treesitter/issues/2825#issuecomment-1369082992
			-- Solution for 'markdown_inline' `shortcut_link`: https://github.com/MDeiml/tree-sitter-markdown/issues/56#issuecomment-1286142674
			-- ':TSEditQuery highlights markdown_inline`
			-- for _, lang in ipairs({ "json", "markdown", "help" }) do
			for _, lang in ipairs({ "markdown" }) do
				local queries = {}
				for _, file in ipairs(require("nvim-treesitter.compat").get_query_files(lang, "highlights")) do
					for _, line in ipairs(vim.fn.readfile(file)) do
						local line_sub = line:gsub([[%(#set! conceal ""%)]], "")
						table.insert(queries, line_sub)
					end
				end
				require("vim.treesitter.query").set(lang, "highlights", table.concat(queries, "\n"))
			end
		end,
	},

	{
		-- for HTML
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {
			filetypes = {
				"html",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"svelte",
				"vue",
				"tsx",
				"jsx",
				"rescript",
				"xml",
				"php",
				"markdown",
				"astro",
				"glimmer",
				"handlebars",
				"hbs",
				"templ",
			},
		},
	},

	{
		"nvim-treesitter/playground",
		cmd = "TSPlaygroundToggle",
	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = true,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		lazy = true,
		opts = {
			enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
			max_lines = 7, -- How many lines the window should span. Values <= 0 mean no limit.
			trim_scope = "inner", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
			patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
				-- For all filetypes
				-- Note that setting an entry here replaces all other patterns for this entry.
				-- By setting the 'default' entry below, you can control which nodes you want to
				-- appear in the context window.
				default = {
					"class",
					"function",
					"method",
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

	{
		"andymass/vim-matchup",
		event = "VeryLazy",
	},
}
