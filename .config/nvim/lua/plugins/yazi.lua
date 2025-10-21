-- Init
local Yazi = require("yazi")
Yazi.setup({
  open_for_directories = true,
})
-- Keymaps
vim.keymap.set({ "n", "v" }, "<leader>-", function() Yazi.yazi() end,
  { desc = "Open yazi at the current file" })
vim.keymap.set({ "n", "v" }, "<leader>cw", function() Yazi.yazi() end,
  { desc = "Open the file manager in nvim's working directory" })
vim.keymap.set({ "n", "v" }, "<c-up>", function() Yazi.yazi() end,
  { desc = "Resume the last yazi session" })
