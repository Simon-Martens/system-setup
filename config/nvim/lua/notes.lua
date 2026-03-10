local M = {}

local NOTES_TAB_VAR = "notes_workspace"
local redirecting = false

M.config = {
	root = vim.fs.normalize(vim.fn.expand("~/notes")),
}

local function get_notes_root()
	return vim.fs.normalize(vim.fn.expand(M.config.root))
end

local function find_notes_tab()
	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		local ok, is_notes_tab = pcall(vim.api.nvim_tabpage_get_var, tabpage, NOTES_TAB_VAR)
		if ok and is_notes_tab then
			return tabpage
		end
	end
end

local function is_notes_tab(tabpage)
	local ok, is_notes_workspace = pcall(vim.api.nvim_tabpage_get_var, tabpage or 0, NOTES_TAB_VAR)
	return ok and is_notes_workspace
end

local function ensure_notes_root()
	local root = get_notes_root()
	if vim.fn.isdirectory(root) == 0 then
		vim.notify("Notes root does not exist: " .. root, vim.log.levels.ERROR)
		return nil
	end

	return root
end

local function notes_root_exists()
	return vim.fn.isdirectory(get_notes_root()) == 1
end

local function normalize_path(path)
	if path == nil or path == "" then
		return nil
	end

	return vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))
end

local function is_file_buffer(bufnr)
	return vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buftype == "" and vim.api.nvim_buf_get_name(bufnr) ~= ""
end

local function is_notes_path(path)
	local root = ensure_notes_root()
	local normalized = normalize_path(path)
	if root == nil or normalized == nil then
		return false
	end

	return normalized == root or vim.startswith(normalized, root .. "/")
end

local function is_notes_buffer(bufnr)
	return is_file_buffer(bufnr) and is_notes_path(vim.api.nvim_buf_get_name(bufnr))
end

local function mark_current_tab_as_notes(root)
	vim.api.nvim_tabpage_set_var(0, NOTES_TAB_VAR, true)
	vim.cmd.tcd(root)
end

local function focus_notes_tab()
	local tabpage = find_notes_tab()
	if tabpage ~= nil then
		vim.api.nvim_set_current_tabpage(tabpage)
	end

	return tabpage
end

local function has_snacks()
	return pcall(require, "snacks")
end

local function is_snacks_window(winid)
	if not vim.api.nvim_win_is_valid(winid) then
		return false
	end

	local bufnr = vim.api.nvim_win_get_buf(winid)
	return vim.w[winid].snacks_layout == true or vim.bo[bufnr].filetype:find("^snacks") ~= nil
end

local function apply_notes_window_options(tabpage)
	for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage or 0)) do
		if not is_snacks_window(winid) then
			vim.wo[winid].wrap = true
			vim.wo[winid].linebreak = true
			vim.wo[winid].breakindent = true
		end
	end
end

local function apply_notes_explorer_keymaps(tabpage)
	for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage or 0)) do
		if is_snacks_window(winid) then
			local bufnr = vim.api.nvim_win_get_buf(winid)
			vim.keymap.set("n", "<Esc>", function()
				focus_main_notes_window()
			end, {
				buffer = bufnr,
				silent = true,
				desc = "Return to notes text window",
			})
		end
	end
end

local function get_main_notes_window(tabpage)
	for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage or 0)) do
		local bufnr = vim.api.nvim_win_get_buf(winid)
		if not is_snacks_window(winid) and vim.bo[bufnr].buftype == "" then
			return winid
		end
	end
end

local function focus_main_notes_window()
	local winid = get_main_notes_window(0)
	if winid ~= nil then
		vim.api.nvim_set_current_win(winid)
		return true
	end

	return false
end

function M.focus_text_window()
	return focus_main_notes_window()
end

local function get_notes_explorer()
	local ok, snacks = pcall(require, "snacks")
	if not ok then
		return nil
	end

	return snacks.picker.get({ source = "explorer" })[1]
end

local function focus_notes_explorer()
	local explorer = get_notes_explorer()
	if explorer ~= nil then
		explorer:focus("input", { show = true })
		return true
	end

	return false
end

local function focus_notes_explorer_later()
	vim.schedule(function()
		if is_notes_tab(0) then
			focus_notes_explorer()
		end
	end)
