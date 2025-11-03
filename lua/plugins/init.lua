return {
  { "folke/lazy.nvim", version = "*" },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.cmd.colorscheme("tokyonight-night")
        end,
    },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
	bigfile = { enabled = true }
    },
    config = function(_, opts)
      -- local notify = vim.notify
      require("snacks").setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      -- if LazyVim.has("noice.nvim") then
      --   vim.notify = notify
      -- end
    end,
  },
  "nvim-tree/nvim-web-devicons",
}
