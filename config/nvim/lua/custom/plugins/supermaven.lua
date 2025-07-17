return {
  'supermaven-inc/supermaven-nvim',
  config = function()
    require('supermaven-nvim').setup {
      disable_keymaps = true,
      keymaps = {
        accept_suggestion = '<C-u>',
        accept_word = '<C-i>',
      },
    }
  end,
}
