return {
	"williamboman/mason.nvim",
	dependencies = { "WhoIsSethDaniel/mason-tool-installer.nvim" },
	opts = {
		ensure_installed = {
			-- lsp
			"typescript-language-server",
			"tailwindcss-language-server",
			"html-lsp",
			"lua-language-server",
		},
	},
	config = function(_, opts)
		require("mason").setup(opts)
		local mr = require("mason-registry")
		local function ensure_installed()
			for _, tool in ipairs(opts.ensure_installed) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end
		end
		-- In case of a fresh install, install the tools
		if mr.refresh then
			mr.refresh(ensure_installed)
		else
			ensure_installed()
		end
	end,
}
