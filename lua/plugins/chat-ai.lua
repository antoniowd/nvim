-- return {
-- 	"nvim-ai",
-- 	dir = "~/projects/nvim-ai",
-- 	config = function()
-- 		require("ai").setup()
-- 	end,
-- 	dependencies = {
-- 		"nvim-lua/plenary.nvim",
-- 		"nvim-telescope/telescope.nvim",
-- 	},
-- }
return {
	"nvim-ai",
	dir = "~/projects/ai-assistant/nvim-ai-assistant",
	config = function()
		require("aihelper").setup()
	end,
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
}
