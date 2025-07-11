return {
	"mfussenegger/nvim-lint",
	config = function()
		local lint = require("lint")

		-- lint.linters.eslint_d_fix = {
		-- 	cmd = "eslint_d",
		-- 	args = { "--stdin", "--stdin-filename", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)), "--fix" },
		-- 	stdin = true,
		-- 	lint_target = "file",
		-- 	ignore_exitcode = true,
		-- }

		vim.env.ESLINT_D_PPID = vim.fn.getpid()
		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint" },
			javascriptreact = { "eslint" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
