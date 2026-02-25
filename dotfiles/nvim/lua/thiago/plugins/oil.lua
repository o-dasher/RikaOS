return {
	"oil.nvim",
	lazy = false,
	keys = {
		{
			"<Leader>pv",
			"<CMD>Oil<CR>",
		},
	},
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
