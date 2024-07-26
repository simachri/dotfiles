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
					legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
					migrations = true, -- Handle deprecated options automatically
				},

				styles = {
					bold = true,
					italic = false,
					transparency = false,
				},

				highlight_groups = {
					["Comment"] = { fg = "muted", italic = true },

					["@keyword.return"] = { bold = true },
					["@function.method.call"] = { italic = true },

                    -- 2024-07-25, disabled due to https://github.com/MeanderingProgrammer/markdown.nvim
					-- ["@markup.raw.markdown_inline"] = { fg = "gold" },
					-- ["@markup.italic.markdown_inline"] = { italic = true },
					-- ["@markup.quote"] = { fg = "muted", italic = true },
					-- ["markdownH1"] = { italic = true, bold = true },
					-- ["markdownH2"] = { italic = true, bold = true },
					-- ["markdownH3"] = { italic = true, bold = true },
					-- ["markdownH4"] = { italic = true, bold = true },
					-- ["markdownH5"] = { italic = true, bold = true },
					-- ["markdownH6"] = { italic = true, bold = true },
				},
			})

			vim.cmd("colorscheme rose-pine")
			-- vim.cmd("colorscheme rose-pine-main")
			-- vim.cmd("colorscheme rose-pine-moon")
			-- vim.cmd("colorscheme rose-pine-dawn")
		end,
	},
}
