vim.api.nvim_command("source " .. "~/.config/nvim/lua/thiago/set.vim")

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
	vim.opt.guifont = { "JetbrainsMono Nerd Font", ":h12" }
else
	local use_cli_transparency = false
	if use_cli_transparency then
		local alphahls = { "Normal", "NormalFloat" }
		for _, hi in pairs(alphahls) do
			vim.api.nvim_set_hl(0, hi, { bg = "none" })
		end
	end
end
