return {

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"saghen/blink.cmp",
		},
		event = { "BufReadPre", "BufNewFile" },
		keys = {
            -- should be available by default in nvim, see :h K-lsp-default
			{ "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { noremap = true, silent = true } },
            -- signature help is on Ctrl-s by default on insert and select mode since 
            -- nvim 0.11
			-- { "<leader>k", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { noremap = true, silent = true } },

			{ "grs", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true } },

            -- default mapping since nvim 0.11
			-- { "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { noremap = true, silent = true } },
			-- { "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { noremap = true, silent = true } },
			{ "<leader>ldq", "<cmd>lua vim.diagnostic.setloclist()<CR>", { noremap = true, silent = true } },
			{ "<leader>ldc", "<cmd>lua vim.diagnostic.disable()<CR>", { noremap = true, silent = true } },
			{ "<leader>lda", "<cmd>lua vim.diagnostic.enable()<CR>", { noremap = true, silent = true } },

			{ "<leader>lr", "<cmd>LspRestart<CR>", { noremap = true, silent = true } },

			-- https://github.com/folke/snacks.nvim/blob/main/docs/rename.md#snacksrenamerename_file
			{
				"<leader>rr",
				"<cmd>lua Snacks.rename.rename_file()<CR>",
				{ noremap = true, silent = true, desc = "Rename file" },
			},

			{ "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { noremap = true, silent = true } },
			{ "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { noremap = true, silent = true } },
			{
				"<space>wl",
				"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
				{ noremap = true, silent = true },
			},
		},
		-- config = function()
		-- 	local nvim_lsp = require("lspconfig")
		-- 	local util = require("lspconfig/util")
		--
		-- 	function Rename_file()
		-- 		local source_file, target_file
		--
		-- 		source_file = vim.api.nvim_buf_get_name(0)
		-- 		vim.ui.input({
		-- 			prompt = "New filename: ",
		-- 			completion = "file",
		-- 			default = source_file,
		-- 		}, function(input)
		-- 			target_file = input
		-- 		end)
		--
		-- 		vim.lsp.util.rename(source_file, target_file)
		-- 	end
		--
		-- 	-- Filter/modify the way how specific diagonistics are shown.
		-- 	vim.lsp.handlers["textDocument/publishDiagnostics"] = function(_, result, ctx, ...)
		-- 		local client = vim.lsp.get_client_by_id(ctx.client_id)
		--
		-- 		-- https://github.com/jose-elias-alvarez/typescript.nvim/issues/19#issuecomment-1193335686
		-- 		-- if client and client.name == "tsserver" then
		-- 		if client and client.name == "ts_ls" then
		-- 			result.diagnostics = vim.tbl_filter(function(diagnostic)
		-- 				return not diagnostic.message:find("is declared but its value is never read.")
		-- 			end, result.diagnostics)
		-- 		end
		--
		-- 		return vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx, ...)
		-- 	end
		--
		-- 	-- Markdown
		-- 	nvim_lsp.marksman.setup({})
		--
		-- 	-- JSON
		-- 	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#jsonls
		-- 	local json_capabilities = vim.lsp.protocol.make_client_capabilities()
		-- 	json_capabilities.textDocument.completion.completionItem.snippetSupport = true
		-- 	nvim_lsp.jsonls.setup({
		-- 		capabilities = json_capabilities,
		-- 	})
		--
		-- 	-- CDS
		-- 	nvim_lsp.cds_lsp.setup({})
		--
		-- 	-- Bash
		-- 	nvim_lsp.bashls.setup({})
		--
		-- 	-- Python: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
		-- 	nvim_lsp.pyright.setup({
		-- 		before_init = function(params)
		-- 			params.processId = vim.NIL
		-- 		end,
		-- 		-- Note: lspcontainers does not work with pipenv yet (21-05-13).
		-- 		-- cmd = require'lspcontainers'.command('pyright'),
		-- 		root_dir = util.root_pattern(".git", vim.fn.getcwd()),
		-- 		-- -- https://github.com/hrsh7th/nvim-cmp
		-- 		-- capabilities = require("cmp_nvim_lsp").default_capabilities(
		-- 		-- 	vim.lsp.protocol.make_client_capabilities()
		-- 		-- ),
		-- 		capablities = require("blink.cmp").get_lsp_capabilities(),
		-- 		settings = {
		-- 			python = {
		-- 				analysis = {
		-- 					-- Allow relative imports of files in a subdirectory 'app'.
		-- 					extraPaths = { "app" },
		-- 				},
		-- 			},
		-- 		},
		-- 	})
		--
		-- 	-- Docker
		-- 	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#dockerls
		-- 	nvim_lsp.dockerls.setup({
		-- 		before_init = function(params)
		-- 			params.processId = vim.NIL
		-- 		end,
		-- 		-- -- https://github.com/hrsh7th/nvim-cmp
		-- 		-- capabilities = require("cmp_nvim_lsp").default_capabilities(
		-- 		-- 	vim.lsp.protocol.make_client_capabilities()
		-- 		-- ),
		-- 		capablities = require("blink.cmp").get_lsp_capabilities(),
		-- 		-- cmd = require'lspcontainers'.command('dockerls'),
		-- 		root_dir = util.root_pattern(".git", vim.fn.getcwd()),
		-- 	})
		--
		-- 	-- SQL
		-- 	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sqlls
		-- 	nvim_lsp.sqlls.setup({
		-- 		-- capabilities = require("cmp_nvim_lsp").default_capabilities(
		-- 		-- 	vim.lsp.protocol.make_client_capabilities()
		-- 		-- ),
		-- 		capablities = require("blink.cmp").get_lsp_capabilities(),
		-- 	})
		--
		-- 	-- Lua https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#lua_ls
		-- 	local runtime_path = vim.split(package.path, ";")
		-- 	table.insert(runtime_path, "lua/?.lua")
		-- 	table.insert(runtime_path, "lua/?/init.lua")
		-- 	nvim_lsp.lua_ls.setup({
		-- 		cmd = {
		-- 			"/opt/lua-language-server/bin/Linux/lua-language-server",
		-- 			"-E",
		-- 			"/opt/lua-language-server/bin/Linux/main.lua",
		-- 		},
		-- 		-- -- https://github.com/hrsh7th/nvim-cmp
		-- 		-- capabilities = require("cmp_nvim_lsp").default_capabilities(
		-- 		-- 	vim.lsp.protocol.make_client_capabilities()
		-- 		-- ),
		-- 		capablities = require("blink.cmp").get_lsp_capabilities(),
		-- 		-- Add 'vim' to globals to prevent message 'Undefined global `vim`.'
		-- 		-- https://www.reddit.com/r/neovim/comments/khk335/lua_configuration_global_vim_is_undefined/gglrg7k?utm_source=share&utm_medium=web2x&context=3
		-- 		settings = {
		-- 			Lua = {
		-- 				runtime = {
		-- 					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
		-- 					version = "LuaJIT",
		-- 					-- Setup your lua path
		-- 					path = runtime_path,
		-- 				},
		-- 				diagnostics = {
		-- 					-- Get the language server to recognize the `vim` global
		-- 					globals = { "vim" },
		-- 				},
		-- 				workspace = {
		-- 					-- Make the server aware of Neovim runtime files
		-- 					library = vim.api.nvim_get_runtime_file("", true),
		-- 					-- fix: Do you need to configure your work environment as `LÖVE`?
		-- 					-- https://github.com/sumneko/lua-language-server/issues/783#issuecomment-1042800532
		-- 					checkThirdParty = false,
		-- 					-- fix: "Preloaded files has reached an upper limit..."
		-- 					-- https://github.com/sumneko/lua-language-server/issues/1594
		-- 					maxPreload = 3000,
		-- 				},
		-- 				-- Do not send telemetry data containing a randomized but unique identifier
		-- 				telemetry = {
		-- 					enable = false,
		-- 				},
		-- 			},
		-- 		},
		-- 	})
		--
		-- 	-- TODO: Migrate to vtsls
		-- 	-- JavaScript/TypeScript
		-- 	-- https://github.com/jose-elias-alvarez/typescript.nvim
		-- 	-- local buf_map = function(bufnr, mode, lhs, rhs, opts)
		-- 	-- 	vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
		-- 	-- 		silent = true,
		-- 	-- 	})
		-- 	-- end
		-- 	-- language server is deprecated, see https://github.com/jose-elias-alvarez/typescript.nvim/issues/80
		-- 	-- serch for an alternative when required
		-- 	-- require("typescript").setup({
		-- 	-- 	disable_commands = false, -- prevent the plugin from creating Vim commands
		-- 	-- 	debug = false, -- enable debug logging for commands
		-- 	-- 	go_to_source_definition = {
		-- 	-- 		fallback = true, -- fall back to standard LSP definition on failure
		-- 	-- 	},
		-- 	-- 	server = { -- pass options to lspconfig's setup method
		-- 	-- 		on_attach = function(client, bufnr)
		-- 	-- 			client.server_capabilities.document_formatting = false
		-- 	-- 			client.server_capabilities.document_range_formatting = false
		-- 	-- 			buf_map(bufnr, "n", "<leader>ro", ":TypescriptOrganizeImports<CR>")
		-- 	-- 			buf_map(bufnr, "n", "<leader>rr", ":TypescriptRenameFile<CR>")
		-- 	-- 			buf_map(bufnr, "n", "gd", ":TypescriptGoToSourceDefinition<CR>")
		-- 	-- 		end,
		-- 	-- 	},
		-- 	-- })
		--
		-- 	-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#svelte
		-- 	nvim_lsp.svelte.setup({})
		--
		-- 	-- Rust
		-- 	nvim_lsp.rust_analyzer.setup({})
		--
		-- 	-- Yaml
		-- 	-- sudo pacman -S yaml-language-server
		-- 	nvim_lsp.yamlls.setup({
		-- 		settings = {
		-- 			yaml = {
		-- 				keyOrdering = false,
		-- 			},
		-- 		},
		-- 	})
		--
		-- 	-- xml
		-- 	-- installed through Mason
		-- 	nvim_lsp.lemminx.setup({})
		--
		-- 	-- https://templ.guide/commands-and-tools/ide-support
		-- 	nvim_lsp.templ.setup({})
		-- 	nvim_lsp.html.setup({
		-- 		filetypes = { "html", "templ" },
		-- 	})
		-- 	nvim_lsp.htmx.setup({
		-- 		filetypes = { "html", "templ" },
		-- 	})
		-- 	nvim_lsp.tailwindcss.setup({
		-- 		filetypes = { "templ", "astro", "javascript", "typescript", "react" },
		-- 		init_options = { userLanguages = { templ = "html" } },
		-- 	})
		--
		-- 	-- Rounded borders for help windows (hover and signature help).
		-- 	-- Source: https://vi.stackexchange.com/a/39075
		-- 	-- The highlight for FloatBorder is defined in /home/xi3k/.config/nvim/after/plugin/colorscheme.lua
		-- 	local _border = "rounded"
		-- 	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		-- 		border = "rounded",
		-- 	})
		-- 	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		-- 		border = _border,
		-- 	})
		-- 	vim.diagnostic.config({
		-- 		float = { border = _border },
		-- 	})
		-- end,
	},
}
