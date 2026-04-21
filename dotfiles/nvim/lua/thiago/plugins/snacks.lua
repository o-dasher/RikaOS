local function s()
	return require("snacks")
end

return {
	"snacks.nvim",
	priority = 1000,
	lazy = false,
	keys = {
		{
			"<leader>lg",
			function()
				s().lazygit()
			end,
			desc = "LazyGit",
		},
		{
			"<leader>pf",
			function()
				s().picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>ps",
			function()
				s().picker.grep()
			end,
			desc = "Grep",
		},
		{
			"<leader>pw",
			function()
				s().picker.grep_word()
			end,
			desc = "Grep Word",
		},
	},
	after = function()
		local opts = {
			bigfile = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			notify = { enabled = true },
			quickfile = { enabled = true },
			scope = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			notifier = { enabled = true },
			picker = {
				enabled = true,
				win = {
					input = {
						keys = {
							["<c-k>"] = { "history_back", mode = { "i", "n" } },
							["<c-j>"] = { "history_forward", mode = { "i", "n" } },
						},
					},
				},
			},
		}

		if not vim.g.neovide then
			opts.scroll = { enabled = true }
			opts.animate = { enabled = true }
		end

		s().setup(opts)
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
