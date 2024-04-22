return {
	-- {
	-- 	"simachri/nvim-solarized-lua",
	-- 	lazy = false, -- make sure we load this during startup if it is your main colorscheme
	-- 	priority = 1000, -- make sure to load this before all the other start plugins
	-- 	init = function()
	-- 		vim.opt.background = "light"
	-- 		vim.cmd("colorscheme solarized-flat")
	-- 	end,
	-- },

	{
		"rose-pine/neovim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		init = function()
			vim.opt.background = "light"

			vim.opt.conceallevel = 2

			require("rose-pine").setup({
				variant = "auto", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = false,
				extend_background_behind_borders = true,

				enable = {
					terminal = true,
					legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
					migrations = true, -- Handle deprecated options automatically
				},

				styles = {
					bold = true,
					italic = false,
					transparency = false,
				},

				groups = {
					border = "muted",
					link = "iris",
					panel = "surface",

					error = "love",
					hint = "iris",
					info = "foam",
					note = "pine",
					todo = "rose",
					warn = "gold",

					git_add = "foam",
					git_change = "rose",
					git_delete = "love",
					git_dirty = "rose",
					git_ignore = "muted",
					git_merge = "iris",
					git_rename = "pine",
					git_stage = "iris",
					git_text = "rose",
					git_untracked = "subtle",

					h1 = "iris",
					h2 = "foam",
					h3 = "rose",
					h4 = "gold",
					h5 = "pine",
					h6 = "foam",
				},

				highlight_groups = {
					["Comment"] = { italic = true },

					["@keyword.return"] = { bold = true },
					["@function.method.call"] = { italic = true },

					-- ["@markup.link.markdown_inline"] = { fg = "subtle" },
					["@markup.raw.markdown_inline"] = { fg = "gold" },
					["@markup.italic.markdown_inline"] = { italic = true },
					["@markup.quote"] = { italic = true },
					["markdownH1"] = { italic = true, bold = true },
					["markdownH2"] = { italic = true, bold = true },
					["markdownH3"] = { italic = true, bold = true },
					["markdownH4"] = { italic = true, bold = true },
					["markdownH5"] = { italic = true, bold = true },
					["markdownH6"] = { italic = true, bold = true },

					-- Comment = { fg = "foam" },
					-- VertSplit = { fg = "muted", bg = "muted" },
				},

				before_highlight = function(group, highlight, palette)
					-- Disable all undercurls
					-- if highlight.undercurl then
					--     highlight.undercurl = false
					-- end
					--
					-- Change palette colour
					-- if highlight.fg == palette.pine then
					--     highlight.fg = palette.foam
					-- end
				end,
			})

			vim.cmd("colorscheme rose-pine")
			-- vim.cmd("colorscheme rose-pine-main")
			-- vim.cmd("colorscheme rose-pine-moon")
			-- vim.cmd("colorscheme rose-pine-dawn")
		end,
	},
}
