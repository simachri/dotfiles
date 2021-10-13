-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require'cmp'
local mapping = require('cmp.config.mapping')
local luasnip = require('luasnip')
cmp.setup({
  -- https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
  snippet = {
    expand = function(args)
      -- For `luasnip` user.
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-k>'] = function(fallback)
                  if cmp.visible() then
                    cmp.mapping.scroll_docs(-4)
                  else
                    fallback() -- The fallback function is treated as original mapped key. In this case, it might be `<Tab>`.
                  end
                end,
    ['<C-j>'] = function(fallback)
                  if cmp.visible() then
                    cmp.mapping.scroll_docs(4)
                  else
                    fallback() -- The fallback function is treated as original mapped key. In this case, it might be `<Tab>`.
                  end
                end,
    ['<C-n>'] = mapping(mapping.select_next_item(), { 'i' }),
    ['<C-p>'] = mapping(mapping.select_prev_item(), { 'i' }),
    ['<C-Space>'] = cmp.mapping.complete(),
    -- ['<C-e>'] = cmp.mapping.close(), -- not required. <C-c> will do that.
    ["<C-y>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            }
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer',
      keyword_length = 5, -- start completion after 5 chars.
      max_item_count = 5, -- only show up to 5 items.
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

vim.api.nvim_exec([[
  augroup cmp_aucmds
    " Set up sources for filetypes.
    autocmd FileType lua lua require'cmp'.setup.buffer {
    \   sources = {
    \     { name = 'nvim_lua' },
    \     { name = 'nvim_lsp' },
    \     { name = 'buffer',
    \       keyword_length = 5,
    \       max_item_count = 5,
    \     },
    \     { name = 'path' },
    \   },
    \ }
    autocmd FileType markdown lua require'cmp'.setup.buffer {
    \   sources = {
    \     { name = 'luasnip' },
    \     { name = 'nvim_lsp' },
    \     { name = 'buffer',
    \       keyword_length = 5,
    \       max_item_count = 5,
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
