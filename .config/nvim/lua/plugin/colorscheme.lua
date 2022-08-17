-- 21-1-19, Use this to make colors in Vim work with rxvt-unicode.
-- set t_Co=256
vim.api.nvim_set_option('background', 'light')

-- The following refers to Plug 'ishan9299/nvim-solarized-lua'
vim.api.nvim_exec(
[[
  augroup adj_solarized
    au!
    " ~/.config/nvim/plugged/nvim-solarized-lua/colors/solarized-flat.lua
    " Default colors:
    " - green - `Statement`: `#859900`
    " - red - `Title`:  #cb4b16
    " - orange - `Type`: `#b58900`
    " - purple - `Underlined`: `#6c71c4`
    " - magenta - `#d33682`
    " - blue - `Identifier`: `#268bd2`
    " - cyan - `Constant`: `#2aa198`
    " - grey - `Comment`: `#93a1a1` 
    " Adjust 'blue'
    " au ColorScheme * hi Identifier guifg=#507da9
    " Adjust 'red'
    au ColorScheme * hi Title guifg=#cd6a46 guibg=NONE gui=bold cterm=bold
    "" Adjust 'cyan'
    "au ColorScheme * hi Constant guifg=#298a81
    "" Override background color of the line number bar
    " highlight LineNr guifg=#839496 guibg=#eee8d5
    au ColorScheme * hi clear LineNr
    " hi CursorLineNr guifg=#cb4b16 guibg=#073642 gui=bold cterm=bold
    au ColorScheme * hi CursorLineNr guibg=None

    " Statusline of non-current buffers
    " au ColorScheme * hi StatusLineNC guibg=#839496 guifg=#eee8d5

    " Treesitter
    " Fix error color group highlighting.
    " https://github.com/nvim-treesitter/nvim-treesitter/issues/119
    au ColorScheme * hi! link TSError Normal
    " Orange
    au ColorScheme * hi TSFunction guifg=#b58900
    au ColorScheme * hi TSMethod guifg=#b58900
    au ColorScheme * hi TSMethodCall guifg=#b58900 gui=italic
    au ColorScheme * hi TSFunctionCall guifg=#b58900 gui=italic
    au ColorScheme * hi TSTypeBuiltin guifg=#b58900 gui=italic
    au ColorScheme * hi TSFuncBuiltin guifg=#b58900 gui=italic
    " Blue
    au ColorScheme * hi TSVariable guifg=#268bd2
    au ColorScheme * hi TSParameter guifg=#268bd2
    au ColorScheme * hi TSParameterReference guifg=#268bd2
    " Red
    au ColorScheme * hi TSOperator guifg=#cb4b16
    " Default text font (grey)
    au ColorScheme * hi TSPunctBracket guifg=#657b83
    au ColorScheme * hi TSPunctDelimiter guifg=#657b83
    au ColorScheme * hi TSProperty guifg=#657b83
    au ColorScheme * hi TSField guifg=#657b83
    au ColorScheme * hi TSType guifg=#657b83 gui=italic
    au ColorScheme * hi TSKeywordFunction guifg=#657b83 gui=bold
    au ColorScheme * hi TSKeywordReturn guifg=#657b83 gui=bold
    " Purple
    au ColorScheme * hi TSNamespace guifg=#6c71c4 
    au ColorScheme * hi TSConstant guifg=#6c71c4

    " Search
    au ColorScheme * hi Search guifg=#eee8d5 guibg=#657b83

  augroup END
]]
, false)
vim.cmd('colorscheme solarized-flat')


-- The following refers to Plug 'shaunsingh/solarized.nvim'
-- vim.g.solarized_italic_comments = true
-- vim.g.solarized_italic_keywords = false
-- vim.g.solarized_italic_functions = true
-- vim.g.solarized_italic_variables = false
-- vim.g.solarized_contrast = false
-- vim.g.solarized_borders = false
-- vim.g.solarized_disable_background = false
-- require('solarized').set()
