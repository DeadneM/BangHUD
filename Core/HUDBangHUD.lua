BangHUD:Require("OutlineText")

HUDBangHUD = HUDBangHUD or class()

function HUDBangHUD:init(hud)
	self._hud_panel = hud.panel

	if self._hud_panel:child("banghud_panel") then
		self._hud_panel:remove(self._hud_panel:child("banghud_panel"))
	end

	self._banghud_panel = self._hud_panel:panel({
		name = "banghud_panel",
		alpha = 0,
		layer = 1
	})
	self._banghud_panel:set_size(self._banghud_panel:parent():w(), self._banghud_panel:parent():h())
	self._banghud_panel:set_center(self._banghud_panel:parent():w() / 2, self._banghud_panel:parent():h() / 2)

	self._texture_sidelen = 512
	local armor_texture = "guis/textures/banghud/arcs/white"
	local health_texture = "guis/textures/banghud/arcs/green"
	local border_texture = "guis/textures/banghud/arcs/border"
	local font = tweak_data.hud_players.name_font

	-- ARMOR

	self._armor_panel = self._banghud_panel:panel()
	self._armor_arc_bg = self._banghud_panel:bitmap({
		name = "armor_arc_bg",
		texture = border_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "normal",
		layer = 0
	})
	self._armor_fade_arc = self._armor_panel:bitmap({
		name = "armor_fade_arc",
		texture = armor_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1
	})
	self._armor_arc = self._armor_panel:bitmap({
		name = "armor_arc",
		texture = armor_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 2
	})
	self._armor_timer = OutlineText:new(self._banghud_panel, {
		text = "0.0s",
		color = Color.white,
		visible = false,
		align = "left",
		vertical = "bottom",
		font = font,
		font_size = 22,
		layer = 3
	})

	-- HEALTH

	self._health_panel = self._banghud_panel:panel()
	self._health_arc_bg = self._banghud_panel:bitmap({
		name = "health_arc_bg",
		texture = border_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "normal",
		layer = 0
	})
	self._health_fade_arc = self._health_panel:bitmap({
		name = "health_fade_arc",
		texture = health_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1
	})
	self._health_arc = self._health_panel:bitmap({
		name = "health_arc",
		texture = health_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 2
	})
	self._invincibility_timer = OutlineText:new(self._banghud_panel, {
		text = "0.0s",
		color = Color(1, 0.7, 0),
		visible = false,
		align = "right",
		vertical = "bottom",
		font = font,
		font_size = 22,
		layer = 3
	})

	-- REVIVES

	self._max_revives = self:_max_revives()
	self._revives = self._max_revives
	self._revives_counter = OutlineText:new(self._banghud_panel, {
		text = (BangHUD:GetOption("show_revives_counter_skull") and utf8.char(57364) or "") .. self._revives,
		color = Color.white,
		align = "right",
		vertical = "top",
		font = font,
		font_size = 22,
		layer = 3
	})

	self:update()
end

