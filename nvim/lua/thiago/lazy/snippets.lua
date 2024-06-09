return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			local ls = require("luasnip")
			ls.filetype_extend("javascript", { "jsdoc" })
		end,
	},
}
