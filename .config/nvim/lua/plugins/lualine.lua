require('lualine').setup({
  sections = {
    lualine_b = { 'branch' },
    lualine_c = { 'buffers' },
    lualine_x = { 'diff', 'diagnostics', 'lsp_status', 'filetype' },
  }
}
)
