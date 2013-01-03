local _, ns = ...

local frame = CreateFrame("Frame", nil, InterfaceOptionsFramePanelContainer)
frame.name = "Peddler"
frame:Hide()

frame:SetScript("OnShow", function(self)
	self:CreateOptions()
	self:SetScript("OnShow", nil)
end)

local function createCheckBox(parent, anchor, number, property, label, tooltip)
	local checkbox = CreateFrame("CheckButton", "PeddlerCheckBox" .. number, parent, "ChatConfigCheckButtonTemplate")
	checkbox:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 16, number * -26)

	local checkboxLabel =_G[checkbox:GetName() .. "Text"]
	checkboxLabel:SetText(label)
	checkboxLabel:SetPoint("TOPLEFT", checkbox, "RIGHT", 5, 7)

	checkbox.tooltip = tooltip
	checkbox:SetChecked(property)

	return checkbox
end

local function changeModifierKey(self)
	UIDropDownMenu_SetSelectedID(ModifierKeyDropDown, self:GetID())
	ModifierKey = self.value
end

local function initModifierKeys(self, level)
	local modifierKeys = {"CTRL", "ALT", "SHIFT"}
	for index, modifierKey in pairs(modifierKeys) do
		local modifierKeyOption = UIDropDownMenu_CreateInfo()
		modifierKeyOption.text = modifierKey
		modifierKeyOption.value = modifierKey
		modifierKeyOption.func = changeModifierKey
		UIDropDownMenu_AddButton(modifierKeyOption)

		if modifierKey == ModifierKey then
			UIDropDownMenu_SetSelectedID(ModifierKeyDropDown, index)
		end
	end
end

function frame:CreateOptions()
	local title = self:CreateFontString(nil, nil, "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("Peddler")

	local sellLimit = createCheckBox(self, title, 1, SellLimit, "Sell Limit", "Limits the amount of items sold in one go, so you may buy all items back.")
	sellLimit:SetScript("PostClick", function(self, button, down)
		SellLimit = self:GetChecked()
	end)

	local silentMode = createCheckBox(self, title, 2, Silent, "Silent Mode", "Silence chat output about prices and sold item information.")
	silentMode:SetScript("PostClick", function(self, button, down)
		Silent = self:GetChecked()
	end)

	local modifierKeyLabel = self:CreateFontString(nil, nil, "GameFontNormal")
	modifierKeyLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 16, -90)
	modifierKeyLabel:SetText("Modifier Key (used with right-click to mark/unmark items):")

	local modifierKey = CreateFrame("Button", "ModifierKeyDropDown", self, "UIDropDownMenuTemplate")
	modifierKey:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 16, -110)
	UIDropDownMenu_Initialize(ModifierKeyDropDown, initModifierKeys)
	UIDropDownMenu_SetWidth(ModifierKeyDropDown, 90);
	UIDropDownMenu_SetButtonWidth(ModifierKeyDropDown, 90)

	local autoSellLabel = self:CreateFontString(nil, nil, "GameFontNormal")
	autoSellLabel:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 16, -160)
	autoSellLabel:SetText("Automatically sell...")

	local autoSellSoulboundOnly = createCheckBox(self, title, 6, SoulboundOnly, "Restrict to Soulbound Items", "Only allow Peddler to automatically mark soulbound items for sale (does not restrict grey items, naturally).")
	autoSellSoulboundOnly:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 120, -155)
	autoSellSoulboundOnly:SetScript("PostClick", function(self, button, down)
		SoulboundOnly = self:GetChecked()
		ns.markWares()
	end)

	local autoSellGreyItems = createCheckBox(self, title, 7, AutoSellGreyItems, "Poor Items", "Automatically sells all grey/junk items.")
	autoSellGreyItems:SetScript("PostClick", function(self, button, down)
		AutoSellGreyItems = self:GetChecked()
		ns.markWares()
	end)

	local autoSellWhiteItems = createCheckBox(self, title, 8, AutoSellWhiteItems, "Common Items", "Automatically sells all white/common items.")
	autoSellWhiteItems:SetScript("PostClick", function(self, button, down)
		AutoSellWhiteItems = self:GetChecked()
		ns.markWares()
	end)

	local autoSellGreenItems = createCheckBox(self, title, 9, AutoSellGreenItems, "Uncommon Items", "Automatically sells all green/uncommon items.")
	autoSellGreenItems:SetScript("PostClick", function(self, button, down)
		AutoSellGreenItems = self:GetChecked()
		ns.markWares()
	end)

	local autoSellBlueItems = createCheckBox(self, title, 10, AutoSellBlueItems, "Rare Items", "Automatically sells all blue/rare items.")
	autoSellBlueItems:SetScript("PostClick", function(self, button, down)
		AutoSellBlueItems = self:GetChecked()
		ns.markWares()
	end)

	local autoSellPurpleItems = createCheckBox(self, title, 11, AutoSellPurpleItems, "Epic Items", "Automatically sells all purple/epic items.")
	autoSellPurpleItems:SetScript("PostClick", function(self, button, down)
		AutoSellPurpleItems = self:GetChecked()
		ns.markWares()
	end)

	local autoSellUnwantedItems = createCheckBox(self, title, 12, AutoSellUnwantedItems, "Unwanted Items", "Automatically sell all items which are unwanted for your current class (e.g. Priests don't want plate gear, so all plate gear will be marked).")
	autoSellUnwantedItems:SetScript("PostClick", function(self, button, down)
		AutoSellUnwantedItems = self:GetChecked()
		ns.markWares()
	end)

	self:refresh()
end

InterfaceOptions_AddCategory(frame)

-- Handling Peddler's options.
SLASH_PEDDLER_COMMAND1 = '/peddler'
SlashCmdList['PEDDLER_COMMAND'] = function(command)
	InterfaceOptionsFrame_OpenToCategory('Peddler')
end