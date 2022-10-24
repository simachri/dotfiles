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
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      prompt_position = "bottom",
      preview_cutoff = 90, -- preview will be disabled when Vim buffer has less columns
      horizontal = {
        mirror = false,
        height= 0.8,
        width = 0.9,
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
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
    cache_picker = {
      -- Store the last search.
      num_pickers = 1,
      -- Only keep 50 search results of the last search.
      limit_entries = 50,
    },
    mappings = {
      i = {
        -- Default mappings: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
        -- close directly without switching to normal mode.
        ["<C-q>"] = actions.close,
        -- Override default C-q to 'smart' add to quickfix list.
        ["<C-f>"] = actions.smart_send_to_qflist + actions.open_qflist,
        ["<C-e>"] = actions.to_fuzzy_refine,
        ["<C-j>"] = require('telescope.actions').cycle_history_next,
        ["<C-k>"] = require('telescope.actions').cycle_history_prev,
      },
      n = {
        -- Default mappings: https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/mappings.lua
        -- close directly without switching to normal mode.
        ["<C-q>"] = actions.close,
        ["<C-f>"] = actions.smart_send_to_qflist + actions.open_qflist,
      }
    },

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker,
  },
  pickers = {
    find_files = {
      -- Search on the bottom part of the screen.
      --theme = "ivy",
    },
    grep_string = {
      -- Search on the bottom part of the screen.
      --theme = "ivy",
    },
    buffers = {
      -- Search on the bottom part of the screen.
      --theme = "ivy",
    },
    live_grep = {
      -- Search on the bottom part of the screen.
      --theme = "ivy",
    }
  },
  extensions = {
    -- https://github.com/nvim-telescope/telescope-fzf-native.nvim
    fzf = {
          fuzzy = true,                    -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
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
require('telescope').load_extension('ui-select')
require('telescope').load_extension('dap')

-- Source: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/init.lua
function grep_prompt()
  require('telescope.builtin').grep_string {
    search = vim.fn.input("Grep (including hidden): "),
    search_dirs = { vim.api.nvim_eval("getcwd()") },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    },
  }
end


function find_dotfiles()
  require('telescope.builtin').find_files {
    prompt_title = "Find config files",
    file_ignore_patterns = { "sessions", "plugged", "lain", "themes", "freedesktop", ".zprezto/" },
    follow = false,
    hidden = true,
    -- Multiple search directories can be used:
    -- https://github.com/errx/telescope.nvim/commit/cf8ec44a4299a26adbd4bdcd01e60271f1fef9d5
    search_dirs = { "~/.config/awesome",
                    "~/.config/kitty",
                    "~/.config/nvim",
                    "~/.config/taskwarrior-tui",
                    "~/.config/nnn",
                    "~/.config/zsh",
                    "~/.config/tmux",
                    "~/.config/task",
                    "~/.config/watson",
                    "~/.config/lazygit" }
    --cwd = "~/.config/nvim",
  }
end

-- Source: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/init.lua
function curbuf()
  local opts = {
    previewer = false,
    -- layout_strategy = 'current_buffer',
  }
  require('telescope.builtin').current_buffer_fuzzy_find(opts)
end

-- Source: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/init.lua
function buffers()
  require('telescope.builtin').buffers {
    sort_lastused = false,
  }
end

function grep_md_anchor_refs()
  opts = {}

  -- We have to omit the leading ( as the anchor might be part of a longer URL.
  opts.search = "#" .. vim.fn.expand("<cword>") .. ")"
  opts.prompt_title = "Find anchor references"

  opts.search_dirs = { vim.api.nvim_eval("getcwd()") }

  -- grep_string: https://github.com/nvim-telescope/telescope.nvim/blob/e7f724b437aa0cdfecb144e39aea67d62b745f83/lua/telescope/builtin/files.lua
  require('telescope.builtin').grep_string(opts)
end

function search_all_files()
  require('telescope.builtin').find_files {
    -- --no-ignore-vcs does not take .gitingore rules into account.
    -- Ignore node_mdules: https://github.com/nvim-telescope/telescope.nvim/issues/1769#issuecomment-1067459702
    find_command = { 'rg', '--no-ignore-vcs', '--hidden', '--files', '-g', '!*node_modules'},
    follow = true,
    prompt_title = "Search files - including hidden"
  }
end

function currbufftags()
  -- Create Ctags for current file.
  -- Do not sort, that is, show the tags in the sequence as they occur in the file.
  os.execute("ctags" .. ' --sort=no ' .. vim.fn.expand("%"))

  local opts = {
    previewer = false,
  }
  require('telescope.builtin').current_buffer_tags(opts)
end


function search_currbuf_contents()
  local opts = {
    previewer = false,
  }
  require('telescope.builtin').current_buffer_fuzzy_find(opts)
end

function outline()
  local opts = {
    previewer = false,
  }
  require('telescope.builtin').treesitter(opts)
end

-- Find Git files and - if not in a Git repo - find files.
-- Recipe for configuration: https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#falling-back-to-find_files-if-git_files-cant-find-a-git-directory
-- https://github.com/nvim-telescope/telescope.nvim/blob/a09df82861944aab86c74648b1a570ff8ff73f82/lua/telescope/builtin/__git.lua
function Project_files()
  local is_git_repo = pcall(require"telescope.utils".get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" }, vim.loop.cwd()))
  if is_git_repo then
    require"telescope.builtin".git_files({ use_git_root = false, show_untracked = true })
  else
    require"telescope.builtin".find_files({ follow = true })
  end
end


-- Source: https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope/mappings.lua
-- Find Git files and - if not in a Git repo - find files.
vim.api.nvim_set_keymap('n', '<leader>fj', [[<cmd>lua Project_files()<cr>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').find_files()<cr>]], { noremap = true, silent = true })
-- All Files, including the hidden ones
vim.api.nvim_set_keymap('n', '<leader>fk', [[<cmd>lua search_all_files()<cr>]], { noremap = true, silent = true })
-- Configuration files / dotfiles
vim.api.nvim_set_keymap('n', '<leader>fd', [[<cmd>lua find_dotfiles()<cr>]], { noremap = true, silent = true })

-- Grep prompt
vim.api.nvim_set_keymap('n', '<leader>gp', [[<cmd>lua grep_prompt()<cr>]], { noremap = true, silent = true })
-- Grep live
vim.api.nvim_set_keymap('n', '<leader>gj', [[<cmd>lua require('telescope.builtin').live_grep({disable_coordinates=true})<cr>]], { noremap = true, silent = true })
-- Grep in open buffers
vim.api.nvim_set_keymap('n', '<leader>go', [[<cmd>lua require('telescope.builtin').live_grep({grep_open_files=true, disable_coordinates=true, prompt_title='Grep in open buffers'})<cr>]], { noremap = true, silent = true })
-- Grep word under cursor
vim.api.nvim_set_keymap('n', '<leader>gw', [[<cmd>lua require('telescope.builtin').grep_string({ search_dirs = { vim.api.nvim_eval("getcwd()") }})<cr>]], { noremap = true, silent = true })
-- Find markdown wiki anchor references
vim.api.nvim_set_keymap('n', '<leader>fmr', [[<cmd>lua grep_md_anchor_refs()<cr>]], { noremap = true, silent = true })
-- Find markdown wiki headers
vim.api.nvim_set_keymap('n', '<leader>fmf', [[<cmd>lua require('telescope.builtin').live_grep({disable_coordinates=true, default_text='## .*', prompt_title="Find header"})<cr>]], { noremap = true, silent = true })
-- Find help tags
vim.api.nvim_set_keymap('n', '<leader>fh', [[<cmd>lua require('telescope.builtin').help_tags()<cr>]], { noremap = true, silent = true })
---- CurrBuf
--vim.api.nvim_set_keymap('n', '<leader>fc', [[<cmd>lua curbuf()<cr>]], { noremap = true, silent = true })
-- List buffers
vim.api.nvim_set_keymap('n', '<leader>lb', [[<cmd>lua buffers()<cr>]], { noremap = true, silent = true })
---- Outline
--vim.api.nvim_set_keymap('n', '<leader>fo', [[<cmd>lua outline()<cr>]], { noremap = true, silent = true })
-- Find last - continue search
vim.api.nvim_set_keymap('n', '<leader>fl', [[<cmd>lua require('telescope.builtin').resume()<cr>]], { noremap = true, silent = true })
-- -- Explorer/file browser
-- vim.api.nvim_set_keymap('n', '<leader>fe', [[<cmd>lua require('telescope.builtin').file_browser()<cr>]], { noremap = true, silent = true })
-- -- Buffer fuzzy find: Headers
-- vim.api.nvim_set_keymap('n', '<leader>fd', [[<cmd>lua search_currbuf_contents()<cr>]], { noremap = true, silent = true })
-- Find Vim commands
vim.api.nvim_set_keymap('n', '<leader>fc', [[<cmd>lua require('telescope.builtin').commands()<cr>]], { noremap = true, silent = true })

-- LSP: Actions
vim.api.nvim_set_keymap('n', '<leader>la', [[<cmd>lua vim.lsp.buf.code_action({ apply=true })<cr>]], { noremap = true, silent = true })
-- LSP: Find Document symbols
vim.api.nvim_set_keymap('n', '<leader>fs', [[<cmd>lua require('telescope.builtin').lsp_document_symbols({symbol_width=60})<cr>]], { noremap = true, silent = true })
-- LSP: Find Document symbols - only functions and methods
vim.api.nvim_set_keymap('n', '<leader>ff', [[<cmd>lua require('telescope.builtin').lsp_document_symbols({ symbol_width = 60, symbols = {'function', 'method'}, prompt_title = "Find functions & methods" })<cr>]], { noremap = true, silent = true })
-- LSP: Find workspace symbols
vim.api.nvim_set_keymap('n', '<leader>fw', [[<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<cr>]], { noremap = true, silent = true })
-- LSP: Show type definition(s) for word under cursor
vim.api.nvim_set_keymap('n', 'gt', [[<cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>]], { noremap = true, silent = true })
-- LSP: Go to definition(s)
vim.api.nvim_set_keymap('n', 'gd', [[<cmd>lua require('telescope.builtin').lsp_definitions()<cr>]], { noremap = true, silent = true })
-- LSP: Go to implementaion(s)
vim.api.nvim_set_keymap('n', 'gi', [[<cmd>lua require('telescope.builtin').lsp_implementations()<cr>]], { noremap = true, silent = true })
-- LSP: Go to reference(s)
vim.api.nvim_set_keymap('n', 'gr', [[<cmd>lua require('telescope.builtin').lsp_references({include_declaration=false, fname_width=60, show_line=false})<cr>]], { noremap = true, silent = true })

-- Grep Search history - use <C-e> for the entry to populate the search prompt.
vim.api.nvim_set_keymap('n', '<leader>ghs', [[<cmd>lua require('telescope.builtin').search_history()<cr>]], { noremap = true, silent = true })
-- Grep Command history - use <C-e> for the entry to populate the command prompt.
vim.api.nvim_set_keymap('n', '<leader>ghc', [[<cmd>lua require('telescope.builtin').command_history()<cr>]], { noremap = true, silent = true })

-- Find projects
-- See /home/xi3k/.config/nvim/lua/plugin/project.lua
-- vim.api.nvim_set_keymap('n', '<leader>fp', [[<cmd>Telescope projects<cr>]], { noremap = true, silent = true })

-- Find spellcheck proposals.
--vim.api.nvim_set_keymap('n', '<leader>fs', [[<cmd>lua require('telescope.builtin').spell_suggest()<cr>]], { noremap = true, silent = true })

---- Harpoon
---- https://github.com/ThePrimeagen/harpoon
--require("telescope").load_extension('harpoon')
--vim.api.nvim_set_keymap('n', '<leader>fh', [[<cmd>Telescope harpoon marks<cr>]], { noremap = true, silent = true })

-- Grep Quickfix list
vim.api.nvim_set_keymap('n', '<leader>gq', [[<cmd>lua require('telescope.builtin').quickfix()<cr>]], { noremap = true, silent = true })
