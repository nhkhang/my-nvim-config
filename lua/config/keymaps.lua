----- Save
vim.keymap.set("n", "<leader>W", "<cmd>noautocmd w<cr>", { desc = "Save without formatting" })

----- Markdown preview via glow (terminal)
vim.keymap.set("n", "<leader>mg", function()
	local file = vim.fn.expand("%:p")
	if file == "" then return vim.notify("No file", vim.log.levels.WARN) end
	vim.cmd("tabnew | term glow -s dark " .. vim.fn.shellescape(file))
end, { desc = "Glow Markdown Preview" })

----- Buffer
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-h>", "<cmd>bprev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bd", function()
	local bd = require("mini.bufremove").delete
	local win_count = #vim.api.nvim_list_wins()
	if vim.bo.modified then
		local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
		if choice == 1 then -- Yes
			vim.cmd.write()
			if win_count > 1 then vim.cmd("close") else bd(0) end
		elseif choice == 2 then -- No
			if win_count > 1 then vim.cmd("close") else bd(0, true) end
		end
	else
		if win_count > 1 then vim.cmd("close") else bd(0) end
	end
end, { desc = "Delete Buffer" })

----- Register
-- Paste in visual mode without replacing the register
vim.keymap.set("x", "<leader>p", [["_dP]])
-- Delete to black hole register (doesn't override clipboard)
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
vim.keymap.set("n", "x", '"_x')
-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")
vim.keymap.set({ "n", "v" }, "<leader>0", '"0p', { desc = "Paste from Yank Register" })
