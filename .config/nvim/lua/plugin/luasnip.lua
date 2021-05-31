-- https://github.com/L3MON4D3/LuaSnip
-- Examples from https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua

-- TODO: Disable automatic text-wrap on textwidth before inserting a snippet.
--local m = {
  --customSnipExpand = function()
    --vim.api.nvim_call_function("<Plug>luasnip-expand-or-jump")
  --end
--}
---- Temporarily disable text wrapping if it is enabled.
--local textWrapDisabled = false
--if string.find(vim.api.nvim_buf_get_option(0, 'fo'), 't') then
  ---- vim.bo is the shorthand for vim.api.nvim_buf_get|set_option.
  --vim.bo.fo = vim.bo.fo:gsub("t", "")
  --textWrapDisabled = true
--end

--vim.api.nvim_set_keymap("i", "<C-Y>", "luasnip#expand_or_jumpable() ? v:lua.require'luasnip'.customSnipExpand() : '<C-Y>'", {expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<C-Y>", "luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-Y>'", {expr = true, silent = true})
vim.api.nvim_set_keymap("i", "<C-E>", "luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'", {expr = true, silent = true})
vim.api.nvim_set_keymap("s", "<C-N>", "v:lua.require'luasnip'.jump(1)", { expr = true, noremap = true, silent = true})
vim.api.nvim_set_keymap("s", "<C-P>", "v:lua.require'luasnip'.jump(-1)", { expr = true, noremap = true, silent = true})

local ls = require'luasnip'
-- some shorthands...
local s = ls.s
--local sn = ls.sn
local t = ls.t
local i = ls.i
local f = ls.f
--local c = ls.c
--local d = ls.d

ls.config.set_config({
        -- history: If true, Snippets that were exited can still be jumped back into. As
        -- Snippets are not removed when their text is deleted, they have to be removed
        -- manually via LuasnipUnlinkCurrent.
        history = true
})

local function splitPath(path)
  local elems = {}
  --vim.api.nvim_echo({{path, "WarningMsg"}}, true, {}) -- default {history = true}
  -- Add a trailing / to make the gmatch work.
  for elem in (path .. "/"):gmatch("([^/]*)/") do
    --vim.api.nvim_echo({{elem, "WarningMsg"}}, true, {}) -- default {history = true}
    table.insert(elems, elem)
  end
  return elems
end

ls.snippets = {
    all={},
    markdown = {
            -- Checkbox: "- [ ]", trigger is 'cb'.
            s({trig="cb"}, {
                    t({"- [ ] "}),
                    i(0),
            }),
            -- URL in the format [<URL name>](<URL>), trigger is 'url'.
            s({trig="url"}, {
                    t({"["}),
                    -- Placeholder with initial text.
                    i(1, {"<link name>"}),
                    t({"]("}),
                    f(function()
                        return {vim.api.nvim_eval("@+")}
                      end, {}),

                    -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
                    i(0),
                    t({")"}),
            }),
            -- trigger is 'ref'.
            s({trig="ref"}, {
                    t({"["}),
                    -- Placeholder with initial text.
                    i(1, {"<link name>"}),
                    t({"]("}),
                    f(function()
                        local destPath = vim.api.nvim_eval("@x")
                        local currFileParentDirPath = vim.api.nvim_eval("expand('%:h')")
                        local anchor = vim.api.nvim_eval("@y")
                        -- Example:
                        -- destPath = SAP/ECTR/Documents/Solutions
                        -- currFileParentDirPath = SAP/ECTR/CAD/Cloning/API
                        -- Result: ../../CAD/Cloning/API

                        --vim.api.nvim_echo({{destPath, "WarningMsg"}}, true, {}) -- default {history = true}
                        --vim.api.nvim_echo({{currFileParentDirPath, "WarningMsg"}}, true, {}) -- default {history = true}

                        -- Split the paths into their directories.
                        local destPathElems = splitPath(destPath)
                        local currFilePathElems = splitPath(currFileParentDirPath)
                        -- Identify the first elements of the path that are identical.
                        local branchIdx = 0
                        for idx, val in ipairs(destPathElems) do
                          --vim.api.nvim_echo({{val, "WarningMsg"}}, true, {}) -- default {history = true}
                          --vim.api.nvim_echo({{currFilePathElems[idx], "WarningMsg"}}, true, {}) -- default {history = true}
                          if val == currFilePathElems[idx] then
                              branchIdx = branchIdx + 1
                              --vim.api.nvim_echo({{"branchIdx is "..branchIdx, "WarningMsg"}}, true, {}) -- default {history = true}
                            else
                              --vim.api.nvim_echo({{"breaking", "WarningMsg"}}, true, {}) -- default {history = true}
                              break
                          end
                        end
                        --vim.api.nvim_echo({{"branchIdx is "..branchIdx, "WarningMsg"}}, true, {}) -- default {history = true}

                        -- When there are no identical elements, set the branchIdx to 1.
                        if branchIdx == 0 then branchIdx = 1 end

                        --vim.api.nvim_echo({{"branchIdx is "..branchIdx, "WarningMsg"}}, true, {}) -- default {history = true}
                        --vim.api.nvim_echo({{"Length of currFilePathElems is "..#currFilePathElems, "WarningMsg"}}, true, {}) -- default {history = true}
                        --vim.api.nvim_echo({{"Length of destPathElems is "..#destPathElems, "WarningMsg"}}, true, {}) -- default {history = true}

                        -- For each directory level above the current file
                        -- add ../ to the result path.
                        local result = ""
                        for currIdx = branchIdx + 1, #currFilePathElems do
                          --vim.api.nvim_echo({{"currIdx is "..currIdx, "WarningMsg"}}, true, {}) -- default {history = true}
                          result = result .. "../"
                        end
                        -- Add each directory level of the destination file.
                        for destIdx = branchIdx + 1, #destPathElems do
                          --vim.api.nvim_echo({{"destIdx is "..destIdx, "WarningMsg"}}, true, {}) -- default {history = true}
                          result = result .. destPathElems[destIdx] .. "/"
                        end
                        -- Remove the trailing slash.
                        if result:sub(-1) == "/" then result = result:sub(1,-2) end
                        -- Add the anchor.
                        result = result .. "#" .. anchor
                        return {result}
                      end, {}),

                    -- Last Placeholder, exit Point of the snippet. EVERY 'outer' SNIPPET NEEDS Placeholder 0.
                    i(0),
                    t({")"}),
            })
    }
}

--return m
