require'bufferline'.setup{
  -- https://github.com/akinsho/nvim-bufferline.lua/blob/946d25e001953e7cedf1062f85fb19a8763fecb1/lua/bufferline/config.lua
  options = {
    -- view = "multiwindow" | "default",
    view = "default",
    -- numbers = "none" | "ordinal" | "buffer_id",
    numbers = "none",
    -- number_style = "superscript" | "",
    number_style = "",
    -- mappings = true | false,
    mappings = false,
    -- buffer_close_icon= '',
    buffer_close_icon= '',
    modified_icon = '●',
    -- close_icon = '',
    close_icon = '',
    left_trunc_marker = '',
    right_trunc_marker = '',
    -- max_name_length = 18,
    max_name_length = 30,
    -- max_prefix_length = 15, -- prefix used when a buffer is deduplicated
    max_prefix_length = 15, -- prefix used when a buffer is deduplicated
    -- tab_size = 18,
    tab_size = 15,
    -- diagnostics = false | "nvim_lsp"
    diagnostics = "nvim_lsp",
    --diagnostics_indicator = function(count, level)
      --return "("..count..")"
    --end 
    -- show_buffer_close_icons = true | false,
    show_buffer_close_icons = false,
    -- show_tab_indicators = true | false,
    show_tab_indicators = true,
    persist_buffer_sort = false, -- whether or not custom sorted buffers should persist
    -- can also be a table containing 2 custom separators
    -- [focused and unfocused]. eg: { '|', '|' }
    -- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
    separator_style = "thin",
    -- enforce_regular_tabs = false | true,
    enforce_regular_tabs = false,
    -- always_show_bufferline = true | false,
    always_show_bufferline = true,
    --sort_by = 'extension' | 'relative_directory' | 'directory' | function(buffer_a, buffer_b)
      ---- add custom logic
      --return buffer_a.modified > buffer_b.modified
    --end
  },
  highlights = {
      -- general backround color of tabline
      fill = {
        guifg = '#586e75',
        guibg = '#fdf6e3',
      },
    -- background of topright element
      tab_close = {
        guifg = '#586e75',
        guibg = '#fdf6e3',
      },
  },
}

