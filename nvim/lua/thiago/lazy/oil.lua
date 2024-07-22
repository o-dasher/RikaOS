return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"<Leader>pv",
			"<CMD>Oil<CR>",
		},
	},
	opts = {
		default_file_explorer = true,
		columns = { "icon" },
		view_options = {
			show_hidden = true,
		},
	},
}
