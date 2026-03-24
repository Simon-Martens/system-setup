-- NVIM LSP SETUP
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },         -- Format files
	{ src = "https://github.com/neovim/nvim-lspconfig" },         -- Prepackaged LSP configurations
	{ src = "https://github.com/mason-org/mason.nvim" },          -- Install language servers
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" }, -- Mason LSPConfig -- auitop configues the LSP to start appropriate language servers
	{ src = "https://github.com/Saghen/blink.cmp" },              -- Completion engine
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
		["<Tab>"] = {
			function(cmp)
				if cmp.is_visible() then
					return cmp.select_next({ auto_insert = true })
				end

				if has_words_before() then
					return cmp.show_and_insert_or_accept_single()
				end
			end,
			"snippet_forward",
			"fallback",
		},
		["<S-Tab>"] = {
			function(cmp)
				if cmp.is_visible() then
					return cmp.select_prev({ auto_insert = true })
				end
			end,
			"snippet_backward",
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

local capabilities = require("blink.cmp").get_lsp_capabilities()

local servers = {
	lua_ls = {},
	tinymist = {},
	gopls = {},
	zls = {},
	rust_analyzer = {
		settings = {
			["rust-analyzer"] = {
				completion = {
					autoimport = { enable = true },
				},
				imports = {
					granularity = { group = "module" },
					prefix = "self",
				},
			},
		},
	},
}

for name, config in pairs(servers) do
	vim.lsp.config(name, vim.tbl_deep_extend("force", {
		capabilities = capabilities,
	}, config))
end

require("mason").setup()

require("mason-lspconfig").setup({
	ensure_installed = vim.tbl_keys(servers),
	automatic_enable = true,
})
--
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

local lsp_picker = function(scope, method)
	return function()
		local clients = vim.lsp.get_clients({ bufnr = 0, method = method })
		if vim.tbl_isempty(clients) then
			vim.notify("No LSP client with " .. scope .. " support for this buffer", vim.log.levels.WARN)
			return
		end

		MiniExtra.pickers.lsp({ scope = scope })
	end
end

-- Keybinds
-- ------------------------------------------------------------------------------------
-- Format document
vim.keymap.set({ "n", "v" }, "<Leader>f", function()
	require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "[F]ormat file" })

vim.keymap.set("n", "<Leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ction" })
vim.keymap.set(
	"n",
	"<Leader>ss",
	lsp_picker("document_symbol", vim.lsp.protocol.Methods.textDocument_documentSymbol),
	{ desc = "[S]earch document [S]ymbols" }
)
vim.keymap.set(
	"n",
	"<Leader>sS",
	lsp_picker("workspace_symbol_live", vim.lsp.protocol.Methods.workspace_symbol),
	{ desc = "[S]earch workspace [S]ymbols" }
)
