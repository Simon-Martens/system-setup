-- Provides the Bdelete and Bwipeout commands to close buffers without closing the windows.
return {
  'moll/vim-bbye',
  config = function()
    local map = vim.api.nvim_set_keymap
    map('n', '<Leader>q', '<Cmd>Bdelete<CR>', { desc = 'Close buffer ' })
    map('n', '<Leader>Q', '<Cmd>Bdelete!<CR>', { desc = 'Close buffer (without saving)' })
  end,
}
