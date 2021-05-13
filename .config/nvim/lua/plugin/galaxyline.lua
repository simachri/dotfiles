local gl = require('galaxyline')
local condition = require('galaxyline.condition')
local gls = gl.section
gl.short_line_list = {'NvimTree','vista','dbui','packer'}
local vim = vim

-- Set colors to solarized: https://en.wikipedia.org/wiki/Solarized_(color_scheme)
local colors = {
  --fg = '#586e75', -- verbose hi Statusline
  --bg = '#fdf6e3', -- Base3
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
}

-- padding left
gls.left[1] = {
  RainbowRed = {
    provider = function() return '   ' end,
    highlight = {colors.fg,colors.bg}
  },
}
-- gls.left[2] = {
--   ViMode = {
--     provider = function()
--       -- auto change color according the vim mode
--       local mode_color = {n = colors.red, i = colors.green,v=colors.blue,
--                           [''] = colors.blue,V=colors.blue,
--                           c = colors.magenta,no = colors.red,s = colors.orange,
--                           S=colors.orange,[''] = colors.orange,
--                           ic = colors.yellow,R = colors.violet,Rv = colors.violet,
--                           cv = colors.red,ce=colors.red, r = colors.cyan,
--                           rm = colors.cyan, ['r?'] = colors.cyan,
--                           ['!']  = colors.red,t = colors.red}
--       vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color[vim.fn.mode()])
--       return '  '
--     end,
--     highlight = {colors.red,colors.bg,'bold'},
--   },
-- }
--gls.left[3] = {
  --FileSize = {
    --provider = 'FileSize',
    --condition = condition.buffer_not_empty,
    --highlight = {colors.fg,colors.bg}
  --}
--}
gls.left[4] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    -- highlight = {require('galaxyline.provider_fileinfo').get_file_icon_color,colors.bg},
    highlight = {colors.fg,colors.bg},
  },
}

gls.left[5] = {
  FileName = {
    --provider = 'FileName',
    provider = function () return vim.fn.expand('%') end,
    condition = condition.buffer_not_empty,
    -- highlight = {colors.fg,colors.bg,'bold'}
    highlight = {colors.fg,colors.bg}
  }
}

gls.left[6] = {
  LineInfo = {
    provider = 'LineColumn',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg},
  },
}

gls.left[7] = {
  PerCent = {
    provider = 'LinePercent',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.fg,colors.bg},
  }
}

gls.left[8] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.fg,colors.bg}
  }
}
gls.left[9] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.fg,colors.bg},
  }
}

gls.left[10] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.fg,colors.bg},
  }
}

gls.left[11] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.fg,colors.bg},
  }
}

gls.right[1] = {
  TreesitterLocInfo = {
    provider = function ()
      --return vim.api.nvim_command('call nvim_treesitter#statusline(50)')
      return vim.fn["nvim_treesitter#statusline"]("50")
    end,
    condition = function ()
      local tbl = {['python'] = true}
      if tbl[vim.bo.filetype] then
        return true
      end
      return false
    end,
    icon = '  ',
    highlight = {colors.fg,colors.bg}
  }
}

--gls.right[2] = {
  --ShowLspClient = {
    --provider = 'GetLspClient',
    --condition = function ()
      --local tbl = {['dashboard'] = true,['']=true}
      --if tbl[vim.bo.filetype] then
        --return false
      --end
      --return true
    --end,
    --icon = ' LSP: ',
    --highlight = {colors.fg,colors.bg}
  --}
--}



-- gls.right[1] = {
--   FileEncode = {
--     provider = 'FileEncode',
--     condition = condition.hide_in_width,
--     separator = ' ',
--     separator_highlight = {'NONE',colors.bg},
--     highlight = {colors.green,colors.bg,'bold'}
--   }
-- }

-- gls.right[2] = {
--   FileFormat = {
--     provider = 'FileFormat',
--     condition = condition.hide_in_width,
--     separator = ' ',
--     separator_highlight = {'NONE',colors.bg},
--     highlight = {colors.green,colors.bg,'bold'}
--   }
-- }

gls.right[3] = {
  GitIcon = {
    provider = function() return '  ' end,
    condition = condition.check_git_workspace,
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.violet,colors.bg,'bold'},
  }
}

gls.right[4] = {
  GitBranch = {
    provider = 'GitBranch',
    condition = condition.check_git_workspace,
    highlight = {colors.violet,colors.bg,'bold'},
  }
}

gls.right[5] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.green,colors.bg},
  }
}
gls.right[6] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' 柳',
    highlight = {colors.orange,colors.bg},
  }
}
gls.right[7] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = '  ',
    highlight = {colors.red,colors.bg},
  }
}

-- padding right
gls.right[8] = {
  RainbowBlue = {
    provider = function() return ' ' end,
    highlight = {colors.fg,colors.bg}
  },
}

--gls.short_line_left[1] = {
  --BufferType = {
    --provider = 'FileTypeName',
    --separator = ' ',
    --separator_highlight = {'NONE',colors.bg},
    --highlight = {colors.fg,colors.bg,'bold'}
  --}
--}

gls.short_line_left[2] = {
  SFileName = {
    provider =  'SFileName',
    condition = condition.buffer_not_empty,
    highlight = {colors.bg,colors.beige}
  }
}

--gls.short_line_right[1] = {
  --BufferIcon = {
    --provider= 'BufferIcon',
    --highlight = {colors.fg,colors.bg}
  --}
--}