end

local function open_path_in_current_tab(path)
	vim.cmd.edit(vim.fn.fnameescape(path))
end

local function ensure_default_note_buffer(root)
	local winid = get_main_notes_window(0)
	if winid ~= nil then
		vim.api.nvim_set_current_win(winid)
		local bufnr = vim.api.nvim_win_get_buf(winid)
		if is_notes_buffer(bufnr) then
			return
		end
	end

	local default_note = root .. "/note.md"
	if vim.fn.filereadable(default_note) == 1 then
		open_path_in_current_tab(default_note)
		return
	end

	vim.cmd.enew()
end

local function open_notes_explorer(root)
	local ok, snacks = pcall(require, "snacks")
	if not ok then
		return false
	end

	local explorer = get_notes_explorer()
	local opened_now = false
	if explorer == nil then
		explorer = snacks.explorer({
			cwd = root,
			follow_file = true,
			layout = {
				layout = { position = "right" },
			},
		})
		opened_now = true
	end

	if explorer == nil or explorer.closed then
		return false
	end

	if explorer:cwd() ~= root then
		explorer:set_cwd(root)
		explorer:find()
	end

	local main_win = get_main_notes_window(0)
	local main_buf = main_win and vim.api.nvim_win_get_buf(main_win) or nil
	if not opened_now and main_buf ~= nil and is_notes_buffer(main_buf) then
		pcall(function()
			snacks.explorer.reveal({ buf = main_buf })
		end)
	end

	return true
end

local function ensure_notes_tab()
	local root = ensure_notes_root()
	if root == nil then
		return nil
	end

	local tabpage = focus_notes_tab()
	if tabpage == nil then
		vim.cmd.tabnew()
		tabpage = vim.api.nvim_get_current_tabpage()
	end

	mark_current_tab_as_notes(root)
	return tabpage
end

local function choose_in_notes_tab(item)
	if item == nil then
		return
	end

	if ensure_notes_tab() == nil then
		return
	end

	MiniPick.set_picker_target_window(vim.api.nvim_get_current_win())
	MiniPick.default_choose(item)
end

local function ensure_notes_layout(opts)
	local root = ensure_notes_root()
	if root == nil then
		return nil
	end

	if ensure_notes_tab() == nil then
		return nil
	end

	ensure_default_note_buffer(root)
	open_notes_explorer(root)
	apply_notes_window_options(0)
	apply_notes_explorer_keymaps(0)

	if opts ~= nil and opts.focus_explorer then
		focus_notes_explorer_later()
	elseif opts ~= nil and opts.focus_main then
		vim.schedule(function()
			if is_notes_tab(0) then
				focus_main_notes_window()
			end
		end)
	end

	return root
end

local function replace_current_window_buffer()
	local alternate = vim.fn.bufnr("#")
	if alternate > 0 and vim.api.nvim_buf_is_valid(alternate) and not is_notes_buffer(alternate) then
		vim.cmd.buffer(alternate)
		return
	end

	vim.cmd.enew()
end

local function ensure_regular_tab()
	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		if not is_notes_tab(tabpage) then
			vim.api.nvim_set_current_tabpage(tabpage)
			return
		end
	end

	vim.cmd.tabnew()
end

local function enforce_buffer_isolation(args)
	if redirecting then
		return
	end

	local bufnr = args.buf
	if not is_file_buffer(bufnr) then
		return
	end

	local path = normalize_path(vim.api.nvim_buf_get_name(bufnr))
	if path == nil then
		return
	end

	local current_tab = vim.api.nvim_get_current_tabpage()
	local in_notes_tab = is_notes_tab(current_tab)
	local note_buffer = is_notes_path(path)

	if note_buffer and not in_notes_tab then
		redirecting = true
		replace_current_window_buffer()
		ensure_notes_tab()
		open_path_in_current_tab(path)
		redirecting = false
		return
	end

	if in_notes_tab and not note_buffer then
		redirecting = true
		replace_current_window_buffer()
		ensure_regular_tab()
		open_path_in_current_tab(path)
		redirecting = false
	end
end

local function tab_label(tabpage)
	if is_notes_tab(tabpage) then
		return "notes"
	end

	local win = vim.api.nvim_tabpage_get_win(tabpage)
	local buf = vim.api.nvim_win_get_buf(win)
	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" then
		return "[No Name]"
	end

	return vim.fn.fnamemodify(name, ":t")
