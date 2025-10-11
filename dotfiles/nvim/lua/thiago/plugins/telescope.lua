local function t()
	return require("telescope.builtin")
end

return {
	"telescope.nvim",
	on_require = "telescope",
	load = function(name)
		vim.cmd.packadd(name)
		vim.cmd.packadd("telescope-live-grep-args.nvim")
	end,
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
}
