return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"folke/trouble.nvim", -- Added strictly for dependency if you use it in keymaps
		},
		config = function()
			local cmp = require("cmp")
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				cmp_lsp.default_capabilities()
			)

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

					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
					vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
					vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)

					-- Trouble Keymap (Optional, since we discussed it)
					vim.keymap.set("n", "<leader>vd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", opts)
				end,
			})

			-- Autocomplete setup
			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
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
