
function MenuCallbackHandler:banghud_menu_callback(item)
	local optionName = item._parameters.name
	local value = item:value()
	if item._type == "toggle" then
		value = (value == "on") -- convert to boolean
	end
	BangHUD:SetOption(optionName, value)
end
