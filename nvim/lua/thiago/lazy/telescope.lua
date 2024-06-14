local function t()
	return require("telescope.builtin")
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
	},
	keys = {
		{
			"<leader>pf",
			function()
				t().find_files()
			end,
		},
		{
			"<leader>ps",
			function()
				t().live_grep()
			end,
		},
		{
			"<leader>pw",
			function()
				require("telescope-live-grep-args.shortcuts").grep_word_under_cursor()
			end,
		},
	},
}
