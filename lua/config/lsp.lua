local map = vim.keymap.set

-- LSP Performance: Diagnostic configuration
vim.diagnostic.config({
	update_in_insert = false, -- Don't update diagnostics in insert mode
	virtual_text = {
		spacing = 4,
		severity = { min = vim.diagnostic.severity.WARN }, -- Only show warnings+
	},
	signs = {
		severity = { min = vim.diagnostic.severity.HINT },
	},
	underline = {
		severity = { min = vim.diagnostic.severity.WARN },
	},
	float = {
		source = "if_many",
		border = "rounded",
	},
	severity_sort = true,
})

-- LSP Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)

		-- Performance: Disable semantic tokens (Treesitter handles highlighting)
		if client then
			client.server_capabilities.semanticTokensProvider = nil
		end

		local opts = { buffer = ev.buf, silent = true }

		opts.desc = "LSP: [R]e[n]ame"
		map("n", "<leader>rn", vim.lsp.buf.rename, opts)

		opts.desc = "LSP: [C]ode [A]ction"
		map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

		opts.desc = "LSP: [G]oto [D]efinition"
		map("n", "gd", vim.lsp.buf.definition, opts)

		opts.desc = "LSP: [G]oto [R]eferences"
		map("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "LSP: [G]oto [I]mplementation"
		map("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)

		opts.desc = "LSP: Type [D]efinition"
		map("n", "<leader>D", vim.lsp.buf.type_definition, opts)

		opts.desc = "LSP: [D]ocument [S]ymbols"
		map("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", opts)

		opts.desc = "LSP: [W]orkspace [S]ymbols"
		map("n", "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)

		opts.desc = "LSP: Hover Documentation"
		map("n", "K", vim.lsp.buf.hover, opts)

		opts.desc = "LSP: Signature Documentation"
		map("n", "<leader>k", vim.lsp.buf.signature_help, opts)
	end,
})

-- Toggle inlay hints keymap (global, not buffer-local)
map("n", "<leader>uh", function()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle Inlay Hints" })


