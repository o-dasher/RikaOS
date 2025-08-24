return {
	"blink.cmp",
	dep_of = { "nvim-lspconfig" },
	lazy = false,
	after = function()
		vim.keymap.set("i", "<C-Space>", function()
			require("blink.cmp").show()
		end, { silent = true })

		require("blink.cmp").setup({
			keymap = {
				preset = "enter",
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			signature = { enabled = true },
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			completion = {
				accept = { auto_brackets = { enabled = true } },
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 250,
					treesitter_highlighting = true,
				},
			},
		})
	end,
}
