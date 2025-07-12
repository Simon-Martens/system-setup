-- Highlight todo, notes, etc in comments
return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { signs = false },
  config = function()
    require('todo-comments').setup()
    vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope keywords=TODO<cr>')
    vim.keymap.set('n', '<leader>sb', '<cmd>TodoTelescope keywords=PERF,BUG,FIX<cr>')
  end,
}
