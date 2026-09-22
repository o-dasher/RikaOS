return {
	"nvim-lint",
	event = "BufRead",
	after = function()
		local lint = require("lint")

		lint.linters.cppcheck.args = vim.list_extend({
			"--enable=all",
			"--inconclusive",
			"--check-level=exhaustive",
			"--force",
			"--suppress=missingIncludeSystem",
			"--suppress=unusedFunction",
		}, lint.linters.cppcheck.args or {})

		lint.linters.clangtidy.args = {
			"--quiet",
			"-p",
			function()
				local root = vim.fs.root(0, { "CMakeLists.txt", ".clang-tidy", ".git" })
				local build = (root or ".") .. "/build"
				return vim.uv.fs_stat(build .. "/compile_commands.json") and build or (root or ".")
			end,
		}

		lint.linters_by_ft = {
			rust = { "clippy" },
			c = { "clangtidy", "cppcheck" },
			cpp = { "clangtidy", "cppcheck" },
			cmake = { "cmake_lint" },
			markdown = { "markdownlint" },
			python = { "ruff" },
			php = { "phpstan" },
			yaml = { "yamllint" },
			sh = { "shellcheck" },
			bash = { "shellcheck" },
			nix = { "statix", "deadnix" },
		}

		local function linter_is_available(linter)
			local command = linter.cmd
			if type(command) == "function" then
				command = command()
			end
			return type(command) == "string" and vim.fn.executable(command) == 1
		end

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
			callback = function()
				-- Skip linters supplied by a dev shell that is not currently active.
				require("lint").try_lint(nil, {
					filter = linter_is_available,
				})
			end,
		})
	end,
}
