return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = { virtual_text = false },
    servers = {
      dartls = {
        cmd = { "dart", "language-server", "--protocol=lsp" },
        filetypes = { "dart" },
        root_dir = require("lspconfig.util").root_pattern("pubspec.yaml"),
        settings = {
          dart = {
            enableSdkFormatter = true,
          },
        },
      },
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
