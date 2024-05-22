return {
	"VonHeikemen/lsp-zero.nvim",
	event = "BufReadPost",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/nvim-cmp",
	},
	config = function(_, opts)
		local lsp_zero = require("lsp-zero")

		lsp_zero.on_attach(function(_, bufnr)
			-- see :help lsp-zero-keybindings to learn the available actions
			lsp_zero.default_keymaps({
				buffer = bufnr,
				preserve_mappings = false
			})

			for _, set in pairs({
				{ "vd", vim.diagnostic.open_float },
				{ "rn", vim.lsp.buf.rename },
				{ "ca", vim.lsp.buf.code_action }
			}) do
				local key, fun = unpack(set);
				vim.keymap.set("n", "<leader>" .. key, fun, { buffer = bufnr, remap = false });
			end
		end)
		
		local lspcfg = require("lspconfig")

		lspcfg.rust_analyzer.setup {}
		lspcfg.nixd.setup {}
		lspcfg.tsserver.setup {}
		lspcfg.pyright.setup {}
		lspcfg.phpactor.setup {}
		lspcfg.clangd.setup {}
	end
}
