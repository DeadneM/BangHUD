
BangHUDMenu = BangHUDMenu or class(BLTMenu)

function BangHUDMenu:Init(root)
	self:Title({
		text = "banghud",
	})
	self:Label({
		text = nil,
		localize = false,
		h = 8,
	})
	self:Toggle({
		name = "swap_bars",
		text = "swap_bars",
		value = BangHUD._data.swap_bars,
		callback = callback(self, self, "swap_bars"),
	})
	self:SubTitle({text = "", localize = false}) -- subtitle
	self:Slider({
		name = "bars_scale",
		text = "bars_scale",
		value = BangHUD._data.bars_scale,
		min = 0.1,
		max = 2,
		callback = callback(self, self, "bars_scale"),
	})
	self:Slider({
		name = "center_margin",
		text = "center_margin",
		value = BangHUD._data.center_margin,
		min = 0,
		max = 1000,
		callback = callback(self, self, "center_margin"),
	})
	self:Slider({
		name = "x_offset",
		text = "x_offset",
		value = BangHUD._data.x_offset,
		min = -1000,
		max = 1000,
		callback = callback(self, self, "x_offset"),
	})
	self:Slider({
		name = "y_offset",
		text = "y_offset",
		value = BangHUD._data.y_offset,
		min = -1000,
		max = 1000,
		callback = callback(self, self, "y_offset"),
	})
	self:SubTitle({text = "", localize = false}) -- subtitle
	self:Slider({
		name = "bars_alpha",
		text = "bars_alpha",
		value = BangHUD._data.bars_alpha,
		min = 0,
		max = 1,
		callback = callback(self, self, "bars_alpha"),
	})
	self:Slider({
		name = "background_alpha",
		text = "background_alpha",
		value = BangHUD._data.background_alpha,
		min = 0,
		max = 1,
		callback = callback(self, self, "background_alpha"),
	})
	self:Slider({
		name = "health_animation_time",
		text = "health_animation_time",
		value = BangHUD._data.health_animation_time,
		min = 0,
		max = 10,
		callback = callback(self, self, "health_animation_time"),
	})
	self:Slider({
		name = "stamina_animation_time",
		text = "stamina_animation_time",
		value = BangHUD._data.stamina_animation_time,
		min = 0,
		max = 10,
		callback = callback(self, self, "stamina_animation_time"),
	})
	self:SubTitle({text = "", localize = false}) -- subtitle
	self:Toggle({
		name = "show_revives",
		text = "show_revives",
		value = BangHUD._data.show_revives,
		callback = callback(self, self, "show_revives"),
	})
	self:Slider({
		name = "revives_alpha",
		text = "revives_alpha",
		value = BangHUD._data.revives_alpha,
		min = 0,
		max = 1,
		callback = callback(self, self, "revives_alpha"),
	})
	self:SubTitle({text = "", localize = false}) -- subtitle
	self:Toggle({
		name = "show_warcry",
		text = "show_warcry",
		value = BangHUD._data.show_warcry,
		callback = callback(self, self, "show_warcry"),
	})
	self:Slider({
		name = "warcry_alpha",
		text = "warcry_alpha",
		value = BangHUD._data.warcry_alpha,
		min = 0,
		max = 1,
		callback = callback(self, self, "warcry_alpha"),
	})
	self:LongRoundedButton2({
		name = "banghud_reset",
		text = "banghud_reset",
		localize = true,
		callback = callback(self, self, "Reset"),
		ignore_align = true,
		y = 832,
		x = 1472,
	})
end

function BangHUDMenu:swap_bars(value)
	BangHUD._data.swap_bars = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:bars_scale(value)
	BangHUD._data.bars_scale = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:center_margin(value)
	BangHUD._data.center_margin = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:x_offset(value)
	BangHUD._data.x_offset = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:y_offset(value)
	BangHUD._data.y_offset = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:bars_alpha(value)
	BangHUD._data.bars_alpha = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:background_alpha(value)
	BangHUD._data.background_alpha = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:health_animation_time(value)
	BangHUD._data.health_animation_time = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:stamina_animation_time(value)
	BangHUD._data.stamina_animation_time = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:show_revives(value)
	BangHUD._data.show_revives = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:revives_alpha(value)
	BangHUD._data.revives_alpha = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:show_warcry(value)
	BangHUD._data.show_warcry = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:warcry_alpha(value)
	BangHUD._data.warcry_alpha = value
	BangHUD:OptionChanged()
end

function BangHUDMenu:Reset(value, item)
	QuickMenu:new(
		managers.localization:text("banghud_reset"),
		managers.localization:text("banghud_reset_confirm"),
		{
			[1] = {
				text = managers.localization:text("dialog_no"),
				is_cancel_button = true,
			},
			[2] = {
				text = managers.localization:text("dialog_yes"),
				callback = function()
					BangHUD:LoadDefaults()
					self:ReloadMenu()
					BangHUD:OptionChanged()
				end,
			},
		},
		true
	)
end

function BangHUDMenu:Close()
	BangHUD:Save()
end

Hooks:Add("MenuComponentManagerInitialize", "BangHUD.MenuComponentManagerInitialize", function(self)
	RaidMenuHelper:CreateMenu({
		name = "BangHUD_options",
		name_id = "banghud",
		inject_menu = "blt_options",
		class = BangHUDMenu
	})
end)
