return {
	"nvim-treesitter/nvim-treesitter",
	event = "BufRead",
	after = function()
		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
			},
		})
	end,
	dep_of = {
		"markdown",
		"avante",
	},
}
