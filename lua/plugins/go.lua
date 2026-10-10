return {
  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      -- Language extras install Delve / js-debug-adapter themselves. Avoid
      -- mason-nvim-dap trying the retired chrome-debug-adapter package.
      automatic_installation = false,
    },
  },
  {
    "leoluz/nvim-dap-go",
    config = function(_, opts)
      require("dap-go").setup(opts)
      local dap = require("dap")
      local go_adapter = dap.adapters.go
      dap.adapters.go = function(callback, config)
        go_adapter(function(adapter)
          adapter = vim.deepcopy(adapter)
          if adapter.executable then
            -- Delve builds in the adapter process cwd, not the launch cwd.
            -- Resolve the module even when nvim was opened from a parent folder.
            local program = type(config.program) == "string" and config.program or vim.api.nvim_buf_get_name(0)
            adapter.executable.cwd = config.cwd or vim.fs.root(program, { "go.work", "go.mod" }) or vim.fn.getcwd()
          end
          callback(adapter)
        end, config)
      end
    end,
  },
}
