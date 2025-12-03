local map = vim.keymap.set

-- Go to normal mode
map("i", "jj", "<Esc>", { desc = "Exit insert mode", silent = true })
map("c", "jj", "<C-c>", { desc = "Exit insert mode", silent = true })

-- move between windows
map("n", "<C-j>", "<C-w>j", { desc = "Mode to bottom window", silent = true })
map("n", "<C-k>", "<C-w>k", { desc = "Mode to top window", silent = true })
map("n", "<C-h>", "<C-w>h", { desc = "Mode to left window", silent = true })
map("n", "<C-l>", "<C-w>l", { desc = "Mode to right window", silent = true })

map("i", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Mode to bottom window", silent = true })
map("i", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Mode to top window", silent = true })
map("i", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Mode to left window", silent = true })
map("i", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Mode to right window", silent = true })

map("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Mode to bottom window", silent = true })
map("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Mode to top window", silent = true })
map("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Mode to left window", silent = true })
map("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Mode to right window", silent = true })

-- terminal
-- map("n", "<leader>t", ":belowright split | :terminal<CR>", { desc = "Open [T]erminal", silent = true })
map("t", "jj", "<C-\\><C-n>", { desc = "Exit insert mode from terminal", silent = true })

-- resize windows
map("n", "<C-Right>", ":vertical resize +6<CR>", { desc = "Resize window to right", silent = true })
map("n", "<C-Left>", ":vertical resize -5<CR>", { desc = "Resize window to left", silent = true })
map("n", "<C-Up>", ":resize +5<CR>", { desc = "Resize window to top", silent = true })
map("n", "<C-Down>", ":resize -5<CR>", { desc = "Resize window to bottom", silent = true })

-- Save keymaps
map("n", "ss", ":w<CR>", { desc = "[S]ave [B]uffer", silent = true })
map("n", "<leader>sa", ":wa<CR>", { desc = "[S]ave [A]ll Opened Buffers", silent = true })
map("n", "<leader>sq", ":wq<CR>", { desc = "[S]ave and [Q]uit", silent = true })

-- Explorer
-- map("n", "<leader>p", ":Ex<CR>", { desc = "[E]xplorer", silent = true })

-- Yank to the end
map("n", "Y", "y$")

-- tmux-sessionizer
map("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>", { silent = true })

-- git fugitive
map("n", "<leader>gs", ":G<CR>", { desc = "[G]it [S]tatus", silent = true })
-- map("n", "<leader>gp", ":G push<CR>", { desc = "[G]it [P]ush", silent = true })
-- map("n", "<leader>gu", ":G pull<CR>", { desc = "[G]it P[U]ll", silent = true })

-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })
