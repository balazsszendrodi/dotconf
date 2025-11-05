require("fzf-lua").setup({
  { "ivy" },
  winopts = {
    width = 0.9,
    height = 0.9,
    row = 0.35,
    col = 0.5,
    preview = {
      scrollchars = { "┃", "" },
    },
  },
  keymap = {
    builtin = {
      ["<c-f>"] = "preview-page-down",
      ["<c-b>"] = "preview-page-up",
    },
    fzf = {
      ["ctrl-q"] = "select-all+accept",
      ["ctrl-u"] = "half-page-up",
      ["ctrl-d"] = "half-page-down",
      ["ctrl-x"] = "jump",
      ["ctrl-f"] = "preview-page-down",
      ["ctrl-b"] = "preview-page-up"

    }
  },
  files = {
    -- formatter = "path.filename_first",
    formatter = "path.dirname_first"
  },
})

local map = vim.keymap.set

map("n", "<leader>sh", "<cmd>FzfLua helptags<cr>", { desc = "Find nvim help tags" })
map("n", "<leader>sk", "<cmd>FzfLua keymaps<cr>", { desc = "Find keymaps" })
map("n", "<leader>sc", "<cmd>FzfLua commands<cr>", { desc = "Find commands" })
map("n", "<leader>sq", "<cmd>FzfLua quickfix<cr>", { desc = "Find Quickfix" })
map("n", "<leader> ", "<cmd>FzfLua files<cr>", { desc = "Find Files (Root Dir)" })
map("n", "<leader>/", "<cmd>FzfLua live_grep<cr>", { desc = "Grep (Root Dir)" })
map("n", "<leader>c/", "<cmd>FzfLua live_grep cwd<cr>", { desc = "Grep (cwd)" })
map("n", "<leader>sw", "<cmd>FzfLua grep_cword<cr>", { desc = "Word (Root Dir)" })
map("n", "<leader>sW", "<cmd>FzfLua grep_cword cwd<cr>", { desc = "Word (cwd)" })
map("x", "<leader>sw", "<cmd>FzfLua grep_visual<cr>", { desc = "Selection (Root Dir)" })
map("x", "<leader>sW", "<cmd>FzfLua grep_visual cwd<cr>", { desc = "Selection (cwd)" })
map("n", "<leader>,", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", { desc = "Command History" })
map("n", "<leader>:", "<cmd>FzfLua command_history<cr>", { desc = "Command History" })
-- -- git
map("n", "<leader>gf", "<cmd>FzfLua git_files<cr>", { desc = "Find Files (git-files)" })
map("n", "<leader>gc", "<cmd>FzfLua git_commits<CR>", { desc = "Commits" })
map("n", "<leader>gd", "<cmd>FzfLua git_diff<cr>", { desc = "Git Diff (hunks)" })
map("n", "<leader>gh", "<cmd>FzfLua git_hunks<cr>", { desc = "Git Diff (hunks)" })

-- -- find
map("n", "<leader>sM", "<cmd>FzfLua manpages<cr>", { desc = "Man Pages" })
map("n", "<leader>sm", "<cmd>FzfLua marks<cr>", { desc = "Jump to Mark" })
map("n", "<leader>sd", "<cmd>FzfLua diagnostics_workspace<cr>", { desc = "Diagnostics" })
map("n", "<leader>sD", "<cmd>FzfLua diagnostics_document<cr>", { desc = "Buffer Diagnostics" })
map("n", "<leader>sr", "<cmd>FzfLua resume<cr>", { desc = "Resume" })
