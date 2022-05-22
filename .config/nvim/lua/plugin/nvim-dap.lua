-- Continue is also used for starting a new debug session.
vim.api.nvim_set_keymap('n', '<leader>dd', [[<cmd>lua require"dap".continue()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d<space>', [[<cmd>lua require"dap".continue()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dr', [[<cmd>lua require"dap".run('run')<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dt', [[<cmd>lua require"dap".run('test')<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>d_', [[<cmd>lua require"dap".run_last()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dq', [[<cmd>lua require"dap".terminate()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dp', [[<cmd>lua require"dap".pause()<cr>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>db', [[<cmd>lua require"dap".toggle_breakpoint()<cr>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>dl', [[<cmd>lua require"dap".step_into()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dj', [[<cmd>lua require"dap".step_over()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dh', [[<cmd>lua require"dap".step_out()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>drc', [[<cmd>lua require"dap".run_to_cursor()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dn', [[<cmd>lua require"dap".down()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dp', [[<cmd>lua require"dap".up()<cr>]], { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>di', [[<cmd>lua require"dapui".eval()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>di', [[<cmd>lua require"dapui".eval()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', [[<cmd>lua require"dapui".float_element()<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dw', [[<cmd>lua require"dapui".float_element("watches")<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>do', [[<cmd>lua require"dapui".float_element("scopes")<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ds', [[<cmd>lua require"dapui".float_element("stacks")<cr>]], { noremap = true, silent = true })
-- REPL: Debug console
vim.api.nvim_set_keymap('n', '<leader>dt', [[<cmd>lua require"dapui".float_element("repl")<cr>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dp', [[<cmd>lua require"dapui".float_element("breakpoints")<cr>]], { noremap = true, silent = true })

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7"),
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
  }
})
