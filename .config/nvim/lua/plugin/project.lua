-- https://github.com/ahmedkhalf/project.nvim
require("project_nvim").setup {
  -- Manual mode doesn't automatically change your root directory, so you have
  -- the option to manually do so using `:ProjectRoot` command.
  manual_mode = true,

  -- Methods of detecting the root directory. **"lsp"** uses the native neovim
  -- lsp, while **"pattern"** uses vim-rooter like glob pattern matching. Here
  -- order matters: if one is not detected, the other is used as fallback. You
  -- can also delete or rearangne the detection methods.
  --detection_methods = { "lsp", "pattern" },
  detection_methods = {},

  -- All the patterns used to detect root dir, when **"pattern"** is in
  -- detection_methods
  patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

  -- Table of lsp clients to ignore by name
  -- eg: { "efm", ... }
  ignore_lsp = {},

  -- Don't calculate root dir on specific directories
  -- Ex: { "~/.cargo/*", ... }
  exclude_dirs = {},

  -- Show hidden files in telescope
  show_hidden = false,

  -- When set to false, you will get a message when project.nvim changes your
  -- directory.
  silent_chdir = true,

  -- Path where project.nvim will store the project history for use in
  -- telescope
  datapath = vim.fn.stdpath("data"),
}

-- Custom picker for Telescope
-- https://github.com/ahmedkhalf/project.nvim/blob/main/lua/telescope/_extensions/projects.lua
local pickers = require("telescope.pickers")
local telescope_config = require("telescope.config").values
local actions = require("telescope.actions")
local entry_display = require("telescope.pickers.entry_display")
local history = require("project_nvim.utils.history")
local finders = require("telescope.finders")
local state = require("telescope.actions.state")
local project = require("project_nvim.project")
local config = require("project_nvim.config")
local builtin = require("telescope.builtin")

local function create_finder()
  local results = history.get_recent_projects()

  -- Reverse results
  for i = 1, math.floor(#results / 2) do
    results[i], results[#results - i + 1] = results[#results - i + 1], results[i]
  end
  local displayer = entry_display.create({
    separator = " ",
    items = {
      {
        width = 60,
      },
      {
        remaining = true,
      },
    },
  })

  local function make_display(entry)
    return displayer({ entry.name, { entry.value, "Comment" } })
  end

  return finders.new_table({
    results = results,
    entry_maker = function(entry)
      local name = vim.fn.fnamemodify(entry, ":t")
      return {
        display = make_display,
        name = name,
        value = entry,
        ordinal = name .. " " .. entry,
      }
    end,
  })
end

local function change_working_directory(prompt_bufnr, prompt)
  local selected_entry = state.get_selected_entry()
  if selected_entry == nil then
    actions.close(prompt_bufnr)
    return
  end
  local project_path = selected_entry.value
  if prompt == true then
    actions.close(prompt_bufnr)
  else
    actions.close(prompt_bufnr)
  end
  local cd_successful = project.set_pwd(project_path, "telescope")
  return project_path, cd_successful
end

local function find_project_files(prompt_bufnr)
  local project_path, cd_successful = change_working_directory(prompt_bufnr, true)
  local opt = {
    cwd = project_path,
    hidden = config.options.show_hidden,
    mode = "insert",
  }
  if cd_successful then
    builtin.find_files(opt)
  end
end

local function delete_project(prompt_bufnr)
  local selectedEntry = state.get_selected_entry()
  if selectedEntry == nil then
    actions.close(prompt_bufnr)
    return
  end
  local choice = vim.fn.confirm("Delete '" .. selectedEntry.value .. "' from project list?", "&Yes\n&No", 2)

  if choice == 1 then
    history.delete_project(selectedEntry)

    local finder = create_finder()
    state.get_current_picker(prompt_bufnr):refresh(finder, {
      reset_prompt = true,
    })
  end
end

function Projects_custom(opts)
  opts = opts or {}

  pickers.new(opts, {
    prompt_title = "Recent Projects",
    finder = create_finder(),
    previewer = false,
    sorter = telescope_config.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<c-d>", delete_project)
      map("i", "<c-l>", find_project_files)
      map("i", "<c-g>", change_working_directory)

      local on_project_selected = function()
        change_working_directory(prompt_bufnr)
        vim.cmd('silent! RestoreSession')
        vim.cmd('FloatermNew --name=zsh --title=zsh --silent')
        vim.cmd('FloatermNew --name=tw --title=Taskwarrior --silent taskwarrior-tui')
      end
      actions.select_default:replace(on_project_selected)
      return true
    end,
  }):find()
end

vim.api.nvim_set_keymap('n', '<leader>fp', [[<cmd>lua Projects_custom()<cr>]], { noremap = true, silent = true })

-- https://github.com/ahmedkhalf/project.nvim/issues/43
function _ADD_CURR_DIR_TO_PROJECTS()
  local historyfile = require("project_nvim.utils.path").historyfile
  --local curr_directory = vim.fn.expand("%:p:h")
  local cwd = vim.fn.getcwd()
  vim.cmd("!echo " .. cwd .. " >> " .. historyfile)
end
vim.cmd("command! ProjectAdd lua _ADD_CURR_DIR_TO_PROJECTS()")
