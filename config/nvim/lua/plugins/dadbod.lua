return {
  'tpope/vim-dadbod',
  'kristijanhusak/vim-dadbod-completion',
  'kristijanhusak/vim-dadbod-ui',
  config = function()
    vim.g.db_ui_save_location = vim.fn.getcwd() .. '/queries/'
    -- Setup SQL completions
    -- Setup up vim-dadbod
    local cmp = require 'cmp'
    cmp.setup.filetype({ 'sql' }, {
      sources = {
        { name = 'vim-dadbod-completion' },
        { name = 'buffer' },
      },
    })
  end,
}
