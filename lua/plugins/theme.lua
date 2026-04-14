return {
	-- 1. Persistence Plugin
	{
		"propet/colorscheme-persist.nvim",
		lazy = false, -- Must load on startup to apply the saved theme
		config = true,
		opts = {
			-- Optional: set a fallback if no theme is saved yet
			fallback = "oxocarbon",
		},
		keys = {
			-- Press <leader>th to open the theme picker (requires Telescope)
			{
				"<leader>th",
				function()
					require("colorscheme-persist").picker()
				end,
				desc = "Browse Themes",
			},
		},
	},

	-- 2. Tokyonight Config
	{
		"folke/tokyonight.nvim",
		lazy = true, -- Can be lazy now!
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				style = "night",
				transparent = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
				},
			})
		end,
	},

	-- 3. Kanagawa Config
	{
		"rebelot/kanagawa.nvim",
		lazy = true, -- Can be lazy now!
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				undercurl = true,
				commentStyle = { italic = true },
				keywordStyle = { italic = true, bold = false },
				theme = "dragon",
				background = { dark = "dragon", light = "lotus" },
			})
		end,
	},

	-- 4. Oxocarbon (nyoom) Config
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = true,
		priority = 1000,
	},
}
