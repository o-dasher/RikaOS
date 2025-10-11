local function t()
	return require("telescope.builtin")
end

return {
	{
		"telescope-live-grep-args.nvim",
		dep_of = "telescope.nvim",
	},
	{
		"telescope.nvim",
		on_require = "telescope",
		after = function(_, _)
			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-k>"] = actions.cycle_history_prev,
							["<C-j>"] = actions.cycle_history_next,
						},
					},
				},
			})

			telescope.load_extension("live_grep_args")
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
		dep_of = { "harpoon2" },
	},
}
