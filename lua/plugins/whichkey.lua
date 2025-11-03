return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Document existing key chains
    wk.add({
      { "<leader>s", group = "Search/Save" },
      { "<leader>g", group = "Git" },
      { "<leader>t", group = "Terminal" },
      { "<leader>p", group = "Explorer" },
      { "<leader><space>", desc = "Buffers" },
      { "<leader>?", desc = "Recent Files" },
    })
  end,
}
