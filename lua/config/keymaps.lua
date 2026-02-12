----- Buffer
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next Buffer" })
vim.keymap.set("n", "<S-h>", ":bprev<CR>", { desc = "Previous Buffer" })
vim.keymap.set("n", "<leader>bd", function()
	local bd = require("mini.bufremove").delete
	if vim.bo.modified then
		local choice = vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
		if choice == 1 then -- Yes
			vim.cmd.write()
			bd(0)
		elseif choice == 2 then -- No
			bd(0, true)
		end
	else
		bd(0)
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
