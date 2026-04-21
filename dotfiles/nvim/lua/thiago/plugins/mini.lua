local visit_keys = {
	{
		"<leader>a",
		function()
			require("mini.visits").add_path()
		end,
	},
	{
		"<leader>h",
		function()
			require("mini.visits").select_path()
		end,
	},
}

for i = 1, 5, 1 do
	table.insert(visit_keys, {
		"<leader>" .. i .. ">",
		function()
			local paths = require("mini.visits").list_paths()
			if paths[i] then
				vim.cmd("edit " .. paths[i])
			end
		end,
	})
end

return {
	{
		"mini.pairs",
		after = function()
			require("mini.pairs").setup()
		end,
	},
	{
		"mini.icons",
		dep_of = { "oil.nvim", "render-markdown.nvim" },
		after = function()
			require("mini.icons").setup()
			require("mini.icons").mock_nvim_web_devicons()
		end,
	},
	{
		"mini.visits",
		keys = visit_keys,
		after = function()
			require("mini.visits").setup()
		end,
	},
}
