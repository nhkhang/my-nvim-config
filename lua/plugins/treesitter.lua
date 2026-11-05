return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		local ts = require("nvim-treesitter")
		ts.install({
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
		})

		local function attach(buf, lang)
			if not pcall(vim.treesitter.start, buf, lang) then
				return false
			end
			if vim.treesitter.query.get(lang, "indents") then
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end
			return true
		end

		-- Replaces master's auto_install: install a missing parser once, then attach.
		local tried = {}
		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("treesitter_attach", { clear = true }),
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(ev.match)
				if not lang or attach(ev.buf, lang) or tried[lang] then
					return
				end
				if not require("nvim-treesitter.parsers")[lang] then
					return
				end
				tried[lang] = true
				ts.install(lang):await(vim.schedule_wrap(function()
					if vim.api.nvim_buf_is_valid(ev.buf) then
						attach(ev.buf, lang)
					end
				end))
			end,
		})
	end,
}
