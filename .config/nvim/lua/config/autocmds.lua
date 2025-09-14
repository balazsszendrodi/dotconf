-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_augroup("JenkinsfileSyntax", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "Jenkinsfile*",
  callback = function()
    vim.opt.filetype = "groovy"
  end,
  group = "JenkinsfileSyntax",
})

vim.api.nvim_create_augroup("KubeConfigFileSyntax", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = vim.fn.expand("~") .. "/.kube/*.config",
  callback = function()
    vim.bo.filetype = "yaml"
  end,
  group = "KubeConfigFileSyntax",
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.dart",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.api.nvim_create_augroup("LineWrapIndicatorFiles", { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.go",
  callback = function()
    vim.opt.colorcolumn = "100"
  end,
  group = "LineWrapIndicatorFiles",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.go",
  callback = function()
    vim.opt_local.makeprg = "golangci-lint run --enable-only errcheck"
    vim.opt_local.errorformat = "%f:%l:%c: %m"
  end,
})
