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

            local palette = require("rose-pine.palette")

			require("rose-pine").setup({
				variant = "auto", -- auto, main, moon, or dawn
				dark_variant = "main", -- main, moon, or dawn
				dim_inactive_windows = true,
				extend_background_behind_borders = true,

				enable = {
					terminal = true,
					legacy_highlights = false, -- Improve compatibility for previous versions of Neovim
					migrations = true, -- Handle deprecated options automatically
				},

				styles = {
					bold = true,
					italic = true,
					transparency = false,
				},

				highlight_groups = {
					["Comment"] = { fg = "muted", italic = true },

					["@keyword.return"] = { bold = true },
					["@function.method.call"] = { italic = true },

					["CustomMarkdownInlineCodeBlock"] = { fg = palette.foam, bg = palette.overlay, },

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

                    -- -- disable the background of markdown headings, see https://github.com/MeanderingProgrammer/markdown.nvim?tab=readme-ov-file#headings
                    -- ["RenderMarkdownH1Bg"] = { bg = palette.base },
                    -- ["RenderMarkdownH2Bg"] = { bg = palette.base },
                    -- ["RenderMarkdownH3Bg"] = { bg = palette.base },
                    -- ["RenderMarkdownH4Bg"] = { bg = palette.base },
                    -- ["RenderMarkdownH5Bg"] = { bg = palette.base },
                    -- ["RenderMarkdownH6Bg"] = { bg = palette.base },
				},

                groups = {
                    h1 = "iris",
                    -- h2 = "foam",
                    h2 = "rose",
                    -- h3 = "rose",
                    h3 = "foam",
                    h4 = "gold",
                    h5 = "pine",
                    h6 = "foam",
                },
			})

			vim.cmd("colorscheme rose-pine")
			-- vim.cmd("colorscheme rose-pine-main")
			-- vim.cmd("colorscheme rose-pine-moon")
			-- vim.cmd("colorscheme rose-pine-dawn")
		end,
	},
}
