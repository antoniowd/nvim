return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"mason-org/mason-lspconfig.nvim",
	},
	config = function()
		-- Configure cspell manually (not managed by mason-lspconfig)
		vim.lsp.config("cspell", {
			cmd = { "cspell-lsp", "--stdio" },
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"html",
				"css",
				"scss",
				"markdown",
				"text",
				"lua",
				"json",
			},
			root_dir = function(fname)
				return vim.fs.root(fname, { ".git", "package.json" }) or vim.fn.getcwd()
			end,
		})
		vim.lsp.enable("cspell")
	end,
}
