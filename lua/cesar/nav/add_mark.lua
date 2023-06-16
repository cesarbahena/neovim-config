local harpoon = require("harpoon")
local mark = require("harpoon.mark")
local utils = require("harpoon.utils")
local log = require("harpoon.dev").log

local callbacks = {}

local function emit_changed()
	local t = 0
	log.trace("_emit_changed()")

	local global_settings = harpoon.get_global_settings()

	if global_settings.save_on_change then
		harpoon.save()
	end

	if global_settings.tabline then
		vim.cmd("redrawt")
	end

	if not callbacks["changed"] then
		log.trace("_emit_changed(): no callbacks for 'changed', returning")
		return
	end

	for idx, cb in pairs(callbacks["changed"]) do
		log.trace(string.format("_emit_changed(): Running callback #%d for 'changed'", idx))
		cb()
	end
end

local function get_buf_name(id)
	log.trace("_get_buf_name():", id)
	if id == nil then
		return utils.normalize_path(vim.api.nvim_buf_get_name(0))
	elseif type(id) == "string" then
		return utils.normalize_path(id)
	end

	local idx = mark.get_index_of(id)
	if mark.valid_index(idx) then
		return mark.get_marked_file_name(idx)
	end
	return ""
end

local function create_mark(filename)
	local cursor_pos = vim.api.nvim_win_get_cursor(0)
	log.trace(
		string.format(
			"_create_mark(): Creating mark at row: %d, col: %d for %s",
			cursor_pos[1],
			cursor_pos[2],
			filename
		)
	)
	return {
		filename = filename,
		row = cursor_pos[1],
		col = cursor_pos[2],
	}
end

local function validate_buf_name(buf_name)
	log.trace("_validate_buf_name():", buf_name)
	if buf_name == "" or buf_name == nil then
		log.error("_validate_buf_name(): Not a valid name for a mark,", buf_name)
		error("Couldn't find a valid file name to mark, sorry.")
		return
	end
end

local function filter_filetype()
	local current_filetype = vim.bo.filetype
	local excluded_filetypes = harpoon.get_global_settings().excluded_filetypes

	if current_filetype == "harpoon" then
		log.error("filter_filetype(): You can't add harpoon to the harpoon")
		error("You can't add harpoon to the harpoon")
		return
	end

	if vim.tbl_contains(excluded_filetypes, current_filetype) then
		log.error('filter_filetype(): This filetype cannot be added or is included in the "excluded_filetypes" option')
		error('This filetype cannot be added or is included in the "excluded_filetypes" option')
		return
	end
end

local function get_first_empty_slot()
	log.trace("_get_first_empty_slot()")
	for idx = 1, mark.get_length() do
		local filename = mark.get_marked_file_name(idx)
		if filename == "" or filename == "(empty)" then
			return idx
		end
	end

	return mark.get_length() + 1
end

local function remove_empty_tail()
	log.trace("remove_empty_tail()")
	local config = harpoon.get_mark_config()
	local found = false

	for i = mark.get_length(), 1, -1 do
		local filename = mark.get_marked_file_name(i)
		if filename ~= "" then
			return
		end

		if filename == "" or filename == "(empty)" then
			table.remove(config.marks, i)
			found = found
		end
	end
end

local function add_file_at_pos(position)
	pcall(function()
		filter_filetype()
		local buf_name = get_buf_name()
		log.trace("add_file():", buf_name)

		if mark.valid_index(mark.get_index_of(buf_name)) then
			return
		end

		validate_buf_name(buf_name)

		local marks = harpoon.get_mark_config().marks

		if not position then -- Assing an empty slot
			local found_idx = get_first_empty_slot()
			marks[found_idx] = create_mark(buf_name)
			remove_empty_tail()
			emit_changed()
			return
		end

		-- If position is ocupied, keep the mark info
		local move, to_move = false, {}
		if marks[position] and marks[position].filename ~= "(empty)" then
			to_move = marks[position]
			move = true
		end

		-- Assin the desired file to the given position
		marks[position] = create_mark(buf_name)

		-- Move the previous mark to an empty slot
		if move then
			local empty_slot = get_first_empty_slot()
			marks[empty_slot] = to_move
			vim.notify(
				string.format(
					"%s assigned to mark %d.\n%s moved to mark %d.",
					marks[position].filename,
					position,
					marks[empty_slot].filename,
					empty_slot
				),
				"info",
				{ title = "Harpoon" }
			)
		end

		-- Corrections before save
		for i = 1, position, 1 do
			if not marks[i] then
				marks[i] = {}
			end
		end
		remove_empty_tail()
		emit_changed()
	end)
end

function L()
	local marks = harpoon.get_mark_config().marks
	vim.notify(vim.inspect(marks))
end

return add_file_at_pos
