-- Database UI: vim-dadbod-ui (client) over vim-dadbod (engine),
-- with SQL autocompletion via vim-dadbod-completion (feeds blink.cmp).
--
-- Lazy-loaded on :DBUI* commands and <leader>D keymaps — zero startup cost.
-- Connections: set g:dbs or use :DBUIAddConnection (stored in ~/.local/state/nvim/db_ui).

-- Scratch DuckDB, also used by <leader>Dq below. A real file (not dadbod's
-- default per-session tempname) so `CREATE VIEW v AS SELECT * FROM 'x.parquet'`
-- survives restarts and stays browsable in the drawer. Delete it to reset.
local duckdb_db = vim.fn.stdpath("state") .. "/duckdb/scratch.duckdb"

-- Data files DuckDB can scan directly, no import step
local queryable = { csv = true, tsv = true, parquet = true, json = true, ndjson = true }

--- Open a scratch SQL buffer that queries the current data file via DuckDB.
local function query_data_file()
	local path = vim.api.nvim_buf_get_name(0)
	local ext = path:match("%.(%w+)$")
	if not ext or not queryable[ext:lower()] then
		vim.notify("Not a csv/tsv/parquet/json file", vim.log.levels.WARN)
		return
	end

	vim.cmd("botright 10new")
	local buf = vim.api.nvim_get_current_buf()
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false

	-- Order matters: vim-dadbod-completion reads b:db on the FileType hook,
	-- so binding the connection has to happen before the filetype is set.
	vim.b[buf].db = "duckdb:" .. duckdb_db
	vim.bo[buf].filetype = "sql"

	-- '' escapes a quote inside a single-quoted SQL literal
	local lines = { ("SELECT * FROM '%s'"):format(path:gsub("'", "''")), "LIMIT 100;" }
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- dadbod-ui's <Leader>S maps to a <Plug> it only defines in its own buffers.
	-- %DB is what it falls back to internally, and needs just b:db.
	vim.keymap.set("n", "<leader>S", "<cmd>%DB<cr>", { buffer = buf, desc = "Database: Run query" })
	-- `:` from visual mode prefills the '<,'> range, so this runs the selection
	vim.keymap.set("x", "<leader>S", ":DB<cr>", { buffer = buf, desc = "Database: Run selection" })
end

return {
	{
		"kristijanhusak/vim-dadbod-ui",
		dependencies = {
			{ "tpope/vim-dadbod", lazy = true },
			-- Completion source; loads for the SQL-family filetypes dadbod opens
			{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
		},
		cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
		keys = {
			{ "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Database: Toggle UI" },
			{ "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Database: Add Connection" },
			{ "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Database: Find Buffer" },
			{ "<leader>Dq", query_data_file, desc = "Database: Query current data file" },
		},
		init = function()
			-- Persist queries under state dir instead of cluttering the cwd
			vim.g.db_ui_save_location = vim.fn.stdpath("state") .. "/db_ui"
			vim.g.db_ui_use_nerd_fonts = 1
			vim.g.db_ui_show_database_icon = 1
			-- Run queries explicitly (<leader>S / <C-s>), not on every :w
			vim.g.db_ui_execute_on_save = 0

			-- mkdir -p; no-op once it exists. duckdb won't create a missing dir.
			vim.fn.mkdir(vim.fn.fnamemodify(duckdb_db, ":h"), "p")
			vim.g.dbs = { duckdb = "duckdb:" .. duckdb_db }
		end,
	},
}
