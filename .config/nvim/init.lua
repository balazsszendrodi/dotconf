require("options")
require("keymaps")
require("autocmds")


vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  { src = "https://github.com/nvim-mini/mini.pick" },
  { src = "https://github.com/nvim-mini/mini.ai" },
  -- { src = "https://github.com/nvim-mini/mini.files" },
  { src = "https://github.com/nvim-lua/plenary.nvim" }, --dependency of yazi.nvim
  { src = "https://github.com/mikavilpas/yazi.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})
vim.cmd("colorscheme tokyonight-moon")
vim.cmd(":hi statusline guibg=NONE")

-- Plugins
require('plugins.mini.icons')
require('plugins.mini.pick')
require('plugins.mini.ai')
-- require('plugins.mini.files') -- alternative to yazi.nvim with 0 dependencies
require('plugins.yazi')
require('plugins.gitsigns')
require('plugins.treesitter')
require('plugins.lualine')

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

lsp.enable({
  "lua_ls",
  "ruff",
  "pyright",
  "gopls",
  "protols"
})
