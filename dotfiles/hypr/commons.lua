-- Logging
hl.env("AQ_TRACE", "0")
hl.env("HYPRLAND_TRACE", "0")

-- Primary GPU: dynamically detect and prioritize dedicated GPU over integrated GPU.
local cards = {}
for _, id in ipairs({ "03:00.0", "11:00.0" }) do
	local p = io.popen("readlink -e /dev/dri/by-path/pci-0000:" .. id .. "-card 2>/dev/null")
	if p then
		local card = p:read("*l")
		p:close()
		if card and card ~= "" then
			cards[#cards + 1] = card
		end
	end
end

if #cards > 0 then
	hl.env("AQ_DRM_DEVICES", table.concat(cards, ":"))
end

hl.config({
	cursor = {
		no_hardware_cursors = 1,
	},
})

require("monitors")
