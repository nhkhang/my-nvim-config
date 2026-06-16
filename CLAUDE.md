This is my nvim config with all the keymaps, plugins.

- Ensure the performance is optimized for every new change
- If there's another better way to achieve something, suggest and explain why. Also point out the trade-off.
- Keep the config structure consistent and organized.
- Prefer following best practice optimal setup combine with personalization (from the current config). If conflict, show and ask for way preference.
- When making major changes (adding/removing plugins, restructuring files, changing conventions), update this CLAUDE.md to reflect the new structure or content.

## Directory Structure

```
init.lua                    # Entry point: loads options → keymaps → lazy
lua/
  config/
    options.lua             # Editor settings (line numbers, tabs, folds, clipboard, splits)
    keymaps.lua             # Custom keybinds (save, buffer nav, register ops)
    lazy.lua                # Lazy.nvim plugin manager init
  plugins/
    debug.lua               # nvim-dap, dap-ui, dap-go, dap-python
    error.lua               # trouble.nvim (diagnostics viewer)
    formatting.lua          # conform.nvim (format on save: Lua, Python, Go, JS/TS, PHP, JSON)
    git.lua                 # gitsigns, diffview, lazygit
    lsp.lua                 # lspconfig, mason, blink.cmp (Go, Python, Lua, TS, PHP)
    markdown.lua            # markdown-preview (browser), render-markdown
    neotest.lua             # neotest with Go and Python adapters
    noice.lua               # noice.nvim, nui, nvim-notify (UI for messages/commands)
    session.lua             # persistence.nvim (session save/restore)
    telescope.lua           # telescope.nvim (fuzzy finder)
    theme.lua               # colorscheme-persist, tokyonight, kanagawa, oxocarbon
    treesitter.lua          # nvim-treesitter (syntax highlighting, 27+ languages)
    ui.lua                  # oil.nvim (file explorer), bufferline, lualine, devicons
    utils.lua               # toggleterm, which-key, autopairs, mini.bufremove (commenting uses built-in gc/gcc)
    venv-selector.lua       # venv-selector.nvim (Python virtualenv picker)
```

## Conventions

- Plugin manager: **lazy.nvim** — all plugins go in `lua/plugins/` as separate files
- Leader key: `<Space>`
- New plugins: add a new file in `lua/plugins/` or append to the most relevant existing file
- Config/options: go in `lua/config/options.lua`, keybinds in `lua/config/keymaps.lua`
