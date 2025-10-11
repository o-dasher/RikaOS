return {
	"nvim-treesitter",
	event = "DeferredUIEnter",
	after = function()
		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
			},
		})
	end,
	dep_of = {
		"markdown",
	},
}
