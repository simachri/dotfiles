local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
-- local dl = require("luasnip.extras").dynamic_lambda

local function current_date()
	return os.date("%Y-%m-%d")
end

local function get_filename_without_leading_date()
	local filename = vim.fn.expand("%:t:r")
	return filename:gsub("^%d%d%d%d%-%d%d%-%d%d[-_ ]*", ""):gsub("[-_]", " ")
end

local function splitPath(path)
	local elems = {}
	-- vim.api.nvim_echo({{path, "WarningMsg"}}, true, {}) -- default {history = true}
	-- Add a trailing / to make the gmatch work.
	for elem in (path .. "/"):gmatch("([^/]*)/") do
		-- vim.api.nvim_echo({{elem, "WarningMsg"}}, true, {}) -- default {history = true}
		table.insert(elems, elem)
	end
	return elems
end

local function get_weekday_date(day_of_week)
	local date = os.date("*t")
	local current_day = date.wday - 1 -- Lua's os.date("%w") returns 1 for Sunday, 2 for Monday, etc.
	local offset = day_of_week - current_day
	if offset < 0 then
		offset = offset + 7
	end
	return os.date("%d.%m.%Y", os.time(date) + offset * 24 * 60 * 60)
end

local function print_monday()
	return get_weekday_date(1)
end

local function print_tuesday()
	return get_weekday_date(2)
end

local function print_wednesday()
	return get_weekday_date(3)
end

local function print_friday()
	return get_weekday_date(4)
end

local function print_week_number_and_year()
	local week = os.date("%W") + 1 -- is off by one in 2025 for some reason
	local formatted_week_number = string.format("%02d", week)
	local full_month_name = os.date("%B")
	local year = os.date("%Y")
	return formatted_week_number .. ", " .. full_month_name .. " " .. year
end

local function extract_jira_issue_id()
	return vim.api.nvim_eval("@+"):match(".*/browse/([A-Z]+%-%d+)")
end

