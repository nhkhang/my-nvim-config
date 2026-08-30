-- Read PDFs as rendered pages: n/p page, z/q/e zoom, :PDFReader for bookmarks,
-- ToC and view modes. Needs ghostscript for ImageMagick's PDF delegate:
--   brew install ghostscript
--
-- pdfreader.nvim is thin in three places, patched below rather than forked.
-- Each patch is pinned to one upstream function, so a breaking update surfaces
-- as a clear error here instead of silently reverting the behaviour.

local CACHE_DIR = vim.fn.stdpath("cache") .. "/pdfreader"

--- Memoize page rasterization on disk.
--
-- Upstream rasterizes on *every* page turn — twice, in fact: get_next_page and
-- display_page each build a fresh ImagePage, and its cache branch is commented
-- out behind a TODO. At ~850ms per magick+ghostscript call that made `n` a ~3s
-- freeze. Keying on the pdf's mtime means an edited file still re-renders.
local function cache_conversions()
	local utils = require("pdfreader.utils")
	local convert = utils.convert_pdf_to_png

	utils.convert_pdf_to_png = function(input, output, config)
		-- upstream builds input as "<path>[<0-based page>]"
		local path, page = input:match("^(.*)%[(%d+)%]$")
		if not path then
			return convert(input, output, config)
		end

		local key = ("%s:%s:%s:%s"):format(path, page, config.mode or 0, vim.fn.getftime(path))
		local cached = ("%s/%s.png"):format(CACHE_DIR, vim.fn.sha256(key))
		if vim.fn.filereadable(cached) == 1 then
			return cached
		end

		vim.fn.mkdir(CACHE_DIR, "p")
		return convert(input, cached, config)
	end
end

--- Publish the page indicator where lualine can reach it.
--
-- Upstream sets a window-local 'statusline', which lualine owns and overwrites,
-- so the page number was never visible. Stash it on the buffer instead and let
-- lualine render it (see the pdfreader component in ui.lua).
local function publish_page_indicator()
	local Book = require("pdfreader.book")

	function Book:show_statusline(bufnr, opts)
		local mode = opts.mode == 1 and "dark" or opts.mode == 2 and "text" or "standard"
		vim.b[bufnr].pdfreader_status = ("%s/%s · %s"):format(self.current_page_number, self.number_of_pages, mode)
	end
end

--- Keep the raw PDF bytes out of the buffer.
--
-- Upstream has no BufReadCmd, so Neovim loads the binary and snacks overlays the
-- image on top of it — leaving garbage visible around and below the page. Blank
-- lines still give snacks the rows its overlay extmarks need.
local function blank_buffer_on_read()
	vim.api.nvim_create_autocmd("BufReadCmd", {
		pattern = "*.pdf",
		group = vim.api.nvim_create_augroup("PdfBlankBuffer", { clear = true }),
		callback = function(args)
			vim.bo[args.buf].buftype = "nofile"
			vim.bo[args.buf].swapfile = false
			vim.bo[args.buf].filetype = "pdf"
			-- generous enough for any zoom level; cheap to hold
			vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, vim.split(string.rep("\n", 300), "\n"))
			vim.bo[args.buf].modified = false
		end,
	})
end

return {
	-- Rendering backend for pdfreader.nvim only. image.nvim stays the renderer
	-- for everything else: formats={} leaves snacks' file-hijack autocmds
	-- unregistered entirely, while placement.new() still works.
	{
		"folke/snacks.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			image = {
				enabled = true,
				formats = {}, -- hijack nothing; pdfreader places its images itself
				doc = { enabled = false }, -- render-markdown + image.nvim already own markdown
			},
		},
	},
	{
		"r-pletnev/pdfreader.nvim",
		lazy = false, -- eager: its BufEnter hook must exist before the first buffer
		dependencies = { "folke/snacks.nvim", "nvim-telescope/telescope.nvim" },
		config = function()
			require("pdfreader").setup()
			cache_conversions()
			publish_page_indicator()
			blank_buffer_on_read()
		end,
	},
}
