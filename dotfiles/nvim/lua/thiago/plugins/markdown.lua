return {
	"render-markdown.nvim",
	ft = "markdown",
	after = function()
		require("render-markdown").setup()
	end,
}
