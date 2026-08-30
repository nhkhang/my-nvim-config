-- init.lua
local original_notify = vim.notify
vim.notify = function(msg, level, opts)
  if msg and msg:find("vim.tbl_islist is deprecated") then
    return
  end
  original_notify(msg, level, opts)
end

require("config.options")
require("config.keymaps")
-- Eager: a lazy hook can't intercept `nvim data.parquet` on the very first buffer
require("config.parquet")
require("config.lazy")
