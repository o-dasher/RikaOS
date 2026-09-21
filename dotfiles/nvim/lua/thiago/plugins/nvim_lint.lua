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

		local function linter_is_available(linter)
			local command = linter.cmd
			if type(command) == "function" then
				command = command()
			end
			return type(command) == "string" and vim.fn.executable(command) == 1
		end

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				-- Skip linters supplied by a dev shell that is not currently active.
				require("lint").try_lint(nil, {
					filter = linter_is_available,
				})
			end,
		})
	end,
}
