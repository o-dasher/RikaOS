local function t()
	return require("telescope.builtin")
end

return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
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
	},
}
