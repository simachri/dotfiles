local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node

local function current_date()
	return os.date("%Y-%m-%d")
end

ls.add_snippets("markdown", {
	s("mt", {
		t({
			"---",
			"location: Virtual",
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
		i(1, "<Meeting Title>"),
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
