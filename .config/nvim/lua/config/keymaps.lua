-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

-- this function remove flickering when spamming ctrl+d and ctrl+u
local function lazykeys(keys)
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  return function()
    local old = vim.o.lazyredraw
    vim.o.lazyredraw = true
    vim.api.nvim_feedkeys(keys, "nx", false)
    vim.o.lazyredraw = old
  end
end
-- Center cursor when scrolling half page
vim.keymap.set("n", "<c-d>", lazykeys("<c-d>zz"), { desc = "Center cursor after moving down half-page" })
vim.keymap.set("n", "<c-u>", lazykeys("<c-u>zz"), { desc = "Center cursor after moving up half-page" })

-- Change the defualt split keymaps to mimic tmux keybinds
vim.keymap.set("n", "<leader>%", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", '<leader>"', "<C-W>v", { desc = "Split Window Right", remap = true })

-- Keep cursor in place when joining lines.
local function smartJoinKeepCursor()
  -- Set a temporary mark 'z'
  vim.cmd("normal! mz") -- Only join if not on the last line
  if vim.fn.line(".") < vim.fn.line("$") then
    vim.cmd("normal! J")
  end -- Jump back to the marked position
  vim.cmd("normal! `z") -- Remove the temporary mark
  vim.cmd("delmarks z")
end
vim.keymap.set("n", "J", smartJoinKeepCursor, { noremap = true, silent = true })
-- This version does not remove mark if there is no lines left
-- vim.keymap.set("n", "J", "mzJ`z:delmarks z<CR>", { noremap = true, silent = true })

-- Duplicate line and comment the first line.
vim.keymap.set("n", "ycc", "yygccp", { remap = true })
--search within visual selection
vim.keymap.set("x", "/", "<Esc>/\\%V")
