return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			ensure_installed = {
				"markdown_inline",
			},
			highlight = {
				enable = true,
			},
		})
	end,
}
