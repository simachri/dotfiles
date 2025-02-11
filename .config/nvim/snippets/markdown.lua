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
})

ls.add_snippets("markdown", {
	s("Issue", {
		t({
			"---",
			"status: open",
			"tags:",
			"  - issue",
			"---",
			"# ",
		}),
		i(1, "<Issue Title>"),
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
})
