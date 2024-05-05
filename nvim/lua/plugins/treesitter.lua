return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"typescript",
				"rust",
				"vim",
				"lua"
			},
			auto_install = false,
			highlight = {
				enable = true
			}
		})
	end
}
