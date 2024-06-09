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

		lspcfg = require("lspconfig")

		lspcfg.lua_ls.setup({})
		lspcfg.nixd.setup({})
		lspcfg.phpactor.setup({})
		lspcfg.ccls.setup({})
		lspcfg.pyright.setup({})
		lspcfg.ruff_lsp.setup({})
		lspcfg.yamlls.setup({})
		lspcfg.tailwindcss.setup({})
		lspcfg.cssls.setup({})
		lspcfg.rust_analyzer.setup({})
		lspcfg.tsserver.setup({})
	end,
}
