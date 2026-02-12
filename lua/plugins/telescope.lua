return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local telescope = require("telescope")
		local builtin = require("telescope.builtin")

		telescope.setup({
			defaults = {
				path_display = { "filename_first" },
				wrap_results = false,
				layout_strategy = "horizontal",

				layout_config = {
					preview_cutoff = 0,
					width = 0.95,
					height = 0.95,
					horizontal = {
						preview_width = 0.6, -- 60% for preview
						prompt_position = "top", -- Search bar at the top (VS Code style)
					},
				},

				preview = {
					treesitter = false,
				},
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Search Files" })
		vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
		vim.keymap.set("n", "<C-p>", builtin.git_files, {})
		vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>pws", builtin.grep_string, {})
		vim.keymap.set("n", "<leader>pr", builtin.resume, {})
	end,
}
