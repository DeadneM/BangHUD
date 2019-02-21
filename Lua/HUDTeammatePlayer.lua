
local set_warcry_ready_original = HUDTeammatePlayer.set_warcry_ready

function HUDTeammatePlayer:set_warcry_ready(value, ...)
	local result = set_warcry_ready_original(self, value, ...)
	if managers.hud and managers.hud._hud_banghud then
		managers.hud._hud_banghud:set_warcry_ready(value)
	end
	return result
end
