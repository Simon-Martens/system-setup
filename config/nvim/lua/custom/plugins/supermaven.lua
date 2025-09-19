return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup {
      keymaps = {
        accept_sugggestion = '<C-Y>',
      },
    }
  end,
}
