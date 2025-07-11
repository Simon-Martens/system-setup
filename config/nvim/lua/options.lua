-- Options
-----------------------------------------------------------------------------------------------
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Dont use the tab key for copilot suggestions
vim.g.copilot_no_tab_map = true

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
-- vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.stdpath 'data' .. '/undo'
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'number'

-- Decrease update time
vim.opt.updatetime = 250

-- Time when the help popup will appear
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '  ', trail = '·', nbsp = '␣', multispace = '·', lead = '·' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 16

-- Tab size
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Don't expand tabs into spaces
vim.opt.expandtab = false
vim.opt.et = false

-- Relative line numbers
-- See `:help 'relativenumber'`
vim.opt.relativenumber = true

-- Disable folding, we don't need it
vim.opt.fen = false

-- vim.opt.textwidth = 100

-- Set highlight on search,
vim.opt.hlsearch = true

-- Reset the cursor
-- BUG: this is still not working for tmux with ghostty
vim.cmd.normal ':set guicursor='
vim.cmd.normal ':autocmd OptionSet guicursor noautocmd set guicursor='
