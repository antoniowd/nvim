return {
	"mason-org/mason-lspconfig.nvim",
	opts = {
		ensure_installed = {
			"vtsls", -- Faster than ts_ls for large TypeScript projects
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

			-- Optimized vtsls configuration for TypeScript/JavaScript
			["vtsls"] = function()
				vim.lsp.config("vtsls", {
					settings = {
						typescript = {
							-- Disable inlay hints for performance (toggle with <leader>uh)
							inlayHints = {
								parameterNames = { enabled = "none" },
								parameterTypes = { enabled = false },
								variableTypes = { enabled = false },
								propertyDeclarationTypes = { enabled = false },
								functionLikeReturnTypes = { enabled = false },
								enumMemberValues = { enabled = false },
							},
							preferences = {
								importModuleSpecifier = "relative",
							},
						},
						javascript = {
							inlayHints = {
								parameterNames = { enabled = "none" },
								parameterTypes = { enabled = false },
								variableTypes = { enabled = false },
								propertyDeclarationTypes = { enabled = false },
								functionLikeReturnTypes = { enabled = false },
								enumMemberValues = { enabled = false },
							},
						},
						vtsls = {
							autoUseWorkspaceTsdk = true,
							experimental = {
								completion = {
									enableServerSideFuzzyMatch = true,
								},
							},
						},
					},
					-- Smart root directory for monorepos and single packages
					root_dir = function(fname)
						local root_files = {
							"tsconfig.json",
							"jsconfig.json",
							"package.json",
							".git",
						}
						return vim.fs.root(fname, root_files) or vim.fn.getcwd()
					end,
				})
				vim.lsp.enable("vtsls")
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
