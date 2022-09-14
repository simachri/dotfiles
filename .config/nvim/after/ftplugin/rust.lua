local function on_stdout()
  return function(err, data)
    assert(not err, err)
    if data then
      vim.schedule(function()
        require('dap.repl').append(data)
      end)
    end
  end
end

function Start_debugging()
  require("plenary").job:new({
        command = 'codelldb',
        --env = env.dump(),
        --cwd = uv.cwd(),
        args = { '--port', '13000'},
        on_exit = function(_, code)
                    print('codelldb exited with code', code)
                  end,
        on_stdout = on_stdout(),
        on_stderr = on_stdout(),
  }):start()

  vim.defer_fn(function()
    require("dap").continue()
    end, 2000)
end

vim.api.nvim_set_keymap('n', '<leader>dd', [[<cmd>lua Start_debugging()<cr>]], { noremap = true, silent = true })
