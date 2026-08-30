-- lua/plugins/utils.lua
return {
	-- Toggle Terminal (Ctrl+t to open floating terminal)
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = { { "<C-t>", desc = "Toggle Terminal" } },
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-t>]],
				direction = "float",
				float_opts = { border = "curved" },
			})
		end,
	},

	-- Which-Key (Popup menu for keybindings so you don't forget)
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			spec = {
				{ "<leader>D", group = "Database" },
				{ "<leader>d", group = "Diffview" },
				{ "<leader>g", group = "Git (Hunk review)" },
				{ "<leader>h", group = "Git Hunks" },
				{ "<leader>l", group = "LazyGit" },
				{ "<leader>p", group = "Search/Grep" },
				{ "<leader>t", group = "Toggle" },
			},
		},
	},

	-- Auto Pairs (Simply closes brackets/quotes)
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},

	{
		"echasnovski/mini.bufremove",
		version = "*",
		event = "BufReadPost",
	},

	{
		"saghen/blink.cmp",
		version = "*",
		lazy = false,
		opts = {
			keymap = { preset = "super-tab" },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				-- SQL buffers (dadbod-ui) also get schema/table/column completion
				per_filetype = {
					sql = { "dadbod", "snippets", "buffer" },
					mysql = { "dadbod", "snippets", "buffer" },
					plsql = { "dadbod", "snippets", "buffer" },
				},
				providers = {
					dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
				},
			},
		},
	},
}
