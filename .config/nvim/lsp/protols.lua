---@brief
---
--- https://github.com/coder3101/protols
---
--- `protols` can be installed via `cargo`:
--- ```sh
--- cargo install protols
--- ```
---
--- A Language Server for proto3 files. It uses tree-sitter and runs in single file mode.

local function abs(p)
  return vim.fn.fnamemodify(p, ':p')
end

---@type vim.lsp.Config
return {
  cmd = { 'protols' },
  filetypes = { 'proto' },
  single_file_support = true,
  init_options = {
    include_paths = {
      abs("./proto"),
      abs("../../proto"),
    },
  },
}