ls.add_snippets("markdown", {
	s("Meeting Notes", {
		t({
			"---",
			"location: virtual",
			"tags: [meeting]",
			"---",
			"# ",
		}),
		f(current_date, {}),
		t(" "),
		f(get_filename_without_leading_date, {}),
		i(0, ""),
		-- dl(1, get_filename_without_leading_date, {}),
		t({
			"",
			"",
			"## Previous Meeting",
			"",
			"## Agenda",
			"",
			"## Attendees",
			"",
			"## Notes",
			"",
			"## Relations",
			"",
			"## References",
			"",
			"## Actions",
			"",
		}),
	}),

	s("Issue", {
		t({
			"---",
			"priority: default",
			"status: open",
			"created: ",
		}),
		f(current_date, {}),
		t({
			"",
			"tags: [issue]",
			"---",
			"# ",
		}),
		f(get_filename_without_leading_date, {}),
		i(0, ""),
		t({
			"",
			"",
			"## Request",
			"",
			"## Notes",
			"",
			"## Solution",
			"",
			"## Relations",
			"",
			"## References",
			"",
		}),
	}),

	s("Design", {
		t({
			"---",
			"status: open",
			"tags: [design, ",
		}),
		i(1, "tags"),
		t({ "]", "---", "# " }),
		f(get_filename_without_leading_date, {}),
		i(0, ""),
		t({
			"",
			"",
			"## Design",
			"",
			"## Relations",
			"",
			"## References",
			"",
		}),
	}),

	s("Solution", {
		t({
			"---",
			"status: resolved",
			"tags: [solution, ",
		}),
		i(1, "tags"),
		t({ "]", "---", "# " }),
		f(get_filename_without_leading_date, {}),
		i(0, ""),
		t({
			"",
			"",
			"## Solution",
			"",
			"## Relations",
			"",
			"## References",
			"",
		}),
	}),

	s({ trig = "ref", name = "Insert Markdown Wiki Link" }, {
		t({ "[[" }),
		f(function()
			return { vim.api.nvim_eval("@+") }
		end, {}),
		t({ "|" }),
		i(0, "link name"),
		t({ "]]" }),
	}),

	-- s({ trig = "ref", name = "Insert Markdown Wiki Link" }, {
	-- 	t({ "[[" }),
	-- 	f(function()
	-- 		return { vim.api.nvim_eval("@x") }
	-- 	end, {}),
	-- 	t({ "|" }),
	-- 	i(0, "link name"),
	-- 	t({ "]]" }),
	-- }),

	-- Old 'ref' snippet for reference.
	-- s({ trig = "ref", name = "Insert Markdown Wiki Link" }, {
	-- 	t({ "[" }),
	-- 	-- Placeholder with initial text.
	-- 	i(1, { "<link name>" }),
	-- 	t({ "](" }),
	-- 	f(function()
	-- 		local destPath = vim.api.nvim_eval("@x")
	-- 		local currFileParentDirPath = vim.api.nvim_eval("expand('%:.:h')")
	-- 		local anchor = vim.api.nvim_eval("@y")
	-- 		local function starts_with(entireStr, startStr)
	-- 			return entireStr:sub(1, #startStr) == startStr
	-- 		end
	-- 		-- Example:
	-- 		-- destPath = SAP/ECTR/Documents/Solutions
	-- 		-- currFileParentDirPath = SAP/ECTR/CAD/Cloning/API
	-- 		-- Result: ../../CAD/Cloning/API
	--
	-- 		--vim.api.nvim_echo({{destPath, "WarningMsg"}}, true, {}) -- default {history = true}
	-- 		--vim.api.nvim_echo({{currFileParentDirPath, "WarningMsg"}}, true, {}) -- default {history = true}
	--
	-- 		-- Remove any leading './'
	-- 		if starts_with(destPath, "./") then
	-- 			destPath = string.sub(destPath, 3, #destPath)
	-- 		end
	-- 		if starts_with(currFileParentDirPath, "./") then
	-- 			currFileParentDirPath = string.sub(currFileParentDirPath, 3, #currFileParentDirPath)
	-- 		end
	--
	-- 		-- Split the paths into their directories.
	-- 		local destPathElems = splitPath(destPath)
	-- 		local currFilePathElems = splitPath(currFileParentDirPath)
	-- 		-- vim.api.nvim_echo({{vim.inspect(destPathElems), "WarningMsg"}}, true, {}) -- default {history = true}
	-- 		-- vim.api.nvim_echo({{vim.inspect(currFilePathElems), "WarningMsg"}}, true, {}) -- default {history = true}
	--
	-- 		-- Identify the first elements of the path that are identical.
	-- 		local branchIdx = 0
	-- 		for idx, val in ipairs(destPathElems) do
	-- 			-- vim.api.nvim_echo({{val, "WarningMsg"}}, true, {}) -- default {history = true}
	-- 			-- vim.api.nvim_echo({{currFilePathElems[idx], "WarningMsg"}}, true, {}) -- default {history = true}
	-- 			if val == currFilePathElems[idx] then
	-- 				branchIdx = branchIdx + 1
	-- 				-- vim.api.nvim_echo({{"branchIdx is "..branchIdx, "WarningMsg"}}, true, {}) -- default {history = true}
	-- 			else
	-- 				-- vim.api.nvim_echo({{"breaking", "WarningMsg"}}, true, {}) -- default {history = true}
	-- 				break
	-- 			end
	-- 		end
	-- 		-- vim.api.nvim_echo({{"branchIdx is "..branchIdx, "WarningMsg"}}, true, {}) -- default {history = true}
	--
	-- 		-- When there are no identical elements, set the branchIdx to 1.
	-- 		-- Fix: Don't do this as it will break cases when there is no
	-- 		-- common root branch.
	-- 		-- if branchIdx == 0 then branchIdx = 1 end
	--
	-- 		--vim.api.nvim_echo({{"branchIdx is "..branchIdx, "WarningMsg"}}, true, {}) -- default {history = true}
	-- 		--vim.api.nvim_echo({{"Length of currFilePathElems is "..#currFilePathElems, "WarningMsg"}}, true, {}) -- default {history = true}
	-- 		--vim.api.nvim_echo({{"Length of destPathElems is "..#destPathElems, "WarningMsg"}}, true, {}) -- default {history = true}
	--
	-- 		-- For each directory level above the current file
	-- 		-- add ../ to the result path.
	-- 		local result = ""
	-- 		local relPath = ""
	-- 		-- If the destination anchor is in the current file, no
	-- 		-- paths need to be adjusted. That is, only do something if the
	-- 		-- destination anchor is in a different file (strip the file
	-- 		-- extension!).
	-- 		if destPath ~= vim.api.nvim_eval("expand('%:.:r')") then
	-- 			for _ = branchIdx + 1, #currFilePathElems do
	-- 				--vim.api.nvim_echo({{"currIdx is "..currIdx, "WarningMsg"}}, true, {}) -- default {history = true}
	-- 				relPath = relPath .. "../"
	-- 			end
	-- 			-- Add each directory level of the destination file.
	-- 			for destIdx = branchIdx + 1, #destPathElems do
	-- 				--vim.api.nvim_echo({{"destIdx is "..destIdx, "WarningMsg"}}, true, {}) -- default {history = true}
	-- 				relPath = relPath .. destPathElems[destIdx] .. "/"
	-- 			end
	-- 			-- Remove the trailing slash.
	-- 			if relPath:sub(-1) == "/" then
	-- 				relPath = relPath:sub(1, -2)
	-- 			end
	-- 		end
	-- 		-- Add the anchor.
	-- 		result = relPath .. "#" .. anchor
	-- 		return { result }
	-- 	end, {}),
	--
	-- 	-- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
	-- 	i(0),
	-- 	t({ ")" }),
	-- }),

	-- URL to a Jira issue in the format [<Jira Issue ID> <Name>](<URL>)
	s({ trig = "jira", name = "Jira URL" }, {
		t({ "[" }),
		f(extract_jira_issue_id, {}),
		t({ " " }),
		i(1, { "<Name>" }),
		t({ "](" }),
		f(function()
			return { vim.api.nvim_eval("@+") }
		end, {}),

		-- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
		i(0),
		t({ ")" }),
	}),

	s("Footnote", {
		t({
			"[^fn-1",
		}),
		i(0),
		t({
			"]",
		}),
	}),

	s("Weekly Note", {
		t({
			"# Week ",
		}),
		f(print_week_number_and_year, {}),
		t({
			"",
			"",
			"## Monday, ",
		}),
		f(print_monday, {}),
		t({
			"",
			"",
			"- [ ] Vemas",
			"",
		}),
		i(0),
		t({
			"",
			"## Tuesday, ",
		}),
		f(print_tuesday, {}),
		t({
			"",
			"",
			"- [ ] Vemas",
			"",
			"## Wednesday, ",
		}),
		f(print_wednesday, {}),
		t({
			"",
			"",
			"- [ ] Vemas",
			"",
			"## Friday, ",
		}),
		f(print_friday, {}),
		t({
			"",
			"",
			"- [ ] Vemas",
			"",
		}),
	}),
})
