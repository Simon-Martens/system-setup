return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup {
      keymaps = {
        accept_suggestion = '<C-u>',
        accept_word = '<C-i>',
      },
    }
  end,
}
