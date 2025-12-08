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
		map("n", "gd", function()
			-- Custom handler that filters duplicates and uses Snacks picker
			local params = vim.lsp.util.make_position_params()
			vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, ctx, config)
				if err then
					vim.notify("Error getting definition: " .. tostring(err), vim.log.levels.ERROR)
					return
				end

				if not result or vim.tbl_isempty(result) then
					vim.notify("No definition found", vim.log.levels.WARN)
					return
				end

				-- Normalize result to always be a list
				local locations = vim.islist(result) and result or { result }

				-- Filter out duplicates based on uri and range
				local seen = {}
				local unique_locations = {}
				for _, location in ipairs(locations) do
					local key = string.format(
						"%s:%d:%d",
						location.uri or location.targetUri,
						location.range and location.range.start.line or location.targetRange.start.line,
						location.range and location.range.start.character or location.targetRange.start.character
					)
					if not seen[key] then
						seen[key] = true
						table.insert(unique_locations, location)
					end
				end

				-- If only one unique location, jump directly
				if #unique_locations == 1 then
					vim.lsp.util.jump_to_location(unique_locations[1], "utf-8")
				else
					-- Use Snacks picker for multiple locations
					Snacks.picker.lsp_definitions()
				end
			end)
		end, opts)

		opts.desc = "LSP: [G]oto [R]eferences"
		map("n", "gr", function()
			Snacks.picker.lsp_references()
		end, opts)

		opts.desc = "LSP: [G]oto [I]mplementation"
		map("n", "gI", function()
			Snacks.picker.lsp_implementations()
		end, opts)

		opts.desc = "LSP: Type [D]efinition"
		map("n", "<leader>D", vim.lsp.buf.type_definition, opts)

		opts.desc = "LSP: [D]ocument [S]ymbols"
		map("n", "<leader>ds", function()
			Snacks.picker.lsp_symbols()
		end, opts)

		opts.desc = "LSP: [W]orkspace [S]ymbols"
		map("n", "<leader>ws", function()
			Snacks.picker.lsp_workspace_symbols()
		end, opts)

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

-- Claude Code reference keymaps
local function get_git_root()
	local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		return nil
	end
	return git_root
end

local function get_relative_path()
	local git_root = get_git_root()
	if not git_root then
		vim.notify("Not in a git repository", vim.log.levels.WARN)
		return nil
	end

	local filepath = vim.fn.expand("%:p")
	local relative_path = filepath:sub(#git_root + 2) -- +2 to remove trailing slash
	return relative_path
end

-- Normal mode: Copy @filepath
map("n", "<leader>cr", function()
	local relative_path = get_relative_path()
	if relative_path then
		local reference = "@" .. relative_path
		vim.fn.setreg("+", reference)
		vim.notify("Copied: " .. reference, vim.log.levels.INFO)
	end
end, { desc = "Copy Claude Code reference" })

-- Visual mode: Copy @filepath:start-end
map("v", "<leader>cr", function()
	local relative_path = get_relative_path()
	if relative_path then
		local start_line = vim.fn.line("v")
		local end_line = vim.fn.line(".")

		-- Ensure start_line is always less than end_line
		if start_line > end_line then
			start_line, end_line = end_line, start_line
		end

		local reference = string.format("@%s:%d-%d", relative_path, start_line, end_line)
		vim.fn.setreg("+", reference)
		vim.notify("Copied: " .. reference, vim.log.levels.INFO)
	end
end, { desc = "Copy Claude Code reference with line range" })


