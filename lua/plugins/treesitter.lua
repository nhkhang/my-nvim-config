return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.config").setup({
      ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "python", "markdown", "javascript", "typescript", "tsx", 
      "go", "gomod", "gowork", "gosum",
      "php", "phpdoc" },
      auto_install = true,
      highlight = {
        enable = true,
      },
    })
  end,
}
