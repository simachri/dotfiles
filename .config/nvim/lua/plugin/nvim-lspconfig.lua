-- https://github.com/crispgm/nvim-go
-- Defaults see further below.
require('go').setup{
    -- auto commands
    auto_format = false,
    auto_lint = true,
    -- linters: revive, errcheck, staticcheck, golangci-lint
    linter = 'revive',
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = 'vt',
    -- formatter: goimports, gofmt, gofumpt
    formatter = 'goimports',
    -- test flags: -count=1 will disable cache
    test_flags = {'-v'},
    test_timeout = '30s',
    test_env = {},
    -- show test result with popup window
    test_popup = true,
    test_popup_width = 200,
    test_popup_height = 200,
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
  buf_set_keymap('n', '<leader>ld', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<leader>ll', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
  --buf_set_keymap('n', '<leader>lr', '<cmd>lua vim.lsp.stop_client(vim.lsp.get_active_clients())<CR><cmd>e<CR>', opts)

  -- Set some keybinds conditional on server capabilities
  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<leader>rf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("v", "<leader>rf", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
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

-- JSON
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonls
require'lspconfig'.jsonls.setup {
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
}

-- Python: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
nvim_lsp.pyright.setup {
  before_init = function(params)
    params.processId = vim.NIL
  end,
  -- Note: lspcontainers does not work with pipenv yet (21-05-13).
  -- cmd = require'lspcontainers'.command('pyright'),
  root_dir = util.root_pattern(".git", vim.fn.getcwd()),
  on_attach = on_attach,
  -- https://github.com/hrsh7th/nvim-cmp
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
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
  -- https://github.com/hrsh7th/nvim-cmp
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  on_attach = on_attach,
}

-- Docker
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dockerls
nvim_lsp.dockerls.setup {
  before_init = function(params)
    params.processId = vim.NIL
  end,
  -- https://github.com/hrsh7th/nvim-cmp
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  -- cmd = require'lspcontainers'.command('dockerls'),
  root_dir = util.root_pattern(".git", vim.fn.getcwd()),
  on_attach = on_attach,
}

-- SQL
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sqlls
require'lspconfig'.sqlls.setup{
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
}

-- Lua https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua
-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
nvim_lsp.sumneko_lua.setup {
  -- cmd = require'lspcontainers'.command('sumneko_lua'),
  cmd = {'/opt/lua-language-server/bin/Linux/lua-language-server', "-E", '/opt/lua-language-server/bin/Linux/main.lua'};
  on_attach = on_attach,
  -- https://github.com/hrsh7th/nvim-cmp
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  -- Add 'vim' to globals to prevent message 'Undefined global `vim`.'
  -- https://www.reddit.com/r/neovim/comments/khk335/lua_configuration_global_vim_is_undefined/gglrg7k?utm_source=share&utm_medium=web2x&context=3
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
        -- fix: Do you need to configure your work environment as `LÖVE`?
        -- https://github.com/sumneko/lua-language-server/issues/679#issuecomment-960478223
        checkThirdPart = false,
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

-- JavaScript/TypeScript
-- https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils
-- https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end
nvim_lsp.tsserver.setup({
    -- https://github.com/hrsh7th/nvim-cmp
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
    -- https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils
    init_options = require("nvim-lsp-ts-utils").init_options,
    on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({
            -- Filter messages:
              -- 'File is a CommonJS module; it may be converted to an ES6 module'
              -- ''{0}' is declared but its value is never read.'
            -- Source: https://stackoverflow.com/a/70294761
            -- List of codes: https://github.com/microsoft/TypeScript/blob/master/src/compiler/diagnosticMessages.json
            filter_out_diagnostics_by_code = { 80001, 6133 },
        })
        ts_utils.setup_client(client)
        buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
        buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
        on_attach(client, bufnr)
    end,
})
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
        null_ls.builtins.formatting.prettier
    },
    on_attach = on_attach
})

-- Initialize lsp-kind for symbbols
-- https://github.com/onsails/lspkind-nvim
require('lspkind').init()
