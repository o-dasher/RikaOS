vim.api.nvim_command("source " .. "~/.config/nvim/lua/thiago/set.vim")

require("thiago.plugins")

if vim.g.neovide then
	vim.g.neovide_transparency = 0.9
else
	local alphahls = { "Normal", "NormalFloat" }
	for _, hi in pairs(alphahls) do
		vim.api.nvim_set_hl(0, hi, { bg = "none" })
	end
end
