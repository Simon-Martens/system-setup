local M = {}

local defaults = {
	keymap = "<Leader>r",
	sidebar_prefix = "<Leader>b",
	wide_threshold = 120,
	vertical_width = 60,
	horizontal_height = 10,
	resize_debounce = 80,
}

local config = vim.deepcopy(defaults)
local register_buffer
local last_notes_buffer
local sidebar_window_ids = {}
local window_orientations = {}
local sidebar_origin_windows = {}
local previous_buffers = {}
local markdown_route_suspended = false
local resize_generation = 0
local refresh_scheduled = false
local current_view = "registers"
local namespace = vim.api.nvim_create_namespace("register-scrapbook")

local registers = {
	{ '"', "unnamed" },
	{ "0", "last yank" },
	{ "1", "last delete" },
	{ "2", "delete history" },
	{ "3", "delete history" },
	{ "4", "delete history" },
	{ "5", "delete history" },
	{ "6", "delete history" },
	{ "7", "delete history" },
	{ "8", "delete history" },
	{ "9", "delete history" },
	{ "-", "small delete" },
}

for character = string.byte("a"), string.byte("z") do
	table.insert(registers, { string.char(character), "named" })
end

vim.list_extend(registers, {
	{ "+", "system clipboard" },
	{ "*", "selection clipboard" },
	{ ":", "last command" },
	{ ".", "last inserted text" },
	{ "%", "current file" },
	{ "#", "alternate file" },
	{ "/", "last search" },
	{ "=", "expression" },
	{ "~", "last dropped text" },
	{ "_", "black hole" },
})

local function is_valid_buffer()
	return register_buffer and vim.api.nvim_buf_is_valid(register_buffer)
end

local function scrapbook_windows()
	return vim.tbl_filter(function(window)
		return sidebar_window_ids[window] == true and vim.api.nvim_win_is_valid(window)
	end, vim.api.nvim_tabpage_list_wins(0))
end

local function is_sidebar_window(window)
	return sidebar_window_ids[window] == true and vim.api.nvim_win_is_valid(window)
end

local function is_normal_window(window)
	return window ~= nil
		and vim.api.nvim_win_is_valid(window)
		and not is_sidebar_window(window)
		and vim.api.nvim_win_get_config(window).relative == ""
end

local function remember_editor_window(window)
	if not is_normal_window(window) then
		return
	end

	local tabpage = vim.api.nvim_win_get_tabpage(window)
	for sidebar in pairs(sidebar_window_ids) do
		if is_sidebar_window(sidebar) and vim.api.nvim_win_get_tabpage(sidebar) == tabpage then
			sidebar_origin_windows[sidebar] = window
		end
	end
end

local function editor_window_for(sidebar)
	local origin = sidebar_origin_windows[sidebar]
	if is_normal_window(origin) and vim.api.nvim_win_get_tabpage(origin) == vim.api.nvim_win_get_tabpage(sidebar) then
		return origin
	end

	for _, window in ipairs(vim.api.nvim_tabpage_list_wins(vim.api.nvim_win_get_tabpage(sidebar))) do
		if is_normal_window(window) then
			sidebar_origin_windows[sidebar] = window
			return window
		end
	end
end

local function printable_contents(name)
	local ok, contents = pcall(vim.fn.getreg, name, 1, false)
	if not ok or contents == "" then
		return "·", true
	end

	contents = contents:gsub("\r", "\\r")
	contents = contents:gsub("\n", " ↵ ")
	contents = contents:gsub("\t", "⇥ ")
	return contents, false
end

local function table_width()
	local windows = scrapbook_windows()
	if windows[1] and vim.api.nvim_win_is_valid(windows[1]) then
		return vim.api.nvim_win_get_width(windows[1])
	end

	if vim.o.columns > config.wide_threshold then
		return math.min(config.vertical_width, vim.o.columns - 20)
	end
	return vim.o.columns
end

local function pad_cell(text, width)
	return text .. string.rep(" ", math.max(0, width - vim.fn.strdisplaywidth(text)))
end

