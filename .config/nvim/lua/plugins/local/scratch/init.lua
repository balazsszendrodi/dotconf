--- *scratch.nvim* Floating scratch buffer
---
--- Floating scratch buffer that can be toggled with a keymap. Content is
--- persisted to a file. The buffer is not listed and is displayed in a
--- centered floating window. Close on leave or toggle again.
---
--- # Setup ~
---
--- Setup with `require('scratch').setup({})` (replace `{}` with your config).
--- This creates the global Lua table `Scratch` for scripting or `:lua Scratch.*`.
---
--- See |Scratch.config| for config structure and defaults.
---
--- # Disabling ~
---
--- Set `vim.g.scratch_disable` (global) or `vim.b.scratch_disable` (buffer)
--- to `true` to disable the plugin.
---@tag Scratch

-- Module definition ==========================================================
local Scratch = {}
local H = {}

--- Default configuration
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
---@text # Options ~
---
--- - `options.scratch_file` - Path to persist file. Default: stdpath('data')..'/scratch-buffer.txt'
--- - `options.filetype` - Scratch buffer filetype (e.g. 'markdown', ''). Default: 'markdown'
--- - `options.win_width_ratio` - Float window width as ratio 0–1. Default: 0.9
--- - `options.win_height_ratio` - Float window height as ratio 0–1. Default: 0.9
--- - `options.border` - Border style: 'rounded', 'single', 'double', etc. Default: 'rounded'
--- - `options.title` - Window title. Default: ' Scratch Buffer '
--- - `options.title_pos` - Title position: 'center', 'left', 'right'. Default: 'center'
--- - `options.close_on_leave` - Close window on BufLeave. Default: true
--- - `options.save_on_leave` - Save on BufLeave. Default: true
--- - `options.save_on_exit` - Save on VimLeavePre. Default: true
Scratch.config = {
  options = {
    scratch_file = nil, -- set in setup_config
    filetype = 'markdown',
    win_width_ratio = 0.9,
    win_height_ratio = 0.9,
    border = 'rounded',
    title = ' Scratch Buffer ',
    title_pos = 'center',
    close_on_leave = true,
    save_on_leave = true,
    save_on_exit = true,
  },
  --- Module mappings. Use `''` to disable.
  mappings = {
    --- Toggle scratch buffer
    toggle = '<leader>.',
  },
}
--minidoc_afterlines_end

-- Module state ===============================================================
local state = {
  scratch_win = nil,
  scratch_buf = nil,
}

-- Helper data ================================================================
H.default_config = vim.deepcopy(Scratch.config)

-- Helper functionality ======================================================
-- Settings -------------------------------------------------------------------
H.setup_config = function(config)
  H.check_type('config', config, 'table', true)
  config = vim.tbl_deep_extend('force', vim.deepcopy(H.default_config), config or {})

  H.check_type('options', config.options, 'table')
  H.check_type('options.scratch_file', config.options.scratch_file, 'string', true)
  H.check_type('options.filetype', config.options.filetype, 'string')
  H.check_type('options.win_width_ratio', config.options.win_width_ratio, 'number')
  H.check_type('options.win_height_ratio', config.options.win_height_ratio, 'number')
  H.check_type('options.border', config.options.border, 'string')
  H.check_type('options.title', config.options.title, 'string')
  H.check_type('options.title_pos', config.options.title_pos, 'string')
  H.check_type('options.close_on_leave', config.options.close_on_leave, 'boolean')
  H.check_type('options.save_on_leave', config.options.save_on_leave, 'boolean')
  H.check_type('options.save_on_exit', config.options.save_on_exit, 'boolean')

  H.check_type('mappings', config.mappings, 'table')
  H.check_type('mappings.toggle', config.mappings.toggle, 'string')

  if not config.options.scratch_file or config.options.scratch_file == '' then
    config.options.scratch_file = vim.fn.stdpath('data') .. '/scratch-buffer.txt'
  end

  return config
end

H.apply_config = function(config)
  Scratch.config = config
  H.setup_autocommands()
  H.map('n', config.mappings.toggle, Scratch.toggle, { desc = 'Toggle scratch buffer' })
end

H.get_config = function()
  return vim.tbl_deep_extend('force', Scratch.config, vim.b.scratch_config or {})
end

H.is_disabled = function()
  return vim.g.scratch_disable == true or vim.b.scratch_disable == true
end

