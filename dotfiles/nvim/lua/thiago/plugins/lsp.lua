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

		local servers = {
			"yamlls", -- yaml

			-- php
			"intelephense",
			"phpactor",

			"clangd", -- C and cpp
			"cmake", -- CMake

			-- python
			"pyright",
			"ruff",

			-- css
			"tailwindcss",
			"cssls",
			"html",
			"jsonls",

			-- nix
			"statix",
			"nixd",

			-- typescript
			"ts_ls",
			"biome",

			"svelte", -- svelte
			"texlab", -- tex
			"tinymist", -- typst

			"lua_ls", -- lua
			"marksman", -- markdown
			"omnisharp", -- dotnet
			"bashls", -- bash
		}

		local available_servers = vim.tbl_filter(function(server)
			local ok, mod = pcall(require, "lspconfig.configs." .. server)
			local cmd = (vim.lsp.config[server] or (ok and mod.default_config) or {}).cmd
			local bin = type(cmd) == "table" and cmd[1]
				or (type(cmd) == "function" and (pcall(cmd) and select(2, pcall(cmd))[1]))
			return bin and vim.fn.executable(bin) == 1
		end, servers)

		vim.lsp.enable(available_servers)
	end,
}
