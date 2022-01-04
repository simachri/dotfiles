-- This file is loaded from ../../after/ftplugin/markdown.vim
-----------------------------------------
-- Treesitter: Implement 'ge' - go to URL
-----------------------------------------
-- Treesitter hierarchy:
--   inline_link [9, 12] - [9, 133]
--       link_text [9, 13] - [9, 36]
--       link_destination [9, 38] - [9, 132]
--
-- Logic:
-- If on inline_link || link_text || link_destination:
--   1. Get element link_destination.
--   2. Split link_destination at '#' into FILE and ANCHOR.
--   3. Open FILE.
--   4. Search and jump to ANCHOR.
local ts_utils = require("nvim-treesitter.ts_utils")
local function jump_to_file_with_anchor ()
  -- Get TS parser for current buffer.
  local parser = vim.treesitter.get_parser(0)
  local root = parser:parse()[1]:root()
  local row = vim.fn.line(".") - 1
  local col = vim.fn.col(".") - 1
  local selected_node = root:named_descendant_for_range(row, col, row, col)

  local node_type = selected_node:type()
  if not (string.match(node_type, "inline_link") or
          string.match(node_type, "link_text") or
          string.match(node_type, "link_destination") ) then
          print("Cursor is not on a link.")
          return
  end

  local dest_node = {}
  if string.match(node_type, "link_destination") then
    dest_node = selected_node
  end
  if string.match(node_type, "inline_link") then
    dest_node = selected_node:named_child(1)
  end
  if string.match(node_type, "link_text") then
    dest_node = selected_node:next_named_sibling()
  end
  local destination = ts_utils.get_node_text(dest_node)[1]

  -- Split the destination at '#' into RELATIVE_FILEPATH and ANCHOR.
  local t = {}
  for str in string.gmatch(destination, "([^#]+)") do
    table.insert(t, str)
  end
  local tab_cnt = 0
  for _ in pairs(t) do tab_cnt = tab_cnt + 1 end
  if tab_cnt ~= 1 and tab_cnt ~= 2 then
    print("Only links in the format '[FILEPATH]#ANCHOR' work.")
    return
  end

  -- RELATIVE_FILEPATH can be empty.
  if tab_cnt == 2 then
    -- Transform the relative filepath to a filepath relative to the CWD.
    -- Vimscript command: fnameescape(fnamemodify(expand('%:h').'/'.l:url.'.md', ':.'))
    -- ':.' Reduces the file name to be relative to the current directory.
    local fname = vim.fn.fnameescape(vim.fn.fnamemodify(vim.fn.expand('%:h') .. '/' .. t[1] .. '.md', ':.'))
    vim.cfd('edit ' .. fname)
  end

  -- Jump to the anchor.
  local anchor
  if tab_cnt == 2 then
    anchor = t[2]
  else
    anchor = t[1]
  end
  vim.cmd('/id="' .. anchor)
end

return { jump_to_file_with_anchor = jump_to_file_with_anchor }
