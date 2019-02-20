
BangHUD = BangHUD or {}
if not BangHUD.setup then
	BangHUD.setup = true

	BangHUD._path = ModPath
	BangHUD._core_path = ModPath .. "Core/"
	BangHUD._options_file = SavePath .. "BangHUD.json"
	BangHUD._options = {}

	function BangHUD:Save()
		local file = io.open(self._options_file, "w+")
		if file then
			file:write(json.encode(self._options))
			file:close()
		end
	end

	function BangHUD:Load()
		self:LoadDefaults()
		local file = io.open(self._options_file, "r")
		if file then
			local settings = json.decode(file:read("*all"))
			file:close()
			if settings ~= nil and type(settings) == "table" then
				for k, v in pairs(settings) do
					self._options[k] = v
				end
			end
		end
	end

	function BangHUD:GetOption(id)
		return self._options[id]
	end

	function BangHUD:SetOption(id, value)
		if self._options[id] ~= value then
			self._options[id] = value
			self:OptionChanged()
		end
	end

	function BangHUD:OptionChanged()
		self:Save()
		if managers and managers.hud and managers.hud._hud_banghud then
			managers.hud._hud_banghud:update()
		end
	end

	function BangHUD:LoadDefaults()
		local default_file = io.open(self._path .. "default_values.json")
		self._options = json.decode(default_file:read("*all"))
		default_file:close()
	end

	function BangHUD:Require(fileName)
		dofile(BangHUD._core_path .. fileName .. ".lua")
	end

	BangHUD:Load()
	MenuHelper:LoadFromJsonFile(BangHUD._path .. "Menu/menu.json", BangHUD, BangHUD._options)
end