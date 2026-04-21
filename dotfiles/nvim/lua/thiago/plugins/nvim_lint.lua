return {
	"nvim-lint",
	event = "BufRead",
	after = function()
		require("lint").linters_by_ft = {
			rust = { "clippy" },
			c = { "clangtidy" },
			cpp = { "clangtidy" },
			python = { "ruff" },
			php = { "phpstan" },
			yaml = { "yamllint" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			nix = { "statix" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				-- try_lint without arguments runs the linters defined in `linters_by_ft`
				-- for the current filetype
				require("lint").try_lint()
			end,
		})
	end,
}
