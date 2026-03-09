vim.pack.add({
	{ src = "https://github.com/echasnovski/mini.nvim" }, -- Some mini-plugins for commonly needed things
})

-- Plugin configuration
-- Enable mini functions
require("mini.pick").setup() -- File Search, Picker, Buffer Picker
require("mini.surround").setup() -- [s]urround [a]dd [r]eplace or [d]elete
-- require("mini.ai").setup({ n_lines = 500 }) -- better around/inside visual selections
-- require('mini.indentscope').setup() -- Shows the scope of an indentation
-- require('mini.pairs').setup() -- If wanted mini auto-pairing
-- require('mini.tabline').setup() -- If wanted mini tabline
-- require('mini.visits.).setup() -- TODO: this shound interesting
-- require("mini.cursorword").setup() -- all occurances of the current word are highlighhted
require("mini.jump").setup() -- f and t works across lines
require("mini.git").setup() -- Git integration
require("mini.bracketed").setup() -- go forward anmd backeards with []
require("mini.bufremove").setup() -- remove buffers

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
