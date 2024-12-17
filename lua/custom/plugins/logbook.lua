return {
  {
    'syiin/nvim-logbook',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-lua/plenary.nvim', -- required by telescope
    },
    config = function()
      require('logbook').setup {
        default_path = '~/Gosei/logbook',
        file_extension = '.md',
      }

      -- Load the telescope extension
      require('telescope').load_extension 'logbook'

      -- Optional: Add keymaps for searching
      vim.keymap.set('n', '<leader>lf', '<cmd>Telescope logbook<cr>', { noremap = true, silent = true })
      vim.keymap.set('n', '<leader>lF', '<cmd>Telescope logbook_files<cr>', { noremap = true, silent = true })
    end,
  },
  {
    -- The telescope extension as a separate plugin
    'syiin/telescope-nvim-logbook',
    dependencies = {
      'syiin/nvim-logbook',
      'nvim-telescope/telescope.nvim',
    },
    config = function()
      require('telescope').load_extension 'logbook'
      -- Optional: Add your keymaps here
      vim.keymap.set('n', '<leader>fl', '<cmd>Telescope logbook<cr>')
      vim.keymap.set('n', '<leader>fL', '<cmd>Telescope logbook_files<cr>')
    end,
  },
}
