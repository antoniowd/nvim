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

opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals

opt.spelllang = { "en", "es", "pt" }

opt.tabstop = 2 -- Number of spaces tabs count for

opt.termguicolors = true -- True color support

opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold

opt.sidescrolloff = 8 -- Columns of context
