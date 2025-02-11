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
	return filename:gsub("^%d%d%d%d%-%d%d%-%d%d[-_ ]*", ""):gsub("-", " ")
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

local function extract_jira_issue_id()
	return vim.api.nvim_eval("@+"):match(".*/browse/([A-Z]+%-%d+)")
end

ls.add_snippets("markdown", {
	s("Meeting Notes", {
		t({
			"---",
			"location: virtual",
			"previous_meeting: [[",
		}),
		i(2, "<Previous Meeting>"), -- Jump here AFTER the meeting title is provided
		-- t("]]"), omitted because will be provided by autocomplete
		t({
			"",
			"tags:",
			"  - meeting",
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
			"tags:",
			"  - issue",
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
			"## Solution",
			"",
			"## Notes",
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
			"tags:",
			"  - design",
			"---",
			"# ",
		}),
		f(get_filename_without_leading_date, {}),
		i(0, ""),
	}),

	s("Solution", {
		t({
			"---",
			"status: open",
			"tags:",
			"  - solution",
			"---",
			"# ",
		}),
		f(get_filename_without_leading_date, {}),
		i(0, ""),
	}),

	s({ trig = "ref", name = "Markdown Link" }, {
		t({ "[" }),
		-- Placeholder with initial text.
		i(1, { "<link name>" }),
		t({ "](" }),
		f(function()
			local destPath = vim.api.nvim_eval("@x")
			local currFileParentDirPath = vim.api.nvim_eval("expand('%:.:h')")
			local anchor = vim.api.nvim_eval("@y")
			local function starts_with(entireStr, startStr)
				return entireStr:sub(1, #startStr) == startStr
			end
			-- Example:
			-- destPath = SAP/ECTR/Documents/Solutions
			-- currFileParentDirPath = SAP/ECTR/CAD/Cloning/API
			-- Result: ../../CAD/Cloning/API

			--vim.api.nvim_echo({{destPath, "WarningMsg"}}, true, {}) -- default {history = true}
			--vim.api.nvim_echo({{currFileParentDirPath, "WarningMsg"}}, true, {}) -- default {history = true}

			-- Remove any leading './'
			if starts_with(destPath, "./") then
				destPath = string.sub(destPath, 3, #destPath)
			end
			if starts_with(currFileParentDirPath, "./") then
				currFileParentDirPath = string.sub(currFileParentDirPath, 3, #currFileParentDirPath)
			end

			-- Split the paths into their directories.
			local destPathElems = splitPath(destPath)
			local currFilePathElems = splitPath(currFileParentDirPath)
			-- vim.api.nvim_echo({{vim.inspect(destPathElems), "WarningMsg"}}, true, {}) -- default {history = true}
			-- vim.api.nvim_echo({{vim.inspect(currFilePathElems), "WarningMsg"}}, true, {}) -- default {history = true}

			-- Identify the first elements of the path that are identical.
			local branchIdx = 0
			for idx, val in ipairs(destPathElems) do
				-- vim.api.nvim_echo({{val, "WarningMsg"}}, true, {}) -- default {history = true}
				-- vim.api.nvim_echo({{currFilePathElems[idx], "WarningMsg"}}, true, {}) -- default {history = true}
				if val == currFilePathElems[idx] then
					branchIdx = branchIdx + 1
					-- vim.api.nvim_echo({{"branchIdx is "..branchIdx, "WarningMsg"}}, true, {}) -- default {history = true}
				else
					-- vim.api.nvim_echo({{"breaking", "WarningMsg"}}, true, {}) -- default {history = true}
					break
				end
			end
			-- vim.api.nvim_echo({{"branchIdx is "..branchIdx, "WarningMsg"}}, true, {}) -- default {history = true}

			-- When there are no identical elements, set the branchIdx to 1.
			-- Fix: Don't do this as it will break cases when there is no
			-- common root branch.
			-- if branchIdx == 0 then branchIdx = 1 end

			--vim.api.nvim_echo({{"branchIdx is "..branchIdx, "WarningMsg"}}, true, {}) -- default {history = true}
			--vim.api.nvim_echo({{"Length of currFilePathElems is "..#currFilePathElems, "WarningMsg"}}, true, {}) -- default {history = true}
			--vim.api.nvim_echo({{"Length of destPathElems is "..#destPathElems, "WarningMsg"}}, true, {}) -- default {history = true}

			-- For each directory level above the current file
			-- add ../ to the result path.
			local result = ""
			local relPath = ""
			-- If the destination anchor is in the current file, no
			-- paths need to be adjusted. That is, only do something if the
			-- destination anchor is in a different file (strip the file
			-- extension!).
			if destPath ~= vim.api.nvim_eval("expand('%:.:r')") then
				for _ = branchIdx + 1, #currFilePathElems do
					--vim.api.nvim_echo({{"currIdx is "..currIdx, "WarningMsg"}}, true, {}) -- default {history = true}
					relPath = relPath .. "../"
				end
				-- Add each directory level of the destination file.
				for destIdx = branchIdx + 1, #destPathElems do
					--vim.api.nvim_echo({{"destIdx is "..destIdx, "WarningMsg"}}, true, {}) -- default {history = true}
					relPath = relPath .. destPathElems[destIdx] .. "/"
				end
				-- Remove the trailing slash.
				if relPath:sub(-1) == "/" then
					relPath = relPath:sub(1, -2)
				end
			end
			-- Add the anchor.
			result = relPath .. "#" .. anchor
			return { result }
		end, {}),

		-- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
		i(0),
		t({ ")" }),
	}),

	-- URL to a Jira issue in the format [<Jira Issue ID> <Name>](<URL>)
	s({ trig = "jira", name = "Jira URL" }, {
		t({ "[" }),
		f(extract_jira_issue_id, {}),
		t({ "i " }),
		i(1, { "<Name>" }),
		t({ "](" }),
		f(function()
			return { vim.api.nvim_eval("@+") }
		end, {}),

		-- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
		i(0),
		t({ ")" }),
	}),
})
