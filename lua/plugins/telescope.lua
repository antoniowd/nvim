return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
    config = function ()
      local tb = require('telescope.builtin')
      local actions = require "telescope.actions"


      pcall(require('telescope').load_extension, 'fzf')
      require('telescope').setup({
        defaults = {
          layout_strategy = 'vertical',
          mappings = {
            i = {
              -- ['<C-u>'] = false,
              -- ['<C-d>'] = false,
              ["<C-l>"] = actions.send_selected_to_qflist + actions.open_qflist
            },
            n = {
              ["<C-l>"] = actions.send_selected_to_qflist + actions.open_qflist
            }
          },
        },
      })

      vim.keymap.set('n', '<leader>?', tb.oldfiles, { desc = '[?] Find recently opened files' })
      vim.keymap.set('n', '<leader><space>', tb.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        tb.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>gf', tb.git_files, { desc = 'Search [G]it [F]iles' })
      vim.keymap.set('n', '<leader>gb', tb.git_branches, { desc = '[G]it [B]ranches' })
      vim.keymap.set('n', '<leader>gc', tb.git_commits, { desc = '[G]it [C]ommits' })
      vim.keymap.set('n', '<leader>sf', tb.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sh', tb.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sw', tb.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', tb.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', tb.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', tb.resume, { desc = '[S]earch [R]esume' })
    end
  },
}
