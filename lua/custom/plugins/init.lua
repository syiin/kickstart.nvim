-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup {}
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter', -- optional
    'nvim-tree/nvim-web-devicons', -- optional
    {
      'alexghergh/nvim-tmux-navigation',
      config = function()
        local nvim_tmux_nav = require 'nvim-tmux-navigation'

        nvim_tmux_nav.setup {
          disable_when_zoomed = true, -- defaults to false
        }

        vim.keymap.set('n', '<C-h>', nvim_tmux_nav.NvimTmuxNavigateLeft)
        vim.keymap.set('n', '<C-j>', nvim_tmux_nav.NvimTmuxNavigateDown)
        vim.keymap.set('n', '<C-k>', nvim_tmux_nav.NvimTmuxNavigateUp)
        vim.keymap.set('n', '<C-l>', nvim_tmux_nav.NvimTmuxNavigateRight)
        vim.keymap.set('n', '<C-\\>', nvim_tmux_nav.NvimTmuxNavigateLastActive)
        vim.keymap.set('n', '<C-Space>', nvim_tmux_nav.NvimTmuxNavigateNext)
      end,
    },
  },
  require('lspconfig').dartls.setup {},
}
