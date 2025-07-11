return {
	-- LSP Configuration & Plugins
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		"williamboman/mason-lspconfig.nvim",

		-- Useful status updates for LSP
		{ "j-hui/fidget.nvim", opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		"folke/neodev.nvim",
	},
	config = function()
		vim.diagnostic.config({ virtual_text = true })
		--  This function gets run when an LSP connects to a particular buffer.
		local on_attach = function(_, bufnr)
			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, "Format", function(_)
				vim.lsp.buf.format()
			end, { desc = "Format current buffer with LSP" })
		end

		local lspconfig = require("lspconfig")
		local servers = {
			-- gopls = {},
			-- pyright = {}:
			ts_ls = {
				settings = {
					typescript = {
						format = {
							enable = false,
						},
					},
					javascript = {
						format = {
							enable = false,
						},
					},
				},
			},
			tailwindcss = {},
			html = { filetypes = { "html", "twig", "hbs" } },

			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
				},
			},
		}

		-- Setup neovim lua configuration
		require("neodev").setup()

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		-- Ensure the servers above are installed
		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup_handlers({
			function(server_name)
				local setup = {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
				}

				lspconfig[server_name].setup(setup)
			end,
		})
	end,
}
