--[[--------------------------------------------------------------------
	PhanxConfig-ColorPicker
	Simple color picker widget generator. Requires LibStub.
	https://github.com/Phanx/PhanxConfig-ColorPicker
	Copyright (c) 2009-2015 Phanx <addons@phanx.net>. All rights reserved.
	Feel free to include copies of this file WITHOUT CHANGES inside World of
	Warcraft addons that make use of it as a library, and feel free to use code
	from this file in other projects as long as you DO NOT use my name or the
	original name of this file anywhere in your project outside of an optional
	credits line -- any modified versions must be renamed to avoid conflicts.
----------------------------------------------------------------------]]

local MINOR_VERSION = 20150112

local lib, oldminor = _G.LibStub:NewLibrary("LibColorPicker-1.0", MINOR_VERSION)
if not lib then return end

------------------------------------------------------------------------

local scripts = {}

function scripts:OnEnter()
	if not self.disabled then
		local color = NORMAL_FONT_COLOR
		self.bg:SetVertexColor(color.r, color.g, color.b)
	end
	if self.tooltipText then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
	end
end

function scripts:OnLeave()
	if not self.disabled then
		local color = HIGHLIGHT_FONT_COLOR
		self.bg:SetVertexColor(color.r, color.g, color.b)
	end
	GameTooltip:Hide()
end

function scripts:OnClick(button)
	if ColorPickerFrame:IsShown() then
		-- HideUIPanel(ColorPickerFrame)
		ColorPickerFrame:Hide();
	else
		self.r, self.g, self.b, self.opacity = self:GetValue()
		self.opacity = 1 - self.opacity -- oh Blizzard
		self.opening = true
		OpenColorPicker(self)
		ColorPickerFrame:SetFrameStrata("TOOLTIP")
		ColorPickerFrame:Raise()
		self.opening = nil
	end
end

function scripts:OnDisable()
	local color = GRAY_FONT_COLOR
	self.bg:SetVertexColor(color.r, color.g, color.b)
	self.labelText:SetFontObject(GameFontDisable)
	self.disabled = true
end

function scripts:OnEnable()
	local color = self:IsMouseOver() and NORMAL_FONT_COLOR or HIGHLIGHT_FONT_COLOR
	self.bg:SetVertexColor(color.r, color.g, color.b)
	self.labelText:SetFontObject(GameFontHighlight)
	self.disabled = nil
end

------------------------------------------------------------------------

local methods = {}

function methods:GetValue()
	local r, g, b, a = self.swatch:GetVertexColor()
	return floor(r * 100 + 0.5) / 100, floor(g * 100 + 0.5) / 100, floor(b * 100 + 0.5) / 100, floor(a * 100 + 0.5) / 100
end

function methods:SetValue(r, g, b, a)
	if type(r) == "table" then
		r, g, b, a = r.r or r[1], r.g or r[2], r.b or r[3], r.a or r[4]
	end

	r = floor(r * 100 + 0.5) / 100
	g = floor(g * 100 + 0.5) / 100
	b = floor(b * 100 + 0.5) / 100
	a = a and self.hasOpacity and (floor(a * 100 + 0.5) / 100) or 1

	self.swatch:SetVertexColor(r, g, b, a)
	self.bg:SetAlpha(a)

	local callback = self.OnValueChanged or self.OnColorChanged or self.Callback or self.callback
	if callback then
		-- Ignore updates while ColorPickerFrame:IsShown() if desired.
		callback(self, r, g, b, a)
	end
end

------------------------------------------------------------------------

function lib:New(parent, name, tooltipText, hasOpacity)
	assert(type(parent) == "table" and parent.CreateFontString, "PhanxConfig-ColorPicker: Parent is not a valid frame!")
	if type(name) ~= "string" then name = nil end
	if type(tooltipText) ~= "string" then tooltipText = nil end

	local frame = CreateFrame("Button", nil, parent)
	frame:SetSize(26, 26)

	local bg = frame:CreateTexture(nil, "BACKGROUND")
	bg:SetTexture("Interface\\BUTTONS\\WHITE8X8")
	bg:SetVertexColor(0.8, 0.8, 0.8)
	bg:SetPoint("CENTER", 0, 0)
	bg:SetSize(16, 16)
	frame.bg = bg

	local bgi = frame:CreateTexture(nil, "BORDER")
	bgi:SetTexture("Interface\\BUTTONS\\WHITE8X8")
	bgi:SetVertexColor(0, 0, 0)
	bgi:SetPoint("BOTTOMLEFT", bg, 1, 1)
	bgi:SetPoint("TOPRIGHT", bg, -1, -1)
	frame.bgInner = bgi

	local swatch = frame:CreateTexture(nil, "OVERLAY")
	swatch:SetTexture("Interface\\BUTTONS\\WHITE8X8")
	swatch:SetPoint("BOTTOMLEFT", bgi, 1, 1)
	swatch:SetPoint("TOPRIGHT", bgi, -1, -1)
	frame.swatch = swatch

	local label = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	label:SetPoint("LEFT", swatch, "RIGHT", 10, 0)
	frame.labelText = label

	frame:SetMotionScriptsWhileDisabled(true)
	for name, func in pairs(scripts) do
		frame:SetScript(name, func)
	end
	for name, func in pairs(methods) do
		frame[name] = func
	end

	frame.hasOpacity = hasOpacity
	frame.cancelFunc = function()
		frame:SetValue(frame.r, frame.g, frame.b, frame.hasOpacity and (1 - frame.opacity) or 1)
	end
	frame.opacityFunc = function()
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local a = 1 - OpacitySliderFrame:GetValue()
		frame:SetValue(r, g, b, a)
	end
	frame.swatchFunc = function()
		if frame.opening then return end
		local r, g, b = ColorPickerFrame:GetColorRGB()
		local a = 1 - OpacitySliderFrame:GetValue()
		frame:SetValue(r, g, b, a)
	end

	label:SetText(name)
	--frame:SetHitRectInsets(0, -1 * max(100, label:GetStringWidth() + 4), 0, 0)
	frame.tooltipText = tooltipText

	return frame
end

function lib.CreateColorPicker(...) return lib:New(...) end