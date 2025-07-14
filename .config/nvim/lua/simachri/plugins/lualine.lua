return {
	{
		"letieu/harpoon-lualine",
		dependencies = {
			{
				"ThePrimeagen/harpoon",
				branch = "harpoon2",
			},
		},
	},

	{
		"nvim-lualine/lualine.nvim",
		-- event = "VeryLazy",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"letieu/harpoon-lualine",
		},
		config = function()
			-- local custom_solarized = require("lualine.themes.solarized_light")
			-- local colors = {
			-- 	base3 = "#002b36",
			-- 	base2 = "#073642",
			-- 	base1 = "#586e75",
			-- 	base0 = "#657b83",
			-- 	base00 = "#839496",
			-- 	base01 = "#93a1a1",
			-- 	base02 = "#eee8d5",
			-- 	base03 = "#fdf6e3",
			-- 	yellow = "#b58900",
			-- 	orange = "#cb4b16",
			-- 	red = "#dc322f",
			-- 	magenta = "#d33682",
			-- 	violet = "#6c71c4",
			-- 	blue = "#268bd2",
			-- 	cyan = "#2aa198",
			-- 	green = "#859900",
			-- }
			--
			-- custom_solarized.normal = {
			-- 	-- a = { fg = colors.base03, bg = colors.blue, gui = "bold" },
			-- 	-- b = { fg = colors.base03, bg = colors.base1 },
			-- 	-- c = { fg = colors.base1, bg = colors.base02 },
			-- 	a = { fg = colors.base03, bg = colors.base1 },
			-- 	b = { fg = colors.base03, bg = colors.base00 },
			-- 	c = { fg = colors.base1, bg = colors.base02 },
			-- }
			-- custom_solarized.insert = custom_solarized.normal
			-- custom_solarized.visual = custom_solarized.normal
			-- custom_solarized.replace = custom_solarized.normal
			-- custom_solarized.command = custom_solarized.normal
			-- custom_solarized.terminal = custom_solarized.normal

			require("lualine").setup({
				options = {
					theme = "rose-pine",
				},
				sections = {
					-- https://github.com/letieu/harpoon-lualine
					lualine_a = { {
						"harpoon2",
						icon = false,
					} },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = {
						"%=",
						{
							"filename",
							path = 1,
							separator = { left = ".", right = "" },
							symbols = {
								-- modified = "[+]", -- Text to show when the file is modified.
								modified = "●",
								-- readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
								readonly = "", -- Text to show when the file is non-modifiable or readonly.
								unnamed = "[No Name]", -- Text to show for unnamed buffers.
								newfile = "[New]", -- Text to show for newly created file before first write
							},
						},
					},
					lualine_x = { "encoding", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
}
