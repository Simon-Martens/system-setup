-- Github Copilot
-- This is a plugin that provides AI-powered code suggestions
return {
  'github/copilot.vim',
  name = 'copilot',
  config = function()
    -- Use Ctrl + u to accept GitHub Copilot suggestions
    vim.api.nvim_set_keymap('i', '<C-U>', 'copilot#Accept("<CR>")', { expr = true, noremap = false, silent = true })
  end,
}
