-- lua/plugins/utils.lua
return {
  -- Toggle Terminal (Ctrl+t to open floating terminal)
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup({
        open_mapping = [[<C-t>]],
        direction = "float",
        float_opts = { border = "curved" },
      })
    end,
  },

  -- Git Signs (Green/Red bars in the gutter)
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Which-Key (Popup menu for keybindings so you don't forget)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {},
  },

  -- Auto Pairs (Simply closes brackets/quotes)
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },
  
  -- Comments (gc to comment lines)
  {
    "numToStr/Comment.nvim",
    config = true,
  },
}
