local api = vim.api

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = api.nvim_create_augroup("highlight_yank", { clear = true }),
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = api.nvim_create_augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = api.nvim_create_augroup("last_loc", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("close_with_q", { clear = true }),
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("man_unlisted", { clear = true }),
  pattern = { "man" },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = api.nvim_create_augroup("wrap_spell", { clear = true }),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = api.nvim_create_augroup("json_conceal", { clear = true }),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})


-- Syntax highlight for non standard Jenkins file names
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "Jenkinsfile*",
  callback = function()
    vim.opt.filetype = "groovy"
  end,
  group = api.nvim_create_augroup("JenkinsfileSyntax", { clear = true }),
})

-- YAML Syntax highlight for kubeconfig
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = vim.fn.expand("~") .. "/.kube/*.config",
  callback = function()
    vim.bo.filetype = "yaml"
  end,
  group = api.nvim_create_augroup("KubeConfigFileSyntax", { clear = true }),
})

-- Enable 120 line indicator for go files
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.go",
  callback = function()
    vim.opt.colorcolumn = "120"
  end,
  group = api.nvim_create_augroup("LineWrapIndicatorFiles", { clear = true }),
})

-- Custom make command for go files
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.go",
  callback = function()
    vim.opt_local.makeprg = "golangci-lint run"
    -- vim.opt_local.makeprg = "go build -o /dev/null"
    vim.opt_local.errorformat = "%f:%l:%c: %m"
  end,
})

-- Custom make command for python files
api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.py",
  callback = function()
    -- vim.opt_local.makeprg = "ruff check --respect-gitignore --output-format='concise'"
    -- vim.opt_local.makeprg = "pyrefly check --output-format min-text"
    vim.opt_local.makeprg = "mypy ."
    vim.opt_local.errorformat = "%f:%l: %m"
    -- vim.opt_local.errorformat = "%E%f:%l:%c%*[^:]: %m"
    -- vim.opt_local.errorformat = "ERROR %f:%l:%c-%*[0-9]: %m"
  end,
})

-- Automatically open quickfix list after make
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
  pattern = { "make" },
  callback = function()
    -- Close the quickfix list if it was left open
    vim.cmd("cclose")
    -- Only open if there are entries
    if vim.fn.getqflist({ size = 0 }).size > 0 then
      vim.cmd("copen")
    end
  end,
})

-- api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.go",
--   callback = function()
--     local params = vim.lsp.util.make_range_params(0,"utf-8")
--     params.context = { only = { "source.organizeImports" } }
--     -- buf_request_sync defaults to a 1000ms timeout. Depending on your
--     -- machine and codebase, you may want longer. Add an additional
--     -- argument after params if you find that you have to write the file
--     -- twice for changes to be saved.
--     -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
--     local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
--     for cid, res in pairs(result or {}) do
--       for _, r in pairs(res.result or {}) do
--         if r.edit then
--           local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
--           vim.lsp.util.apply_workspace_edit(r.edit, enc)
--         end
--       end
--     end
--     vim.lsp.buf.format({ async = false })
--   end
-- })

-- Trigger LSP completion when pressing the '.' key or with the <C-Space> key in insert mode
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method('textDocument/completion') then
      -- Safely add '.' as a trigger character if not already there
      local triggers = client.server_capabilities.completionProvider.triggerCharacters or {}
      local seen = {}
      for _, ch in ipairs(triggers) do
        seen[ch] = true
      end
      if not seen["."] then
        table.insert(triggers, ".")
      end
      client.server_capabilities.completionProvider.triggerCharacters = triggers

      -- Enable built-in LSP completion
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })

      -- Keymap for manual completion trigger with Ctrl+Space
      vim.keymap.set("i", "<C-Space>", function()
        vim.lsp.completion.get()
      end, { buffer = args.buf, desc = "Trigger LSP completion" })
    end
  end,
})

-- LSP Inline Completion
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
      vim.lsp.inline_completion.enable(true, { bufnr = bufnr })

      vim.keymap.set(
        'i',
        '<C-F>',
        vim.lsp.inline_completion.get,
        { desc = 'LSP: accept inline completion', buffer = bufnr }
      )
      vim.keymap.set(
        'i',
        '<C-G>',
        vim.lsp.inline_completion.select,
        { desc = 'LSP: switch inline completion', buffer = bufnr }
      )
    end
  end
})


---------------------------------------------------------------------
---                      scratch buffer                           ---
---------------------------------------------------------------------
--- This code creates a floating scratch buffer that can be toggled
--- with a keymap. The buffer is created as a scratch buffer
--- (not listed, no filetype) and is displayed in the center of the
--- screen with a rounded border. The buffer will be closed when you
--- leave it or toggle it again.

-- Configuration
local SCRATCH_FILE = vim.fn.stdpath('data') .. '/scratch-buffer.txt'
local scratch_win = nil
local scratch_buf = nil

-- Function to load content from file
local function load_scratch_content()
  local file = io.open(SCRATCH_FILE, 'r')
  if file then
    local content = file:read('*all')
    file:close()
    return vim.split(content, '\n')
  end
  return { '' } -- Return empty line if file doesn't exist
end

-- Function to save content to file
local function save_scratch_content()
  if scratch_buf and vim.api.nvim_buf_is_valid(scratch_buf) then
    local lines = vim.api.nvim_buf_get_lines(scratch_buf, 0, -1, false)
    local file = io.open(SCRATCH_FILE, 'w')
    if file then
      file:write(table.concat(lines, '\n'))
      file:close()
    end
  end
end

-- Function to create/toggle the floating scratch buffer
local function toggle_scratch_buffer()
  -- If window exists and is valid, close it (and save)
  if scratch_win and vim.api.nvim_win_is_valid(scratch_win) then
    save_scratch_content()
    vim.api.nvim_win_close(scratch_win, true)
    scratch_win = nil
    return
  end

  -- Create or reuse scratch buffer
  if not scratch_buf or not vim.api.nvim_buf_is_valid(scratch_buf) then
    scratch_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_option_value('buftype', 'nofile', { buf = scratch_buf })
    vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = scratch_buf })
    vim.api.nvim_set_option_value('swapfile', false, { buf = scratch_buf })
    vim.api.nvim_set_option_value('filetype', 'markdown', { buf = scratch_buf }) -- Optional: syntax highlighting

    -- Load persisted content
    local content = load_scratch_content()
    vim.api.nvim_buf_set_lines(scratch_buf, 0, -1, false, content)
  end

  -- Calculate centered floating window dimensions
  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Window configuration
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = ' Scratch Buffer ',
    title_pos = 'center'
  }

  -- Open the floating window
  scratch_win = vim.api.nvim_open_win(scratch_buf, true, opts)
end

-- Create autocommand group
local scratch_group = vim.api.nvim_create_augroup('ScratchBuffer', { clear = true })

-- Save on buffer leave
vim.api.nvim_create_autocmd('BufLeave', {
  group = scratch_group,
  callback = function(args)
    if args.buf == scratch_buf then
      save_scratch_content()
      if scratch_win and vim.api.nvim_win_is_valid(scratch_win) then
        vim.api.nvim_win_close(scratch_win, true)
        scratch_win = nil
      end
    end
  end
})

-- Save on Neovim exit
vim.api.nvim_create_autocmd('VimLeavePre', {
  group = scratch_group,
  callback = save_scratch_content
})

-- Create keymap
vim.keymap.set('n', '<leader>.', toggle_scratch_buffer, {
  desc = 'Toggle persistent scratch buffer',
  noremap = true,
  silent = true
})
