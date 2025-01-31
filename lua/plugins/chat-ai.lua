return {
	"nvim-ai",
	dir = "~/projects/nvim-ai",
	config = function()
		require("ai").setup()
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
}
