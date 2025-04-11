-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.snacks_animate = false
vim.g.clipboard = {
  name = "xsel",
  copy = { ["+"] = "xsel --clipboard --input", [""] = "xsel --primary --input" },
  paste = { ["+"] = "xsel --clipboard --output", [""] = "xsel --primary --output" },
  cache_enabled = 0,
}

vim.opt.updatetime = 100
