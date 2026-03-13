-- NVIM LSP SETUP
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" }, -- Format files
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- Prepackaged LSP configurations
	{ src = "https://github.com/mason-org/mason.nvim" }, -- Install language servers
	{ src = "https://github.com/Saghen/blink.cmp" }, -- Completion engine
})

-- Plugin config
-- ------------------------------------------------------------------------------------
local has_words_before = function()
	local col = vim.api.nvim_win_get_cursor(0)[2]
	if col == 0 then
		return false
	end

	local line = vim.api.nvim_get_current_line()
	return line:sub(col, col):match("%s") == nil
end

require("blink.cmp").setup({
	keymap = {
		preset = "default",
		["<C-y>"] = false,
		["<Tab>"] = false,
		["<S-Tab>"] = false,
		["<C-Tab>"] = {
			function(cmp)
				if cmp.is_visible() then
					return cmp.select_next({ auto_insert = true })
				end

				if has_words_before() then
					return cmp.show_and_insert()
				end
			end,
			"fallback",
		},
		["<C-S-Tab>"] = {
			function(cmp)
				if cmp.is_visible() then
					return cmp.select_prev({ auto_insert = true })
				end
			end,
			"fallback",
		},
	},
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = false },
		list = {
			selection = {
				preselect = false,
				auto_insert = true,
			},
		},
		menu = {
			draw = {
				columns = {
					{ "label", "label_description", gap = 1 },
				},
			},
		},
	},
	sources = {
		default = { "lsp", "path", "buffer" },
	},
	-- Avoid the Rust/curl dependency path for the fuzzy matcher.
	fuzzy = { implementation = "lua" },
})

local servers = { "lua_ls", "tinymist", "rust_analyzer", "gopls", "zls" }
local capabilities = require("blink.cmp").get_lsp_capabilities()

for _, server in ipairs(servers) do
	vim.lsp.config(server, {
		capabilities = capabilities,
	})
end

vim.lsp.enable(servers)
require("mason").setup()

-- Conform config
require("conform").setup({
	format_on_save = function(bufnr)
		-- INFO: we can disable auto format for certain filetypes
		local disable_filetypes = { c = true, cpp = true, xml = true }
		if disable_filetypes[vim.bo[bufnr].filetype] then
			return nil
		else
			return {
				timeout_ms = 500,
				lsp_format = "fallback",
			}
		end
	end,
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports", "gofumpt" },
		gohtmltmpl = { "prettierd", "prettier", stop_after_first = true },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		css = { "prettierd", "prettier", stop_after_first = true },
	},
	notify_on_error = false,
})

-- Keybinds
-- ------------------------------------------------------------------------------------
-- Format document
vim.keymap.set({ "n", "v" }, "<Leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat file" })
