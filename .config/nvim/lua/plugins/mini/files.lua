require('mini.files').setup(
  {
    windows = {
      max_numer = 2,
      -- Whether to show preview of file/directory under cursor
      preview = true,
      width_focus = 30,
      width_preview = 30,
    }
  })

-- Keymaps
vim.keymap.set("n", "<leader>fm", function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end,
  { desc = "Open mini.files (Directory of Current File)" })
vim.keymap.set("n", "<leader>fM", function() require("mini.files").open(vim.uv.cwd(), true) end,
  { desc = "Open mini.files (cwd)" })
vim.keymap.set("n", "<leader>-", function() require("mini.files").open(vim.api.nvim_buf_get_name(0), true) end,
  { desc = "Open mini.files (Directory of Current File)" })
