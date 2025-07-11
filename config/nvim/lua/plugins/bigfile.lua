-- Improve handling of huge files
return {
  'LunarVim/bigfile.nvim',
  -- default config
  config = function()
    require('bigfile').setup {
      filesize = 2, -- size of the file in MiB, the plugin round file sizes to the closest MiB
      pattern = { '*' }, -- autocmd pattern or function see <### Overriding the detection of big files>
      features = { -- features to disable
        'indent_blankline',
        'illuminate',
        'lsp',
        'treesitter',
        'syntax',
        'matchparen',
      },
    }
  end,
}
