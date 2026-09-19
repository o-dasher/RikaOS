return {
	"typst-preview.nvim",
	ft = { "typst" },
	cmd = { "TypstPreview", "TypstPreviewToggle", "TypstPreviewStop" },
	after = function()
		require("typst-preview").setup({})
	end,
}
