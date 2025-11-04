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

			-- Custom handler for eslint
			["eslint"] = function()
				vim.lsp.config("eslint", {
					-- Use the file's location as working directory to properly resolve dependencies
					-- This is critical for pnpm and workspace setups
					settings = {
						workingDirectory = { mode = "location" },
					},
					-- Smart root directory detection for standalone and monorepo projects
					root_dir = function(fname)
						local root_files = {
							".git",
							"pnpm-workspace.yaml",
							"yarn.lock",
							"package-lock.json",
							"pnpm-lock.yaml",
							"package.json",
							".eslintrc",
							".eslintrc.js",
							".eslintrc.json",
							"eslint.config.js",
						}
						return vim.fs.root(fname, root_files) or vim.fn.getcwd()
					end,
				})
				vim.lsp.enable("eslint")
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
