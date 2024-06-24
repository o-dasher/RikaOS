return {
	"lervag/vimtex",
	ft = { "tex" },
	init = function()
		vim.g["vimtex_view_method"] = "zathura"
		vim.g["vimtex_context_pdf_viewer"] = "zathura"
		vim.g["tex_flavor"] = "latex"
	end,
}
