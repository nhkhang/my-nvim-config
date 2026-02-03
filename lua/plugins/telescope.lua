return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.6",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    telescope.setup({
      defaults = {
        wrap_results = true,
        layout_strategy = "horizontal",
        path_display={"truncate"},
        layout_config = {
          width = 0.95,     -- Use 95% of screen width
          height = 0.85,    -- Use 85% of screen height
          preview_width = 0.6, -- Give 60% of that space to the preview
        },
        preview = {
          treesitter = false,
        },
      },
    })

    -- Your Keymaps
    vim.keymap.set("n", "<leader><leader>", builtin.find_files, { desc = "Search Files" })
    vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
    vim.keymap.set("n", "<C-p>", builtin.git_files, {})
    vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>pws", builtin.grep_string, {})
    vim.keymap.set("n", "<leader>pr", builtin.resume, {})
  end,
}
