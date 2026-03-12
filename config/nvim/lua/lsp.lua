-- NVIM LSP SETUP
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" }, -- Format files
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- Prepackaged LSP configurations
	{ src = "https://github.com/mason-org/mason.nvim" }, -- Install language servers
	{ src = "https://github.com/Saghen/blink.cmp" }, -- Completion engine
})

-- Plugin config
-- ------------------------------------------------------------------------------------
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	completion = {
		documentation = { auto_show = false },
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
