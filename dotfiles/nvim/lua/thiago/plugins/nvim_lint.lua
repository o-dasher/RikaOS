return {
	"nvim-lint",
	event = "BufRead",
	after = function()
		local lint = require("lint")

		lint.linters.cppcheck.args = vim.list_extend({ "--check-level=exhaustive" }, lint.linters.cppcheck.args)
		lint.linters_by_ft = {
			rust = { "clippy" },
			c = { "clangtidy", "cppcheck" },
			cpp = { "clangtidy", "cppcheck" },
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
