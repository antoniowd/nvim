-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically.
opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.mouse = "a" -- Enable mouse mode

opt.number = true -- Print line number
opt.relativenumber = true -- Relative line numbers

opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.softtabstop = 2 -- Number of spaces tabs count for in insert mode
opt.smartindent = true -- Insert indents automatically

opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals

opt.spelllang = { "en", "es", "pt" }

opt.tabstop = 2 -- Number of spaces tabs count for

opt.termguicolors = true -- True color support

opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold

opt.sidescrolloff = 8 -- Columns of context

opt.scrolloff = 8

-- this is for Avante views can only be fully collapsed with the global statusline
opt.laststatus = 3

-- [[ Highlight on yank ]]
-- See `:help vim.hl.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- [[ Performance Optimizations ]]

-- Syntax/display performance
opt.synmaxcol = 240 -- Only syntax highlight first 240 columns
opt.redrawtime = 1500 -- Allow more time for syntax highlighting large files

-- Sign column (prevents layout shift)
opt.signcolumn = "yes"

-- Cursor line optimization
opt.cursorline = true
opt.cursorlineopt = "number" -- Only highlight line number (less redraws)

-- Disable unused providers (faster startup)
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- Disable unused built-in plugins (faster startup)
local disabled_plugins = {
	"gzip",
	"tar",
	"tarPlugin",
	"zip",
	"zipPlugin",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logiPat",
	"rrhelper",
	"matchit",
	"matchparen",
	"netrw",
	"netrwPlugin",
	"netrwSettings",
	"netrwFileHandlers",
}
for _, plugin in ipairs(disabled_plugins) do
	vim.g["loaded_" .. plugin] = 1
end
