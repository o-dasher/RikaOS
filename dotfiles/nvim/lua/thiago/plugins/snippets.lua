return {
	{
		"luasnip",
		event = "InsertEnter",
		after = function()
			local ls = require("luasnip")

			require("luasnip.loaders.from_vscode").lazy_load()
			ls.config.setup({})

			vim.keymap.set({ "i", "s" }, "<M-n>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end)
		end,
		dep_of = "blink.cmp",
	},
	{
		"friendly-snippets",
		dep_of = { "luasnip" },
	},
}
