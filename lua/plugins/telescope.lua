return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			-- NOTE: If you are having trouble with this installation,
			--       refer to the README for telescope-fzf-native for more instructions.
			build = "make",
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
	},
	keys = {
		{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>gf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
		{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git Files" },
		{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git Files" },
		{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader><space>", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
		{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
		{ "<leader>?", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
		{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Find Word" },
		{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Find Word" },
	},
	opts = {
		defaults = {
			layout_strategy = "vertical",
			mappings = {
				i = {
					["<C-j>"] = "move_selection_next",
					["<C-k>"] = "move_selection_previous",
				},
			},
			file_ignore_patterns = {
				"node_modules",
				".git/",
				"dist/",
				"build/",
			},
		},
		pickers = {
			find_files = {
				hidden = true,
			},
		},
	},
}
