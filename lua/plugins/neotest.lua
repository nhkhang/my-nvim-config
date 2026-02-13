return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"fredrikaverpil/neotest-golang",
			"nvim-neotest/neotest-python",
		},
		config = function()
			-- 3. Configure the new adapter
			local neotest_golang = require("neotest-golang")

			require("neotest").setup({
				adapters = {
					-- Go Adapter Config (FredrikAverpil version)
					neotest_golang({
						-- ERROR FIX: The option you asked for
						testify_enabled = true,

						-- Recommended settings for this adapter
						go_test_args = {
							"-v",
							"-race",
							"-count=1",
							"-timeout=60s",
						},
						runner = "gotestsum", -- Recommended if you have 'gotestsum' installed
					}),

					require("neotest-python")({
						dap = { justMyCode = false },
					}),
				},
				output = {
					open_on_run = true,
					enter = true,
					short = false,
				},
			})
		end,
		-- (Your keymaps remain the same)
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest Test",
			},
			{
				"<leader>tf",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true })
				end,
				desc = "Test Output",
			},
			{
				"<leader>td",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Debug Nearest Test",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Test Summary",
			},
			{
				"<leader>tT",
				function()
					require("trouble").toggle("quickfix")
				end,
				desc = "Test Failures (Trouble)",
			},
			-- Jump to the next failed test
			{
				"]t",
				function()
					require("neotest").jump.next({ status = "failed" })
				end,
				desc = "Next Failed Test",
			},

			-- Jump to the previous failed test
			{
				"[t",
				function()
					require("neotest").jump.prev({ status = "failed" })
				end,
				desc = "Prev Failed Test",
			},
		},
	},
}
