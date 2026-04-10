CursorDB = CursorDB
or {
  color = { 1, 1, 1 },
  texture = "Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga",
  size = 54,
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

function ApplyCursorSettings()
  cursoricon:SetVertexColor(CursorDB.color[1], CursorDB.color[2], CursorDB.color[3])
  cursoricon:SetTexture(CursorDB and CursorDB.texture or "Interface\\AddOns\\Simple_Cursor\\Media\\Circle1.tga")
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
