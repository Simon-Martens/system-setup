-- NVIM LSP SETUP
-- Currently, no completion engine is used; sth like blink can be installed if needed
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" }, -- Format files
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- Prepackaged LSP configurations
	{ src = "https://github.com/mason-org/mason.nvim" }, -- Install language servers
})

-- Plugin config
-- ------------------------------------------------------------------------------------
vim.lsp.enable({ "lua_ls", "tinymist", "rust_analyzer", "gopls" })
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

-- Autocommands
-- ------------------------------------------------------------------------------------
-- autocomplete
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})
vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect" }

-- Keybinds
-- ------------------------------------------------------------------------------------
-- Format document
vim.keymap.set({ "n", "v" }, "<Leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat file" })
