-- NUMBER LINES --
vim.opt.nu = true
vim.opt.relativenumber = true

-- TAB SIZES --
local tablength = 4

vim.opt.tabstop = tablength
vim.opt.softtabstop = tablength
vim.opt.shiftwidth = tablength
vim.opt.smartindent = true

-- RIGHT COLUMN --
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "80"

-- SEARCH --
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- This is so searches are automatically implied to be case sensitive or not!
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- UNDOS --
vim.opt.swapfile = false
vim.opt.backup = false;
-- I need to study about undo files.

-- SCROLL --
vim.opt.scrolloff = 4
