local panel = CreateFrame("Frame", "CursorOptionsPanel", UIParent, BackdropTemplateMixin and "BackdropTemplate")
panel:SetSize(300, 400)
panel:SetPoint("CENTER")
panel:SetMovable(true)
panel:EnableMouse(true)
panel:RegisterForDrag("LeftButton")
panel:SetClampedToScreen(true)
panel:SetBackdrop({
  bgFile = "Interface/Tooltips/UI-Tooltip-Background",
  edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
  tile = true, tileSize = 16, edgeSize = 16,
  insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
panel:SetBackdropColor(0, 0, 0, 0.9)
panel:Hide()

local title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
title:SetPoint("TOP", 0, -10)
title:SetText("|cff00d9ffCursor Settings|r")

local closeButton = CreateFrame("Button", nil, panel, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -5, -5)

panel:SetScript("OnDragStart", panel.StartMoving)
panel:SetScript("OnDragStop", panel.StopMovingOrSizing)

function ToggleGCDVisibility(enabled)
  if enabled then
    gCD:Show()
    gCD:SetDrawSwipe(true)
    gCD:SetDrawEdge(false)
    gCD:SetDrawBling(false)
  else
    gCD:Hide()
    gCD:SetDrawSwipe(false)
  end
end

local gCDBox = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
gCDBox:SetPoint("TOPRIGHT", -110, -40)
gCDBox.text = gCDBox:CreateFontString(nil, "OVERLAY", "GameFontNormal")
gCDBox.text:SetPoint("LEFT", gCDBox, "RIGHT", 5, 0)
gCDBox.text:SetText("Enable GCD Ring")
gCDBox:SetChecked(CursorDB.gCD)
gCDBox:SetScript("OnClick", function(self)
  CursorDB.gCD = self:GetChecked()
  ToggleGCDVisibility(CursorDB.gCD)
end)

local sizeLabel = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
sizeLabel:SetPoint("TOPLEFT", 20, -50)
sizeLabel:SetText("Cursor Size: " .. CursorDB.size)

local sizeSlider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
sizeSlider:SetPoint("TOPLEFT", 20, -70)
sizeSlider:SetMinMaxValues(32, 128)
sizeSlider:SetValue(CursorDB.size)
sizeSlider:SetValueStep(1)
sizeSlider:SetObeyStepOnDrag(true)
sizeSlider:SetWidth(250)

sizeSlider:SetScript("OnValueChanged", function(self, value)
  CursorDB.size = value
  ApplyCursorSettings()
  sizeLabel:SetText("Cursor Size: " .. value)
  cursorframe:SetSize(value, value)
end)

local function CreateColorSlider(colorName, yPos, colorIndex)
  local label = panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  label:SetPoint("TOPLEFT", 20, yPos)
  label:SetText(colorName ..": " .. CursorDB.color[colorIndex])

  local slider = CreateFrame("Slider", nil, panel, "OptionsSliderTemplate")
  slider:SetPoint("TOPLEFT", 20, yPos - 20)
  slider:SetMinMaxValues(0, 1)
  slider:SetValue(CursorDB.color[colorIndex])
  slider:SetValueStep(0.1)
  slider:SetObeyStepOnDrag(true)
  slider:SetWidth(250)

  slider:SetScript("OnValueChanged", function(self, value)
    CursorDB.color[colorIndex] = value
    ApplyCursorSettings()
    label:SetText(colorName .. ": " .. math.floor(value * 100) .. "%")
    cursoricon:SetVertexColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3])
  end)
  return slider
end

local redSlider = CreateColorSlider("Red", -130, 1)
local greenSlider = CreateColorSlider("Green", -200, 2)
local blueSlider = CreateColorSlider("Blue", -270, 3)

local cursorList = {
  {name = "Circle 1", value = "Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga"},
  {name = "Circle 2", value = "Interface\\AddOns\\Simple_Cursor\\Media\\Circle2.tga"},
  {name = "Circle 3", value = "Interface\\AddOns\\Simple_Cursor\\Media\\Circle3.tga"},
}

local previewSize = 40
local padding = 5

for i, texturePath in ipairs(cursorList) do
  local prevBtn = CreateFrame("Button", nil, panel)
  prevBtn:SetSize(previewSize, previewSize)
  prevBtn:SetPoint("TOPLEFT", 20 + (i - 1) * (previewSize + padding), -330)

  local texture = prevBtn:CreateTexture(nil, "ARTWORK")
  texture:SetAllPoints()
  texture:SetTexture(texturePath.value)
  texture:SetVertexColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3])

  prevBtn:SetScript("OnClick", function()
    CursorDB.texture = texturePath.value
    cursoricon:SetTexture(texturePath.value)
  end)
end

panel:SetScript("OnShow", function()
  sizeSlider:SetValue(CursorDB.size)
  redSlider:SetValue(CursorDB.color[1])
  greenSlider:SetValue(CursorDB.color[2])
  blueSlider:SetValue(CursorDB.color[3])
  gCDBox:SetChecked(CursorDB.gCD)
  ToggleGCDVisibility(CursorDB.gCD)
  ApplyCursorSettings()
end)

SLASH_CURSORCONFIG1 = "/sc"
SLASH_CURSORCONFIG2 = "/scr"
SlashCmdList["CURSORCONFIG"] = function ()
  panel:SetShown(not panel:IsShown())
end
