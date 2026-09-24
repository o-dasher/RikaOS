return {
	"conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
		},
	},
	after = function()
		require("conform").setup({
			notify_on_error = false,
			notify_no_formatters = false,

			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "fallback",
			},

			default_format_opts = {
				lsp_format = "fallback",
			},

			formatters_by_ft = {
				nix = { "nixfmt" },
				c = { "clang_format" },
				cpp = { "clang_format" },
				cmake = { "cmake_format" },
				javascript = { "biome", "biome-organize-imports" },
				javascriptreact = { "biome", "biome-organize-imports" },
				typescript = { "biome", "biome-organize-imports" },
				typescriptreact = { "biome", "biome-organize-imports" },
				svelte = { "biome" },
				html = { "biome" },
				css = { "biome" },
				lua = { "stylua" },
				php = { "pint", "php_cs_fixer", stop_after_first = true },
				markdown = { "biome" },
				json = { "biome" },
				rust = { "rustfmt" },
				python = { "ruff_format", "ruff_organize_imports" },
				yaml = { "biome" },
				cs = { "csharpier" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				typst = { "typstyle" },
			},
		})
	end,
}
