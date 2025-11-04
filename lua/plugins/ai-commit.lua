return {
	name = "ai-commit",
	dir = vim.fn.stdpath("config") .. "/lua/ai-commit",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"zbirenbaum/copilot.lua",
	},
	opts = {
		provider = "copilot", -- AI provider: "claude", "openai", or "copilot"
		commit_format = "conventional", -- Use conventional commits format (feat:, fix:, etc.)
		custom_instructions = nil, -- Optional custom prompt instructions
	},
	config = function(_, opts)
		require("ai-commit").setup(opts)
	end,
	keys = {
		{
			"<leader>gm",
			"<cmd>GenerateCommitMessage<cr>",
			desc = "Generate commit [M]essage with AI",
		},
	},
}