function HUDBangHUD:update() --public
	local swap = BangHUD:GetOption("swap_bars")
	local scale = BangHUD:GetOption("bars_scale") / 3
	local margin = BangHUD:GetOption("center_margin")
	local alpha = BangHUD:GetOption("bars_alpha") / 2
	local bg_alpha = BangHUD:GetOption("background_alpha")
	local x_offset = BangHUD:GetOption("x_offset")
	local y_offset = BangHUD:GetOption("y_offset")

	-- update scale/sizes
	local texture_scale = self._texture_sidelen * scale
	self._armor_arc:set_size(texture_scale, texture_scale)
	self._health_arc:set_size(texture_scale, texture_scale)
	self._armor_fade_arc:set_size(texture_scale, texture_scale)
	self._health_fade_arc:set_size(texture_scale, texture_scale)
	self._armor_arc_bg:set_size(texture_scale, texture_scale)
	self._health_arc_bg:set_size(texture_scale, texture_scale)

	-- update x position and textures
	local x_left = self._banghud_panel:w() / 2 - margin / 2 + x_offset
	local x_right = self._banghud_panel:w() / 2 + margin / 2 + x_offset
	if swap then
		self._armor_arc:set_center_x(x_right)
		self._health_arc:set_center_x(x_left)
		self._armor_fade_arc:set_center_x(x_right)
		self._health_fade_arc:set_center_x(x_left)
		self._armor_arc_bg:set_center_x(x_right)
		self._health_arc_bg:set_center_x(x_left)
		self._armor_arc:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._health_arc:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._armor_fade_arc:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._health_fade_arc:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._armor_arc_bg:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._health_arc_bg:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
	else
		self._armor_arc:set_center_x(x_left)
		self._health_arc:set_center_x(x_right)
		self._armor_fade_arc:set_center_x(x_left)
		self._health_fade_arc:set_center_x(x_right)
		self._armor_arc_bg:set_center_x(x_left)
		self._health_arc_bg:set_center_x(x_right)
		self._armor_arc:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._health_arc:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._armor_fade_arc:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._health_fade_arc:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._armor_arc_bg:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._health_arc_bg:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
	end

	-- update y position
	local y_center = self._banghud_panel:h() / 2 + y_offset
	self._armor_arc:set_center_y(y_center)
	self._health_arc:set_center_y(y_center)
	self._armor_fade_arc:set_center_y(y_center)
	self._health_fade_arc:set_center_y(y_center)
	self._armor_arc_bg:set_center_y(y_center)
	self._health_arc_bg:set_center_y(y_center)

	-- update armor timer position
	self._armor_timer:set_bottom(self._armor_arc:bottom())
	if swap then
		self._armor_timer:set_right(self._armor_arc:right())
		self._armor_timer:set_align("right")
	else
		self._armor_timer:set_left(self._armor_arc:left())
		self._armor_timer:set_align("left")
	end

	-- update invincibility timer position
	self._invincibility_timer:set_bottom(self._health_arc:bottom())
	if swap then
		self._invincibility_timer:set_left(self._health_arc:left())
		self._invincibility_timer:set_align("left")
	else
		self._invincibility_timer:set_right(self._health_arc:right())
		self._invincibility_timer:set_align("right")
	end

	-- update revive counter position
	self._revives_counter:set_top(self._health_arc:top())
	if swap then
		self._revives_counter:set_left(self._health_arc:left())
		self._revives_counter:set_align("left")
	else
		self._revives_counter:set_right(self._health_arc:right())
		self._revives_counter:set_align("right")
	end

	-- update alpha
	self._armor_panel:set_alpha(alpha)
	self._health_panel:set_alpha(alpha)
	self._armor_arc_bg:set_alpha(bg_alpha)
	self._health_arc_bg:set_alpha(bg_alpha)

	-- update values
	self:_update_armor()
	self:_update_health()
	self:_update_revives()
	self:update_armor_timer(0)
	self:update_invincibility_timer(0)
end

-- CORE

function HUDBangHUD:_round(val, dec)
	dec = math.pow(10, dec or 0)
	val = val * dec
	val = val >= 0 and math.floor(val + 0.5) or math.ceil(val - 0.5)
	return val / dec
end

function HUDBangHUD:_max_health_reduction()
	return managers.player and managers.player:upgrade_value("player", "max_health_reduction", 1) or 1
end

function HUDBangHUD:_check_player_state()
	if not managers.player
			or not managers.player:player_unit()
			or not managers.player:player_unit():character_damage()
			or managers.player:player_unit():character_damage().swansong then -- cancel if in swansong
		return false
	end
	local state = managers.player:current_state() or "empty"
	return state ~= "bleed_out" and state ~= "fatal" and state ~= "arrested" and state ~= "incapacitated"
	-- other possible states are:
	-- standard, mask_off, tased, clean, civilian, carry, bipod, driving, jerry2, jerry1
end

function HUDBangHUD:_fade_out_animation(panel)
	local duration = BangHUD:GetOption("fade_out_time")
	local t = duration
	panel:set_alpha(1)
	while t > 0 do
		t = t - coroutine.yield()
		panel:set_alpha(math.clamp(t / duration, 0, 1))
	end
	panel:set_alpha(0)
end

function HUDBangHUD:update_status() --public
	self._banghud_panel:set_visible(self:_check_player_state())
end

function HUDBangHUD:update_visbility() --public
	local stealth = managers.groupai and managers.groupai:state() and managers.groupai:state():whisper_mode()
	local behaviour = stealth and BangHUD:GetOption("stealth_behaviour") or BangHUD:GetOption("loud_behaviour")
	local hide = true
	if behaviour == 1 then
		hide = false
	elseif behaviour < 4 then
		hide = self:_armor_percentage() >= 0.99
				and (behaviour == 3 or (self:_health_percentage() >= (BangHUD:GetOption("frenzy_handling") == 3 and (self:_max_health_reduction() - 0.01) or 0.99)))
	end
	if not hide then
		self._banghud_panel:stop()
		self._banghud_panel:set_alpha(1)
	elseif self._banghud_panel:alpha() == 1 then
		self._banghud_panel:stop()
		self._banghud_panel:animate(callback(self, self, "_fade_out_animation"))
	end
