-- https://github.com/famiu/feline.nvim/blob/master/USAGE.md
-- https://github.com/famiu/feline.nvim/blob/master/lua/feline/presets/default.lua
local fl = require('feline')
local vi_mode_utils = require('feline.providers.vi_mode')

local comps = {
  -- Active buffer
  active = {},
  -- Inactive buffer
  inactive = {},
}
-----------------
-- Active buffer
-----------------
-- Left
comps.active[1] = {
    {
        provider = '▊ ',
        hl = {
          fg = 'bg',
        },
    },
    {
        provider = 'vi_mode',
        hl = function()
            return {
                name = vi_mode_utils.get_mode_highlight_name(),
                fg = vi_mode_utils.get_mode_color(),
                style = 'bold'
            }
        end,
        right_sep = ' ',
    },
    {
      -- https://github.com/famiu/feline.nvim/blob/master/USAGE.md#file-info
      provider = {
        name = 'file_info',
        opts = {
          colored_icon = false,
          type = 'relative',
        },
      },
      --hl = { style = 'bold' },
      left_sep = '  ',
      right_sep = '  ',
    },
    {
      provider = function ()
                    local status = require("harpoon.mark").status()
                    if status == "" then
                        status = " "
                    end

                    return string.format("%s", status)
                end,
      type = 'relative',
      hl = {
        style = 'bold'
      },
      left_sep = '  ',
      right_sep = ' ',
    },
    {
      provider = function ()
                    local bCntModif = vim.fn.len(vim.fn.getbufinfo({bufmodified=1, buflisted=1}))
                    local bCntList = vim.fn.len(vim.fn.getbufinfo({buflisted=1}))
                    if bCntModif > 0 then
                      return bCntList .. " (" .. bCntModif .. ")"
                    else
                      return bCntList .. "   "
                    end
                  end,
      type = 'relative',
      right_sep = '  ',
    },
    {
        provider = 'diagnostic_errors',
        hl = { style = 'bold' },
        left_sep = ' ',
        right_sep = ' ',
    },
    {
        provider = 'diagnostic_warnings',
        hl = { style = 'bold' },
        left_sep = ' ',
        right_sep = ' ',
    },
    {
        provider = 'diagnostic_hints',
        hl = { style = 'bold' },
        left_sep = ' ',
        right_sep = ' ',
    },
    {
        provider = 'diagnostic_info',
        hl = { style = 'bold' },
        left_sep = ' ',
        right_sep = ' ',
    }
}
-- right
comps.active[2] = {
    {
        provider = function () return vim.fn.fnamemodify('.', ':p:h:t') end,
        left_sep = ' ',
        right_sep = '  ',
    },
    {
        provider = 'git_branch',
        hl = { style = 'bold' },
        left_sep = ' ',
        right_sep = ' ',
    },
    {
        provider = 'git_diff_added',
        left_sep = ' ',
        right_sep = ' ',
    },
    {
        provider = 'git_diff_changed',
        left_sep = ' ',
        right_sep = ' ',
    },
    {
        provider = 'git_diff_removed',
        left_sep = ' ',
        right_sep = '  ',
    },
    {
        provider = 'position',
        left_sep = ' ',
        right_sep = ' ',
    },
    {
        provider = 'line_percentage',
        left_sep = ' ',
        right_sep = '',
    },
    {
        provider = ' ▊',
        hl = {
          fg = 'bg',
        },
    },
}


-----------------
-- Inactive buffer
-----------------
comps.inactive[1] = {
    {
        provider = ' ',
        hl = {
          bg = 'beige',
        },
    },
      {
        -- https://github.com/famiu/feline.nvim/blob/master/USAGE.md#file-info
        provider = {
          name = 'file_info',
          opts = {
            colored_icon = false,
            type = 'relative',
          },
        },
        hl = {
          fg = 'bg',
          bg = 'beige',
        },
      },
}



fl.setup({
  components = comps,
  colors = {
    bg = '#586e75',
    fg = '#fdf6e3',
    yellow = '#b58900',
    red = '#dc322f',
    blue = '#268bd2',
    green = '#859900',
    cyan = '#2aa198',
    orange = '#cb4b16',
    magenta = '#d33682',
    purple = '#6c71c4',
    darkblue = '#073642', -- Base02
    grey = '#93a1a1', -- Base1
    darkgrey = '#839496',
    beige = '#eee8d5'
  },
  vi_mode_colors = {
    ['NORMAL'] = 'fg',
    ['OP'] = 'green',
    ['INSERT'] = 'red',
    ['VISUAL'] = 'skyblue',
    ['LINES'] = 'skyblue',
    ['BLOCK'] = 'skyblue',
    ['REPLACE'] = 'violet',
    ['V-REPLACE'] = 'violet',
    ['ENTER'] = 'cyan',
    ['MORE'] = 'cyan',
    ['SELECT'] = 'orange',
    ['COMMAND'] = 'green',
    ['SHELL'] = 'green',
    ['TERM'] = 'green',
    ['NONE'] = 'yellow'
      },
})
