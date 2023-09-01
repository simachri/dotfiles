

local function custom_dap_setup(dap)
    local dapui = require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- TODO: Switch to new debug adapter: https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript
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

    -- Rust
    -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
    -- First, codelldb --port 13000 has to be executed.
    dap.adapters.lldb = {
      type = 'server',
      host = '127.0.0.1',
      port = 13000
    }
    Last_debug_path = ""
    dap.configurations.rust = {
        {
            type = 'lldb',
            request = 'launch',
            program = function()
              -- if Last_debug_path == "" then
                Last_debug_path = vim.fn.input('Path to executable: ', vim.fn.getcwd()..'/', 'file')
              -- else
                -- Last_debug_path = vim.fn.input('Path to executable: ', Last_debug_path, 'file')
              -- end
              return Last_debug_path
            end,
            cwd = '${workspaceFolder}',
            terminal = 'integrated',
            sourceLanguages = { 'rust' },
            stopOnEntry = false,
            args = {},
        }
    }
end

return {
    {
        'mfussenegger/nvim-dap',
        name = 'dap',
        keys = {
          { '<leader>dd', '<cmd>lua require("dap.ext.vscode").load_launchjs(nil, { node2 = {"typescript", "javascript"}})<cr><cmd>lua require"dap".continue()<cr>', { noremap = true, silent = true } },
          { '<leader>d<space>', '<cmd>lua require"dap".continue()<cr>', { noremap = true, silent = true } },
          { '<leader>drr', '<cmd>lua require"dap".run("run")<cr>', { noremap = true, silent = true } },
          { '<leader>drt', '<cmd>lua require"dap".run("test")<cr>', { noremap = true, silent = true } },
          { '<leader>drl', '<cmd>lua require"dap".run_last()<cr>', { noremap = true, silent = true } },
          { '<leader>dq', '<cmd>lua require"dap".terminate()<cr>', { noremap = true, silent = true } },
          { '<leader>dp', '<cmd>lua require"dap".pause()<cr>', { noremap = true, silent = true } },

          { '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<cr>', { noremap = true, silent = true } },

          { '<leader>dl', '<cmd>lua require"dap".step_into()<cr>', { noremap = true, silent = true } },
          { '<leader>dj', '<cmd>lua require"dap".step_over()<cr>', { noremap = true, silent = true } },
          { '<leader>dh', '<cmd>lua require"dap".step_out()<cr>', { noremap = true, silent = true } },
          { '<leader>dt', '<cmd>lua require"dap".run_to_cursor()<cr>', { noremap = true, silent = true } },
          { '<leader>dn', '<cmd>lua require"dap".down()<cr>', { noremap = true, silent = true } },
          { '<leader>dp', '<cmd>lua require"dap".up()<cr>', { noremap = true, silent = true } },
        },
        config = function()
            local dap = require('dap')
            custom_dap_setup(dap)
        end
    },

    {
      'rcarriga/nvim-dap-ui',
      lazy = true,
      dependencies = {
        'mfussenegger/nvim-dap',
      },
      opts  = {
          icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
          mappings = {
            -- Use a table to apply multiple mappings
            expand = { "<CR>", "<2-LeftMouse>" },
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t",
          },
          -- Use this to override mappings for specific elements
          element_mappings = {
            -- Example:
            -- stacks = {
            --   open = "<CR>",
            --   expand = "o",
            -- }
          },
          -- Expand lines larger than the window
          -- Requires >= 0.7
          expand_lines = vim.fn.has("nvim-0.7") == 1,
          -- Layouts define sections of the screen to place windows.
          -- The position can be "left", "right", "top" or "bottom".
          -- The size specifies the height/width depending on position. It can be an Int
          -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
          -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
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
              size = 40, -- 40 columns
              position = "left",
            },
            {
              elements = {
                "repl",
                "console",
              },
              size = 0.25, -- 25% of total lines
              position = "bottom",
            },
          },
          controls = {
            -- Requires Neovim nightly (or 0.8 when released)
            enabled = false,
            -- Display controls in this element
            element = "repl",
            icons = {
              pause = "",
              play = "",
              step_into = "",
              step_over = "",
              step_out = "",
              step_back = "",
              run_last = "",
              terminate = "",
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
            max_value_lines = 100, -- Can be integer or nil.
          }
        },
        keys = {
          { '<leader>di', '<cmd>lua require"dapui".eval(nil, { enter = false })<cr>', { noremap = true, silent = true } },
          { '<leader>di', '<cmd>lua require"dapui".eval(nil, { enter = false })<cr>', { noremap = true, silent = true } },
          { '<leader>dI', '<cmd>lua require"dapui".eval(nil, { enter = true })<cr>', { noremap = true, silent = true } },
          { '<leader>dI', '<cmd>lua require"dapui".eval(nil, { enter = true })<cr>', { noremap = true, silent = true } },
          { '<leader>dwl', '<cmd>lua require"dapui".float_element()<cr>', { noremap = true, silent = true } },
          { '<leader>dww', '<cmd>lua require"dapui".float_element("watches", { enter = true })<cr>', { noremap = true, silent = true } },
          { '<leader>dwv', '<cmd>lua require"dapui".float_element("scopes", { enter = true })<cr>', { noremap = true, silent = true } },
          { '<leader>dws', '<cmd>lua require"dapui".float_element("stacks", { enter = true })<cr>', { noremap = true, silent = true } },
          { '<leader>dwr', '<cmd>lua require"dapui".float_element("repl", { enter = true })<cr>', { noremap = true, silent = true } },
          { '<leader>dwb', '<cmd>lua require"dapui".float_element("breakpoints")<cr>', { noremap = true, silent = true } },
        },
    },

    {
        'theHamsta/nvim-dap-virtual-text',
        dependencies = {
            'mfussenegger/nvim-dap',
        },
        lazy = true,
        opts = {
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
        },
    },


    {
        'nvim-telescope/telescope-dap.nvim',
        lazy = true,
        dependencies = {
          'mfussenegger/nvim-dap',
        },
    },
}
