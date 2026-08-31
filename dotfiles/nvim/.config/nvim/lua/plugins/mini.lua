vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" }, -- Some mini-plugins for commonly needed things
})

-- Plugin configuration
-- Enable mini functions
-- require("mini.pick").setup() -- File Search, Picker, Buffer Picker
-- require("mini.extra").setup() -- Extra pickers, including LSP symbols
require("mini.surround").setup() -- [s]urround [a]dd [r]eplace or [d]elete
require("mini.ai").setup({ n_lines = 500 }) -- better around/inside visual selections
-- require('mini.indentscope').setup() -- Shows the scope of an indentation
-- require('mini.pairs').setup() -- If wanted mini auto-pairing
-- require('mini.tabline').setup() -- If wanted mini tabline
-- require('mini.visits.).setup() -- TODO: this shound interesting
-- require("mini.cursorword").setup() -- all occurances of the current word are highlighhted
require("mini.jump").setup() -- f and t works across lines
require("mini.git").setup() -- Git integration
require("mini.bracketed").setup() -- go forward anmd backeards with []

local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		{ mode = { "n", "x" }, keys = "<Leader>" }, -- Leader triggers
		{ mode = "n", keys = "[" }, -- `[` and `]` keys to go forward and back
		{ mode = "n", keys = "]" },
		{ mode = "i", keys = "<C-x>" }, -- Built-in completion
		{ mode = { "n", "x" }, keys = "g" }, -- 'g' key
		{ mode = { "n", "x" }, keys = "'" }, -- Marks
		{ mode = { "n", "x" }, keys = "`" },
		{ mode = { "n", "x" }, keys = '"' }, -- Registers
		{ mode = { "i", "c" }, keys = "<C-r>" },
		{ mode = "n", keys = "<C-w>" }, -- Window commands
		-- { mode = { 'n', 'x' }, keys = 'z' }, -- z Key (folds, Depreracted)
	},
	clues = {
		miniclue.gen_clues.square_brackets(),
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.g(),
		miniclue.gen_clues.marks(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
	},
})

-- Deprecated Mini Statusbar:
-- local statusline = require 'mini.statusline'
-- statusline.setup { use_icons = vim.g.have_nerd_font }
--
-- -- You can configure sections in the statusline by overriding their
-- -- default behavior. For example, here we set the section for
-- -- cursor location to LINE:COLUMN
-- ---@diagnostic disable-next-line: duplicate-set-field
-- statusline.section_location = function()
-- 	return '%2l:%-2v'
-- end

local hipatterns = require("mini.hipatterns") -- Highlight standalone BUG, TODO, NOTE, HACK
hipatterns.setup({
	highlighters = {
		bug = { pattern = "%f[%w]()BUG:()", group = "MiniHipatternsFixme" },
		hack = { pattern = "%f[%w]()HACK:()", group = "MiniHipatternsHack" },
		todo = { pattern = "%f[%w]()TODO:()", group = "MiniHipatternsTodo" },
		note = { pattern = "%f[%w]()NOTE:()", group = "MiniHipatternsNote" },
	},

	hex_color = hipatterns.gen_highlighter.hex_color(), -- Highlight hex color strings (`#rrggbb`) using that color
})


-- vim.keymap.set({ "n", "v" }, "<Leader>sf", function()
-- 	local in_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null")
-- 	in_git_repo = vim.v.shell_error == 0
--
-- 	if in_git_repo then
-- 		MiniPick.builtin.files({ tool = "git" })
-- 	else
-- 		MiniPick.builtin.files()
-- 	end
-- end, { desc = "[S]earch [F]iles" })
-- vim.keymap.set({ "n", "v" }, "<Leader><Leader>", "<cmd>:Pick buffers<CR>", { desc = "Pick Buffers" })
-- vim.keymap.set({ "n", "v" }, "<Leader>sg", "<cmd>:Pick grep_live<CR>", { desc = "[S]earch [G]rep" })


local bufremove = require("mini.bufremove")
bufremove.setup()
vim.keymap.set({ "n", "v" }, "<leader>q", function()
	bufremove.delete(0, false)
end, { desc = "[Q]uit buffer" })
vim.keymap.set({ "n", "v" }, "<leader>Q", function()
	bufremove.delete(0, true)
end, { desc = "Force [Q]uit buffer" })
