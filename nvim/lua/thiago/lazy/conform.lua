return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
		},
	},
	opts = {
		format_on_save = {
			timeout_ms = 1000,
			lsp_fallback = true,
		},
		formatters_by_ft = {
			nix = { "nixfmt" },
			javascript = { "prettierd" },
			lua = { "stylua" },
			php = { "pint" },
		},
	},
}
