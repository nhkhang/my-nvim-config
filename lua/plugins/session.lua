return {
	{
		"folke/persistence.nvim",
		event = "BufReadPre", -- this will only start session saving when you open a file
		opts = {
			-- directory where session files are saved
			dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
			options = { "buffers", "curdir", "tabpages", "winsize" },
		},
		keys = {
			-- Restore last session for the current directory
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore Session",
			},
			-- Restore the last session (regardless of directory)
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore Last Session",
			},
			-- Stop persistence (don't save on exit)
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Don't Save Current Session",
			},
		},
	},
}
