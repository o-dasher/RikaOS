local function setup()
	local lsp = require("lsp-zero")

	lsp.on_attach(function(_, zero_buffer)
		local opts = { buffer = zero_buffer, remap = false }

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

		for _, set in pairs(
			{
				{ "gd", vim.lsp.buf.definition },
				{ "vd", vim.diagnostic.open_float },
				{ "rn", vim.lsp.buf.rename },
				{ "ca", vim.lsp.buf.code_action }
			}
		) do
			local key, fun = unpack(set)
			vim.keymap.set("n", "<leader>" .. key, fun, opts)
		end
	end)

	require("mason").setup({})
	require("mason-lspconfig").setup({
		ensure_installed = {
			"rust_analyzer",
			"tsserver"
		},
		handlers = {
			lsp.default_setup,
			-- Using lsp-zero's lua_ls because it provides the nvim global.
			lua_ls = function()
				local lua_opts = lsp.nvim_lua_ls()
				require('lspconfig').lua_ls.setup(lua_opts)
			end
		}
	})

	local cmp = require("cmp")
	local cmp_select = { behavior = cmp.SelectBehavior.Select }

	cmp.setup({
		sources = {
			{ name = 'path' },
			{ name = 'nvim_lsp' },
		},
		formatting = lsp.cmp_format(),
		mapping = cmp.mapping.preset.insert({
			['<C-n>'] = cmp.mapping.select_prev_item(cmp_select),
			['<C-p>'] = cmp.mapping.select_next_item(cmp_select),
			['<enter>'] = cmp.mapping.confirm({ select = true }),
			['<C-Space>'] = cmp.mapping.complete(),
		}),
	})
end

return {
	"VonHeikemen/lsp-zero.nvim",
	config = setup,
	lazy = false,
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"L3MON4D3/LuaSnip"
	}
}
