return {
	"oil.nvim",
	lazy = false, -- Default file explorer != lazy
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
