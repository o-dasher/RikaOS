vim.g.mapleader = " "
vim.cmd("runtime lua/thiago/set.vim")

local lze = require("lze")

lze.load("thiago.plugins")

vim.cmd("colorscheme rose-pine")

vim.g.rustaceanvim = {
	server = {
		on_attach = function(_, bufnr)
			vim.lsp.inlay_hint.enable(true, { bufnr })
		end,
	},
	tools = {
		enable_clippy = true,
	},
}

if vim.g.neovide then
	vim.g.neovide_opacity = 0.9
	vim.o.guifont = "JetBrainsMono Nerd Font:h12"
else
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end
