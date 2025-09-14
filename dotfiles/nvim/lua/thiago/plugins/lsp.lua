return {
	{
		"neovim/nvim-lspconfig.nvim",
		event = "BufRead",
		cmd = {
			"LspInfo",
		},
		after = function()
			local capabilities = require("blink.cmp").get_lsp_capabilities()
			local lspcfg = require("lspconfig")

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = function(event)
					local opts = { buffer = event.buf }

					for _, set in pairs({
						{ "vd", vim.diagnostic.open_float },
						{ "vr", vim.lsp.buf.references },
						{ "rn", vim.lsp.buf.rename },
						{ "ca", vim.lsp.buf.code_action },
						{ "gd", vim.lsp.buf.definition },
						{ "gD", vim.lsp.buf.declaration },
						{ "gi", vim.lsp.buf.type_definition },
						{ "gs", vim.lsp.buf.signature_help },
					}) do
						local key, fun = unpack(set)
						vim.keymap.set("n", "<leader>" .. key, fun, opts)
					end
				end,
			})

			-- yaml
			lspcfg.yamlls.setup({ capabilities = capabilities })

			-- php
			lspcfg.intelephense.setup({ capabilities = capabilities })
			lspcfg.phpactor.setup({
				capabilities = capabilities,
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
			lspcfg.ccls.setup({ capabilities = capabilities })

			-- python
			lspcfg.pyright.setup({ capabilities = capabilities })
			lspcfg.ruff.setup({ capabilities = capabilities })

			-- css
			lspcfg.tailwindcss.setup({ capabilities = capabilities })
			lspcfg.cssls.setup({ capabilities = capabilities })

			-- Typescript
			lspcfg.ts_ls.setup({ capabilities = capabilities })
			lspcfg.biome.setup({ capabilities = capabilities })

			lspcfg.svelte.setup({ capabilities = capabilities }) -- svelte
			lspcfg.yamlls.setup({ capabilities = capabilities }) -- yaml
			lspcfg.nixd.setup({ capabilities = capabilities }) -- nix
			lspcfg.texlab.setup({ capabilities = capabilities }) -- tex

			-- Rust
			lspcfg.rust_analyzer.setup({ capabilities = capabilities })

			-- dotnet
			lspcfg.omnisharp.setup({
				capabilities = capabilities,

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
				capabilities = capabilities,
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
	},
}
