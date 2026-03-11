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

local function apply_notes_window_options(tabpage)
	for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage or 0)) do
		vim.wo[winid].wrap = true
		vim.wo[winid].linebreak = true
		vim.wo[winid].breakindent = true
	end
end

local function get_main_notes_window(tabpage)
	for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabpage or 0)) do
		local bufnr = vim.api.nvim_win_get_buf(winid)
		if vim.bo[bufnr].buftype == "" then
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

local function open_path_in_current_tab(path)
	vim.cmd.edit(vim.fn.fnameescape(path))
end

local function get_journal_dir(root)
	return root .. "/journal"
end

local function current_journal_path(root)
	return string.format("%s/%s.md", get_journal_dir(root), os.date("%Y-%d-%m"))
end

local function latest_journal_path(root)
	local journal_dir = get_journal_dir(root)
	if vim.fn.isdirectory(journal_dir) == 0 then
		return nil
	end

	local latest_path, latest_mtime = nil, nil
	local handle = vim.uv.fs_scandir(journal_dir)
	if handle == nil then
		return nil
	end

	while true do
		local name, entry_type = vim.uv.fs_scandir_next(handle)
		if name == nil then
			break
		end

		if entry_type == "file" and name:match("%.md$") then
			local path = journal_dir .. "/" .. name
			local stat = vim.uv.fs_stat(path)
			local mtime = stat and stat.mtime and stat.mtime.sec or 0
			if latest_mtime == nil or mtime > latest_mtime then
				latest_path = path
				latest_mtime = mtime
			end
		end
	end

	return latest_path
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
	apply_notes_window_options(0)

	if opts ~= nil and opts.focus_main then
		vim.schedule(function()
			if is_notes_tab(0) then
				focus_main_notes_window()
			end
		end)
	end

	return root
end

local function open_note_in_workspace(path)
	if ensure_notes_layout({ focus_main = true }) == nil then
		return
	end

	open_path_in_current_tab(path)
	apply_notes_window_options(0)
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
	ensure_notes_layout({ focus_main = true })
end

function M.open_journal()
	local root = ensure_notes_root()
	if root == nil then
		return
	end

	local path = latest_journal_path(root)
	if path == nil then
		vim.notify("No journal entries found in " .. get_journal_dir(root), vim.log.levels.INFO)
		return
	end

	open_note_in_workspace(path)
end

function M.new_journal_entry()
	local root = ensure_notes_root()
	if root == nil then
		return
	end

	local journal_dir = get_journal_dir(root)
	vim.fn.mkdir(journal_dir, "p")
	local path = current_journal_path(root)
	if vim.fn.filereadable(path) == 0 then
		vim.fn.writefile({}, path)
	end
	open_note_in_workspace(path)
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
			if is_notes_tab(0) then
				vim.schedule(function()
					ensure_notes_layout()
				end)
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
	vim.api.nvim_create_user_command("Journal", function(opts)
		if opts.args == "new" then
			M.new_journal_entry()
			return
		end

		M.open_journal()
	end, {
		desc = "Open the latest journal entry or create today's entry",
		nargs = "?",
		complete = function()
			return { "new" }
		end,
	})

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
