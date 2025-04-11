return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = { virtual_text = false },
    servers = {
      gopls = {
        settings = {
          gopls = {
            hints = {
              assignVariableTypes = false,
              compositeLiteralFields = false,
              compositeLiteralTypes = false,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = false,
              rangeVariableTypes = true,
            },
          },
        },
      },
    },
  },
}
