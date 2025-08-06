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
	after = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 1000,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				nix = { "nixfmt" },
				conformjavascript = { "biome", "biome-organize-imports" },
				javascriptreact = { "biome", "biome-organize-imports" },
				typescript = { "biome", "biome-organize-imports" },
				typescriptreact = { "biome", "biome-organize-imports" },
				html = { "prettierd" },
				css = { "prettierd" },
				lua = { "stylua" },
				php = { "pint" },
				markdown = { "prettierd" },
				json = { "prettierd" },
				rust = { "rustfmt" },
			},
		})
	end,
}
