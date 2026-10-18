-- ZTB SKULL EDITION — Meme Sea (Optimized & Cleaned)
-- Dark skull UI + compact floating toggle + Ghost Hitbox + Fly Boost
​local TW = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local PLR = game:GetService("Players")
local RS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local HS = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local LIGHT = game:GetService("Lighting")
local Lighting = LIGHT
​_G.TLG = _G.TLG or {}
local TLG = _G.TLG
TLG.LP = PLR.LocalPlayer
TLG.Cam = workspace.CurrentCamera
TLG.IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
TLG.SelectedTarget = nil
​workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
if workspace.CurrentCamera then TLG.Cam = workspace.CurrentCamera end
end)
​local function getParent()
local p
pcall(function() if gethui then p = gethui() end end)
if not p then
pcall(function()
if syn and syn.protect_gui then
local g = Instance.new("ScreenGui")
syn.protect_gui(g); g.Parent = CG; p = g
end
end)
end
if not p then
local ok = pcall(function()
local f = Instance.new("Folder")
f.Parent = CG; f:Destroy(); return CG
end)
if ok then p = CG end
end
if not p then p = TLG.LP:WaitForChild("PlayerGui") end
return p
end
TLG.getParent = getParent
TLG.SP = getParent()
​--==================================================
-- ZTB HUB KEY SYSTEM
--==================================================
local TLGKeySystem = {
Enabled = true,
Verified = false,
ValidKeys = {
["TLG-2026"] = true,
}
}
TLG.KeySystem = TLGKeySystem
​local function VerifyTLGKey(key)
key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", "")
if TLGKeySystem.ValidKeys[key] then
TLGKeySystem.Verified = true
return true
end
return false
end
​local function ShowTLGKeyGate()
if not TLGKeySystem.Enabled then
TLGKeySystem.Verified = true
return true
end
​local parent = TLG.SP
if not parent then return false end
​local old = parent:FindFirstChild("TLG_KeySystem")
if old then old:Destroy() end
​local gui = Instance.new("ScreenGui")
gui.Name = "TLG_KeySystem"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = parent
​local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(320, 190)
frame.Position = UDim2.fromScale(0.5, 0.5)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
frame.BorderSizePixel = 0
frame.Parent = gui
​Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)
​local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 40)
title.Position = UDim2.fromOffset(12, 10)
title.BackgroundTransparency = 1
title.Text = "🔐 ZTB HUB — KEY SYSTEM"
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 215, 0)
title.Parent = frame
​local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -24, 0, 42)
box.Position = UDim2.fromOffset(12, 58)
box.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
box.PlaceholderText = "Introduce tu key (TLG-2026)..."
box.Text = ""
box.TextSize = 15
box.Font = Enum.Font.Gotham
box.TextColor3 = Color3.fromRGB(245, 245, 245)
box.Parent = frame
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
​local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -24, 0, 40)
button.Position = UDim2.fromOffset(12, 110)
button.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
button.Text = "VERIFY KEY"
button.TextSize = 15
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.fromRGB(20, 20, 20)
button.Parent = frame
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
​local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -24, 0, 25)
status.Position = UDim2.fromOffset(12, 153)
status.BackgroundTransparency = 1
status.Text = "🔒 Key por defecto: TLG-2026"
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextColor3 = Color3.fromRGB(190, 190, 190)
status.Parent = frame
​local verified = false
local function tryVerify()
if VerifyTLGKey(box.Text) then
verified = true
status.Text = "✅ Key válida"
task.wait(0.25)
gui:Destroy()
else
status.Text = "❌ Key incorrecta"
box.Text = ""
end
end
​button.MouseButton1Click:Connect(tryVerify)
box.FocusLost:Connect(function(enterPressed)
if enterPressed then tryVerify() end
end)
​while gui.Parent and not verified do
task.wait()
end
return verified
end
​if not ShowTLGKeyGate() then return end
​-- Limpieza de interfaces previas
local names = {"TLG_GoldV4","TLG_GoldV5","TLG_GoldV6","TLG_GoldV7",
"TLG_GoldV8","ZTB_HUB_Menu","TLG_HideBtn","TLG_Express","TLG_FAB","TLG_FAB_Float",
"ZTB_Intro","ZTB_Watermark","TLG_FugaFAB"}
for _, n in ipairs(names) do
pcall(function() local o = TLG.SP:FindFirstChild(n); if o then o:Destroy() end end)
pcall(function() local o = CG:FindFirstChild(n); if o then o:Destroy() end end)
end
​local SG = Instance.new("ScreenGui")
SG.Name = "ZTB_HUB_Menu"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.DisplayOrder = 200
pcall(function() SG.Parent = TLG.SP end)
if not SG.Parent then pcall(function() SG.Parent = CG end) end
TLG.SG = SG
​function TLG.getPing()
local p = 0
pcall(function() p = math.floor((TLG.LP:GetNetworkPing() or 0) * 1000) end)
return p
end
​local Themes = {
["👑 Gold"]   = {A=Color3.fromRGB(255,215,0),  A2=Color3.fromRGB(255,235,100)},
["💜 Purple"] = {A=Color3.fromRGB(190,90,255), A2=Color3.fromRGB(230,150,255)},
["💙 Cyan"]   = {A=Color3.fromRGB(0,240,255),  A2=Color3.fromRGB(120,255,255)},
["❤️ Red"]    = {A=Color3.fromRGB(255,70,90),  A2=Color3.fromRGB(255,160,160)},
["💚 Green"]  = {A=Color3.fromRGB(80,255,130), A2=Color3.fromRGB(160,255,180)},
}
TLG.Themes = Themes
TLG.CurrentTheme = "👑 Gold"
function TLG.A() return Themes[TLG.CurrentTheme].A end
​local C = {
BG=Color3.fromRGB(12,7,8), BG2=Color3.fromRGB(24,12,13),
BG3=Color3.fromRGB(39,20,19), Wh=Color3.fromRGB(255,255,255),
Gr=Color3.fromRGB(150,140,110), Grn=Color3.fromRGB(100,255,140),
Rd=Color3.fromRGB(255,80,100), Cyan=Color3.fromRGB(0,240,255),
Yel=Color3.fromRGB(230,135,65)
}
TLG.C = C
​function TLG.PNotif(title, text, color)
color = color or TLG.A()
local nf = Instance.new("Frame", SG)
nf.Size = UDim2.new(0, 260, 0, 52)
nf.Position = UDim2.new(1, -270, 0, 20)
nf.BackgroundColor3 = C.BG2
nf.BorderSizePixel = 0
nf.ZIndex = 10000
Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 10)
local s = Instance.new("UIStroke", nf)
s.Color = color; s.Thickness = 2
​local tL = Instance.new("TextLabel", nf)
tL.Size = UDim2.new(1, -20, 0, 18)
tL.Position = UDim2.new(0, 14, 0, 6)
tL.BackgroundTransparency = 1
tL.Font = Enum.Font.GothamBold
tL.Text = title; tL.TextColor3 = color; tL.TextSize = 11
tL.TextXAlignment = Enum.TextXAlignment.Left
​local xL = Instance.new("TextLabel", nf)
xL.Size = UDim2.new(1, -20, 0, 18)
xL.Position = UDim2.new(0, 14, 0, 24)
xL.BackgroundTransparency = 1
xL.Font = Enum.Font.Gotham
xL.Text = text; xL.TextColor3 = C.Wh; xL.TextSize = 10
xL.TextXAlignment = Enum.TextXAlignment.Left
​task.delay(2.5, function()
pcall(function() nf:Destroy() end)
end)
end
​print("[ZTB SKULL EDITION] 💀 Script limpiado y optimizado correctamente.")
