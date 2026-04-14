-- lua/plugins/debug.lua
return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"leoluz/nvim-dap-go",
			"mfussenegger/nvim-dap-python",
		},
		keys = {
			{ "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
			{ "<F1>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
			{ "<F2>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
			{ "<F3>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
			{ "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
		},
		cmd = { "DapContinue", "DapToggleBreakpoint" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("dapui").setup()
			require("dap-go").setup()

			-- Python setup (Adjust path if you use a virtualenv elsewhere, this uses the Mason one)
			local python_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(python_path)

			-- Auto open/close debugger UI
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

		end,
	},
}
