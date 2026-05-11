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
}
