return {
	"rose-pine/neovim",
	name = "rose-pine",
	lazy = false;
	priority = 1000;
	config = function()
		vim.cmd.colorscheme("rose-pine");

		local alphahls = {"Normal", "NormalFloat"}
		for _, hi in pairs(alphahls) do
			vim.api.nvim_set_hl(0, hi, { bg = "none" })
		end
	end
}
