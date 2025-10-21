return {
  "leoluz/nvim-dap-go",
  opts = {
    dap_configurations = {
      {
        type = "go",
        name = "Attach remote Docker",
        mode = "remote",
        request = "attach",
      },
    },
    delve = {
      port = "40000",
    },
  },
}
