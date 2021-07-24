-- https://github.com/crispgm/nvim-go
-- Defaults see further below.
require('go').setup{
    -- auto commands
    auto_format = true,
    auto_lint = true,
    -- linters: golint, errcheck, staticcheck, golangci-lint
    linter = 'golint',
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = 'qf',
    -- formatter: goimports, gofmt, gofumpt
    formatter = 'goimports',
    -- test flags: -count=1 will disable cache
    test_flags = {'-v'},
    test_timeout = '30s',
    test_env = {},
    -- show test result with popup window
    test_popup = true,
    popup_width = 100,
    popup_height = 200,
    -- struct tags
    tags_name = 'json',
    tags_options = {'json=omitempty'},
    tags_transform = 'snakecase',
    tags_flags = {'-skip-unexported'},
    -- quick type
    quick_type_flags = {'--just-types'},
}


local nvim_lsp = require('lspconfig')
local util = require 'lspconfig/util'

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<leader>k', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  --buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  --buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<leader>es', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>el', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  --buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR><cmd>e<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>rf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  elseif client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("n", "<leader>rf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
  end
  -- 21-06-12, add formatter for python as pyright does not provide one.
  -- https://www.reddit.com/r/neovim/comments/kpkc7o/how_to_leverage_neovims_vimlspbufformatting/ghy9550?utm_source=share&utm_medium=web2x&context=3
  if client.name == "pyright" then
    -- https://github.com/sbdchd/neoformat
    -- vim.api.nvim_command[[autocmd BufWritePre <buffer> undojoin | Neoformat]]
    buf_set_keymap("n", "<leader>rf", "<cmd>Neoformat<CR>", opts)
  end

  -- Set autocommands conditional on server_capabilities
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      " Default color is LightYellow
      " Brown background and light foreground
      "hi LspReferenceRead cterm=bold ctermbg=red guibg=#9d8c78 guifg=#fff8f3
      "hi LspReferenceText cterm=bold ctermbg=red guibg=#9d8c78 guifg=#fff8f3
      "hi LspReferenceWrite cterm=bold ctermbg=red guibg=#9d8c78 guifg=#fff8f3
      " Light background
      hi LspReferenceRead cterm=bold ctermbg=red guibg=#efe0d3
      hi LspReferenceText cterm=bold ctermbg=red guibg=#efe0d3
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=#efe0d3
      augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

-- Using lspcontainers to run the language servers, see
-- https://github.com/lspcontainers/lspcontainers.nvim#supported-lsps
-- The 'on_attach' is required to have the keymappings defined in the functions above.

-- Python: https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#pyright
nvim_lsp.pyright.setup {
  before_init = function(params)
    params.processId = vim.NIL
  end,
  -- Note: lspcontainers does not work with pipenv yet (21-05-13).
  -- cmd = require'lspcontainers'.command('pyright'),
  root_dir = util.root_pattern(".git", vim.fn.getcwd()),
  on_attach = on_attach,
  settings = {
    python = {
      analysis = {
        -- Allow relative imports of files in a subdirectory 'app'.
        extraPaths = { "app" }
      }
    }
  }
}
-- Golang
nvim_lsp.gopls.setup {
  -- Do not use lspcontainers as it does not yet work with Go modules (21-07-25).
  --cmd = require'lspcontainers'.command('gopls'),
  on_attach = on_attach,
}
-- Docker
nvim_lsp.dockerls.setup {
  before_init = function(params)
    params.processId = vim.NIL
  end,
  cmd = require'lspcontainers'.command('dockerls'),
  root_dir = util.root_pattern(".git", vim.fn.getcwd()),
  on_attach = on_attach,
}
-- Lua
nvim_lsp.sumneko_lua.setup {
  cmd = require'lspcontainers'.command('sumneko_lua'),
  on_attach = on_attach,
  -- Add 'vim' to globals to prevent message 'Undefined global `vim`.'
  -- https://www.reddit.com/r/neovim/comments/khk335/lua_configuration_global_vim_is_undefined/gglrg7k?utm_source=share&utm_medium=web2x&context=3
  settings = {
      Lua = {
          diagnostics = {
              globals = { 'vim' }
          }
      }
  }
}

-- Initialize lsp-kind for symbbols
-- https://github.com/onsails/lspkind-nvim
require('lspkind').init()
