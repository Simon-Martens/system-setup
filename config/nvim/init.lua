--[[

=====================================================================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||        nvim        ||   |-----|          ========
========         ||    config file     ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||                    ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

originally kickstart.nvim by tj devries:
https://github.com/nvim-lua/kickstart.nvim
--]]

require 'custom.options'
require 'custom.keymaps'
require 'custom.autocommands'
require 'custom.notes'

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

local rtp = vim.opt.rtp
---@type vim.Option
rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]

local plugins = {
  -- Miscellaneous plugins
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  require 'custom.plugins.autotag', -- Close Tags automatically
  require 'custom.plugins.bbye', -- Shortcuts for deleting buffers
  require 'custom.plugins.bigfile', -- Handle large files
  require 'custom.plugins.biscuits', -- Show opening and closing lines on brackets
  -- require 'custom.plugins.copilot', -- GitHub Copilot
  require 'custom.plugins.supermaven',
  require 'custom.plugins.fff', -- Fuzzy Finder for files, buffers, etc.
  require 'custom.plugins.gitsigns', -- Git signs in the gutter
  require 'custom.plugins.grug-far', -- Search and replace tool
  require 'custom.plugins.mini', -- Mini plugins for various enhancements
  require 'custom.plugins.multiselect', -- Multi-select functionality
  require 'custom.plugins.noneckpain', -- Make the window not too wide
  require 'custom.plugins.telescope', -- Fuzzy Finder for files, buffers, etc.
  require 'custom.plugins.tmux', -- Tmux integration
  require 'custom.plugins.todo-comments', -- Highlight TODO comments
  require 'custom.plugins.treesitter', -- Syntax highlighting & more
  require 'custom.plugins.whichkey', -- Keybindings helper
  require 'custom.plugins.typst', -- Typst document preview
  require 'custom.plugins.lazydev', -- Better LSP experience with lua configs

  -- LSP plugins & dependent features
  require 'custom.lsp.lspconfig', -- LSP configuration
  require 'custom.lsp.conform', -- Autoformat (on Close)
  require 'custom.lsp.blink', -- Autocompletion

  { import = 'custom.lsp' },

  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
}

-- Define the path to your theme file
-- lua/theme.lua is usually a link to a file
-- It is controlled by the os theme
local theme_path = vim.fn.stdpath 'config' .. '/lua/theme.lua'

-- Check if the theme file exists and is readable
-- If it exists, add it to the list of plugins to be loaded
if vim.fn.filereadable(theme_path) == 1 then
  table.insert(plugins, require 'theme')
end

require('lazy').setup(plugins, {
  -- These are the options for lazy.nvim itself
  git = {
    timeout = 3000,
  },
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
