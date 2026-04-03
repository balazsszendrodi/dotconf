-- markdown-preview.nvim configuration
-- Prefer Bun when available, fallback to Node.
pcall(vim.cmd, 'packadd markdown-preview.nvim')

if vim.fn.executable('bun') == 1 then
  vim.g.mkdp_node_bin = 'bun'
end

vim.g.mkdp_filetypes = { 'markdown' }
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 1
vim.g.mkdp_refresh_slow = 0
vim.g.mkdp_echo_preview_url = 1

vim.keymap.set('n', '<leader>mp', '<cmd>MarkdownPreviewToggle<CR>', { desc = 'Markdown Preview Toggle' })
