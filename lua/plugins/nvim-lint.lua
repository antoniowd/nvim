return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Configure linters by filetype
    -- ESLint removed: using ESLint LSP instead for JS/TS (more efficient)
    lint.linters_by_ft = {
      -- Add non-LSP linters here as needed
    }

    -- Create autocmds for linting (only on save for performance)
    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        if vim.bo.buftype ~= "" then
          return
        end
        lint.try_lint()
      end,
    })

    -- Manual lint command
    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Trigger linting" })
  end,
}
