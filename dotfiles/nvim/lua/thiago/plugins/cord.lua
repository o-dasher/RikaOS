local function get_language(opts)
	if not opts then
		return nil
	end
	if opts.tooltip and opts.tooltip ~= "" and opts.tooltip ~= "Unknown" and opts.tooltip ~= "New file" then
		return vim.trim(opts.tooltip)
	end
	if opts.filetype and opts.filetype ~= "" and opts.filetype ~= "Cord.unknown" and opts.filetype ~= "Cord.new" then
		return opts.filetype
	end
	return nil
end

return {
	"cord.nvim",
	lazy = false,
	after = function()
		require("cord").setup({
			editor = {
				client = "neovim",
				tooltip = "Neovim",
			},
			display = {
				theme = "default",
				flavor = "dark",
				view = "auto",
				swap_fields = false,
				swap_icons = false,
			},
			idle = {
				enabled = true,
				show_status = true,
				details = "Working on projects",
				state = "Idling",
				tooltip = "💤",
			},
			text = {
				default = "Working on projects",
				workspace = function(opts)
					if opts and opts.type == "dashboard" then
						return ""
					end
					if opts and opts.type == "language" and not get_language(opts) then
						return ""
					end
					return "Working on projects"
				end,
				viewing = function(opts)
					local lang = get_language(opts)
					return lang and ("Viewing " .. lang) or "Working on projects"
				end,
				editing = function(opts)
					local lang = get_language(opts)
					return lang and ("Editing " .. lang) or "Working on projects"
				end,
				file_browser = "Browsing files",
				plugin_manager = "Managing plugins",
				lsp = "Configuring LSP",
				docs = "Reading documentation",
				vcs = "Version control",
				notes = "Taking notes",
				debug = "Debugging",
				test = "Testing",
				diagnostics = "Fixing diagnostics",
				games = "Playing",
				terminal = "In terminal",
				dashboard = "Working on projects",
			},
			buttons = nil,
			advanced = {
				discord = {
					reconnect = {
						enabled = true,
					},
				},
			},
		})
	end,
}
