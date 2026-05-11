return {
	"stevearc/conform.nvim",
	dependencies = {
		"williamboman/mason.nvim",
		"zapling/mason-conform.nvim",
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				go = { "goimports", "gofmt" },
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" }, -- JSX
				typescriptreact = { "prettier" }, -- TSX
				php = { "php_cs_fixer" },
				json = { "prettierd", "prettier" },
				jsonc = { "prettierd", "prettier" },
			},
			format_on_save = function(bufnr)
				local ignore_filetypes = { "json" }
				if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
					return { timeout_ms = 3000, lsp_fallback = false }
				end
				return { timeout_ms = 1000, lsp_fallback = true }
			end,
		})
		require("mason-conform").setup()
	end,
}
