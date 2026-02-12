return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- The Go Adapter
			"nvim-neotest/neotest-go",
			-- The Python Adapter (since you have python dap)
			"nvim-neotest/neotest-python",
		},
		config = function()
			-- 1. Setup Neotest
			require("neotest").setup({
				adapters = {
					-- Go Adapter Config
					require("neotest-go")({
						experimental = {
							test_table = true,
						},
						-- Useful: Force color output and disable cache
						args = { "-count=1", "-timeout=60s" },
					}),

					-- Python Adapter Config
					require("neotest-python")({
						dap = { justMyCode = false },
					}),
				},
				-- Optional: Configure the Output Panel
				output = {
					open_on_run = true,
					enter = true,
				},
			})
		end,
		-- 2. Keymaps (The important part!)
		keys = {
			-- Run the test under the cursor
			{
				"<leader>tt",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest Test",
			},

			-- Run the entire current file
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File",
			},

			-- Open the output panel (if it closed)
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "Test Output",
			},

			-- DEBUG the test under the cursor (Uses nvim-dap-go)
			{
				"<leader>td",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Debug Nearest Test",
			},
		},
	},
}
