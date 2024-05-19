return {
	"nvim-telescope/telescope.nvim",
	config = function()
		telescope = require("telescope.builtin");

		vim.keymap.set("n", "<leader>pf", telescope.find_files, {})
		vim.keymap.set("n", "<leader>ps", function()
			telescope.grep_string({ search = vim.fn.input("Search: ") })
		end)
	end,
	dependencies = {
		"nvim-lua/plenary.nvim"
	}
}
