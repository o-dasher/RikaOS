require("lze").load({
	{ import = "thiago.plugins.blink_cmp" },
	{ import = "thiago.plugins.lsp" },
	{ import = "thiago.plugins.conform" },
	{ import = "thiago.plugins.harpoon" },
	{ import = "thiago.plugins.lazygit" },
	{ import = "thiago.plugins.nvim_lint" },
	{ import = "thiago.plugins.markdown" },
	{ import = "thiago.plugins.oil" },
	{ import = "thiago.plugins.snacks" },
	{ import = "thiago.plugins.snippets" },
	{ import = "thiago.plugins.telescope" },
	{ import = "thiago.plugins.treesitter" },
	{ import = "thiago.plugins.vimtex" },
	{ import = "thiago.plugins.mini" },
	{ import = "thiago.plugins.avante" },
	{
		"plenary.nvim",
		dep_of = { "harpoon", "lazygit", "telescope", "avante" },
	},
	{ "nvim-web-devicons", dep_of = { "oil" } },
	{ "telescope-live-grep-args.nvim", dep_of = "telescope" },
	{
		"rose-pine",
		colorscheme = "rose-pine",
	},
	{
		"rustaceanvim",
		lazy = false, -- This plugin is already lazy
	},
})
