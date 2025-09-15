require("keymaps")
require("autocmds")
require("options")



-- LSP config
local lsp = vim.lsp
lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  },
  root_markers = { '.git' },
})
lsp.enable({"luals","ruff","gopls"})
