local function t()
	return require("telescope.builtin")
end

return {
	"nvim-telescope/telescope.nvim",
	after = function(_, _)
		local actions = require("telescope.actions")
		require("telescope").setup({
			defaults = {
				mappings = {
					i = {
						["<C-k>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.cycle_history_next,
					},
				},
			},
		})
	end,
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
