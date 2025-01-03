return {
	"VonHeikemen/lsp-zero.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
	},
	event = "BufRead",
	cmd = {
		"LspInfo",
	},
	config = function()
		local lsp_zero = require("lsp-zero")

		lsp_zero.on_attach(function(_, bufnr)
			-- see :help lsp-zero-keybindings to learn the available actions
			lsp_zero.default_keymaps({
				buffer = bufnr,
				preserve_mappings = false,
				omit = { "gl", "<F2>", "<F3>", "<F4>" },
			})

			for _, set in pairs({
				{ "vd", vim.diagnostic.open_float },
				{ "vr", vim.lsp.buf.references },
				{ "rn", vim.lsp.buf.rename },
				{ "ca", vim.lsp.buf.code_action },
			}) do
				local key, fun = unpack(set)
				vim.keymap.set("n", "<leader>" .. key, fun, { buffer = bufnr, remap = false })
			end
		end)

		local lspcfg = require("lspconfig")

		-- php
		lspcfg.intelephense.setup({})
		lspcfg.phpactor.setup({
			-- We only use phpactor for code actions and rename
			init_options = {
				["language_server.diagnostics_on_update"] = false,
				["language_server.diagnostics_on_open"] = false,
				["language_server.diagnostics_on_save"] = false,
				["language_server_phpstan.enabled"] = false,
				["language_server_psalm.enabled"] = false,
			},
		})

		-- c and cpp
		lspcfg.ccls.setup({})

		-- python
		lspcfg.pyright.setup({})
		lspcfg.ruff.setup({})

		-- css
		lspcfg.tailwindcss.setup({})
		lspcfg.cssls.setup({})

		lspcfg.ts_ls.setup({}) -- typescript
		-- lspcfg.rust_analyzer.setup({}) -- rust using rustacean
		lspcfg.yamlls.setup({}) -- yaml
		lspcfg.nixd.setup({}) -- nix
		lspcfg.texlab.setup({}) -- tex

		-- dotnet
		lspcfg.omnisharp.setup({
			cmd = {
				vim.fn.expand("~") .. "/.nix-profile/bin/OmniSharp",
				"--languageserver",
				"--hostPID",
				tostring(vim.fn.getpid()),
			},

			settings = {
				FormattingOptions = {
					-- Enables support for reading code style, naming convention and analyzer
					-- settings from .editorconfig.
					EnableEditorConfigSupport = true,
					-- Specifies whether 'using' directives should be grouped and sorted during
					-- document formatting.
					OrganizeImports = nil,
				},
				RoslynExtensionsOptions = {
					-- Enables support for roslyn analyzers, code fixes and rulesets.
					EnableAnalyzersSupport = true,
					-- Enables support for showing unimported types and unimported extension
					-- methods in completion lists. When committed, the appropriate using
					-- directive will be added at the top of the current file. This option can
					-- have a negative impact on initial completion responsiveness,
					-- particularly for the first few completion sessions after opening a
					-- solution.
					EnableImportCompletion = false, -- when I get an ssd I may change.
				},
				Sdk = {
					-- Specifies whether to include preview versions of the .NET SDK when
					-- determining which version to use for project loading.
					IncludePrereleases = true,
				},
			},
		})

		-- lua
		lspcfg.lua_ls.setup({
			settings = {
				Lua = {
					runtime = { version = "Lua 5.1" },
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
	end,
}
