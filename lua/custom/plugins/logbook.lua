return {
  'syiin/nvim-logbook',
  config = function()
    require('logbook').setup {
      default_path = '~/Gosei/logbook',
    }
  end,
}