end

function M.tabline()
	local parts = {}
	for index, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		local hl = tabpage == vim.api.nvim_get_current_tabpage() and "%#TabLineSel#" or "%#TabLine#"
		table.insert(parts, string.format("%%%dT", index))
		table.insert(parts, hl)
		table.insert(parts, " " .. tab_label(tabpage) .. " ")
	end

	table.insert(parts, "%#TabLineFill#%T")
	return table.concat(parts)
end

local function filtered_buffer_items()
	local items = {}
	local in_notes_tab = is_notes_tab(vim.api.nvim_get_current_tabpage())

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
			local path = normalize_path(vim.api.nvim_buf_get_name(bufnr))
			if path ~= nil then
				local is_note = is_notes_path(path)
				if is_note == in_notes_tab then
					table.insert(items, {
						bufnr = bufnr,
						text = vim.fn.fnamemodify(path, ":~:."),
						path = path,
					})
				end
			end
		end
	end

	table.sort(items, function(a, b)
		return a.text < b.text
	end)

	return items
end

function M.pick_buffers()
	local show = MiniPick.config.source.show or MiniPick.default_show
	local source_name = is_notes_tab(vim.api.nvim_get_current_tabpage()) and "Notes Buffers" or "Buffers"

	MiniPick.start({
		source = {
			name = source_name,
			items = filtered_buffer_items(),
			show = show,
		},
	})
end

function M.pick_files()
	local root = ensure_notes_root()
	if root == nil then
		return
	end

	if has_snacks() then
		ensure_notes_layout({ focus_explorer = true })
		return
	end

	MiniPick.builtin.files(nil, { source = { cwd = root, choose = choose_in_notes_tab } })
end

function M.grep()
	local root = ensure_notes_root()
	if root == nil then
		return
	end

	MiniPick.builtin.grep_live(nil, {
		source = {
			cwd = root,
			choose = choose_in_notes_tab,
		},
	})
end

function M.open_workspace()
	ensure_notes_layout({ focus_explorer = true })
end

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	if not notes_root_exists() then
		return
	end

	vim.o.showtabline = 2
	vim.o.tabline = "%!v:lua.require'notes'.tabline()"

	local group = vim.api.nvim_create_augroup("notes-workspace", { clear = true })
	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		callback = function(args)
			enforce_buffer_isolation(args)
		end,
	})
	vim.api.nvim_create_autocmd("TabEnter", {
		group = group,
		callback = function()
			if is_notes_tab(0) and has_snacks() then
				vim.schedule(function()
					ensure_notes_layout()
				end)
			end
		end,
	})
	vim.api.nvim_create_autocmd("WinEnter", {
		group = group,
		callback = function()
			if not is_notes_tab(0) or not has_snacks() then
				return
			end

			local current_win = vim.api.nvim_get_current_win()
			if is_snacks_window(current_win) then
				focus_notes_explorer_later()
			end
		end,
	})

	vim.api.nvim_create_user_command("Notes", function()
		M.open_workspace()
	end, { desc = "Open the notes workspace" })

	vim.api.nvim_create_user_command("NotesFiles", function()
		M.pick_files()
	end, { desc = "Pick files from the notes workspace" })

	vim.api.nvim_create_user_command("NotesGrep", function()
		M.grep()
	end, { desc = "Live grep inside the notes workspace" })

	vim.api.nvim_create_user_command("NotesBuffers", function()
		M.pick_buffers()
	end, { desc = "Pick buffers for the current workspace" })

	vim.keymap.set("n", "<Leader>o", function()
		M.open_workspace()
	end, { desc = "[O]pen notes workspace" })
	vim.keymap.set({ "n", "v" }, "<Leader><Leader>", function()
		M.pick_buffers()
	end, { desc = "Pick Buffers" })
	vim.keymap.set({ "n", "v" }, "<Leader>sn", function()
		M.pick_files()
	end, { desc = "[S]earch [N]otes files" })
	vim.keymap.set({ "n", "v" }, "<Leader>sN", function()
		M.grep()
	end, { desc = "[S]earch [N]otes grep" })
end

return M
