return {
	"zbirenbaum/copilot.lua",
	lazy = false, -- Load immediately
	priority = 100, -- Load early
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true, -- Enable auto-trigger for inline suggestions
			debounce = 75,
				keymap = {
					accept = "<C-a>", -- Ctrl+a to accept
					accept_word = false,
					accept_line = false,
					next = "<M-]>",
					prev = "<M-[>",
					dismiss = "<C-]>",
				},
			},
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = "[[",
					jump_next = "]]",
					accept = "<CR>",
					refresh = "gr",
					open = "<M-CR>",
				},
			},
			filetypes = {
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				["."] = false,
			},
			copilot_node_command = vim.fn.expand("$HOME") .. "/.local/bin/node-copilot", -- Custom node wrapper
			server_opts_overrides = {},
		})
	end,
}
