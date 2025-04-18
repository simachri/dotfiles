return {
	{
		"glacambre/firenvim",

		-- Lazy load firenvim
		-- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-6652991
		lazy = not vim.g.started_by_firenvim,
		build = ":call firenvim#install(0)",
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
                      " The font name is taken from the Control Panel > Appearance and Personalization > Fonts
                      " application and the display name of the font.
                      "execute "set guifont=SauceCodePro\\ NF:h" . s:fontsize
                      "execute "set guifont=MesloLGLDZ\\ NF:h" . s:fontsize
                      "execute "set guifont=CaskaydiaCove\\ Nerd\\ Font\\ MonoNF:h" . s:fontsize
                      "execute "set guifont=Delugia\\ Mono:h" . s:fontsize
                      execute "set guifont=Cascadia\\ Mono\\ NF:h" . s:fontsize
                      call rpcnotify(0, 'Gui', 'WindowMaximized', 1)
                    endfunction

                    nnoremap  <C-+> :call AdjustFontSizeF(1)<CR>
                    nnoremap  <C--> :call AdjustFontSizeF(-1)<CR>
                    " set guifont=SauceCodePro\ NF:h12
                    " set guifont=MesloLGLDZ\ NF:h12
                    " set guifont=CaskaydiaCove\ Nerd\ Font\ Mono:h14
                    " set guifont=Delugia\ Mono:h14
                    set guifont=Cascadia\ Mono\ NF:h14
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

                " https://github.com/glacambre/firenvim/issues/491
                autocmd FocusLost * ++nested write

                autocmd BufEnter *.html set wrap 
            ]])

			-- disabled the following as it triggers a window resize after the save; trying to
			-- mitigate the resizing leads to flickering
			-- vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
			-- 	callback = function()
			-- 		if vim.g.timer_started == true then
			-- 			return
			-- 		end
			-- 		vim.g.timer_started = true
			-- 		vim.fn.timer_start(2000, function()
			-- 			vim.g.timer_started = false
			-- 			vim.cmd("silent write")
			--
			--          vim.cmd("set lines=70 columns=110")
			-- 		end)
			-- 	end,
			-- })

			vim.api.nvim_set_keymap(
				"n",
				"<leader>mr",
				"<cmd>set lines=70 columns=110<cr>",
				{ desc = "Resize window", noremap = true, silent = true }
			)

			vim.api.nvim_set_keymap(
				"n",
				"<leader>cm",
				[[gg/<br><CR>cf><CR><CR><Esc>ki]],
				{ desc = "Compose Mail", noremap = true, silent = true }
			)
		end,
	},
}
