-- [[ Basic Keymaps ]]
-------------------------------------------------------------------------------------------------------
--  See `:help vim.keymap.set()`
--
--  Always paste what was yanked, not what was deleted:
vim.keymap.set({ 'n', 'v' }, ',p', '"0p', { noremap = true, silent = true, desc = 'Paste yanked' })
vim.keymap.set({ 'n', 'v' }, ',P', '"0P', { noremap = true, silent = true, desc = 'Paste yanked' })

-- Normal behaviour of j and k in wrapped lines
vim.keymap.set({ 'n', 'v' }, 'j', 'gj', { noremap = true, silent = true, desc = 'Move down' })
vim.keymap.set({ 'n', 'v' }, 'k', 'gk', { noremap = true, silent = true, desc = 'Move up' })

-- Replace word I am on in the whole file
vim.keymap.set('n', '<leader>rw', ':%s/\\<<C-r><C-w>\\>//g<left><left>', { noremap = true, silent = true, desc = 'Replace word in file' })

-- Allow moving selected text horizontally in visual mode
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = 'Move selection up' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = 'Move selection down' })

-- Clear highlight on pressing <Esc> in normal mode:
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Vertically jump around half a page and always center the cursor
-- Vertically jump around to the next/prev search result and always center the cursor
-- See `:help scroll.txt`
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Delete without yanking
vim.keymap.set('n', '<leader>d', '"_d', { noremap = true, desc = 'Delete without yanking' })
vim.keymap.set('v', '<leader>d', '"_d', { noremap = true, desc = 'Delete without yanking' })

-- Paste without yanking
vim.keymap.set('n', '<leader>p', '"_dP', { noremap = true, desc = 'Paste without yanking' })

-- Disable deselection when indenting in visual mode
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

--
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.

--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
-- The first four are set in the tmux plugin
-- vim.keymap.set({ 'n', 'i', 'v' }, '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window', silent = true })
-- vim.keymap.set({ 'n', 'i', 'v' }, '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window', silent = true })
-- vim.keymap.set({ 'n', 'i', 'v' }, '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the window below', silent = true })
-- vim.keymap.set({ 'n', 'i', 'v' }, '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the window up', silent = true })
vim.keymap.set({ 'n', 'v' }, '<Left>', '<C-w><C-h>', { desc = 'Move focus to the left window', silent = true })
vim.keymap.set({ 'n', 'v' }, '<Right>', '<C-w><C-l>', { desc = 'Move focus to the right window', silent = true })
vim.keymap.set({ 'n', 'v' }, '<Down>', '<C-w><C-j>', { desc = 'Move focus to the window down', silent = true })
vim.keymap.set({ 'n', 'v' }, '<Up>', '<C-w><C-k>', { desc = 'Move focus to the window up', silent = true })

-- Keybinds to make buffer scopes easier
vim.keymap.set('n', 'gb', '<cmd>bn<CR>', { desc = 'Go to next buffer', silent = true })
vim.keymap.set('n', 'gB', '<cmd>bp<CR>', { desc = 'Go to previous buffer', silent = true })

-- Keybinds to make tab scopes easier
vim.keymap.set('n', 'gT', '<cmd>tabprevious<CR>', { desc = '[G]oto previous [T]ab' })
vim.keymap.set('n', 'gt', '<cmd>tabnext<CR>', { desc = '[G]oto to next [t]ab' })
vim.keymap.set('n', '<Leader>t', '<cmd>tabnew<CR>', { remap = true, desc = 'Open a new tab' })
vim.keymap.set('n', '<Leader><S-Tab>', '<cmd>tabprevious<CR>', { desc = '[G]oto previous [T]ab' })
vim.keymap.set('n', '<Leader><Tab>', '<cmd>tabnext<CR>', { desc = '[G]oto next [T]ab' })

-- Further plugin dependent keybinds
-- See bbye for closing buffer keymaps <Leader>q <Leader>Q
-- See treesitter for semantic keymaps in v-mode vaf vif etc
-- See telescope for fuzzy finding keymaps <Leader>s and buffer search <Leader><Leader>
-- See comment for gc keymap gc
-- See lspconfig for various LSP keymaps
-- See multiselect for C-n
-- See mini for jumping with f / F / t / T and suraunding selection in v-mode va{ va( vi( etc
-- See copilot for C-u
-- See which-key for <Leader> <LocalLeader> <Leader>h <Leader>l
-- See scratch for adhs-files keybinds
