local enable_format_on_save = false
local format_on_save_table = {}

if enable_format_on_save then
	format_on_save_table = {
		timeout_ms = 1000,
		lsp_fallback = true,
	}
end

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
		format_on_save = format_on_save_table,
		formatters_by_ft = {
			nix = { "nixfmt" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			lua = { "stylua" },
			php = { "pint" },
			markdown = { "prettierd" },
		},
	},
}
