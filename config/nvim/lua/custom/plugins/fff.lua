return {
  'dmtrKovalenko/fff.nvim',
  build = 'cargo build --release',
  opts = {
    -- pass here all the options
  },
  keys = {
    {
      '<leader>sf', -- try it if you didn't it is a banger keybinding for a picker
      function()
        require('fff').toggle()
      end,
      desc = 'Toggle FFF',
    },
  },
}
