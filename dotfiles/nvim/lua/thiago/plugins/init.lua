require("lze").load({
	{ import = "thiago.plugins.comment" },
	{ import = "thiago.plugins.completions" },
	{ import = "thiago.plugins.lsp" },
	{ import = "thiago.plugins.conform" },
	{ import = "thiago.plugins.fidget" },
	{ import = "thiago.plugins.harpoon" },
	{ import = "thiago.plugins.lazygit" },
	{ import = "thiago.plugins.lint" },
	{ import = "thiago.plugins.markdown" },
	{ import = "thiago.plugins.oil" },
	{ import = "thiago.plugins.snacks" },
	{ import = "thiago.plugins.snippets" },
	{ import = "thiago.plugins.telescope" },
	{ import = "thiago.plugins.treesitter" },
	{ import = "thiago.plugins.vimtex" },
	{
		"nvim-lua/plenary.nvim",
		dep_of = { "harpoon", "lazygit", "telescope" },
	},
	{ "nvim-tree/nvim-web-devicons", dep_of = { "oil" } },
	{ "nvim-telescope/telescope-live-grep-args.nvim", dep_of = "telescope" },
})
