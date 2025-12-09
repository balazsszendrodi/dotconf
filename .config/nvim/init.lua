require("options")
require("keymaps")
require("autocmds")


vim.pack.add({
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/nvim-mini/mini.icons" },
  -- { src = "https://github.com/nvim-mini/mini.pick" },
  { src = "https://github.com/ibhagwan/fzf-lua" }, -- alternate picker
  -- {src = "https://github.com/nvim-telescope/telescope.nvim"}, -- alternate picker
  -- { src = "https://github.com/nvim-mini/mini.ai" }, -- additional treesitter textobjects
  -- { src = "https://github.com/nvim-mini/mini.files" },
  { src = "https://github.com/nvim-lua/plenary.nvim" }, --dependency of yazi.nvim
  { src = "https://github.com/mikavilpas/yazi.nvim" },
  { src = "https://github.com/lewis6991/gitsigns.nvim" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" }, -- Shows the the signiture of the funciton on the top while in the scope
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects" },
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
})
-- vim.pack.update() -- udpate all plugins managed by vim.pack
vim.cmd("colorscheme tokyonight-moon")
vim.cmd(":hi statusline guibg=NONE")

-- Plugins
require('plugins.mini.icons')
-- require('plugins.mini.pick')
-- require('plugins.mini.ai')
-- require('plugins.mini.files') -- alternative to yazi.nvim with 0 dependencies
require('plugins.fzf-lua')
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
  -- "pyright",
  "pyrefly",
  "gopls",
  "protols",
  -- "copilot", -- TODO: Apply the command in lsp/copilot.lua to attach to sessions
  "dartls"
})
