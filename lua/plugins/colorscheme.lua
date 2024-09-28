return {
  'AlexvZyl/nordic.nvim',
  lazy = false,
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'nordic'
    vim.cmd.hi 'Comment gui=none'
  end,
}
