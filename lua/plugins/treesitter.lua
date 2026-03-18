return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	cmd = { "TSUpdate", "TSInstall" },
	config = function()
		local ok, treesitter = pcall(require, "nvim-treesitter")
		if not ok then
			return
		end

		treesitter.setup()
	end,
}
