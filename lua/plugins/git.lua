-- Cache base branch per repo (keyed by git root)
-- Persists for the Neovim session; no repeated network calls
local base_branch_cache = {}
local function get_base_branch()
	local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if base_branch_cache[root] then
		return base_branch_cache[root]
	end
	local result = vim.fn.systemlist("git remote show origin")
	local base = "main"
	for _, line in ipairs(result) do
		local match = line:match("HEAD branch:%s*(.+)")
		if match then
			base = match
			break
		end
	end
	base_branch_cache[root] = base
	return base
end

-- Hunk: review-first diff TUI (https://github.com/modem-dev/hunk).
-- No Neovim plugin exists, so we float the `hunk` CLI in a toggleterm window
-- (the same pattern lazygit.nvim uses). Requires `hunkdiff` on $PATH:
--   npm i -g hunkdiff   (or: brew install hunk / nix)
local hunk_terms = {}
local function hunk(cmd)
	return function()
		if vim.fn.executable("hunk") == 0 then
			return vim.notify("hunk not found — run `npm i -g hunkdiff`", vim.log.levels.ERROR)
		end
		-- Memoize one terminal per command so toggling reuses the same window
		if not hunk_terms[cmd] then
			hunk_terms[cmd] = require("toggleterm.terminal").Terminal:new({
				cmd = cmd,
				direction = "float",
				float_opts = {
					border = "curved",
					-- hunk only shows its sidebar when the window is >= 220 columns
					-- wide (src/ui/lib/responsive.ts), so use nearly the full editor width.
					width = function()
						return math.max(math.floor(vim.o.columns * 0.98), vim.o.columns - 2)
					end,
					height = function()
						return math.floor(vim.o.lines * 0.9)
					end,
				},
				close_on_exit = true,
				hidden = true,
			})
		end
		hunk_terms[cmd]:toggle()
	end
end

return {
	-- 1. Gitsigns (The side bars)
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signs_staged = {
					add = { text = "┃" },
					change = { text = "┃" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signs_staged_enable = true,
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					follow_files = true,
				},
				auto_attach = true,
				attach_to_untracked = true,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
					virt_text_priority = 100,
					use_focus = true,
				},
				current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000, -- Disable if file is longer than this (in lines)
				preview_config = {
					-- Options passed to nvim_open_win
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]h", gs.next_hunk, { desc = "Next Change" })
					map("n", "[h", gs.prev_hunk, { desc = "Prev Change" })

					-- Actions
					map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage Hunk" })
					map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset Hunk" })
					map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview Hunk Inline" })
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame Line (Popup)" })
					map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle Blame Ghost Text" })
					map("n", "<leader>hd", gs.diffthis, { desc = "Diff against Index" })
				end,
			})
		end,
	},
	-- 2. Diffview (PR review & diff viewer)
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
		keys = {
			{ "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "Diff against Index" },
			{
				"<leader>dm",
				function()
					vim.cmd("DiffviewOpen origin/" .. get_base_branch() .. "...HEAD")
				end,
				desc = "Diff against Base Branch",
			},
			{ "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current)" },
			{ "<leader>dH", "<cmd>DiffviewFileHistory<cr>", desc = "File History (all)" },
			{ "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
		},
		opts = {
			enhanced_diff_hl = true,
			diff_binaries = false,
			view = {
				default = { layout = "diff2_horizontal" },
				merge_tool = { layout = "diff3_mixed" },
			},
			file_panel = {
				listing_style = "tree",
				win_config = { width = 35 },
			},
		},
		config = function(_, opts)
			vim.opt.diffopt:append("context:99999")
			-- Jump to first change when entering a diff buffer
			vim.api.nvim_create_autocmd("BufWinEnter", {
				callback = function()
					if vim.wo.diff then
						vim.defer_fn(function()
							pcall(vim.cmd, "normal! gg]c")
						end, 100)
					end
				end,
			})
			require("diffview").setup(opts)
		end,
	},
	-- 3. Lazygit (Full Git GUI)
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- Optional: Load automatically when you open a git repo? usually unnecessary.
		-- event = "BufRead",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
	},
	-- 4. Hunk (review-first diff TUI) — wrapped via toggleterm (no nvim plugin exists)
	{
		"akinsho/toggleterm.nvim", -- merged with the spec in utils.lua
		keys = {
			{ "<leader>gh", hunk("hunk diff"), desc = "Hunk: review working tree" },
			{ "<leader>gH", hunk("hunk show"), desc = "Hunk: review last commit" },
			{
				"<leader>gm",
				function()
					hunk("git diff --no-color origin/" .. get_base_branch() .. "...HEAD | hunk patch -")()
				end,
				desc = "Hunk: review vs base branch",
			},
		},
	},
}
