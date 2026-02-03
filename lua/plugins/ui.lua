-- lua/plugins/ui.lua
return {
  -- File Explorer (Neo-tree)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = {
          mappings = {
            ["<space>"] = "none",
          },
        },
        filesystem = {
          filtered_items = {
            visible = true, 
            hide_dotfiles = false,
            hide_gitignored = false, 
          },
          follow_current_file = { enabled = true }, 
          use_libuv_file_watcher = true,
          window = {
            mappings = {
              ["<Space>"] = "none",
              ["l"] = "open",
              ["<CR>"] = "open",
            },
          },
        },
      })

      vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", {})
    end,
  },

  -- Tabs (Bufferline)
  {
    "akinsho/bufferline.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    opts = {
      options = {
        mode = "buffers",
        separator_style = "slant",
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
      },
    },
  },

  -- Status Line (Lualine)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = { theme = "dracula" }, -- You can change to 'tokyonight' or 'catppuccin' later
      })
    end,
  },
  
  -- Icons for everything
  { "nvim-tree/nvim-web-devicons", lazy = true },
}
