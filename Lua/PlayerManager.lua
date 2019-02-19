
local _change_player_state_original = PlayerManager._change_player_state

function PlayerManager:_change_player_state(...)
	local result = _change_player_state_original(self, ...)
	if managers.hud and managers.hud._hud_banghud then
		managers.hud._hud_banghud:update_status()
	end
	return result
end
