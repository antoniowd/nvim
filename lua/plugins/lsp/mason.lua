return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"ts_ls",
			"nextls",
			"lua_ls",
			"tailwindcss",
			"html",
			"cssls",
			"eslint",
			"jsonls",
		},
		handlers = {
			-- Default handler for all servers
			function(server_name)
				vim.lsp.enable(server_name)
			end,

			-- Custom handler for lua_ls
			["lua_ls"] = function()
				vim.lsp.config("lua_ls", {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							telemetry = {
								enable = false,
							},
						},
					},
				})
				vim.lsp.enable("lua_ls")
			end,
		},
	},
	dependencies = {
		{
			"mason-org/mason.nvim",
			opts = {
				ensure_installed = {
					"cspell",
				},
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			},
		},
		"neovim/nvim-lspconfig",
	},
}
