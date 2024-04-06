return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
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

		local config = {
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
				"--add-modules=ALL-SYSTEM",
				"--add-opens",
				"java.base/java.util=ALL-UNNAMED",
				"--add-opens",
				"java.base/java.lang=ALL-UNNAMED",

				"-jar",
				vim.fn.glob(
					home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"
				),
				-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
				-- Must point to the                                                     Change this to
				-- eclipse.jdt.ls installation                                           the actual version

				"-configuration",
				"/home/xi3k/.local/share/nvim/mason/packages/jdtls/config_linux",
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
			root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),

			-- Here you can configure eclipse.jdt.ls specific settings
			-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
			-- for a list of options
			settings = {
				java = {},
			},

			-- Language server `initializationOptions`
			-- You need to extend the `bundles` with paths to jar files
			-- if you want to use additional eclipse.jdt.ls plugins.
			--
			-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
			--
			-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
			init_options = {
				bundles = bundles,
			},
		}

		-- This starts a new client & server,
		-- or attaches to an existing client & server depending on the `root_dir`.
		require("jdtls").start_or_attach(config)
	end,

	-- "nvim-java/nvim-java",
	-- dependencies = {
	-- 	"nvim-java/lua-async-await",
	-- 	"nvim-java/nvim-java-core",
	-- 	"nvim-java/nvim-java-test",
	-- 	"nvim-java/nvim-java-dap",
	-- 	"MunifTanjim/nui.nvim",
	-- 	"neovim/nvim-lspconfig",
	-- 	"mfussenegger/nvim-dap",
	-- 	{
	-- 		"williamboman/mason.nvim",
	-- 		opts = {
	-- 			registries = {
	-- 				"github:nvim-java/mason-registry",
	-- 				"github:mason-org/mason-registry",
	-- 			},
	--
	-- 			-- load java debugger plugins
	-- 			java_debug_adapter = {
	-- 				enable = false,
	-- 			},
	--
	-- 			jdk = {
	-- 				-- install jdk using mason.nvim
	-- 				auto_install = false,
	-- 			},
	-- 		},
	-- 	},
	-- },
}
