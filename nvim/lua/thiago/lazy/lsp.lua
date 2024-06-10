return {
	"VonHeikemen/lsp-zero.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		local lsp_zero = require("lsp-zero")

		lsp_zero.on_attach(function(_, bufnr)
			-- see :help lsp-zero-keybindings to learn the available actions
			lsp_zero.default_keymaps({
				buffer = bufnr,
				preserve_mappings = false,
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
				["lanaguge_server.diagnostics_on_save"] = false,
				["language_server_phpstan.enabled"] = false,
				["language_server_psalm.enabled"] = false,
			},
		})

		-- c and cpp
		lspcfg.ccls.setup({})

		-- python
		lspcfg.pyright.setup({})
		lspcfg.ruff_lsp.setup({})

		-- css
		lspcfg.tailwindcss.setup({})
		lspcfg.cssls.setup({})

		lspcfg.tsserver.setup({}) -- typescript
		lspcfg.rust_analyzer.setup({}) -- rust
		lspcfg.yamlls.setup({}) -- yaml
		lspcfg.lua_ls.setup({}) -- lua
		lspcfg.nixd.setup({}) -- nix
	end,
}
