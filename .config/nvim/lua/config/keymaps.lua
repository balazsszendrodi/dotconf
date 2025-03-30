-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
local map = LazyVim.safe_keymap_set

map("n", "<C-d>", "<C-d>zz", { desc = "Center cursor after moving down half-page" })
map("n", "<C-u>", "<C-u>zz", { desc = "Center cursor after moving up half-page" })
