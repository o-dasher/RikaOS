local function h()
	return require("harpoon")
end

local keys = {
	{
		"<leader>a",
		function()
			h():list():add()
		end,
	},
	{
		"<leader>h",
		function()
			h().ui:toggle_quick_menu(h():list())
		end,
	},
}

for i = 1, 5, 1 do
	table.insert(keys, {
		"<leader>" .. i .. ">",
		function()
			h():list():select(i)
		end,
	})
end

return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = "nvim-lua/plenary.nvim",
	keys = keys,
	config = function()
		h():setup()
	end,
}
