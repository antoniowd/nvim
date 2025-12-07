return {
	"zbirenbaum/copilot.lua",
	event = "InsertEnter", -- Defer loading until first insert
	cmd = "Copilot", -- Also load on command
	config = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				debounce = 150, -- Increased from 75ms for better performance
				keymap = {
					accept = "<C-a>",
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
			copilot_node_command = vim.fn.expand("$HOME") .. "/.local/bin/node-copilot",
			server_opts_overrides = {},
		})
	end,
}
