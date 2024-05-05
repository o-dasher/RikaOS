return {
	"nvim-telescope/telescope.nvim",
	config = function(plugin)
		local plugin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>pf", plugin.find_files, {})
		vim.keymap.set("n", "<leader>ps", function()
			plugin.grep_string({ search = vim.fn.input("Search: ") })
		end)
	end,
	dependencies = {
		"nvim-lua/plenary.nvim"
	}
}
