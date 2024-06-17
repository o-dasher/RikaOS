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
			local finder = function()
				local paths = {}
				for _, item in ipairs(h():list().items) do
					table.insert(paths, item.value)
				end

				return require("telescope.finders").new_table({
					results = paths,
				})
			end

			local telescope_cfg = require("telescope.config")

			require("telescope.pickers")
				.new({}, {
					prompt_title = "harpoon",
					finder = finder(),
					initial_mode = "normal",
					previewer = telescope_cfg.values.file_previewer({}),
					sorter = telescope_cfg.values.generic_sorter({}),
					attach_mappings = function(buffer, map)
						map("n", "<c-d>", function()
							local state = require("telescope.actions.state")

							local selected_entry = state.get_selected_entry()
							local current_picker = state.get_current_picker(buffer)

							table.remove(h():list().items, selected_entry.index)
							current_picker:refresh(finder())
						end)
						return true
					end,
				})
				:find()
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
	"theprimeagen/harpoon",
	branch = "harpoon2",
	dependencies = "nvim-lua/plenary.nvim",
	keys = keys,
	config = function()
		h():setup()
	end,
}
