return {
  {
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-web-devicons'
    },
    keys = {
          { '<leader>nn', '<cmd>NvimTreeToggle<cr>', { noremap = true, silent = true } },
          { '<leader>nq', '<cmd>NvimTreeClose<cr>', { noremap = true, silent = true } },
          { '<leader>nf', '<cmd>NvimTreeFindFile<cr>', { noremap = true, silent = true } },
    },
    opts = {
        view = {
            mappings = {
                custom_only = false,
                -- :h nvim-tree-default-mappings
                list = {
                    { key = "<c-q>", action = "close" },
                    { key = "/", action = "live_filter" },
                },
            },
            float = {
                enable = true,
                quit_on_focus_loss = true,
                      open_win_config = function()
                          local screen_w = vim.opt.columns:get()
                          local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                          local _width = screen_w * 0.7
                          local _height = screen_h * 0.8
                          local width = math.floor(_width)
                          local height = math.floor(_height)
                          local center_y = ((vim.opt.lines:get() - _height) / 2) - vim.opt.cmdheight:get()
                          local center_x = (screen_w - _width) / 2
                          local layouts = {
                              center = {
                                  anchor = 'NW',
                                  relative = 'editor',
                                  border = 'single',
                                  row = center_y,
                                  col = center_x,
                                  width = width,
                                  height = height,
                              },
                          }
                          return layouts.center
                      end,
            },
        },
        live_filter = {
            prefix = "[FILTER]: ",
            always_show_folders = false,
        },
    },
  }
}
