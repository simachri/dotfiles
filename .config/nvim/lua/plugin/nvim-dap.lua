require('telescope').load_extension('dap')

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
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position.
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 10,
      position = "bottom",
    },
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
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Golang
dap.adapters.go = function(callback, config)
  local stdout = vim.loop.new_pipe(false)
  local handle
  local pid_or_err
---@diagnostic disable-next-line: undefined-field
  local host = config.host or "127.0.0.1"
---@diagnostic disable-next-line: undefined-field
  local port = config.port or "38697"
  local addr = string.format("%s:%s", host, port)
---@diagnostic disable-next-line: undefined-field
  if (config.request == "attach" and config.mode == "remote") then
    -- Not starting delve server automatically in "Attach remote."
    -- Will connect to delve server that is listening to [host]:[port] instead.
    -- Users can use this with delve headless mode:
    --
    -- dlv debug -l 127.0.0.1:38697 --headless ./cmd/main.go
    --
    local msg = string.format("connecting to server at '%s'...", addr)
    print(msg)
  else
    local opts = {
      stdio = {nil, stdout},
      args = {"dap", "-l", addr},
      detached = true
    }
    handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
      stdout:close()
      handle:close()
      if code ~= 0 then
        print('dlv exited with code', code)
      end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require('dap.repl').append(chunk)
        end)
      end
    end)
  end

  -- Wait for delve to start
  vim.defer_fn(
    function()
      callback({type = "server",
                host = host,
                port = port,
                --enrich_config = function(cfg, on_config)
                  --local final_config = vim.deepcopy(cfg)
                  --final_config.request = "attach"
                  --final_config.mode = "exec"
                  --on_config(final_config)
                --end,
                })
    end,
    1000)
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "go",
    name = "Debug compiled binary './app'",
    request = "launch",
    mode = "exec",
    program = "./app"
  },
  {
    type = "go",
    name = "Debug current file",
    request = "launch",
    mode = "debug",
    program = "${relativeFile}"
  },
  {
    type = "go",
    name = "Attach to remote",
    request = "attach",
    mode = "remote",
    remotePath = "/app",
    port = 4040,
    host = "127.0.0.1"
  },
  --{
    --type = "go",
    --name = "Debug test", -- configuration for debugging test files
    --request = "launch",
    --mode = "test",
    --program = "${file}"
  --},
  ---- works with go.mod packages and sub packages
  --{
    --type = "go",
    --name = "Debug test (go.mod)",
    --request = "launch",
    --mode = "test",
    --program = "./${relativeFileDirname}"
  --}
}

-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/.dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
}
dap.configurations.typescript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    port = 5858,
    processId = require'dap.utils'.pick_process,
  },
}
dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    port = 5858,
    processId = require'dap.utils'.pick_process,
  },
}

require("nvim-dap-virtual-text").setup {
    enabled = true,                        -- enable this plugin (the default)
    enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true,               -- show stop reason when stopped for exceptions
    commented = false,                     -- prefix virtual text with comment string
    only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
    all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
    filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
    -- experimental features:
    virt_text_pos = 'eol',                 -- position of virtual text, see `:h nvim_buf_set_extmark()`
    all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
    virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                           -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
}
