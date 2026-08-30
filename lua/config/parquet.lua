-- Parquet viewer: open a .parquet file and read it like a normal table.
--
-- Parquet is binary, so Neovim's own read would show bytes. BufReadCmd replaces
-- that read and lets the `duckdb` CLI decode it instead — same idea as
-- image.nvim's hijack_file_patterns for *.png (see lua/plugins/image.lua).
--
-- Requires `duckdb` on $PATH:  brew install duckdb

vim.filetype.add({ extension = { parquet = "parquet" } })

local DEFAULT_LIMIT = 500

local function duckdb(args)
	return vim.system(vim.list_extend({ "duckdb" }, args), { text = true }):wait()
end

--- Decode `path` with duckdb and fill `buf` with a rendered table.
local function render(buf, path, limit)
	if vim.fn.executable("duckdb") == 0 then
		vim.notify("duckdb not found — run `brew install duckdb`", vim.log.levels.ERROR)
		return
	end

	-- '' escapes a quote inside a single-quoted SQL literal
	local source = "read_parquet('" .. path:gsub("'", "''") .. "')"

	-- Cheap on huge files: count(*) reads Parquet metadata, LIMIT only touches
	-- the row groups it needs.
	local count = duckdb({ "-noheader", "-list", "-c", "SELECT count(*) FROM " .. source })
	-- .maxwidth: duckdb falls back to 80 when stdout is not a TTY, wrapping wide tables
	local res = duckdb({
		"-cmd",
		".maxwidth " .. math.max(vim.o.columns, 80),
		"-box",
		"-c",
		"SELECT * FROM " .. source .. " LIMIT " .. limit,
	})
	if res.code ~= 0 then
		vim.notify("duckdb failed to read " .. path .. "\n" .. vim.trim(res.stderr or ""), vim.log.levels.ERROR)
		return
	end

	local total = tonumber(vim.trim(count.stdout or ""))
	local header = ("-- %s | %s rows"):format(vim.fn.fnamemodify(path, ":t"), total or "?")
	if total and total > limit then
		header = header .. (" | showing %d — :ParquetLoad <n> for more"):format(limit)
	end
	header = header .. " | <leader>Dq to query"

	vim.bo[buf].modifiable = true
	local lines = vim.list_extend({ header, "" }, vim.split(vim.trim(res.stdout), "\n"))
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].modified = false
end

vim.api.nvim_create_autocmd("BufReadCmd", {
	pattern = "*.parquet",
	group = vim.api.nvim_create_augroup("ParquetView", { clear = true }),
	callback = function(args)
		local buf, path = args.buf, vim.fn.expand(args.match)

		-- nofile so `:w` can never overwrite the real Parquet with rendered text
		vim.bo[buf].buftype = "nofile"
		vim.bo[buf].swapfile = false
		-- Set explicitly: buftype=nofile skips normal filetype detection
		vim.bo[buf].filetype = "parquet"

		vim.api.nvim_buf_create_user_command(buf, "ParquetLoad", function(cmd)
			render(buf, path, tonumber(cmd.args) or DEFAULT_LIMIT)
		end, { nargs = "?", desc = "Parquet: re-render with a row limit" })

		render(buf, path, DEFAULT_LIMIT)
	end,
})
