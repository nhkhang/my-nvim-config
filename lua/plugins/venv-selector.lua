return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap-python",
	},
	branch = "main", -- Use this branch for the latest version
	ft = "python", -- Only load when editing Python files
	config = function()
		require("venv-selector").setup({
			-- SETTINGS
			settings = {
				options = {
					-- Cache the selected venv so you don't have to pick it every time
					notify_user_on_venv_activation = true,
				},
			},
		})
	end,
	-- Keybinding: <leader>vs to open the menu
	keys = {
		{ "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
	},
}
