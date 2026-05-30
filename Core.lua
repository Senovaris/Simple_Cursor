CursorDB = CursorDB or {}
CursorDB.color = CursorDB.color or { 1, 1, 1 }
CursorDB.texture = CursorDB.texture or "Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga"
CursorDB.size = CursorDB.size or 54
CursorDB.gCDColor = CursorDB.gCDColor or { 1, 1, 1 }
CursorDB.gCDClassColor = CursorDB.gCDClassColor or false
if CursorDB.gCD == nil then CursorDB.gCD = true end
CursorDB.showCircle = CursorDB.showCircle ~= false and true or false

cursorframe = CreateFrame("Frame", "CursorHighlight", UIParent)
cursorframe:SetSize(CursorDB.size, CursorDB.size)
cursorframe:SetFrameStrata("FULLSCREEN")
cursorframe:Show()

cursoricon = cursorframe:CreateTexture(nil, "ARTWORK")
cursoricon:SetTexture(CursorDB.texture)
cursoricon:SetAllPoints(cursorframe)
cursoricon:SetAlpha(0.9)
cursoricon:SetVertexColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3])

gCD = CreateFrame("Cooldown", "CursorGCD", cursorframe)
gCD:SetSize(CursorDB.size + 16, CursorDB.size + 16)
gCD:SetPoint("CENTER", cursorframe, "CENTER", 0, 0)
gCD:SetSwipeTexture("Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga")
gCD:SetDrawSwipe(true)
gCD:SetSwipeColor(1, 1, 1, 1)
gCD:SetDrawBling(false)
gCD:SetDrawEdge(false)
gCD:SetHideCountdownNumbers(true)
gCD:SetReverse(false)

local gCDTracker = CreateFrame("Frame")
gCDTracker:RegisterEvent("SPELL_UPDATE_COOLDOWN")
gCDTracker:SetScript("OnEvent", function()
  local info = C_Spell.GetSpellCooldown(61304)
  if info and info.startTime > 0 and info.duration > 0 and info.duration <= 1.5 then
    gCD:SetCooldown(info.startTime, info.duration)
  end
end)

function ApplyGCDColor()
  if not gCD or not CursorDB.gCDColor then return end
  local r, g, b
  if CursorDB.gCDClassColor then
    local _, class = UnitClass("player")
    local c = RAID_CLASS_COLORS[class]
    r, g, b = c.r, c.g, c.b
  else
    r, g, b = CursorDB.gCDColor[1], CursorDB.gCDColor[2], CursorDB.gCDColor[3]
  end
  gCD:SetSwipeColor(r, g, b, 0.8)
end

function ApplyCursorColor()
  if not cursoricon then return end
  local r, g, b
  if CursorDB.gCDClassColor then
    local _, class = UnitClass("player")
    local c = RAID_CLASS_COLORS[class]
    r, g, b = c.r, c.g, c.b
  else
    r, g, b = CursorDB.color[1], CursorDB.color[2], CursorDB.color[3]
  end
  cursoricon:SetVertexColor(r, g, b)
end

function ApplyCursorSettings()
  cursoricon:SetTexture(CursorDB.texture or "Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga")
  cursoricon:SetShown(CursorDB.showCircle ~= false)
  cursorframe:SetSize(CursorDB.size, CursorDB.size)
  gCD:SetSize(CursorDB.size + 16, CursorDB.size + 16)
  ApplyCursorColor()
  ApplyGCDColor()
  if CursorDB.gCD then
    gCD:Show()
    gCD:SetDrawSwipe(true)
    gCD:SetDrawEdge(false)
    gCD:SetDrawBling(false)
  else
    gCD:Hide()
    gCD:SetDrawSwipe(false)
  end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, arg1, ...)
  if event == "ADDON_LOADED" and arg1 == "Simple_Cursor" then
    CursorDB = CursorDB or {}
    CursorDB.color = CursorDB.color or { 1, 1, 1 }
    CursorDB.texture = CursorDB.texture or "Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga"
    CursorDB.size = CursorDB.size or 54
    CursorDB.gCDColor = CursorDB.gCDColor or { 1, 1, 1 }
    CursorDB.gCDClassColor = CursorDB.gCDClassColor or false
    if CursorDB.gCD == nil then CursorDB.gCD = true end
    CursorDB.showCircle = CursorDB.showCircle ~= false and true or false
    self:UnregisterEvent("ADDON_LOADED")

  elseif event == "PLAYER_ENTERING_WORLD" then
    ApplyCursorSettings()
  end
end)
cursorframe:SetScript("OnUpdate", function()
  cursorframe:SetSize(CursorDB.size, CursorDB.size)
  local scale = UIParent:GetEffectiveScale()
  local x, y = GetCursorPosition()
  x = x / scale
  y = y / scale
  cursorframe:ClearAllPoints()
  cursorframe:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x, y)
end)

C_Timer.After(1, function()
  print("|cff00d9ffSimple Cursor loaded! |cffFFFFFFType /sc or /scr for options.|r")
end)
