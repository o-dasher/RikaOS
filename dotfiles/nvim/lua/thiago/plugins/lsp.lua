return {
	"nvim-lspconfig",
	event = { "BufReadPre", "BufReadPost", "BufNewFile" },
	cmd = {
		"LspInfo",
	},
	after = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf }

				for _, set in pairs({
					{ "vd", vim.diagnostic.open_float },
					{ "vr", vim.lsp.buf.references },
					{ "rn", vim.lsp.buf.rename },
					{ "ca", vim.lsp.buf.code_action },
					{ "gd", vim.lsp.buf.definition },
					{ "gD", vim.lsp.buf.declaration },
					{ "gi", vim.lsp.buf.type_definition },
					{ "gs", vim.lsp.buf.signature_help },
				}) do
					local key, fun = unpack(set)
					vim.keymap.set("n", "<leader>" .. key, fun, opts)
				end
			end,
		})

		vim.lsp.enable({
			"yamlls", -- yaml

			-- php
			"intelephense",
			"phpactor",

			"clangd", -- C and cpp

			-- python
			"pyright",
			"ruff",

			-- css
			"tailwindcss",
			"cssls",

			-- nix
			"statix",
			"nixd",

			-- typescript
			"ts_ls",
			"biome",

			"svelte", -- svelte
			"yamlls", -- yaml
			"texlab", -- tex

			"lua_ls", -- lua
			"omnisharp", -- dotnet
		})
	end,
}
