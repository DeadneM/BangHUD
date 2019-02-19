
local _check_bleed_out_original = PlayerDamage._check_bleed_out
local _regenerated_original = PlayerDamage._regenerated
local band_aid_health_original = PlayerDamage.band_aid_health
--local damage_fall_original = PlayerDamage.damage_fall
--local force_set_revives_original = PlayerDamage.force_set_revives

function PlayerDamage:_check_bleed_out(...)
	local result = _check_bleed_out_original(self, ...)
	if managers.hud and managers.hud._hud_banghud then
		managers.hud._hud_banghud:set_revives(Application:digest_value(self._revives, false))
	end
	return result
end

function PlayerDamage:_regenerated(...)
	local result = _regenerated_original(self, ...)
	if managers.hud and managers.hud._hud_banghud then
		managers.hud._hud_banghud:set_revives(Application:digest_value(self._revives, false))
	end
	return result
end

function PlayerDamage:band_aid_health(...)
	local result = band_aid_health_original(self, ...)
	if managers.hud and managers.hud._hud_banghud then
		managers.hud._hud_banghud:set_revives(Application:digest_value(self._revives, false))
	end
	return result
end

-- damage_fall calls _check_bleed_out, so we alredy covered this case.
--[[function PlayerDamage:damage_fall(...)
	local result = damage_fall_original(self, ...)
	if managers.hud and managers.hud._hud_banghud then
		managers.hud._hud_banghud:set_revives(Application:digest_value(self._revives, false))
	end
	return result
end]]

-- never called
--[[function PlayerDamage:force_set_revives(revives)
	local result = force_set_revives_original(self, ...)
	if managers.hud and managers.hud._hud_banghud then
		managers.hud._hud_banghud:set_revives(Application:digest_value(self._revives, false))
	end
	return result
end]]
