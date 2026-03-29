return {
	"cord.nvim",
	lazy = false,
	after = function()
		require("cord").setup()
	end,
}
