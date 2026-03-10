vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})

local ok, snacks = pcall(require, "snacks")
if not ok then
	return
end

snacks.setup({
	explorer = { enabled = true },
	picker = {
		enabled = true,
		sources = {
			explorer = {
				icons = {
					files = {
						enabled = false,
					},
				},
				win = {
					input = {
						keys = {
							["<Esc>"] = {
								function()
									require("notes").focus_text_window()
								end,
								mode = "n",
								desc = "Return to notes text window",
							},
						},
					},
					list = {
						keys = {
							["<Esc>"] = {
								function()
									require("notes").focus_text_window()
								end,
								mode = "n",
								desc = "Return to notes text window",
							},
						},
					},
					preview = {
						keys = {
							["<Esc>"] = {
								function()
									require("notes").focus_text_window()
								end,
								mode = "n",
								desc = "Return to notes text window",
							},
						},
					},
				},
				layout = {
					layout = { position = "right" },
				},
			},
		},
	},
})
