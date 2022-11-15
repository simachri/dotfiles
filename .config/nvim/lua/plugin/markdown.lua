-- https://github.com/jakewvincent/mkdnflow.nvim#-installation-and-usage
require('mkdnflow').setup({
    modules = {
        bib = false,
        buffers = false,
        conceal = true,
        cursor = true,
        folds = false,
        links = true,
        lists = false,
        maps = true,
        paths = false,
        tables = false,
    },
    filetypes = {md = true, rmd = true, markdown = true},
    create_dirs = true,
    perspective = {
        -- priority = 'first',
        priority = 'current',
        fallback = 'current',
        root_tell = false,
        nvim_wd_heel = false
    },
    wrap = false,
    bib = {
        default_path = nil,
        find_in_root = true
    },
    silent = false,
    links = {
        style = 'markdown',
        name_is_source = false,
        conceal = true,
        implicit_extension = 'md',
        transform_implicit = false,
        transform_explicit = function(text)
            text = text:gsub(" ", "-")
            text = text:lower()
            text = os.date('%Y-%m-%d_')..text
            return(text)
        end
    },
    to_do = {
        symbols = {' ', '-', 'X'},
        update_parents = true,
        not_started = ' ',
        in_progress = '-',
        complete = 'X'
    },
    tables = {
        trim_whitespace = true,
        format_on_move = true,
        auto_extend_rows = false,
        auto_extend_cols = false
    },
    mappings = {
        MkdnEnter = false,
        MkdnTab = false,
        MkdnSTab = false,
        MkdnNextLink = {{'n', 'v'}, ']r'},
        MkdnPrevLink = {{'n', 'v'}, '[r'},
        MkdnNextHeading = {{'n', 'v'}, ']]'},
        MkdnPrevHeading = {{'n', 'v'}, '[['},
        MkdnGoBack = false,
        MkdnGoForward = false,
        MkdnFollowLink = false,
        MkdnDestroyLink = false,
        MkdnTagSpan = false,
        MkdnMoveSource = false,
        MkdnYankAnchorLink = false,
        MkdnYankFileAnchorLink = false,
        MkdnIncreaseHeading = false,
        MkdnDecreaseHeading = false,
        MkdnToggleToDo = false,
        MkdnNewListItem = false,
        MkdnNewListItemBelowInsert = false,
        MkdnNewListItemAboveInsert = false,
        MkdnExtendList = false,
        MkdnUpdateNumbering = false,
        MkdnTableNextCell = false,
        MkdnTablePrevCell = false,
        MkdnTableNextRow = false,
        MkdnTablePrevRow = false,
        MkdnTableNewRowBelow = false,
        MkdnTableNewRowAbove = false,
        MkdnTableNewColAfter = false,
        MkdnTableNewColBefore = false,
        MkdnFoldSection = false,
        MkdnUnfoldSection = false,
    }
})


-- https://github.com/ekickx/clipboard-image.nvim
require'clipboard-image'.setup {
  markdown = {
    img_dir = {"%:p:h", ".img"},
    img_dir_txt = {".img"},
  }
}
-- To make this work, adjust the following in /home/xi3k/.config/nvim/plugged/clipboard-image.nvim/lua/clipboard-image/utils.lua:
---- cmd_paste = "$content = " .. cmd_check .. ";$content.Save('%s', 'png')"
-- cmd_paste = "(" .. cmd_check .. ").Save('%s', 'png')"

-----------------------------------------
-- Treesitter: Implement 'go to URL'
-- Keymap is configured in /home/xi3k/.config/nvim/after/ftplugin/markdown.vim
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
function Jump_to_file_with_anchor ()
  local row = vim.fn.line(".") - 1
  local col = vim.fn.col(".") - 1
  local selected_node = vim.treesitter.get_node_at_pos(0, row, col, {ignore_injections=false})

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
  local destination = vim.treesitter.query.get_node_text(dest_node, 0)

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
    vim.cmd('edit ' .. fname)
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


