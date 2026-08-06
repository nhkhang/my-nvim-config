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

	-- 2. Oxocarbon (nyoom) Config
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = true,
		priority = 1000,
	},

	-- 3. Transparency: oxocarbon ships no `transparent` option, so it repaints an
	-- opaque background over Ghostty's background-opacity. This clears the background
	-- highlight groups on every ColorScheme, so it survives <leader>th switches.
	{
		"xiyaowong/transparent.nvim",
		lazy = false, -- lazy-loading stops the clearing autocmd from registering
		priority = 999, -- after the colorschemes (1000)
		-- Enable declaratively so a fresh clone is transparent out of the box.
		-- Without this the plugin reads ~/.local/share/nvim/transparent_cache,
		-- which defaults to off and isn't tracked in this repo.
		init = function()
			vim.g.transparent_enabled = true
		end,
		opts = {},
	},
}
