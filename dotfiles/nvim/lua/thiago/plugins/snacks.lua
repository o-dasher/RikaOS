return {
	"snacks.nvim",
	priority = 1000,
	lazy = false,
	after = function()
		require("snacks").setup({
			bigfile = { enabled = true },
			dashboard = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			notify = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			scroll = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			notifier = { enabled = true },
		})
		vim.api.nvim_create_autocmd("LspProgress", {
			callback = function(ev)
				local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
				vim.notify(vim.lsp.status(), "info", {
					id = "lsp_progress",
					title = "LSP Progress",
					opts = function(notif)
						notif.icon = ev.data.params.value.kind == "end" and " "
							or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
					end,
				})
			end,
		})
	end,
}
