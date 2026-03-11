--   ___________________________
-- |;;|                     |;;||
-- |[]|---------------------|[]||
-- |;;|                     |;;||
-- |;;|    NEOVIM  CONFIG   |;;||
-- |;;|                     |;;||
-- |;;|                     |;;||
-- |;;|                     |;;||
-- |;;|                     |;;||
-- |;;|_____________________|;;||
-- |;;;;;;;;;;;;;;;;;;;;;;;;;;;||
-- |;;;;;;_______________ ;;;;;||
-- |;;;;;|  ___          |;;;;;||
-- |;;;;;| |;;;|         |;;;;;||
-- |;;;;;| |;;;|         |;;;;;||
-- |;;;;;| |;;;|         |;;;;;||
-- |;;;;;| |;;;|         |;;;;;||
-- |;;;;;| |___|         |;;;;;||
-- \_____|_______________|_____||
--  ~~~~~^^^^^^^^^^^^^^^^^~~~~~~~

-- 0. Expternal files
require("lsp") -- All LSP setup code, setup is done and available after this

-- 1. Options
-----------------------------------------------------------------------------------------------
vim.g.mapleader = " "           -- Leader
vim.g.maplocalleader = " "      -- Local leader key (idk i just do it)
vim.g.copilot_no_tab_map = true -- Dont use the tab key for copilot suggestions
-- vim.o.number = true -- show line numbers
-- vim.o.relativenumber = true -- relativve line numbers
vim.o.mouse = "a" -- Enable mouse mode, can be useful for resizing splits for example!
vim.o.showmode = true -- Don't show the mode, since it's already in status line
vim.o.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.
vim.o.wrap = false -- Don't wrap text
vim.o.breakindent = true -- Keep indentation of a line when it wraps, looks nicer
vim.o.swapfile = false -- no swapfile, ew
vim.o.backup = false -- no backup, ew
vim.o.undodir = vim.fn.stdpath("data") .. "/undo" -- location of undofile
vim.o.undofile = true -- keep an undo file to shae history
vim.o.ignorecase = true -- Case-insensitive searching
vim.o.smartcase = true -- UNLESS \C or capital in search
vim.o.signcolumn = "yes" -- Keep signcolumn on by default
vim.o.updatetime = 250 -- Decrease update time, swap every 250 chars
vim.o.timeoutlen = 300 -- Time when the help popup will appear
vim.o.splitright = true -- Configure how new splits should be opened
vim.o.splitbelow = true -- Same
vim.o.list = true -- Sets how neovim will display certain whitespace in the editor.
vim.opt.listchars = { tab = "  ", trail = "·", nbsp = "␣", multispace = "·", lead = "·" } -- See above
vim.o.inccommand = "split" -- Preview substitutions live, as you type!
vim.o.cursorline = false -- Show which line your cursor is on
vim.o.scrolloff = 16 -- Minimal number of screen lines to keep above and below the cursor.
vim.o.tabstop = 2 -- Tab size
vim.o.shiftwidth = 2 -- Same
vim.o.expandtab = false -- Don't expand tabs into spaces
vim.o.et = false -- Same
vim.o.fen = false -- Disable folding, we don't need it
-- vim.o.textwidth = 100 -- Visible line at the right side
vim.o.hlsearch = true -- Set highlight on search,
vim.o.wildmode = "noselect:lastused,full"
vim.o.wildoptions = "pum"
vim.cmd.normal(":set guicursor=")                                       -- Reset the cursor on tmux BUG: doesn't work
vim.cmd.normal(":autocmd OptionSet guicursor noautocmd set guicursor=") -- Same

-- 2. Plugins
-- -----------------------------------------------------------------------------------------------
-- -> Other lsp-related functions and plugins in lsp config
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- Syntax highlighting
	{ src = "https://github.com/vague2k/vague.nvim" },             -- Theme
})

-- Mini: small tools for everyday use
require("plugins.mini")

-- 3. Looks
-- ----------------------------------------------------------------------------------------------
vim.cmd("colorscheme vague")         -- Sets the volorscheme
vim.cmd(":hi statusline guibg=NONE") -- No background on the status line
vim.cmd(":hi WinSeparator guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE")
vim.cmd(":hi VertSplit guifg=NONE guibg=NONE ctermfg=NONE ctermbg=NONE")
vim.opt.fillchars:append({ vert = " " })
vim.o.winborder = "single"

-- 4. Autocommands
-- -----------------------------------------------------------------------------------------------
-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- show wildmenu when we type in the cmd line
vim.api.nvim_create_autocmd({ "CmdlineChanged" }, {
	pattern = ":*",
	callback = function()
		vim.fn.wildtrigger()
	end,
})

