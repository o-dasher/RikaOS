return {
	"cord.nvim",
	lazy = false,
	after = function()
		local status = function(verb)
			return function(opts)
				local lang = opts.type == "language" and opts.tooltip
				return (lang and lang ~= "Unknown" and lang ~= "New file") and (verb .. " " .. vim.trim(lang))
					or "Working on projects"
			end
		end

		require("cord").setup({
			editor = { tooltip = "Neovim" },
			display = { view = "auto" },
			idle = { details = "Working on projects", state = "Idling" },
			text = {
				default = "Working on projects",
				workspace = function(opts)
					local lang = opts.type == "language" and opts.tooltip
					return (lang and lang ~= "Unknown" and lang ~= "New file") and "Working on projects" or ""
				end,
				editing = status("Editing"),
				viewing = status("Viewing"),
			},
		})
	end,
}
