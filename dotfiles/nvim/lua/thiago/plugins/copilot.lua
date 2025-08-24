return {
	"copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	after = function()
		require("copilot").setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				hide_during_completion = false,
				keymap = {
					accept = "<Tab>",
					next = "<C-n>",
					previous = "<C-p>",
				},
			},
		})
	end,
}
