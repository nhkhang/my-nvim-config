return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup({
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"sql",
				"python",
				"markdown",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"json",
				"go",
				"gomod",
				"gowork",
				"gosum",
				"php",
				"phpdoc",
			},
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
		})
	end,
}