-- Persistence and buffer/window ----------------------------------------------
H.get_scratch_file = function()
  return H.get_config().options.scratch_file
end

H.load_scratch_content = function()
  local path = H.get_scratch_file()
  local file = io.open(path, 'r')
  if file then
    local content = file:read('*all')
    file:close()
    return vim.split(content, '\n')
  end
  return { '' }
end

H.save_scratch_content = function()
  if state.scratch_buf and vim.api.nvim_buf_is_valid(state.scratch_buf) then
    local lines = vim.api.nvim_buf_get_lines(state.scratch_buf, 0, -1, false)
    local path = H.get_scratch_file()
    local file = io.open(path, 'w')
    if file then
      file:write(table.concat(lines, '\n'))
      file:close()
    end
  end
end

H.create_scratch_buffer = function()
  if state.scratch_buf and vim.api.nvim_buf_is_valid(state.scratch_buf) then
    return state.scratch_buf
  end

  local config = H.get_config()
  state.scratch_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = state.scratch_buf })
  vim.api.nvim_set_option_value('bufhidden', 'hide', { buf = state.scratch_buf })
  vim.api.nvim_set_option_value('swapfile', false, { buf = state.scratch_buf })
  if config.options.filetype and config.options.filetype ~= '' then
    vim.api.nvim_set_option_value('filetype', config.options.filetype, { buf = state.scratch_buf })
  end

  local content = H.load_scratch_content()
  vim.api.nvim_buf_set_lines(state.scratch_buf, 0, -1, false, content)
  return state.scratch_buf
end

H.close_scratch_window = function()
  if state.scratch_win and vim.api.nvim_win_is_valid(state.scratch_win) then
    vim.api.nvim_win_close(state.scratch_win, true)
    state.scratch_win = nil
  end
end

H.setup_autocommands = function()
  local group = vim.api.nvim_create_augroup('ScratchBuffer', { clear = true })

  vim.api.nvim_create_autocmd('BufLeave', {
    group = group,
    callback = function(args)
      if args.buf ~= state.scratch_buf then
        return
      end
      local config = H.get_config()
      if config.options.save_on_leave then
        H.save_scratch_content()
      end
      if config.options.close_on_leave then
        H.close_scratch_window()
      end
    end,
  })

  vim.api.nvim_create_autocmd('VimLeavePre', {
    group = group,
    callback = function()
      local config = H.get_config()
      if config.options.save_on_exit then
        H.save_scratch_content()
      end
    end,
  })
end

-- Utilities ------------------------------------------------------------------
H.error = function(msg)
  error('(scratch.nvim) ' .. msg, 0)
end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == 'callable' and vim.is_callable(val)) or (allow_nil and val == nil) then
    return
  end
  H.error(string.format('`%s` should be %s, not %s', name, ref, type(val)))
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == '' then
    return
  end
  opts = vim.tbl_deep_extend('force', { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Module functionality =======================================================
--- Setup the plugin.
---
---@param config table|nil Config table. See |Scratch.config|.
---
---@usage >lua
---   require('scratch').setup()           -- use default config
---   require('scratch').setup({
---     options = {
---       scratch_file = vim.fn.stdpath('data') .. '/my-scratch.txt',
---       filetype = 'markdown',
---       border = 'single',
---     },
---     mappings = { toggle = '<leader>.' },
---   })
--- <
Scratch.setup = function(config)
  _G.Scratch = Scratch

  config = H.setup_config(config)
  H.apply_config(config)
end

--- Toggle the floating scratch buffer.
---
--- Opens a centered float with the scratch buffer (creating/loading it and
--- persisting on close). If the window is already open, closes it and saves.
Scratch.toggle = function()
  if H.is_disabled() then
    return
  end

  if state.scratch_win and vim.api.nvim_win_is_valid(state.scratch_win) then
    local config = H.get_config()
    if config.options.save_on_leave then
      H.save_scratch_content()
    end
    H.close_scratch_window()
    return
  end

  local buf = H.create_scratch_buffer()
  local config = H.get_config()
  local opt = config.options
  local width = math.floor(vim.o.columns * opt.win_width_ratio)
  local height = math.floor(vim.o.lines * opt.win_height_ratio)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win_opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = row,
    col = col,
    style = 'minimal',
    border = opt.border,
    title = opt.title,
    title_pos = opt.title_pos,
  }

  state.scratch_win = vim.api.nvim_open_win(buf, true, win_opts)
end

return Scratch

