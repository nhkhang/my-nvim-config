return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp",
			"folke/trouble.nvim",
		},
		config = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"gopls",
					"pyright",
					"lua_ls",
					"ts_ls",
					"intelephense",
				},
				handlers = {
					-- 1. Default Handler (The catch-all)
					function(server_name)
						require("lspconfig")[server_name].setup({
							capabilities = capabilities,
						})
					end,

					-- 2. Lua Handler (FIXED: Added key "lua_ls")
					["lua_ls"] = function()
						require("lspconfig").lua_ls.setup({
							capabilities = capabilities, -- Don't forget capabilities here too!
							settings = { Lua = { diagnostics = { globals = { "vim" } } } },
						})
					end,

					-- 3. Go Handler (FIXED: Added key "gopls")
					["gopls"] = function()
						require("lspconfig").gopls.setup({
							capabilities = capabilities,
							settings = {
								gopls = {
									semanticTokens = true,
									completeUnimported = true,
									usePlaceholders = true,
									buildFlags = { "-tags=integration" },
									["build.directoryFilters"] = { "-vendor" },
									analyses = {
										unusedparams = true,
									},
								},
							},
						})
					end,

					-- 4. Python handler (FIXED: Added key "pyright")
					["pyright"] = function()
						require("lspconfig").pyright.setup({
							capabilities = capabilities,
							settings = {
								python = {
									analysis = {
										typeCheckingMode = "standard",
										autoSearchPaths = true,
										useLibraryCodeForTypes = true,
										diagnosticMode = "workspace",
									},
								},
							},
						})
					end,
				},
			})

			-- === KEYBINDINGS SETUP === --
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }

					vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
					vim.keymap.set("n", "gi", require("telescope.builtin").lsp_implementations, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

					-- Trouble Keymap (Optional, since we discussed it)
					vim.keymap.set("n", "<leader>vd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", opts)
				end,
			})

			-- Float Diagnostic on Hover
			-- Note: I added a small check to ensure it doesn't run if you are in Insert mode
			vim.api.nvim_create_autocmd({ "CursorHold" }, {
				group = vim.api.nvim_create_augroup("float_diagnostic_cursor", { clear = true }),
				callback = function()
					vim.diagnostic.open_float(nil, {
						focus = false,
						scope = "cursor",
						border = "rounded", -- Added rounded border for better looks
					})
				end,
			})
		end,
	},
}