end

-- ARMOR

function HUDBangHUD:_armor_percentage()
	local value = 1
	if self._armor_data then
		value = self._armor_data.current / self._armor_data.total
	end
	return math.clamp(value, 0, 1)
end

function HUDBangHUD:_update_armor()
	self._armor_panel:stop()
	self._armor_arc:set_color(Color(1, 0.5 + self:_armor_percentage() * 0.5, 1, 1))
	self._armor_panel:animate(callback(self, self, "_armor_animation"))
	self:update_visbility()
end

function HUDBangHUD:_armor_animation(panel)
	local duration = BangHUD:GetOption("armor_animation_time")
	local t = duration
	local armor_arc = panel:child("armor_arc")
	local armor_fade_arc = panel:child("armor_fade_arc")
	local final_pos = armor_arc:color().r
	local distance = armor_fade_arc:color().r - final_pos
	while t > 0 do
		t = t - coroutine.yield()
		armor_fade_arc:set_color(Color(1, t / duration * distance + final_pos, 1, 1))
	end
	armor_fade_arc:set_color(Color(1, final_pos, 1, 1))
end

function HUDBangHUD:set_armor(data) --public
	self._armor_data = data
	self:_update_armor()
	if data.current > 0 and self:_check_player_state() then
		self._banghud_panel:set_visible(true)
	end
end

-- ARMOR TIMER

function HUDBangHUD:update_armor_timer(t) --public
	if t and t > 0 then
		t = string.format("%.1f", self:_round(t, 1)) .. "s"
		self._armor_timer:set_text(t)
		self._armor_timer:set_visible(true)
	elseif self._armor_timer:visible() then
		self._armor_timer:set_visible(false)
	end
end

-- HEALTH

function HUDBangHUD:_health_percentage()
	local value = 1
	if self._health_data then
		value = self._health_data.current / self._health_data.total
		if BangHUD:GetOption("frenzy_handling") == 2 then
			value = self._health_data.current / (self._health_data.total * self:_max_health_reduction())
		end
	end
	return math.clamp(value, 0, 1)
end

function HUDBangHUD:_update_health()
	self._health_panel:stop()
	self._health_arc:set_color(Color(1, 0.5 + self:_health_percentage() * 0.5, 1, 1))
	self._health_panel:animate(callback(self, self, "_health_animation"))
	self:update_visbility()
end

function HUDBangHUD:_health_animation(panel)
	local duration = BangHUD:GetOption("health_animation_time")
	local t = duration
	local health_arc = panel:child("health_arc")
	local health_fade_arc = panel:child("health_fade_arc")
	local final_pos = health_arc:color().r
	local distance = health_fade_arc:color().r - final_pos
	while t > 0 do
		t = t - coroutine.yield()
		health_fade_arc:set_color(Color(1, t / duration * distance + final_pos, 1, 1))
	end
	health_fade_arc:set_color(Color(1, final_pos, 1, 1))
end

function HUDBangHUD:set_health(data) --public
	self._health_data = data
	self:_update_health()
	if data.current > 0 and self:_check_player_state() then
		self._banghud_panel:set_visible(true)
	end
	if data.revives then
		self._revives = data.revives - 1
		self:_update_revives()
	end
end

-- HEALTH TIMER

function HUDBangHUD:update_invincibility_timer(t) --public
	if t and t > 0 then
		t = string.format("%.1f", self:_round(t, 1)) .. "s"
		self._invincibility_timer:set_text(t)
		self._invincibility_timer:set_visible(true)
	elseif self._invincibility_timer:visible() then
		self._invincibility_timer:set_visible(false)
	end
end

-- REVIVES

function HUDBangHUD:_max_revives()
	return managers.modifiers:modify_value("PlayerDamage:GetMaximumLives", (Global.game_settings.difficulty == "sm_wish" and 2 or tweak_data.player.damage.LIVES_INIT) + managers.player:upgrade_value("player", "additional_lives", 0)) - 1
end

function HUDBangHUD:_update_revives()
	self._revives_counter:set_text((BangHUD:GetOption("show_revives_counter_skull") and utf8.char(57364) or "") .. self._revives)
	self._revives_counter:set_color(math.lerp(Color(1, 1, 0.2, 0), Color.white, math.clamp(self._revives / self._max_revives, 0, 1)))
	self._revives_counter:set_visible(BangHUD:GetOption("show_revives_counter"))
	self._revives_counter:set_alpha(BangHUD:GetOption("revives_counter_alpha"))
end
