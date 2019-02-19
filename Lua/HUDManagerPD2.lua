BangHUD:DoLuaFile("HUDBangHUD")

local _setup_ingame_hud_saferect_original = HUDManager._setup_ingame_hud_saferect
local set_teammate_health_original = HUDManager.set_teammate_health
local set_teammate_condition_original = HUDManager.set_teammate_condition
local set_stamina_value_original = HUDManager.set_stamina_value
local set_max_stamina_original = HUDManager.set_max_stamina

function HUDManager:_setup_ingame_hud_saferect(...)
	local result = _setup_ingame_hud_saferect_original(self, ...)
	self._hud_banghud = HUDBangHUD:new(managers.hud:script(PlayerBase.INGAME_HUD_SAFERECT))
	return result
end

function HUDManager:set_teammate_health(i, data, ...)
	local result = set_teammate_health_original(self, i, data, ...)
	if self._hud_banghud and i == HUDManager.PLAYER_PANEL then
		self._hud_banghud:set_health(data)
	end
	return result
end

function HUDManager:set_stamina_value(value, ...)
	local result = set_stamina_value_original(self, value, ...)
	if self._hud_banghud then
		self._hud_banghud:set_stamina(value)
	end
	return result
end

function HUDManager:set_max_stamina(value, ...)
	local result = set_max_stamina_original(self, value, ...)
	if self._hud_banghud then
		self._hud_banghud:set_max_stamina(value)
	end
	return result
end

function HUDManager:set_teammate_condition(i, ...)
	local result = set_teammate_condition_original(self, i, ...)
	if self._hud_banghud and i == HUDManager.PLAYER_PANEL then
		self._hud_banghud:update_status()
	end
	return result
end
