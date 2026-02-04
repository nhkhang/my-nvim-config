return {
	{
		"folke/tokyonight.nvim",
		priority = 1000, -- Important! Load this before all other plugins
		config = function()
			require("tokyonight").setup({
				style = "night", -- Options: "storm", "moon", "night", "day"
				transparent = true, -- Change to true if you want your terminal background
				terminal_colors = true,
				styles = {
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
				},
			})

			vim.cmd.colorscheme("tokyonight")
		end,
	},
}
