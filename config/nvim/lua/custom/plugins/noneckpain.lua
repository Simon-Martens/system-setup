-- Shows a global buffer on the right side of the screen
-- so the text doesnt get too wide and hard to read.
return {
  'shortcuts/no-neck-pain.nvim',
  config = function()
    local nnp = require 'no-neck-pain'
    nnp.setup {
      width = 100,
      minSideBufferWidth = 20,
      fallbackOnBufferDelete = false,
      buffers = {
        right = {
          enabled = true,
          scratchPad = {
            enabled = true,
            pathToFile = vim.fn.getcwd() .. '/scratchpad.md',
          },
        },
        left = {
          enabled = false,
          scratchPad = {
            enabled = false,
          },
        },
        bo = {
          filetype = 'md',
        },
        wo = {
          fillchars = 'eob: ',
        },
      },
      autocmds = {
        enableOnVimEnter = true,
        enableOnTabEnter = true,
        reloadOnColorSchemeChange = true,
      },
      mappings = {
        enabled = true,
      },
    }
  end,
}
