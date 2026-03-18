return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			enabled = true,
			heading = {
				enabled = true,
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			},
			code = {
				enabled = true,
				style = "full",
			},
			pipe_table = {
				enabled = true,
				-- 'padded': pads cells to the max visual width per column
				-- 'trimmed': same but subtracts trailing empty space (better for mixed-width content)
				cell = "trimmed",
				padding = 1,
			},
		},
	},
}
