CursorDB = CursorDB
or {
  color = { 1, 1, 1 },
  texture = "Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga",
  size = 54,
  gCD = true,
}

cursorframe = CreateFrame("Frame", "CursorHighlight", UIParent)
cursorframe:SetSize(CursorDB.size, CursorDB.size)
cursorframe:SetFrameStrata("FULLSCREEN")
cursorframe:Show()

cursoricon = cursorframe:CreateTexture(nil, "ARTWORK")
cursoricon:SetTexture("Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga")
cursoricon:SetAllPoints(cursorframe)
cursoricon:SetAlpha(0.9)
cursoricon:SetVertexColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3])

gCD = CreateFrame("Cooldown", "CursorGCD", cursorframe)
gCD:SetSize(CursorDB.size + 16, CursorDB.size + 16)
gCD:SetPoint("CENTER", cursorframe, "CENTER", 0, 0)
gCD:SetSwipeTexture("Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga")
gCD:SetDrawSwipe(true)
gCD:SetSwipeColor(1, 1, 1, 1)
-- gCD:SetSwipeColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3]) -- Makes the color of the GCD follow the sliders
gCD:SetDrawBling(false)
gCD:SetDrawEdge(false)
gCD:SetHideCountdownNumbers(true)
gCD:SetReverse(false)

local gCDTracker = CreateFrame("Frame")
gCDTracker:RegisterEvent("SPELL_UPDATE_COOLDOWN")
gCDTracker:SetScript("OnEvent", function()
  local info = C_Spell.GetSpellCooldown(61304)
  if info and info.startTime > 0 and info.duration > 0 and info.duration <=1.5 then
    gCD:SetCooldown(info.startTime, info.duration)
  end
end)

function ApplyCursorSettings()
  cursoricon:SetVertexColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3])
  cursoricon:SetTexture(CursorDB and CursorDB.texture or "Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga")
  gCD:SetSize(CursorDB.size + 16, CursorDB.size + 16)
  -- gCD:SetSwipeColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3]) -- Makes the color of the GCD follow the sliders
  if CursorDB.gCD then
    gCD:SetSize(CursorDB.size + 16, CursorDB.size + 16)
    -- gCD:SetSwipeColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3]) -- Same as L44
  end
end

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_ENTERING_WORLD")
loader:SetScript("OnEvent", ApplyCursorSettings)

cursorframe:SetScript("OnUpdate", function(_)
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

C_Timer.After(1, function()
  print("|cff00d9ffSimple Cursor loaded! |cffFFFFFFType /sc or /scr for options or /cursor to hide the circle.|r")
end)
