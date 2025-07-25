vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Go to normal mode
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode", silent = true })
vim.keymap.set("c", "jj", "<C-c>", { desc = "Exit insert mode", silent = true })

-- move between windows
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Mode to bottom window", silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Mode to top window", silent = true })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Mode to left window", silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Mode to right window", silent = true })

vim.keymap.set("i", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Mode to bottom window", silent = true })
vim.keymap.set("i", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Mode to top window", silent = true })
vim.keymap.set("i", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Mode to left window", silent = true })
vim.keymap.set("i", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Mode to right window", silent = true })

vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Mode to bottom window", silent = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Mode to top window", silent = true })
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Mode to left window", silent = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Mode to right window", silent = true })

-- terminal
vim.keymap.set("n", "<leader>t", ":belowright split | :terminal<CR>", { desc = "Open [T]erminal", silent = true })
vim.keymap.set("t", "jj", "<C-\\><C-n>", { desc = "Exit insert mode from terminal", silent = true })

-- resize windows
vim.keymap.set("n", "<C-Right>", ":vertical resize +6<CR>", { desc = "Resize window to right", silent = true })
vim.keymap.set("n", "<C-Left>", ":vertical resize -5<CR>", { desc = "Resize window to left", silent = true })
vim.keymap.set("n", "<C-Up>", ":resize +5<CR>", { desc = "Resize window to top", silent = true })
vim.keymap.set("n", "<C-Down>", ":resize -5<CR>", { desc = "Resize window to bottom", silent = true })

-- Save keymaps
vim.keymap.set("n", "ss", ":w<CR>", { desc = "[S]ave [B]uffer", silent = true })
vim.keymap.set("n", "<leader>sa", ":wa<CR>", { desc = "[S]ave [A]ll Opened Buffers", silent = true })
vim.keymap.set("n", "<leader>sq", ":wq<CR>", { desc = "[S]ave and [Q]uit", silent = true })

-- Explorer
vim.keymap.set("n", "<leader>p", ":Ex<CR>", { desc = "[E]xplorer", silent = true })

-- Yank to the end
vim.keymap.set("n", "Y", "y$")

-- tmux-sessionizer
vim.keymap.set("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- undotree
vim.keymap.set("n", "<leader>ut", vim.cmd.UndotreeToggle)

-- git fugitive
vim.keymap.set("n", "<leader>gs", ":G<CR>", { desc = "[G]it [S]tatus", silent = true })
vim.keymap.set("n", "<leader>gp", ":G push<CR>", { desc = "[G]it [P]ush", silent = true })
vim.keymap.set("n", "<leader>gu", ":G pull<CR>", { desc = "[G]it P[U]ll", silent = true })

-- github copilot
vim.keymap.set("i", "<C-a>", 'copilot#Accept("\\<CR>")', {
	expr = true,
	replace_keycodes = false,
	desc = "[C]opilot [A]ccept",
	silent = true,
})
vim.g.copilot_no_tab_map = true

-- LSP Keymaps
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition" })
vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", { desc = "LSP: [G]oto [R]eferences" })
vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", { desc = "LSP: [G]oto [I]mplementation" })
vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "LSP: Type [D]efinition" })
vim.keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "LSP: [D]ocument [S]ymbols" })
vim.keymap.set("n", "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "LSP: [W]orkspace [S]ymbols" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation" })
vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation" })

