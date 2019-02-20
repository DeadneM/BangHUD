BangHUD:DoLuaFile("OutlineText")

HUDBangHUD = HUDBangHUD or class()

function HUDBangHUD:init(hud) --public
	self._hud_panel = hud.panel

	if self._hud_panel:child("banghud_panel") then
		self._hud_panel:remove(self._hud_panel:child("banghud_panel"))
	end

	self._banghud_panel = self._hud_panel:panel({
		name = "banghud_panel",
		layer = 1
	})
	self._banghud_panel:set_size(self._banghud_panel:parent():w(), self._banghud_panel:parent():h())
	self._banghud_panel:set_center(self._banghud_panel:parent():w() / 2, self._banghud_panel:parent():h() / 2)

	self._texture_sidelen = 512
	local stamina_texture = "core/textures/hub_elements_df"
	local health_texture = "core/textures/gradient_radial"
	local border_texture = "core/textures/default_texture_01_df"
	local font = "ui/fonts/lato_regular_22_mf"

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

	-- STAMINA
	self._stamina_panel = self._banghud_panel:panel()
	self._stamina_arc_bg = self._banghud_panel:bitmap({
		name = "stamina_arc_bg",
		texture = border_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "normal",
		layer = 0
	})
	self._stamina_fade_arc = self._stamina_panel:bitmap({
		name = "stamina_fade_arc",
		texture = stamina_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 1
	})
	self._stamina_arc = self._stamina_panel:bitmap({
		name = "stamina_arc",
		texture = stamina_texture,
		color = Color.white,
		w = self._texture_sidelen,
		h = self._texture_sidelen,
		blend_mode = "add",
		render_template = "VertexColorTexturedRadial",
		layer = 2
	})

	-- REVIVES
	self._revives = self:_max_revives()
	self._revives_counter = OutlineText:new(self._banghud_panel, {
		text = self._revives,
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

	-- get settings
	local swap = BangHUD:GetOption("swap_bars")
	local scale = BangHUD:GetOption("bars_scale") / 3
	local margin = BangHUD:GetOption("center_margin")
	local alpha = BangHUD:GetOption("bars_alpha") / 2
	local bg_alpha = BangHUD:GetOption("background_alpha")
	local x_offset = BangHUD:GetOption("x_offset")
	local y_offset = BangHUD:GetOption("y_offset")

	-- update scale/sizes
	self._stamina_arc:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._health_arc:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._stamina_fade_arc:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._health_fade_arc:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._stamina_arc_bg:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)
	self._health_arc_bg:set_size(self._texture_sidelen * scale, self._texture_sidelen * scale)

	-- update x position and textures
	if swap then
		self._stamina_arc:set_center_x(self._banghud_panel:w() / 2 - margin / 2 + x_offset)
		self._health_arc:set_center_x(self._banghud_panel:w() / 2 + margin / 2 + x_offset)
		self._stamina_fade_arc:set_center_x(self._banghud_panel:w() / 2 - margin / 2 + x_offset)
		self._health_fade_arc:set_center_x(self._banghud_panel:w() / 2 + margin / 2 + x_offset)
		self._stamina_arc:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._health_arc:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._stamina_fade_arc:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._health_fade_arc:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._stamina_arc_bg:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._health_arc_bg:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
	else
		self._stamina_arc:set_center_x(self._banghud_panel:w() / 2 + margin / 2 + x_offset)
		self._health_arc:set_center_x(self._banghud_panel:w() / 2 - margin / 2 + x_offset)
		self._stamina_fade_arc:set_center_x(self._banghud_panel:w() / 2 + margin / 2 + x_offset)
		self._health_fade_arc:set_center_x(self._banghud_panel:w() / 2 - margin / 2 + x_offset)
		self._stamina_arc:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._health_arc:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._stamina_fade_arc:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._health_fade_arc:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
		self._stamina_arc_bg:set_texture_rect(self._texture_sidelen, 0, -self._texture_sidelen, self._texture_sidelen)
		self._health_arc_bg:set_texture_rect(0, 0, self._texture_sidelen, self._texture_sidelen)
	end

	-- update y position
	self._stamina_arc:set_center_y(self._banghud_panel:h() / 2 + y_offset)
	self._health_arc:set_center_y(self._banghud_panel:h() / 2 + y_offset)
	self._stamina_fade_arc:set_center_y(self._banghud_panel:h() / 2 + y_offset)
	self._health_fade_arc:set_center_y(self._banghud_panel:h() / 2 + y_offset)
	self._stamina_arc_bg:set_center(self._stamina_arc:center())
	self._health_arc_bg:set_center(self._health_arc:center())

	-- update revive counter position
	self._revives_counter:set_top(self._health_arc:top())
	if swap then
		self._revives_counter:set_right(self._health_arc:right())
		self._revives_counter:set_align("right")
	else
		self._revives_counter:set_left(self._health_arc:left())
		self._revives_counter:set_align("left")
	end

	-- update alpha
	self._stamina_panel:set_alpha(alpha)
	self._health_panel:set_alpha(alpha)
	self._stamina_arc_bg:set_alpha(bg_alpha)
	self._health_arc_bg:set_alpha(bg_alpha)

	-- update values
	self:_update_health()
	self:_update_stamina()
	self:_update_revives()
end

-- CORE

function HUDBangHUD:_round(val, dec)
	dec = math.pow(10, dec or 0)
	val = val * dec
	val = val >= 0 and math.floor(val + 0.5) or math.ceil(val - 0.5)
	return val / dec
end

function HUDBangHUD:_check_player_state()
	local state = managers.player:current_state() or "empty"
	return state ~= "bleed_out" and state ~= "fatal" and state ~= "incapacitated"
	-- other possible states are:
	-- standard, parachuting, freefall, carry, carry_corpse, bipod, turret, foxhole, tased, driving
end

function HUDBangHUD:update_status() --public
	self._banghud_panel:set_visible(self:_check_player_state())
end

-- HEALTH

function HUDBangHUD:_health_percentage()
	local value = 1
	if self._health_data then
		value = self._health_data.current / self._health_data.total
	end
	return math.clamp(value, 0, 1)
end

function HUDBangHUD:_update_health()
	self._health_panel:stop()
	self._health_arc:set_position_z(0.5 + self:_health_percentage() * 0.5)
	self._health_panel:animate(callback(self, self, "_health_animation"))
end

function HUDBangHUD:_health_animation(panel)
	local duration = BangHUD:GetOption("health_animation_time")
	local t = duration
	local health_arc = panel:child("health_arc")
	local health_fade_arc = panel:child("health_fade_arc")
	local final_pos = health_arc:position_z()
	local distance = health_fade_arc:position_z() - final_pos
	while t > 0 do
		t = t - coroutine.yield()
		health_fade_arc:set_position_z(t / duration * distance + final_pos)
	end
	health_fade_arc:set_position_z(final_pos)
end

function HUDBangHUD:set_health(data) --public
	self._health_data = data
	self:_update_health()
end

-- REVIVES

function HUDBangHUD:_max_revives()
	return tweak_data.player:get_tweak_data_for_class(managers.skilltree:get_character_profile_class() or "recon").damage.BASE_LIVES + managers.player:upgrade_value("player", "additional_lives", 0)
end

function HUDBangHUD:_update_revives()
	self._revives_counter:set_text(self._revives)
	self._revives_counter:set_color(math.lerp(Color(1, 1, 0.2, 0), Color.white, math.clamp(self._revives / self:_max_revives(), 0, 1)))
	self._revives_counter:set_visible(BangHUD:GetOption("show_revives"))
	self._revives_counter:set_alpha(BangHUD:GetOption("revives_alpha"))
end

function HUDBangHUD:set_revives(value) --public
	self._revives = value - 1
	self:_update_revives()
end

-- STAMINA

function HUDBangHUD:_stamina_percentage()
	if self._stamina and self._max_stamina then
		return math.clamp(self._stamina / self._max_stamina, 0, 1)
	else
		return 0
	end
end

function HUDBangHUD:_update_stamina()
	self._stamina_panel:stop()
	self._stamina_arc:set_position_z(0.5 + self:_stamina_percentage() * 0.5)
	self._stamina_panel:animate(callback(self, self, "_stamina_animation"))
end

function HUDBangHUD:_stamina_animation(panel)
	local duration = BangHUD:GetOption("stamina_animation_time")
	local t = duration
	local stamina_arc = panel:child("stamina_arc")
	local stamina_fade_arc = panel:child("stamina_fade_arc")
	local final_pos = stamina_arc:position_z()
	local distance = stamina_fade_arc:position_z() - final_pos
	while t > 0 do
		t = t - coroutine.yield()
		stamina_fade_arc:set_position_z(t / duration * distance + final_pos)
	end
	stamina_fade_arc:set_position_z(final_pos)
end

function HUDBangHUD:set_max_stamina(value) --public
	self._max_stamina = value
end

function HUDBangHUD:set_stamina(value) --public
	self._stamina = value
	self:_update_stamina()
end
