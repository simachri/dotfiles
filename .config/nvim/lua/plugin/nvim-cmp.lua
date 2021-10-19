-- https://github.com/hrsh7th/nvim-cmp
local cmp = require'cmp'
local luasnip = require('luasnip')
cmp.setup({
  -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
  snippet = {
    expand = function(args)
      -- For `luasnip` user.
      luasnip.lsp_expand(args.body)
    end,
  },
  completion = {
    -- Select first item automatically.
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = {
    ['<C-k>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                              cmp.mapping.scroll_docs(-4)
                            else
                              fallback() -- The fallback function is treated as original mapped key. In this case, it might be `<Tab>`.
                            end
                          end, { 'i' }),
    ['<C-j>'] = cmp.mapping(function(fallback)
                            if cmp.visible() then
                              cmp.mapping.scroll_docs(4)
                            else
                              fallback() -- The fallback function is treated as original mapped key. In this case, it might be `<Tab>`.
                            end
                          end, { 'i' }),
    ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i' }),
    ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i' }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-y>'] = cmp.mapping.confirm(),
  },
  sources = {
    { name = 'nvim_lsp' },
    -- https://github.com/hrsh7th/cmp-buffer
    { name = 'buffer',
      keyword_length = 3, -- start completion after 5 chars.
      max_item_count = 5, -- only show up to 5 items.
      opts = {
        get_bufnrs = function()
                       return vim.api.nvim_list_bufs()
                     end
      },
    },
    { name = 'path' },
  },
  formatting = {
    fields = { 'abbr', 'kind', 'menu' },
    -- Show LSP icons from lspkind-nvim.
    format = require("lspkind").cmp_format({with_text = false}),
    --format = require("lspkind").cmp_format({with_text = true, menu = ({
        --buffer = "[Buf]",
        --nvim_lsp = "[LSP]",
        --luasnip = "[LuaSnip]",
        --nvim_lua = "[Lua]",
      --})}),
  },
})

-- https://github.com/onsails/lspkind-nvim/issues/24
-- Do not display an icon for plain text in the buffer autocompletion used by nvim-cmp.
require('lspkind').presets['default']['Text']=''

vim.api.nvim_exec([[
  augroup cmp_aucmds
    " Set up sources for filetypes.
    autocmd FileType lua lua require'cmp'.setup.buffer {
    \   sources = {
    \     { name = 'nvim_lua' },
    \     { name = 'nvim_lsp' },
    \     { name = 'buffer',
    \       keyword_length = 3,
    \       max_item_count = 5,
    \       opts = {
    \         get_bufnrs = function()
    \                       return vim.api.nvim_list_bufs()
    \                     end
    \       },
    \     },
    \     { name = 'path' },
    \   },
    \ }
    autocmd FileType markdown lua require'cmp'.setup.buffer {
    \   sources = {
    \     { name = 'luasnip' },
    \     { name = 'nvim_lsp' },
    \     { name = 'buffer',
    \       keyword_length = 3,
    \       max_item_count = 5,
    \       opts = {
    \         get_bufnrs = function()
    \                       return vim.api.nvim_list_bufs()
    \                     end
    \       },
    \     },
    \     { name = 'path' },
    \   },
    \ }

    " Disable for Telescope prompt. - not required as disabled by the default config.
    " See https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
    " autocmd FileType TelescopePrompt lua require('cmp').setup.buffer { enabled = false }

    " Completion menu: Use the same colors as galaxyline.
    au ColorScheme * hi link Pmenu StatsLineNC
    au ColorScheme * hi link CmpItemAbbr Pmenu
    au ColorScheme * hi link CmpItemKind Pmenu
    au ColorScheme * hi link CmpItemMenu Pmenu
    au ColorScheme * hi CmpItemAbbrMatch guifg=#268bd2
    au ColorScheme * hi link CmpItemAbbrMatchFuzzy CmptItemAbbrMatch
  augroup END
]], false)
