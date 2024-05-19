return {
	"dundalek/lazy-lsp.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"VonHeikemen/lsp-zero.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip"
	},
	config = function()
		local lsp_zero = require("lsp-zero")

		lsp_zero.on_attach(function(client, bufnr)
			-- see :help lsp-zero-keybindings to learn the available actions
			lsp_zero.default_keymaps({
				buffer = bufnr,
				preserve_mappings = false
			})

			for _, set in pairs({
				{"rn", vim.lsp.buf.rename},
				{"ca", vim.lsp.buf.code_action}
			}) do
				local key, fun = unpack(set);
				vim.keymap.set("n", "<leader>" .. key, fun, {buffer = bufnr, remap = false});
			end
		end)

		local cmp = require("cmp");
		cmp.setup({
			mapping = cmp.mapping.preset.insert({
				["<enter>"] = cmp.mapping.confirm({ select = true })
			})
		})

		require("lazy-lsp").setup {}
	end,
}
