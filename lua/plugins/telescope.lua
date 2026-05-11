return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "Telescope",
	keys = {
		{ "<leader><leader>", function() require("telescope.builtin").find_files() end, desc = "Search Files" },
		{ "<leader>pf", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
		{ "<leader>pg", function() require("telescope.builtin").live_grep() end, desc = "Live Grep" },
		{ "<leader>pws", function() require("telescope.builtin").grep_string() end, desc = "Grep String" },
		{ "<leader>pr", function() require("telescope.builtin").resume() end, desc = "Resume Search" },
	},
	config = function()
		require("telescope").setup({
			defaults = {
				path_display = { "filename_first" },
				wrap_results = false,
				layout_strategy = "horizontal",

				layout_config = {
					preview_cutoff = 0,
					width = 0.95,
					height = 0.95,
					horizontal = {
						preview_width = 0.6,
						prompt_position = "top",
					},
				},

				preview = {
					treesitter = false,
				},
			},
		})
	end,
}
