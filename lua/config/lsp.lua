local map = vim.keymap.set

-- LSP Keymaps
vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }

                opts.desc = "LSP: [R]e[n]ame"
                map("n", "<leader>rn", vim.lsp.buf.rename, opts)

                opts.desc = "LSP: [C]ode [A]ction" 
                map("n", "<leader>ca", vim.lsp.buf.code_action, opts)

                opts.desc = "LSP: [G]oto [D]efinition" 
                map("n", "gd", vim.lsp.buf.definition, opts)

                opts.desc = "LSP: [G]oto [R]eferences"
                map("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "LSP: [G]oto [I]mplementation"
                map("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)

                opts.desc = "LSP: Type [D]efinition"
                map("n", "<leader>D", vim.lsp.buf.type_definition, opts)

                opts.desc = "LSP: [D]ocument [S]ymbols"
                map("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", opts)

                opts.desc = "LSP: [W]orkspace [S]ymbols"
                map("n", "<leader>ws", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", opts)

                opts.desc = "LSP: Hover Documentation"
                map("n", "K", vim.lsp.buf.hover, opts)

                opts.desc = "LSP: Signature Documentation"
                map("n", "<leader>k", vim.lsp.buf.signature_help, opts)
        end
})


