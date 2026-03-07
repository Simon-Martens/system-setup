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
  -- require 'custom.plugins.autotag', -- Close Tags automatically
  -- require 'custom.plugins.biscuits', -- Show opening and closing lines on brackets
  -- require 'custom.plugins.grug-far', -- Search and replace tool
  -- require 'custom.plugins.tmux', -- Tmux integration
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  -- require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps
  -- require 'custom.plugins.noneckpain', -- Make the window not too wide
  -- require 'custom.plugins.whichkey', -- Keybindings helper

  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically
  require 'custom.plugins.bbye', -- Shortcuts for deleting buffers used ith <Space>q
  require 'custom.plugins.bigfile', -- Handle large files, auto-disables some features to prevent lag
  require 'custom.plugins.copilot', -- GitHub Copilot, Ctrl+U to accept recommendations
  require 'custom.plugins.gitsigns', -- Git signs in the gutter
  require 'custom.plugins.mini', -- Mini plugins for various enhancements, see there
  require 'custom.plugins.multiselect', -- Multi-select functionality
  require 'custom.plugins.telescope', -- Fuzzy Finder for files, buffers, etc.
  require 'custom.plugins.todo-comments', -- Highlight TODO, BUG, etc. comments
  require 'custom.plugins.treesitter', -- Basic syntax highlighting & more

  -- Languages
  -- require 'custom.plugins.go', -- Go configuration, may conflict with lspconfig
  -- require 'custom.plugins.lazydev', -- Better LSP experience with lua configs LUA only
  require 'custom.plugins.typst', -- Typst document preview
  require 'custom.plugins.dart', -- Dart & Flutter support, may conflict with lspconfig

  -- LSP plugins & dependent features
  require 'custom.lsp.lspconfig', -- LSP configuration
  require 'custom.lsp.conform', -- Autoformat (on Close)
  require 'custom.lsp.blink', -- Autocompletion

  { import = 'custom.lsp' },
}

-- Define the path to your theme file
-- Whether this is copnrolled by you or your system depends on the system
-- If theme file exists, add it to the list of plugins to be loaded
local theme_path = vim.fn.stdpath 'config' .. '/lua/theme.lua'
if vim.fn.filereadable(theme_path) == 1 then
  table.insert(plugins, require 'theme')
end

require('lazy').setup(plugins, {
  -- These are the options for lazy.nvim itself
  git = {
    timeout = 3000,
  },
  ui = {
    -- We need nerd fonts for the icons to work!
    icons = {},
  },
})

-- Adds a file extention for go template files
vim.filetype.add {
  extension = {
    gotmpl = 'gotmpl',
  },
  pattern = {
    ['.*%.gohtml'] = 'gotmpl',
    ['.*/templates/.*%.tpl'] = 'helm',
    ['.*/templates/.*%.ya?ml'] = 'helm',
    ['helmfile.*%.ya?ml'] = 'helm',
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
