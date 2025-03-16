return {
	{
		"rafamadriz/friendly-snippets",
		dep_of = { "luasnip" },
		after = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
	{

		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		after = function()
			require("luasnip").setup({
				history = true,
				delete_check_events = "TextChanged",
			})
		end,
	},
}
