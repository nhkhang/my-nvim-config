vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
    vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
    vim.keymap.set("n", "<leader>rr", vim.lsp.buf.rename, opts)
    -- Navigate buffers (tabs)
    vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "Next Buffer" })
    vim.keymap.set("n", "<S-h>", ":bprev<CR>", { desc = "Previous Buffer" })
    -- Close the current buffer (close tab)
    vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { desc = "Close Buffer" })
  end,
})
