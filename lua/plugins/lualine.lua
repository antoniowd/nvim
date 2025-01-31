function full_file_path()
  return vim.fn.expand('%:p')
end

function relative_file_path()
  return vim.fn.expand('%:~:.')
end

return {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
	options = {
	    icons_enabled = true,
	    theme = 'tokyonight',
	    component_separators = '|',
	    section_separators = '',
	},
	sections = {
	    lualine_a = {'mode'},
	    lualine_b = {'branch', 'diff', 'diagnostics'},
	    lualine_c = { 'filename'  },
	    lualine_x = {'encoding', 'fileformat', 'filesize', 'filetype'},
	    lualine_y = {'progress'},
	    lualine_z = {'location'}
	},
    },
}
