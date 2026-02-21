CursorDB = CursorDB or {
  color = {1, 1, 1},
  size = 54,
}



local cursorframe = CreateFrame("Frame", "CursorHighlight", UIParent)
cursorframe:SetSize(CursorDB.size, CursorDB.size)
cursorframe:SetFrameStrata("HIGH")

cursorframe:Show()
local cursoricon = cursorframe:CreateTexture(nil, "ARTWORK")
cursoricon:SetTexture("Interface\\AddOns\\Simple_Cursor\\Media\\Circle2")
cursoricon:SetAllPoints(cursorframe)
cursoricon:SetAlpha(0.9)
cursoricon:SetVertexColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3])

local function ApplyCursorSettings()
  cursorframe:SetSize(CursorDB.size, CursorDB.size)
  cursoricon:SetVertexColor(
    CursorDB.color[1],
    CursorDB.color[2],
    CursorDB.color[3]
  )
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", ApplyCursorSettings)

cursorframe:SetScript("OnUpdate", function (_)
  cursorframe:SetSize(CursorDB.size, CursorDB.size)
  local scale = UIParent:GetEffectiveScale()
  local x, y = GetCursorPosition()
  x = x / scale
  y = y / scale
  cursorframe:ClearAllPoints()
  cursorframe:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
end)

SLASH_CURSORHIGHLIGHT1 = "/cursor"
SlashCmdList["CURSORHIGHLIGHT"] = function()
  cursorframe:SetShown(not cursorframe:IsShown())
end

local function CreateOptionsPanel()
  local initializing = true
  panel = CreateFrame("Frame", "CursorOptionsPanel", UIParent, BackdropTemplateMixin and "BackdropTemplate")
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
      if initializing then return end
      CursorDB.color[colorIndex] = value
      ApplyCursorSettings()
      label:SetText(colorName .. ": " .. math.floor(value * 100) .. "%")
      cursoricon:SetVertexColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3])
    end)

  end

  CreateColorSlider("Red", -130, 1)
  CreateColorSlider("Green", -200, 2)
  CreateColorSlider("Blue", -270, 3)
  initializing = false
  panel:SetScript("OnShow", function()
    ApplyCursorSettings()
  end)

  optionsPanel = panel
  return panel
end

SLASH_CURSORCONFIG1 = "/sc"
SlashCmdList["CURSORCONFIG"] = function ()
  if not optionsPanel then
    CreateOptionsPanel()
  end
  optionsPanel:SetShown(not optionsPanel:IsShown())
end



C_Timer.After(1, function()
  print("|cff00d9ffSimple Cursor loaded! |cffFFFFFFType /sc for options or /cursor to hide the circle.|r")
end)
