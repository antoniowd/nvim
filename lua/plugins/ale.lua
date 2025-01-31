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
\  'javascriptreact': js_fixers,
\  'css': ['prettier'],
\  'json': ['prettier'],
\  'html': ['prettier'],
\  'go': ['gofmt'],
\  'lua': ['stylua'],
\  'sql': ['sqlfluff'],
\}

let g:ale_linters = {
\  'python': ['pylint'],
\  'javascript': ['eslint'],
\  'typescript': ['eslint'],
\  'typescriptreact': ['eslint'],
\  'javascriptreact': ['eslint'],
\  'sql': ['sqlfluff'],
\}

let g:ale_linters_ignore = {
\  'python': ['pyright'],
\}
let g:ale_fix_on_save = 1
" let g:ale_completion_enabled = 0
" let g:ale_completion_autoimport = 0
let g:ale_disable_lsp = 1

]])

		vim.keymap.set("n", "<leader>fa", ":ALEFix<CR>", { desc = "[F]ormat [A]ll", silent = true })
	end,
}
