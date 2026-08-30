This is my nvim config with all the keymaps, plugins.

- Change as little as possible: smallest diff that fully does the job, no speculative helpers, options, or docs beyond what was asked.
- Ensure the performance is optimized for every new change
- If there's another better way to achieve something, suggest and explain why. Also point out the trade-off.
- Keep the config structure consistent and organized.
- Prefer following best practice optimal setup combine with personalization (from the current config). If conflict, show and ask for way preference.
- When making major changes (adding/removing plugins, restructuring files, changing conventions), update this CLAUDE.md to reflect the new structure or content.

## Directory Structure

```
init.lua                    # Entry point: loads options → keymaps → parquet → lazy
lua/
  config/
    options.lua             # Editor settings (line numbers, tabs, folds, clipboard, splits)
    keymaps.lua             # Custom keybinds (save, buffer nav, register ops)
    parquet.lua             # .parquet viewer: BufReadCmd renders rows via duckdb CLI (needs `brew install duckdb`); <leader>Dq to query it
    lazy.lua                # Lazy.nvim plugin manager init
  plugins/
    d2.lua                  # d2 diagrams: d2-vim (syntax/fmt/ASCII), diagram.nvim (inline render via image.nvim)
    dadbod.lua              # vim-dadbod-ui database client (+ vim-dadbod engine, vim-dadbod-completion → blink.cmp); DuckDB scratch db + <leader>Dq to SQL-query csv/parquet files
    debug.lua               # nvim-dap, dap-ui, dap-go, dap-python
    error.lua               # trouble.nvim (diagnostics viewer)
    formatting.lua          # conform.nvim (format on save: Lua, Python, Go, JS/TS, PHP, JSON)
    git.lua                 # gitsigns, diffview, lazygit, hunk (CLI wrapper via toggleterm)
    image.lua               # image.nvim (inline image engine; views png/jpg/gif/etc. directly; kitty protocol)
    lsp.lua                 # lspconfig, mason, blink.cmp (Go, Python, Lua, TS, PHP)
    markdown.lua            # markdown-preview (browser), render-markdown
    neotest.lua             # neotest with Go and Python adapters
    noice.lua               # noice.nvim, nui, nvim-notify (UI for messages/commands)
    pdf.lua                 # pdfreader.nvim: PDF pages rendered inline (n/p page, z/q/e zoom, :PDFReader for bookmarks/ToC/view modes); needs `brew install ghostscript`
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
- Plugin-free behaviour (autocmds, filetype hooks): its own `lua/config/<topic>.lua`, required from `init.lua`

## Image rendering

- **image.nvim is the general image layer** (kitty protocol via Ghostty). It owns `hijack_file_patterns` for png/jpg/gif/webp/avif, and backs diagram.nvim.
- **snacks.nvim exists solely as pdfreader.nvim's rendering backend.** It is scoped to `formats = {}` and `doc = { enabled = false }` so it registers no file-hijack autocmds and never competes with image.nvim. Do not enable other snacks modules here — reach for image.nvim first.
- `plugins/pdf.lua` patches three thin spots in pdfreader.nvim rather than forking it: disk-memoized page rasterization (upstream re-ran magick on every page turn, twice — ~3s, now ~0.9s cold / ~0ms cached), the page indicator moved to `vim.b.pdfreader_status` (upstream set a window-local statusline that lualine overwrites; rendered by a lualine component in `ui.lua`), and a `BufReadCmd` so the raw PDF binary never loads into the buffer.
