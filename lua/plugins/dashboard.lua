return {
  'MeanderingProgrammer/dashboard.nvim',
  event = 'VimEnter',
  dependencies = {
    { 'MaximilianLloyd/ascii.nvim', dependencies = { 'MunifTanjim/nui.nvim' } },
  },
  config = function()
    -- include dashboard_directories table if it exists on disk
    local status, directories = pcall(function()
      return require('../config/dashboard_directories')
    end)

    -- Empty table if we have no config
    if not status then
      directories = {}
    end

    require('dashboard').setup {
      header = require('ascii').art.text.neovim.sharp,
      directories = directories
    }
  end,
}
