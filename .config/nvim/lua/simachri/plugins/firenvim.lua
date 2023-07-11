return {
	{
		"glacambre/firenvim",

		-- Lazy load firenvim
		-- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
		cond = not not vim.g.started_by_firenvim,
		build = function()
			require("lazy").load({ plugins = "firenvim", wait = true })
			vim.fn["firenvim#install"](0)
		end,
		config = function()
			vim.g.firenvim_config = {
				globalSettings = { alt = "all" },
				localSettings = {
					[".*"] = {
						cmdline = "neovim",
						content = "text",
						priority = 0,
						takeover = "never",
						filename = "/tmp/{pathname%32}.{extension}",
					},
					["outlook.office365.com"] = {
						content = "html",
						priority = 1,
					},
				},
			}

			vim.cmd([[
                function! OnUIEnter(event) abort
                  if 'Firenvim' ==# get(get(nvim_get_chan_info(a:event.chan), 'client', {}), 'name', '')
                    " To create mappings for increasing and decreasing the font size through a key mapping, 
                    " see https://github.com/glacambre/firenvim/issues/972#issuecomment-843733076.
                    let s:fontsize = 14
                    function! AdjustFontSizeF(amount)
                      let s:fontsize = s:fontsize+a:amount
                      "execute "set guifont=SauceCodePro\\ NF:h" . s:fontsize
                      "execute "set guifont=MesloLGLDZ\\ NF:h" . s:fontsize
                      execute "set guifont=CaskaydiaCove\\ Nerd\\ Font\\ MonoNF:h" . s:fontsize
                      call rpcnotify(0, 'Gui', 'WindowMaximized', 1)
                    endfunction

                    nnoremap  <C-+> :call AdjustFontSizeF(1)<CR>
                    nnoremap  <C--> :call AdjustFontSizeF(-1)<CR>
                   " set guifont=SauceCodePro\ NF:h12
                   " set guifont=MesloLGLDZ\ NF:h12
                    set guifont=CaskaydiaCove\ Nerd\ Font\ Mono:h14
                    set lines=70
                    set columns=110
                    " Setting the filetype here has no effect as it is derived from the (temporary) file 
                    " that is being created and edited.
                    " set ft=markdown
                    " https://github.com/glacambre/firenvim#using-different-settings-depending-on-the-pageelement-being-edited
                    au BufEnter *.txt set filetype=confluencewiki
                  endif
                endfunction

                autocmd UIEnter * call OnUIEnter(deepcopy(v:event))
            ]])
		end,
	},
}
