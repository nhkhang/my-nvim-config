return {
	-- 1. Markdown Preview (Opens in Browser)
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install", -- Requires Node.js installed on your Mac
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
		keys = {
			-- Shortcut to toggle the preview window
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
		},
	},

	-- 2. Pretty Markdown in Editor (Hides symbols, renders tables)
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
		opts = {
			anti_conceal = { enabled = false },
			render_modes = { "n", "c", "t" },
		},
		keys = {
			{ "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle Markdown Render" },
			{ "<leader>mb", "<cmd>RenderMarkdown buf_toggle<cr>", desc = "Toggle Markdown Render (buffer)" },
		},
	},
}
