return {
	"stevearc/oil.nvim",
	keys = {
		{
			"<Leader>pv",
			"<CMD>Oil<CR>",
		},
	},
	lazy = false,
	after = function()
		require("oil").setup({
			default_file_explorer = true,
			columns = { "icon" },
			view_options = {
				show_hidden = true,
			},
		})
	end,
}
