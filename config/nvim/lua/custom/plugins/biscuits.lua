return {
  'code-biscuits/nvim-biscuits',
  requires = {
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('nvim-biscuits').setup {
      cursor_line_only = true, -- Only show biscuits on the current line
    }
  end,
}
