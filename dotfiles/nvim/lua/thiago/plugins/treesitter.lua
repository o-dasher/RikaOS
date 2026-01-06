return {
	"nvim-treesitter",
	event = "DeferredUIEnter",
	after = function()
		pcall(vim.treesitter.start)
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
	dep_of = {
		"markdown",
	},
}
