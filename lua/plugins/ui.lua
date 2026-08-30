-- lua/plugins/ui.lua
return {
	-- File Explorer (oil.nvim)
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				win_options = {
					signcolumn = "yes:2",
				},
				default_file_explorer = true,
				view_options = {
					show_hidden = true,
				},
				float = {
					padding = 2,
					max_width = 120,
					max_height = 30,
				},
				keymaps = {
					["q"] = "actions.close",
					["<Esc>"] = "actions.close",
				},
			})

			vim.keymap.set("n", "<leader>e", function()
				require("oil").open_float()
			end, { desc = "Open file explorer" })

			vim.keymap.set("n", "-", function()
				require("oil").open()
			end, { desc = "Open parent directory" })
		end,
	},

	-- Tabs (Bufferline)
	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		version = "*",
		opts = {
			options = {
				mode = "buffers",
				separator_style = "slant",
				diagnostics = "nvim_lsp",
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = { theme = "auto" },
				sections = {
					lualine_c = { { "filename", path = 1 } },
					-- page indicator for pdfreader.nvim (set in plugins/pdf.lua)
					lualine_x = {
						{
							function()
								return vim.b.pdfreader_status
							end,
							cond = function()
								return vim.b.pdfreader_status ~= nil
							end,
						},
						"encoding",
						"fileformat",
						"filetype",
					},
				},
			})
		end,
	},

	-- Icons for everything
	{ "nvim-tree/nvim-web-devicons", lazy = true },
}