-- autocommand to see diagnostic message when hovering over error
vim.api.nvim_create_autocmd({ "CursorHold" }, {
	pattern = "*",
	callback = function()
		for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
			if vim.api.nvim_win_get_config(winid).zindex then
				return
			end
		end
		vim.diagnostic.open_float({
			scope = "cursor",
			focusable = false,
			close_events = {
				"CursorMoved",
				"CursorMovedI",
				"BufHidden",
				"InsertCharPre",
				"WinLeave",
			},
		})
	end,
})

-- 5. Keymaps
-- -----------------------------------------------------------------------------------------------
-- Plugin independent keybinds
-- Behavior of j, k in wrapped lines, so they stay navigable whemn wrapped:
vim.keymap.set({ "n", "v" }, "j", "gj", { noremap = true, silent = true, desc = "Move down" })
vim.keymap.set({ "n", "v" }, "k", "gk", { noremap = true, silent = true, desc = "Move up" })
--  Always paste what was yanked, not what was deleted:
vim.keymap.set({ "n", "v" }, ",p", '"0p', { noremap = true, silent = true, desc = "Paste yanked" })
vim.keymap.set({ "n", "v" }, ",P", '"0P', { noremap = true, silent = true, desc = "Paste yanked" })
-- Delete and paste w/o yanking
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { noremap = true, desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"_dP', { noremap = true, desc = "Paste without yanking" })
-- Do not deselect selected area when using > or < do in/dedent text
vim.keymap.set("v", "<", "<gv", { noremap = true, silent = true })
vim.keymap.set("v", ">", ">gv", { noremap = true, silent = true })
-- Allow moving selected text horizontally in visual mode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
--Clear highlight on pressing <Esc> in normal mode:
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
-- Vertically jump around half a page and always center the cursor
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- Vertically jump around to the next/prev search result and always center the cursor
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')
--  Use CTRL+<hjkl> to switch between windows
vim.keymap.set({ "n", "i", "v" }, "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window", silent = true })
vim.keymap.set({ "n", "i", "v" }, "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window", silent = true })
vim.keymap.set({ "n", "i", "v" }, "<C-j>", "<C-w><C-j>", { desc = "Move focus to the window below", silent = true })
vim.keymap.set({ "n", "i", "v" }, "<C-k>", "<C-w><C-k>", { desc = "Move focus to the window up", silent = true })
-- Some tab creation and managemnent keybinds, seldomly used
vim.keymap.set("n", "gT", "<cmd>tabprevious<CR>", { desc = "[G]oto previous [T]ab" })
vim.keymap.set("n", "gt", "<cmd>tabnext<CR>", { desc = "[G]oto to next [t]ab" })
vim.keymap.set("n", "<S-Tab>", "<cmd>tabprevious<CR>", { desc = "[G]oto previous [T]ab" })
vim.keymap.set("n", "<Tab>", "<cmd>tabnext<CR>", { desc = "[G]oto next [T]ab" })
vim.keymap.set("n", "<Leader>t", "<cmd>tabnew<CR>", { remap = true, desc = "Open a new tab" })
vim.keymap.set("n", "<Leader><S-Tab>", "<cmd>tabprevious<CR>", { desc = "[G]oto previous [T]ab" })
vim.keymap.set("n", "<Leader><Tab>", "<cmd>tabnext<CR>", { desc = "[G]oto next [T]ab" })
-- Enable or disable line numbers
vim.keymap.set({ "n", "v" }, "<Leader>l", function()
	vim.wo.number = not vim.wo.number
end, { desc = "Toggle [L]ine numbers" })
-- Search with a hitlist in all open files
vim.keymap.set("n", "<leader>/", function()
	local pattern = vim.fn.input("Search: ")
	vim.cmd("vimgrep /" .. pattern .. "/g ##")
	vim.cmd("copen")
end)

-- Plugin dependendent keybinds
-- -> Other lsp-related functions and keybinds in lsp config
-- Pickers
vim.keymap.set({ "n", "v" }, "<Leader>sf", function()
	local in_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
	in_git_repo = vim.v.shell_error == 0

	if in_git_repo then
		MiniPick.builtin.files({ tool = "git" })
	else
		MiniPick.builtin.files()
	end
end, { desc = "[S]earch [F]iles" })
vim.keymap.set({ "n", "v" }, "<Leader><Leader>", "<cmd>:Pick buffers<CR>", { desc = "Pick Buffers" })
vim.keymap.set({ "n", "v" }, "<Leader>sg", "<cmd>:Pick grep_live<CR>", { desc = "[S]earch [G]rep" })

-- Buffer removal
vim.keymap.set({ "n", "v" }, "<Leader>q", function()
	MiniBufremove.unshow()
end, { desc = "[Q]uit Buffer" })

require("notes").setup()
