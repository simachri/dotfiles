local M = {}

function M.setup()
	local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
	local home = os.getenv("HOME")
	local workspace_dir = home .. "/.local/share/jdtls/" .. project_name

	local bundles = {
		vim.fn.glob(
			home
				.. "/Development/Neovim/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar"
		),
	}
	vim.list_extend(
		bundles,
		vim.split(vim.fn.glob(home .. "/Development/Neovim/vscode-java-test/server/*.jar", 1), "\n")
	)

	local path_to_mason = home .. "/.local/share/nvim/mason"
	local path_to_jdtls = path_to_mason .. "/packages/jdtls"
	local lombok_path = home .. "/Development/Neovim/java-lombok/lombok_1.18.32.jar"

	local on_attach = function(_, bufnr)
		require("jdtls.dap").setup_dap({ hotcodereplace = "auto" })
		-- require("dap.ext.vscode").load_launchjs()

		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<leader>li",
			-- jdtls.organize_imports,
			"<cmd>lua require('jdtls').organize_imports()<CR>",
			{ desc = "Java Organize Imports", noremap = true, silent = true }
		)

		-- vim.keymap.set("n", "<leader>df", jdtls.test_class, opts)
		-- vim.keymap.set("n", "<leader>dn", jdtls.test_nearest_method, opts)
		-- vim.keymap.set("n", "crv", jdtls.extract_variable, opts)
		-- vim.keymap.set("v", "crm", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]], opts)
		-- vim.keymap.set("n", "crc", jdtls.extract_constant, opts)
	end

	local jdtls_settings = {
		java = {
			references = {
				includeDecompiledSources = true,
			},
			format = {
				enabled = false, -- use conform.nvim instead
				-- settings = {
				-- 	url = home .. "/Development/Neovim/google/styleguide/eclipse-java-google-style.xml",
				-- 	profile = "GoogleStyle",
				-- },
			},
			eclipse = {
				downloadSources = true,
			},
			maven = {
				downloadSources = true,
			},
			signatureHelp = { enabled = true },
			contentProvider = { preferred = "fernflower" },
			-- eclipse = {
			-- 	downloadSources = true,
			-- },
			-- implementationsCodeLens = {
			-- 	enabled = true,
			-- },
			completion = {
				favoriteStaticMembers = {
					"org.hamcrest.MatcherAssert.assertThat",
					"org.hamcrest.Matchers.*",
					"org.hamcrest.CoreMatchers.*",
					"org.junit.jupiter.api.Assertions.*",
					"java.util.Objects.requireNonNull",
					"java.util.Objects.requireNonNullElse",
					"org.mockito.Mockito.*",
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org",
				},
			},
			sources = {
				organizeImports = {
					starThreshold = 9999,
					staticStarThreshold = 9999,
				},
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
					-- flags = {
					-- 	allow_incremental_sync = true,
					-- },
				},
				useBlocks = true,
			},
			-- configuration = {
			--     runtimes = {
			--         {
			--             name = "java-17-openjdk",
			--             path = "/usr/lib/jvm/default-runtime/bin/java"
			--         }
			--     }
			-- }
			-- project = {
			-- 	referencedLibraries = {
			-- 		"**/lib/*.jar",
			-- 	},
			-- },
		},
	}

	local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
	extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

	local config = {
		on_attach = on_attach,
		capabilities = {
			workspace = {
				configuration = true,
			},
			textDocument = {
				completion = {
					completionItem = {
						snippetSupport = true,
					},
				},
			},
		},

		-- Good example config:
		-- https://github.com/mfussenegger/dotfiles/blob/833d634251ebf3bf7e9899ed06ac710735d392da/vim/.config/nvim/ftplugin/java.lua#L1-L149
		cmd = {
			"java", -- or '/path/to/java17_or_newer/bin/java'
			"-Declipse.application=org.eclipse.jdt.ls.core.id1",
			"-Dosgi.bundles.defaultStartLevel=4",
			"-Declipse.product=org.eclipse.jdt.ls.core.product",
			"-Dlog.protocol=true",
			"-Dlog.level=ALL",
			"-Xmx1g",
			"-javaagent:" .. lombok_path,
			"--add-modules=ALL-SYSTEM",
			"--add-opens",
			"java.base/java.util=ALL-UNNAMED",
			"--add-opens",
			"java.base/java.lang=ALL-UNNAMED",

			"-jar",
			vim.fn.glob(path_to_jdtls .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
			-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
			-- Must point to the                                                     Change this to
			-- eclipse.jdt.ls installation                                           the actual version

			"-configuration",
			path_to_jdtls .. "/config_linux",
			-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
			-- Must point to the                      Change to one of `linux`, `win` or `mac`
			-- eclipse.jdt.ls installation            Depending on your system.

			-- 💀
			-- See `data directory configuration` section in the README
			"-data",
			workspace_dir,
		},

		-- 💀
		-- This is the default if not provided, you can remove it. Or adjust as needed.
		-- One dedicated LSP server & client will be started per unique root_dir
		root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

		-- Here you can configure eclipse.jdt.ls specific settings
		-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
		-- for a list of options
		settings = jdtls_settings,

		-- Language server `initializationOptions`
		-- You need to extend the `bundles` with paths to jar files
		-- if you want to use additional eclipse.jdt.ls plugins.
		--
		-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
		--
		-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
		init_options = {
			bundles = bundles,
			extendedClientCapabilities = extendedClientCapabilities,
		},
	}

	require("jdtls").start_or_attach(config)
end

return M
