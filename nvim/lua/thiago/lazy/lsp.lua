return {
	"dundalek/lazy-lsp.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"VonHeikemen/lsp-zero.nvim",
		"hrsh7th/nvim-cmp",
	},
	opts = {
		excluded_servers = {
			"ccls",                    -- prefer clangd
			"denols",                  -- prefer eslint and tsserver
			"docker_compose_language_service", -- yamlls should be enough?
			"flow",                    -- prefer eslint and tsserver
			"ltex",                    -- grammar tool using too much CPU
			"quick_lint_js",           -- prefer eslint and tsserver
			"scry",                    -- archived on Jun 1, 2023
		},
		preferred_servers = {
			markdown = {},
			nix = { "nixd" },
		},
	},
	config = function(_, opts)
		local lsp_zero = require("lsp-zero")

		lsp_zero.on_attach(function(_, bufnr)
			-- see :help lsp-zero-keybindings to learn the available actions
			lsp_zero.default_keymaps({
				buffer = bufnr,
				preserve_mappings = false
			})

			for _, set in pairs({
				{ "vd", vim.diagnostic.open_float },
				{ "rn", vim.lsp.buf.rename },
				{ "ca", vim.lsp.buf.code_action }
			}) do
				local key, fun = unpack(set);
				vim.keymap.set("n", "<leader>" .. key, fun, { buffer = bufnr, remap = false });
			end
		end)

		require("lazy-lsp").setup(opts)
	end
}
