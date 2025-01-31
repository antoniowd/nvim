return {
	"dense-analysis/ale",
	config = function()
		vim.cmd([[
      let js_fixers = ['prettier', 'eslint']
      let g:ale_fixers = {
      \  '*': ['remove_trailing_lines', 'trim_whitespace'],
      \  'javascript': js_fixers,
      \  'typescript': js_fixers,
      \  'typescriptreact': js_fixers,
      \  'css': ['prettier'],
      \  'json': ['prettier'],
      \  'html': ['prettier'],
      \  'go': ['gofmt'],
      \  'lua': ['stylua'],
      \}

      let g:ale_linters = {
      \  'python': ['pylint'],
      \}

      let g:ale_linters_ignore = {
      \  'python': ['pyright'],
      \}
      let g:ale_fix_on_save = 1

    ]])

		vim.keymap.set("n", "<leader>fa", ":ALEFix<CR>", { desc = "[F]ormat [A]ll", silent = true })
	end,
}
