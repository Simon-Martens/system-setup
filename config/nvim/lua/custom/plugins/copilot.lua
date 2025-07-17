-- Github Copilot
-- This is a plugin that provides AI-powered code suggestions
return {
  'github/copilot.vim',
  name = 'copilot',
  config = function()
    -- Use Ctrl + u to accept GitHub Copilot suggestions
    vim.api.nvim_set_keymap('i', '<C-U>', 'copilot#Accept("<CR>")', { expr = true, noremap = false, silent = true })
    -- vim.api.nvim_set_keymap('i', '<C-I>', '<Plug>(copilot-accept-word)', { expr = true, noremap = false, silent = true })
    -- vim.api.nvim_set_keymap('i', '<C-n>', '<Plug>(copilot-next)', { expr = true, noremap = false, silent = true })
    -- vim.api.nvim_set_keymap('i', '<C-N>', '<Plug>(copilot-previous)', { expr = true, noremap = false, silent = true })
    -- vim.api.nvim_set_keymap('i', '<C-s>', '<Plug>(copilot-suggest)', { expr = true, noremap = false, silent = true })
  end,
}
