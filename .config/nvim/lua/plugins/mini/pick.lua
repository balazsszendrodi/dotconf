-- Custom picker from https://github.com/nvim-mini/mini.nvim/blob/main/lua/mini/extra.lua
local MiniPick = require("mini.pick")

local ensure_text_width = function(text, width)
  local text_width = vim.fn.strchars(text)
  if text_width <= width then return text .. string.rep(' ', width - text_width) end
  return '…' .. vim.fn.strcharpart(text, text_width - width + 1, width - 1)
end

local pick_validate_one_of = function(target, opts, values, picker_name)
  if vim.tbl_contains(values, opts[target]) then return opts[target] end
  local msg = string.format(
    '`pickers.%s` has wrong "%s" local option (%s). Should be one of %s.',
    picker_name,
    target,
    vim.inspect(opts[target]),
    table.concat(vim.tbl_map(vim.inspect, values), ', ')
  )
  error(msg)
end

local pick_validate_scope = function(...) return pick_validate_one_of('scope', ...) end
local set_buflines = function(buf_id, lines) vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines) end


MiniPick.registry.keymaps = function(local_opts)
  local_opts = vim.tbl_deep_extend('force', { mode = 'all', scope = 'all' }, local_opts or {})

  local mode = pick_validate_one_of('mode', local_opts, { 'all', 'n', 'x', 's', 'o', 'i', 'l', 'c', 't' }, 'keymaps')
  local scope = pick_validate_scope(local_opts, { 'all', 'global', 'buf' }, 'keymaps')

  -- Create items
  local items = {}
  local populate_modes = mode == 'all' and { 'n', 'x', 's', 'o', 'i', 'l', 'c', 't' } or { mode }
  local max_lhs_width = 0
  local populate_items = function(source)
    for _, m in ipairs(populate_modes) do
      for _, maparg in ipairs(source(m)) do
        local desc = maparg.desc ~= nil and vim.inspect(maparg.desc) or maparg.rhs
        local lhs = vim.fn.keytrans(maparg.lhsraw or maparg.lhs)
        max_lhs_width = math.max(vim.fn.strchars(lhs), max_lhs_width)
        table.insert(items, { lhs = lhs, desc = desc, maparg = maparg })
      end
    end
  end

  if scope == 'all' or scope == 'buf' then populate_items(function(m) return vim.api.nvim_buf_get_keymap(0, m) end) end
  if scope == 'all' or scope == 'global' then populate_items(vim.api.nvim_get_keymap) end

  for _, item in ipairs(items) do
    local buf_map_indicator = item.maparg.buffer == 0 and ' ' or '@'
    local lhs_text = ensure_text_width(item.lhs, max_lhs_width)
    item.text = string.format('%s %s │ %s │ %s', item.maparg.mode, buf_map_indicator, lhs_text, item.desc or '')
  end

  -- Define source
  local get_callback_pos = function(maparg)
    if type(maparg.callback) ~= 'function' then return nil, nil end
    local info = debug.getinfo(maparg.callback)
    local path = info.source:gsub('^@', '')
    if vim.fn.filereadable(path) == 0 then return nil, nil end
    return path, info.linedefined
  end

  local preview = function(buf_id, item)
    local path, lnum = get_callback_pos(item.maparg)
    if path ~= nil then
      item.path, item.lnum = path, lnum
      return MiniPick.default_preview(buf_id, item)
    end
    local lines = vim.split(vim.inspect(item.maparg), '\n')
    set_buflines(buf_id, lines)
  end

  local choose = function(item)
    local keys = vim.api.nvim_replace_termcodes(item.maparg.lhs, true, true, true)
    -- Restore Visual mode (should be active previously at least once)
    if item.maparg.mode == 'x' then keys = 'gv' .. keys end
    vim.schedule(function() vim.fn.feedkeys(keys) end)
  end

  MiniPick.start({ source = { items = items, name = string.format('Keymaps (%s)', scope), preview = preview, choose = choose } })
end
MiniPick.registry.commands = function()
  local commands = vim.tbl_deep_extend('force', vim.api.nvim_get_commands({}), vim.api.nvim_buf_get_commands(0, {}))

  local preview = function(buf_id, item)
    local data = commands[item]
    local lines = data == nil and { string.format('No command data for `%s` is yet available.', item) }
        or vim.split(vim.inspect(data), '\n')
    set_buflines(buf_id, lines)
  end

  local choose = function(item)
    local data = commands[item] or {}
    -- If no arguments needed, execute immediately
    local keys = string.format(':%s%s', item, data.nargs == '0' and '\r' or ' ')
    vim.schedule(function() vim.fn.feedkeys(keys) end)
  end

  local items = vim.fn.getcompletion('', 'command')
  MiniPick.start({
    source = {
      items = items,
      name = "All Keymaps",
      preview = preview,
      choose = choose,
    },
  })
end
MiniPick.setup(
  {
    mappings = {
      choose_marked = '<C-q>',
    },
  }
)

-- Keymap
vim.keymap.set("n", "<leader> ", ":Pick files<CR>", { desc = "Pick files" })
vim.keymap.set("n", "<leader>sh", ":Pick help<CR>", { desc = "Pick help" })
vim.keymap.set("n", "<leader>/", ":Pick grep_live<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>,", ":Pick buffers<CR>", { desc = "Pick buffers" })
