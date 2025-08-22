return {
	{
		"MunifTanjim/nui.nvim",
		dep_of = {
			"avante",
		},
		after = function()
			require("nui").setup()
		end,
	},
	{
		"zbirembau/copilot.lua",
		event = "InsertEnter",
		after = function()
			require("copilot").setup({})
		end,
		dep_of = { "avante" },
	},
	{
		"avante-nvim",
		after = function()
			require("avante_lib").load()
			require("avante").setup({
				provider = "copilot",
			})
		end,
	},
}