local function rule(width)
	return string.rep("─", width)
end

local function register_row(register, content, widths)
	return pad_cell(register, widths.register) .. pad_cell(content, widths.content)
end

local function register_lines(available_width)
	local widths = {
		register = 4,
		content = math.max(10, available_width - 4),
	}
	local lines = {
		rule(available_width),
		register_row("REG", "CONTENT", widths),
		rule(available_width),
	}
	local highlights = {
		{ line = 0, group = "Comment", start = 0, finish = -1 },
		{ line = 1, group = "Title", start = 0, finish = -1 },
		{ line = 2, group = "Comment", start = 0, finish = -1 },
	}

	for _, item in ipairs(registers) do
		local name = item[1]
		-- local kind = item[2] -- Kept in the register metadata for when the KIND column is wanted again.
		local contents, empty = printable_contents(name)
		if not empty then
			table.insert(lines, register_row(name, contents, widths))
			table.insert(highlights, {
				line = #lines - 1,
				group = "Identifier",
				start = 0,
				finish = #name,
			})
		end
	end

	table.insert(lines, rule(available_width))
	table.insert(highlights, { line = #lines - 1, group = "Comment", start = 0, finish = -1 })
	return lines, highlights
end

local function mark_filename(mark)
	local position = mark.pos or {}
	local bufnr = position[1] or 0
	local filename = mark.file or ""

	if filename == "" and bufnr > 0 and vim.api.nvim_buf_is_valid(bufnr) then
		filename = vim.api.nvim_buf_get_name(bufnr)
	end
	if filename == "" then
		return "[No Name]"
	end
	return vim.fs.normalize(vim.fn.fnamemodify(filename, ":p"))
end

local function mark_location(mark)
	local position = mark.pos or {}
	local bufnr = position[1] or 0
	local line = position[2] or 0
	local column = position[3] or 0
	local filename = mark_filename(mark)

	local preview = ""
	if line > 0 and bufnr > 0 and vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
		preview = vim.api.nvim_buf_get_lines(bufnr, line - 1, line, false)[1] or ""
	elseif line > 0 and filename ~= "[No Name]" and vim.fn.filereadable(filename) == 1 then
		preview = vim.fn.readfile(filename, "", line)[line] or ""
	end

	preview = vim.trim(preview):gsub("\r", "\\r"):gsub("\t", "⇥ ")
	return filename, line, column, preview
end

local function named_marks()
	local marks = {}

	for _, mark in ipairs(vim.fn.getmarklist()) do
		if mark.mark and mark.mark:match("^'[A-Z]$") and mark.pos and (mark.pos[2] or 0) > 0 then
			table.insert(marks, mark)
		end
	end

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if bufnr ~= register_buffer and vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
			for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
				if mark.mark and mark.mark:match("^'[a-z]$") and mark.pos and (mark.pos[2] or 0) > 0 then
					table.insert(marks, mark)
				end
			end
		end
	end

	table.sort(marks, function(left, right)
		local left_name, right_name = left.mark:sub(2), right.mark:sub(2)
		if left_name ~= right_name then
			return left_name < right_name
		end
		local left_file = mark_filename(left)
		local right_file = mark_filename(right)
		return left_file < right_file
	end)
	return marks
end

local function path_suffix(path, depth)
	local parts = vim.split(path, "/", { plain = true, trimempty = true })
	return table.concat(parts, "/", math.max(1, #parts - depth + 1), #parts)
end

local function add_unique_filenames(rows)
	local groups = {}
	for _, row in ipairs(rows) do
		local basename = row.filename:match("([^/]+)$") or row.filename
		groups[basename] = groups[basename] or {}
		groups[basename][row.filename] = true
		row.filename_label = basename
	end

	for _, row in ipairs(rows) do
		local paths = groups[row.filename_label]
		if vim.tbl_count(paths) > 1 then
			local parts = vim.split(row.filename, "/", { plain = true, trimempty = true })
			for depth = 2, #parts do
				local candidate = path_suffix(row.filename, depth)
				local unique = true
				for other in pairs(paths) do
					if other ~= row.filename and path_suffix(other, depth) == candidate then
						unique = false
						break
					end
				end
				if unique then
					row.filename_label = candidate
					break
				end
			end
		end
	end
end

local function mark_lines(available_width)
	local marks = named_marks()
	local rows = {}

	for _, mark in ipairs(marks) do
		local filename, line, column, preview = mark_location(mark)
		table.insert(rows, {
			name = mark.mark:sub(2),
			filename = filename,
			line = line,
			column = column,
			preview = preview,
		})
	end
	add_unique_filenames(rows)

	local widths = {
		mark = 5,
		location = 10,
	}
	for _, item in ipairs(rows) do
		item.location = string.format("%s:%d,%d", item.filename_label, item.line, item.column)
		widths.location = math.max(widths.location, vim.fn.strdisplaywidth(item.location) + 2)
	end

	local fixed_width = widths.mark + widths.location
	local preview_width = math.max(10, available_width - fixed_width)
	local function row(mark, location, preview)
		return pad_cell(mark, widths.mark)
			.. pad_cell(location, widths.location)
			.. pad_cell(preview, preview_width)
	end

	local lines = {
		rule(available_width),
		row("MARK", "LOCATION", "PREVIEW"),
		rule(available_width),
	}
	local highlights = {
		{ line = 0, group = "Comment", start = 0, finish = -1 },
		{ line = 1, group = "Title", start = 0, finish = -1 },
		{ line = 2, group = "Comment", start = 0, finish = -1 },
	}

	for _, item in ipairs(rows) do
		local mark_cell = pad_cell(item.name, widths.mark)
		local location_cell = pad_cell(item.location, widths.location)
		table.insert(lines, mark_cell .. location_cell .. item.preview)
		local line_number = #lines - 1
		table.insert(highlights, { line = line_number, group = "Identifier", start = 0, finish = #item.name })
		table.insert(highlights, {
			line = line_number,
			group = "Directory",
			start = #mark_cell,
			finish = #mark_cell + #item.filename_label,
		})
		table.insert(highlights, {
			line = line_number,
			group = "Number",
			start = #mark_cell + #item.filename_label + 1,
			finish = #mark_cell + #item.location,
		})
	end

	if #rows == 0 then
		table.insert(lines, pad_cell("No named marks", available_width))
		table.insert(highlights, { line = #lines - 1, group = "Comment", start = 0, finish = -1 })
	end

	table.insert(lines, rule(available_width))
	table.insert(highlights, { line = #lines - 1, group = "Comment", start = 0, finish = -1 })
	return lines, highlights
end

local function update_winbars()
	local tabs = {
		{ view = "registers", label = "Registers" },
		{ view = "marks", label = "Marks" },
		{ view = "notes", label = "Notes" },
	}
	local sections = {}
	for _, tab in ipairs(tabs) do
		local highlight = tab.view == current_view and "TabLineSel" or "TabLine"
		table.insert(sections, ("%%#%s# %s "):format(highlight, tab.label))
	end
	local winbar = table.concat(sections, "%#WinBar#│") .. "%#WinBar#"

	for window in pairs(sidebar_window_ids) do
		if is_sidebar_window(window) then
			vim.wo[window].winbar = winbar
		else
			sidebar_window_ids[window] = nil
			window_orientations[window] = nil
		end
	end
end

function M.refresh()
	if current_view == "notes" then
		update_winbars()
		return
	end
	if not is_valid_buffer() then
		return
	end

	local available_width = table_width()
	local lines, highlights
	if current_view == "marks" then
		lines, highlights = mark_lines(available_width)
	else
		lines, highlights = register_lines(available_width)
	end

	vim.bo[register_buffer].readonly = false
	vim.bo[register_buffer].modifiable = true
	vim.api.nvim_buf_set_lines(register_buffer, 0, -1, false, lines)
	vim.bo[register_buffer].modifiable = false
	vim.bo[register_buffer].modified = false
	vim.bo[register_buffer].readonly = true

	vim.api.nvim_buf_clear_namespace(register_buffer, namespace, 0, -1)
	for _, highlight in ipairs(highlights) do
		vim.api.nvim_buf_add_highlight(register_buffer, namespace, highlight.group, highlight.line, highlight.start, highlight.finish)
	end

	update_winbars()
end

local function schedule_refresh()
	if refresh_scheduled then
		return
	end

	refresh_scheduled = true
	vim.schedule(function()
		refresh_scheduled = false
		M.refresh()
	end)
end

local function ensure_buffer()
	if is_valid_buffer() then
		return register_buffer
	end

	register_buffer = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_name(register_buffer, "register-scrapbook://registers")
	vim.bo[register_buffer].buftype = "nofile"
	vim.bo[register_buffer].bufhidden = "hide"
	vim.bo[register_buffer].swapfile = false
	vim.bo[register_buffer].undolevels = -1
	vim.bo[register_buffer].filetype = "register-scrapbook"
	vim.bo[register_buffer].modifiable = false
	vim.bo[register_buffer].readonly = true
	vim.keymap.set("n", "<Tab>", function()
		M.cycle_view()
	end, {
		buffer = register_buffer,
		desc = "Cycle register scrapbook view",
		silent = true,
	})
	vim.keymap.set("n", "<S-Tab>", function()
		M.cycle_view(true)
	end, {
		buffer = register_buffer,
		desc = "Cycle register scrapbook view backwards",
		silent = true,
	})
	for character = string.byte("a"), string.byte("z") do
		for _, mark in ipairs({ string.char(character), string.char(character):upper() }) do
			vim.keymap.set("n", "'" .. mark, function()
				M.jump_to_mark(mark, false)
			end, {
				buffer = register_buffer,
				desc = "Jump to mark " .. mark .. " in the editing window",
				silent = true,
			})
			vim.keymap.set("n", "`" .. mark, function()
				M.jump_to_mark(mark, true)
			end, {
				buffer = register_buffer,
				desc = "Jump exactly to mark " .. mark .. " in the editing window",
				silent = true,
			})
		end
	end

	M.refresh()
	return register_buffer
end

local function project_root(bufnr)
	local filename = bufnr and vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_name(bufnr) or ""
	local start = filename ~= "" and vim.fs.dirname(filename) or vim.fn.getcwd()
	return vim.fs.root(start, { ".git" }) or vim.fn.getcwd()
end

function M.find_markdown_files()
	local root = project_root(vim.api.nvim_get_current_buf())
	require("telescope.builtin").find_files({
		cwd = root,
		prompt_title = "Markdown files",
		find_command = {
			"rg",
			"--files",
			"--hidden",
			"--glob",
			"*.md",
			"--glob",
			"*.markdown",
			"--glob",
			"!.git/**",
		},
	})
end

local function configure_notes_buffer(bufnr)
	vim.bo[bufnr].bufhidden = "hide"
	if vim.bo[bufnr].filetype == "" then
		vim.bo[bufnr].filetype = "markdown"
	end
	if vim.b[bufnr].register_scrapbook_notes_mapped then
		return
	end

	vim.b[bufnr].register_scrapbook_notes_mapped = true
	vim.keymap.set("n", "<Tab>", function()
		M.cycle_view()
	end, {
		buffer = bufnr,
		desc = "Cycle register scrapbook view",
		silent = true,
	})
	vim.keymap.set("n", "<S-Tab>", function()
		M.cycle_view(true)
	end, {
		buffer = bufnr,
		desc = "Cycle register scrapbook view backwards",
		silent = true,
	})
	vim.keymap.set("n", "<Leader>sf", M.find_markdown_files, {
		buffer = bufnr,
		desc = "[S]earch project Markdown [F]iles",
		silent = true,
	})
end

local function ensure_notes_buffer(context_bufnr)
	if last_notes_buffer and vim.api.nvim_buf_is_valid(last_notes_buffer) then
		configure_notes_buffer(last_notes_buffer)
		return last_notes_buffer
	end

	local path = project_root(context_bufnr) .. "/scrapbook.md"
	last_notes_buffer = vim.fn.bufadd(path)
	vim.fn.bufload(last_notes_buffer)
	configure_notes_buffer(last_notes_buffer)
	return last_notes_buffer
end

local function hide_end_of_buffer_markers(window)
	vim.api.nvim_win_call(window, function()
		vim.opt_local.fillchars:append({ eob = " " })
	end)
end

local function configure_window(window, vertical)
	vim.wo[window].number = false
	vim.wo[window].relativenumber = false
	vim.wo[window].signcolumn = "no"
	vim.wo[window].foldcolumn = "0"
	vim.wo[window].list = false
	vim.wo[window].cursorline = false
	vim.wo[window].winfixwidth = vertical
	vim.wo[window].winfixheight = not vertical
	hide_end_of_buffer_markers(window)

	if vertical then
		vim.api.nvim_win_set_width(window, math.max(1, math.min(config.vertical_width, vim.o.columns - 20)))
	else
		vim.api.nvim_win_set_height(window, math.max(1, math.min(config.horizontal_height, vim.o.lines - 6)))
	end
end

local function display_view(window, context_bufnr, notes_bufnr)
	vim.wo[window].winfixbuf = false
	if current_view == "notes" then
		local target = notes_bufnr or ensure_notes_buffer(context_bufnr)
		last_notes_buffer = target
		configure_notes_buffer(target)
		markdown_route_suspended = true
		local ok, error_message = pcall(vim.api.nvim_win_set_buf, window, target)
		markdown_route_suspended = false
		if not ok then
			error(error_message)
		end
		vim.wo[window].wrap = true
		vim.wo[window].linebreak = true
	else
		vim.api.nvim_win_set_buf(window, ensure_buffer())
		vim.wo[window].wrap = false
		vim.wo[window].linebreak = false
		vim.wo[window].winfixbuf = true
		M.refresh()
	end
	hide_end_of_buffer_markers(window)
	update_winbars()
end

function M.reflow()
	local vertical = vim.o.columns > config.wide_threshold

	for _, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		for _, window in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
			if is_sidebar_window(window) then
				if window_orientations[window] ~= vertical then
					vim.wo[window].winfixwidth = false
					vim.wo[window].winfixheight = false
					local moved = pcall(vim.api.nvim_win_call, window, function()
						vim.cmd(vertical and "wincmd L" or "wincmd J")
					end)
					if moved then
						window_orientations[window] = vertical
					end
				end

				configure_window(window, window_orientations[window] == true)
			end
		end
	end
	M.refresh()
end

function M.close()
	for _, window in ipairs(scrapbook_windows()) do
		local closed = pcall(vim.api.nvim_win_close, window, false)
		if closed then
			sidebar_window_ids[window] = nil
			window_orientations[window] = nil
			sidebar_origin_windows[window] = nil
		end
	end
end

function M.jump_to_mark(mark, exact)
	local sidebar = vim.api.nvim_get_current_win()
	local editor = is_sidebar_window(sidebar) and editor_window_for(sidebar) or nil
	if not editor then
		vim.notify("No editing window is available for the mark jump", vim.log.levels.WARN)
		return
	end

	vim.api.nvim_set_current_win(editor)
	local ok, error_message = pcall(vim.cmd, "normal! " .. (exact and "`" or "'") .. mark)
	if not ok then
		if vim.api.nvim_win_is_valid(sidebar) then
			vim.api.nvim_set_current_win(sidebar)
		end
		vim.notify(error_message, vim.log.levels.WARN)
	end
end

function M.open(notes_bufnr, origin_window)
	local existing = scrapbook_windows()
	if #existing > 0 then
		if origin_window and is_normal_window(origin_window) then
			sidebar_origin_windows[existing[1]] = origin_window
		elseif is_normal_window(vim.api.nvim_get_current_win()) then
			sidebar_origin_windows[existing[1]] = vim.api.nvim_get_current_win()
		end
		display_view(existing[1], vim.api.nvim_get_current_buf(), notes_bufnr)
		return existing[1]
	end

	local origin = origin_window and vim.api.nvim_win_is_valid(origin_window) and origin_window or vim.api.nvim_get_current_win()
	local context_bufnr = vim.api.nvim_win_get_buf(origin)
	local vertical = vim.o.columns > config.wide_threshold
	local window

	vim.api.nvim_win_call(origin, function()
		vim.cmd(vertical and "rightbelow vsplit" or "rightbelow split")
		window = vim.api.nvim_get_current_win()
	end)

	sidebar_window_ids[window] = true
	window_orientations[window] = vertical
	sidebar_origin_windows[window] = origin
	configure_window(window, vertical)
	display_view(window, context_bufnr, notes_bufnr)
	if vim.api.nvim_win_is_valid(origin) then
		vim.api.nvim_set_current_win(origin)
	end
	return window
end

function M.toggle()
	if #scrapbook_windows() > 0 then
		M.close()
	else
		M.open()
	end
end

local function reset_view_position()
	for window in pairs(sidebar_window_ids) do
		if is_sidebar_window(window) then
			vim.api.nvim_win_call(window, function()
				vim.cmd("normal! gg0")
			end)
		end
	end
end

function M.toggle_view(view)
	local is_open = #scrapbook_windows() > 0
	if is_open and current_view == view then
		M.close()
		return
	end

	current_view = view
	if is_open then
		display_view(scrapbook_windows()[1], vim.api.nvim_get_current_buf())
		reset_view_position()
	else
		M.open()
	end
end

function M.show_view(view)
	current_view = view
	local window
	if #scrapbook_windows() > 0 then
		window = scrapbook_windows()[1]
		display_view(window, vim.api.nvim_get_current_buf())
		reset_view_position()
	else
		window = M.open()
	end
	if view == "notes" and window and vim.api.nvim_win_is_valid(window) then
		vim.api.nvim_set_current_win(window)
	end
end

function M.cycle_view(backwards)
	local next_view = backwards
		and { registers = "notes", notes = "marks", marks = "registers" }
		or { registers = "marks", marks = "notes", notes = "registers" }
	current_view = next_view[current_view]
	local windows = scrapbook_windows()
	if #windows > 0 then
		display_view(windows[1], vim.api.nvim_get_current_buf())
	end
	reset_view_position()
end

local function is_markdown_buffer(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
		return false
	end
	local filename = vim.api.nvim_buf_get_name(bufnr):lower()
	return filename:match("%.md$") ~= nil or filename:match("%.markdown$") ~= nil
end

local function replacement_buffer(window, markdown_bufnr)
	local previous = previous_buffers[window]
	if previous and previous ~= markdown_bufnr and vim.api.nvim_buf_is_valid(previous) and not is_markdown_buffer(previous) then
		return previous
	end

	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if bufnr ~= markdown_bufnr
			and bufnr ~= register_buffer
			and vim.api.nvim_buf_is_valid(bufnr)
			and vim.api.nvim_buf_is_loaded(bufnr)
			and vim.bo[bufnr].buflisted
			and not is_markdown_buffer(bufnr)
		then
			return bufnr
		end
	end

	return vim.api.nvim_create_buf(true, false)
end

local function route_markdown(bufnr, source_window)
	vim.schedule(function()
		if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_win_is_valid(source_window) then
			return
		end
		if vim.api.nvim_win_get_buf(source_window) ~= bufnr then
			return
		end

		current_view = "notes"
		if is_sidebar_window(source_window) then
			last_notes_buffer = bufnr
			configure_notes_buffer(bufnr)
			vim.wo[source_window].winfixbuf = false
			vim.wo[source_window].wrap = true
			vim.wo[source_window].linebreak = true
			hide_end_of_buffer_markers(source_window)
			update_winbars()
			return
		end

		local sidebar = M.open(bufnr, source_window)
		if vim.api.nvim_win_is_valid(source_window) and vim.api.nvim_win_get_buf(source_window) == bufnr then
			vim.api.nvim_win_set_buf(source_window, replacement_buffer(source_window, bufnr))
		end
		if sidebar and vim.api.nvim_win_is_valid(sidebar) then
			vim.api.nvim_set_current_win(sidebar)
		end
	end)
end

function M.setup(options)
	config = vim.tbl_deep_extend("force", defaults, options or {})

	vim.api.nvim_create_user_command("RegistersToggle", function()
		M.toggle_view("registers")
	end, {
		desc = "Toggle the register scrapbook",
	})
	vim.api.nvim_create_user_command("MarksToggle", function()
		M.toggle_view("marks")
	end, {
		desc = "Toggle the marks scrapbook",
	})
	vim.api.nvim_create_user_command("SidebarClose", M.close, {
		desc = "Close the register/marks sidebar",
	})
	vim.api.nvim_create_user_command("NotesOpen", function()
		M.show_view("notes")
	end, {
		desc = "Open the Markdown notes sidebar",
	})
	vim.api.nvim_create_user_command("RegistersRefresh", M.refresh, {
		desc = "Refresh the register scrapbook",
	})

	vim.keymap.set("n", config.keymap, function()
		M.show_view("registers")
	end, {
		desc = "Open [R]egister scrapbook",
		silent = true,
	})
	vim.keymap.set("n", config.sidebar_prefix .. "r", function()
		M.show_view("registers")
	end, {
		desc = "[B]oard: [R]egisters",
		silent = true,
	})
	vim.keymap.set("n", config.sidebar_prefix .. "m", function()
		M.show_view("marks")
	end, {
		desc = "[B]oard: [M]arks",
		silent = true,
	})
	vim.keymap.set("n", config.sidebar_prefix .. "n", function()
		M.show_view("notes")
	end, {
		desc = "[B]oard: [N]otes",
		silent = true,
	})
	vim.keymap.set("n", config.sidebar_prefix .. "c", M.close, {
		desc = "[B]oard: [C]lose",
		silent = true,
	})

	local group = vim.api.nvim_create_augroup("register-scrapbook", { clear = true })
	vim.api.nvim_create_autocmd("BufLeave", {
		group = group,
		callback = function(event)
			local window = vim.api.nvim_get_current_win()
			if not is_sidebar_window(window) then
				previous_buffers[window] = event.buf
			end
		end,
	})
	vim.api.nvim_create_autocmd("BufWinEnter", {
		group = group,
		pattern = { "*.md", "*.markdown", "*.MD", "*.MARKDOWN" },
		callback = function(event)
			if markdown_route_suspended or not is_markdown_buffer(event.buf) then
				return
			end
			local window = vim.api.nvim_get_current_win()
			if vim.api.nvim_win_get_config(window).relative ~= "" then
				return
			end
			route_markdown(event.buf, window)
		end,
	})
	vim.api.nvim_create_autocmd("WinClosed", {
		group = group,
		callback = function(event)
			local window = tonumber(event.match)
			if window then
				sidebar_window_ids[window] = nil
				window_orientations[window] = nil
				sidebar_origin_windows[window] = nil
				previous_buffers[window] = nil
			end
		end,
	})
	vim.api.nvim_create_autocmd("WinEnter", {
		group = group,
		callback = function()
			remember_editor_window(vim.api.nvim_get_current_win())
		end,
	})
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = group,
		callback = function()
			if current_view == "registers" then
				schedule_refresh()
			end
		end,
	})
	vim.api.nvim_create_autocmd("MarkSet", {
		group = group,
		callback = function()
			if current_view == "marks" then
				schedule_refresh()
			end
		end,
	})
	vim.api.nvim_create_autocmd("FocusGained", {
		group = group,
		callback = M.refresh,
	})
	vim.api.nvim_create_autocmd("BufEnter", {
		group = group,
		callback = function(event)
			if event.buf == register_buffer then
				M.refresh()
			end
		end,
	})
	vim.api.nvim_create_autocmd("VimResized", {
		group = group,
		callback = function()
			resize_generation = resize_generation + 1
			local generation = resize_generation
			vim.defer_fn(function()
				if generation == resize_generation then
					M.reflow()
				end
			end, config.resize_debounce)
		end,
	})
end

return M
