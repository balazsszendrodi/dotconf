local map = vim.keymap.set

local function lazykeys(keys)
  keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
  return function()
    local old = vim.o.lazyredraw
    vim.o.lazyredraw = true
    vim.api.nvim_feedkeys(keys, "nx", false)
    vim.o.lazyredraw = old
  end
end
-- Center cursor when scrolling half page
map("n", "<c-d>", lazykeys("<c-d>zz"), { desc = "Center cursor after moving down half-page" })
map("n", "<c-u>", lazykeys("<c-u>zz"), { desc = "Center cursor after moving up half-page" })

-- Change the defualt split keymaps to mimic tmux keybinds
map("n", "<leader>%", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", '<leader>"', "<C-W>v", { desc = "Split Window Right", remap = true })

-- Keep cursor in place when joining lines.
local function smartJoinKeepCursor()
  -- Set a temporary mark 'z'
  vim.cmd("normal! mz") -- Only join if not on the last line
  if vim.fn.line(".") < vim.fn.line("$") then
    vim.cmd("normal! J")
  end -- Jump back to the marked position
  vim.cmd("normal! `z") -- Remove the temporary mark
  vim.cmd("delmarks z")
end
map("n", "J", smartJoinKeepCursor, { noremap = true, silent = true })
-- This version does not remove mark if there is no lines left
-- map("n", "J", "mzJ`z:delmarks z<CR>", { noremap = true, silent = true })

-- Duplicate line and comment the first line.
map("n", "ycc", "yygccp", { remap = true })
--search within visual selection
map("x", "/", "<Esc>/\\%V")
-- Remap accented letters to english
map("n", "ö", "0", { noremap = true, silent = true })
map("n", "Ö", ")", { noremap = true, silent = true })
map("n", "ü", "-", { noremap = true, silent = true })
map("n", "Ü", "_", { noremap = true, silent = true })
map("n", "ó", "=", { noremap = true, silent = true })
map("n", "Ó", "+", { noremap = true, silent = true })
map("n", "ő", "[", { noremap = true, silent = true })
map("n", "Ő", "{", { noremap = true, silent = true })
map("n", "ú", "]", { noremap = true, silent = true })
map("n", "Ú", "}", { noremap = true, silent = true })
map("n", "é", ";", { noremap = true, silent = true })
map("n", "É", ":", { noremap = true, silent = true })
map("n", "á", "'", { noremap = true, silent = true })
map("n", "Á", '"', { noremap = true, silent = true })
map("n", "ű", "\\", { noremap = true, silent = true })
map("n", "Ű", "|", { noremap = true, silent = true })



-- -- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
--
-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })


-- buffers
local function delete_other_buffers()
  local current = vim.api.nvim_get_current_buf()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end

local function delete_current_buffer()
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_delete(buf, { force = false })
end

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", delete_current_buffer , { desc = "Delete Buffer" })
map("n", "<leader>bo", delete_other_buffers, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search and stop snippet on escape
map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd("noh")
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- -- save file
-- map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- location list
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })

-- quickfix list
map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })


-- Quickfix navigation
map("n", "]q", "<cmd>cnext<CR>", { desc = "Next quickfix item" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Previous quickfix item" })

-- formatting
map({ "n", "v" }, "<leader>cf", function()
  print("implement formatting")
end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })


-- Terminal Mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>\"", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>%", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

--lsp
map("n", "gd", vim.lsp.buf.definition,{ desc = "Goto Definition"})
map("n", "gr", vim.lsp.buf.references,{ desc = "References" })
map("n", "gI", vim.lsp.buf.implementation,{ desc = "Goto Implementation" })
map("n", "gy", vim.lsp.buf.type_definition,{ desc = "Goto T[y]pe Definition" })
map("n", "gD", vim.lsp.buf.declaration, {desc = "Goto Declaration" })
map("n", "K", function() return vim.lsp.buf.hover() end, {desc = "Hover" })
map("n", "gK", function() return vim.lsp.buf.signature_help() end, {desc = "Signature Help" })
map("i", "<c-k>", function() return vim.lsp.buf.signature_help() end,{ desc = "Signature Help" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
map({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, {desc = "Run Codelens" })
map("n", "<leader>cC", vim.lsp.codelens.refresh, {desc = "Refresh & Display Codelens" })
map("n", "<leader>cr", vim.lsp.buf.rename, {desc = "Rename" })
map("n", "]]", function() print("next reference not implemented") end, {desc = "Next Reference" })
map("n", "[[", function() print("prev reference not implemented") end, {desc = "Prev Reference" })
map("n", "<a-n>", function() print("next reference not implemented") end, {desc = "Next Reference" })
map("n", "<a-p>", function() print("prev reference not implemented") end, {desc = "Prev Reference" })
