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
			mode = "n",
		}
	},
	opts = {
		formatters_by_ft = {
			nix = { "nixfmt" }
		}
	}
}
