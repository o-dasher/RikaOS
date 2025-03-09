return {
	{
		"rcarriga/nvim-notify",
		enabled = true,
		lazy = false,
		opts = {
			fps = 60,
			background_colour = "#000000",
			render = "default",
			timeout = 1000,
			topDown = true,
		},
		keys = {
			{
				"<leader>dn",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "[D]ismiss [N]otifications",
			},
		},
	},
}
