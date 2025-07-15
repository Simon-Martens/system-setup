-- Enables auto-tag closure and editing via treesitter
return {
  'windwp/nvim-ts-autotag',
  config = function()
    require('nvim-ts-autotag').setup {
      opts = {
        enable_close = false,
        enable_rename = true,
        enable_close_on_slash = true,
      },

      per_filetype = {
        ['htm'] = {
          enable_close = true,
          enable_close_on_slash = true,
        },
        ['html'] = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
        ['xml'] = {
          enable_rename = true,
          enable_close = false,
          enable_close_on_slash = true,
        },
        ['gohtml'] = {
          enable_rename = true,
          enable_close = false,
          enabled_close_on_slash = true,
        },
      },
    }
  end,
}
