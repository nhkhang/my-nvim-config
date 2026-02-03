return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      -- 1. Reduce "spam" (filter out common messages)
      routes = {
        {
          filter = {
            event = "msg_show",
            kind = "",
            find = "written", -- Hides "file written" messages
          },
          opts = { skip = true },
        },
      },
    })

    -- 2. Configure the notification window position (Bottom Right)
    require("notify").setup({
      background_colour = "#000000",
      render = "minimal", -- Cleaner look (no borders)
      stages = "static",  -- No animation (faster)
      timeout = 3000,     -- Disappears after 3 seconds
      top_down = false,   -- <--- THIS MOVES IT TO THE BOTTOM
    })
  end,
}
