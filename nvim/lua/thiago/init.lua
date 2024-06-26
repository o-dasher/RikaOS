require("thiago.remap")
require("thiago.set")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = "thiago.lazy",
})

local alphahls = { "Normal", "NormalFloat" }
for _, hi in pairs(alphahls) do
	vim.api.nvim_set_hl(0, hi, { bg = "none" })
end
