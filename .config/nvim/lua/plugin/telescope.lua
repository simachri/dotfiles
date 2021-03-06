local themes = require('telescope.themes')
local actions = require('telescope.actions')

require('telescope').setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_position = "bottom",
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
        -- preview_height = 15,
      },
    },
    --file_sorter =  require'telescope.sorters'.get_fzy_sorter,
    file_sorter =  require'telescope.sorters'.get_fuzzy_file,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    shorten_path = false,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = false,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    mappings = {
      i = {
        -- Default mappings: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
        -- close directly without switching to normal mode.
        ["<esc>"] = actions.close,
        -- Override default C-q to 'smart' add to quickfix list.
        ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      },
    },

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
  },
  extensions = {
    -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
    fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = false, -- override the generic sorter
          override_file_sorter = true,     -- override the file sorter
          case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                          -- the default case_mode is "smart_case"
        }
    ---- https://github.com/nvim-telescope/telescope.nvim/issues/550
    --fzy_native = {
        --override_generic_sorter = false,
        --override_file_sorter = true,
    --},
    --fzf_writer = {
      --use_highlighter = false,
      --minimum_grep_characters = 4,
    --}
  }
}

require('telescope').load_extension('fzf')

-- Source: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/init.lua
function grep_prompt()
  require('telescope.builtin').grep_string {
    shorten_path = false,
    search = vim.fn.input("Find: "),
  }
end


function find_config()
  require('telescope.builtin').find_files {
    prompt_title = "Find config files",
    shorten_path = false,
    file_ignore_patterns = { "plugged", "lain", "themes", "freedesktop" },
    -- Multiple search directories can be used:
    -- https://github.com/errx/telescope.nvim/commit/cf8ec44a4299a26adbd4bdcd01e60271f1fef9d5
    search_dirs = { "~/.config/awesome",
                    "~/.config/kitty",
                    "~/.config/nvim",
                    "~/.config/taskwarrior-tui",
                    "~/.config/nnn",
                    "~/.config/lazygit" }
    --cwd = "~/.config/nvim",
  }
end

-- Source: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/init.lua
function curbuf()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,

    -- layout_strategy = 'current_buffer',
  }
  require('telescope.builtin').current_buffer_fuzzy_find(opts)
end

-- Source: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/init.lua
function buffers()
  require('telescope.builtin').buffers {
    shorten_path = false,
  }
end

function grep_md_anchor_refs()
  opts = {}

  opts.shorten_path = true
  -- We have to omit the leading ( as the anchor might be part of a longer URL.
  opts.search = "#" .. vim.fn.expand("<cword>") .. ")"
  opts.prompt_title = "Find anchor references"

  -- grep_string: https://github.com/nvim-telescope/telescope.nvim/blob/e7f724b437aa0cdfecb144e39aea67d62b745f83/lua/telescope/builtin/files.lua
  require('telescope.builtin').grep_string(opts)
end

function search_all_files()
  require('telescope.builtin').find_files {
    -- --no-ignore-vcs does not take .gitingore rules into account.
    find_command = { 'rg', '--no-ignore-vcs', '--hidden', '--files', },
    follow = true,
    prompt_title = "Search files - including hidden ones"
  }
end

function currbufftags()
  -- Create Ctags for current file.
  -- Do not sort, that is, show the tags in the sequence as they occur in the file.
  os.execute("ctags" .. ' --sort=no ' .. vim.fn.expand("%"))

  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }
  require('telescope.builtin').current_buffer_tags(opts)
end

function outline()
  local opts = themes.get_dropdown {
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  }
  require('telescope.builtin').treesitter(opts)
end

-- Source: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/mappings.lua
-- Files, following symlinks
vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files({ follow = true })<cr>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], { noremap = true, silent = true })
-- All Files, including the hidden ones
vim.api.nvim_set_keymap('n', '<leader>fa', [[<cmd>lua search_all_files()<cr>]], { noremap = true, silent = true })
-- Configuration files / dotfiles
vim.api.nvim_set_keymap('n', '<leader>fc', [[<cmd>lua find_config()<cr>]], { noremap = true, silent = true })

-- Grep
vim.api.nvim_set_keymap('n', '<leader>fg', [[<cmd>lua grep_prompt()<cr>]], { noremap = true, silent = true })
-- Grep word under cursor
vim.api.nvim_set_keymap('n', '<leader>fw', [[<cmd>lua require('telescope.builtin').grep_string()<cr>]], { noremap = true, silent = true })
-- Grep markdown anchor references
vim.api.nvim_set_keymap('n', '<leader>fr', [[<cmd>lua grep_md_anchor_refs()<cr>]], { noremap = true, silent = true })
---- CurrBuf
--vim.api.nvim_set_keymap('n', '<leader>fc', [[<cmd>lua curbuf()<cr>]], { noremap = true, silent = true })
-- Buffers
vim.api.nvim_set_keymap('n', '<leader>fb', [[<cmd>lua buffers()<cr>]], { noremap = true, silent = true })
-- -- Tags: Use tagbar instead.
-- vim.api.nvim_set_keymap('n', '<leader>ft', [[<cmd>lua currbufftags()<cr>]], { noremap = true, silent = true })
-- Outline/treesitter
vim.api.nvim_set_keymap('n', '<leader>fo', [[<cmd>lua outline()<cr>]], { noremap = true, silent = true })
-- Explorer/file browser
vim.api.nvim_set_keymap('n', '<leader>fe', [[<cmd>lua require('telescope.builtin').file_browser()<cr>]], { noremap = true, silent = true })
