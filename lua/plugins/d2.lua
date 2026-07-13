return {
	-- Official d2 plugin: syntax highlighting, format-on-save, ASCII preview
	{
		"terrastruct/d2-vim",
		ft = { "d2" },
		init = function()
			-- Ensure .d2 files get filetype=d2 at startup so the ft-lazy
			-- specs below (and this one) actually trigger.
			vim.filetype.add({ extension = { d2 = "d2" } })
		end,
	},

	-- Renders d2 (and mermaid) as inline images via image.nvim (see image.lua)
	{
		"3rd/diagram.nvim",
		dependencies = { "3rd/image.nvim" },
		ft = { "d2", "markdown" },
		opts = {
			renderer_options = {
				d2 = { theme_id = 0 }, -- 0 = default; 200 = dark, etc.
			},
		},
	},
}
