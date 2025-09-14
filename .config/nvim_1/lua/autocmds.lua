local api = vim.api
api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "Jenkinsfile*",
  callback = function()
    vim.opt.filetype = "groovy"
  end,
  group = api.nvim_create_augroup("JenkinsfileSyntax", { clear = true }),
})

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = vim.fn.expand("~") .. "/.kube/*.config",
  callback = function()
    vim.bo.filetype = "yaml"
  end,
  group = api.nvim_create_augroup("KubeConfigFileSyntax", { clear = true }),
})

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.go",
  callback = function()
    vim.opt.colorcolumn = "100"
  end,
  group = api.nvim_create_augroup("LineWrapIndicatorFiles", { clear = true }),
})

api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = "*.go",
  callback = function()
    vim.opt_local.makeprg = "golangci-lint run --enable-only errcheck"
    vim.opt_local.errorformat = "%f:%l:%c: %m"
  end,
})


api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})
