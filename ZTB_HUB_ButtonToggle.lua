
-- ZTB SKULL EDITION — Meme Sea
-- Dark skull UI + compact floating toggle + Ghost Hitbox + Fly Boost

local TW = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local PLR = game:GetService("Players")
local RS = game:GetService("RunService")
local CG = game:GetService("CoreGui")
local HS = game:GetService("HttpService")
local TPS = game:GetService("TeleportService")
local LIGHT = game:GetService("Lighting")
local Lighting = LIGHT

_G.TLG = _G.TLG or {}
local TLG = _G.TLG
TLG.LP = PLR.LocalPlayer
TLG.Cam = workspace.CurrentCamera
TLG.IsMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
TLG.SelectedTarget = nil

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
  if workspace.CurrentCamera then TLG.Cam = workspace.CurrentCamera end
end)

local function getParent()
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

--==================================================
-- ZTB HUB KEY SYSTEM
--==================================================
-- Client-side gate only. For real protection, validate keys
-- against a server you control rather than embedding secrets.
--==================================================

local TLGKeySystem = {
    Enabled = true,
    Verified = false,
    ValidKeys = {
        ["TLG-2026"] = true, -- cambia/agrega tus keys aquí
    }
}

TLG.KeySystem = TLGKeySystem

local function VerifyTLGKey(key)
    key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if TLGKeySystem.ValidKeys[key] then
        TLGKeySystem.Verified = true
        return true
    end
    return false
end

local function ShowTLGKeyGate()
    if not TLGKeySystem.Enabled then
        TLGKeySystem.Verified = true
        return true
    end

    local parent = TLG.SP
    if not parent then return false end

    local old = parent:FindFirstChild("TLG_KeySystem")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "TLG_KeySystem"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(320, 190)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    frame.BorderSizePixel = 0
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 0, 40)
    title.Position = UDim2.fromOffset(12, 10)
    title.BackgroundTransparency = 1
    title.Text = "🔐 ZTB HUB — KEY SYSTEM"
    title.TextSize = 18
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 215, 0)
    title.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -24, 0, 42)
    box.Position = UDim2.fromOffset(12, 58)
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
    box.PlaceholderText = "Introduce tu key..."
    box.Text = ""
    box.TextSize = 15
    box.Font = Enum.Font.Gotham
    box.TextColor3 = Color3.fromRGB(245, 245, 245)
    box.Parent = frame

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = box

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -24, 0, 40)
    button.Position = UDim2.fromOffset(12, 110)
    button.BackgroundColor3 = Color3.fromRGB(255, 200, 80)
    button.Text = "VERIFY KEY"
    button.TextSize = 15
    button.Font = Enum.Font.GothamBold
    button.TextColor3 = Color3.fromRGB(20, 20, 20)
    button.Parent = frame

    local ub = Instance.new("UICorner")
    ub.CornerRadius = UDim.new(0, 8)
    ub.Parent = button

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -24, 0, 25)
    status.Position = UDim2.fromOffset(12, 153)
    status.BackgroundTransparency = 1
    status.Text = "🔒 Esperando key..."
    status.TextSize = 13
    status.Font = Enum.Font.Gotham
    status.TextColor3 = Color3.fromRGB(190, 190, 190)
    status.Parent = frame

    local verified = false

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

    button.MouseButton1Click:Connect(tryVerify)
    box.FocusLost:Connect(function(enterPressed)
        if enterPressed then tryVerify() end
    end)

    while gui.Parent and not verified do
        task.wait()
    end

    return verified
end

if not ShowTLGKeyGate() then
    return
end

local names = {"TLG_GoldV4","TLG_GoldV5","TLG_GoldV6","TLG_GoldV7",
  "TLG_GoldV8","ZTB_HUB_Menu","TLG_HideBtn","TLG_Express","TLG_FAB","TLG_FAB_Float",
  "ZTB_Intro","ZTB_Watermark","TLG_FugaFAB"}
for _, n in ipairs(names) do
  pcall(function() local o = TLG.SP:FindFirstChild(n); if o then o:Destroy() end end)
  pcall(function() local o = CG:FindFirstChild(n); if o then o:Destroy() end end)
end

local SG = Instance.new("ScreenGui")
SG.Name = "ZTB_HUB_Menu"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.DisplayOrder = 200
pcall(function() SG.Parent = TLG.SP end)
if not SG.Parent then pcall(function() SG.Parent = CG end) end
TLG.SG = SG

function TLG.getPing()
  local p = 0
  pcall(function() p = math.floor((TLG.LP:GetNetworkPing() or 0) * 1000) end)
  return p
end

local Themes = {
  ["👑 Gold"]   = {A=Color3.fromRGB(255,215,0),  A2=Color3.fromRGB(255,235,100)},
  ["💜 Purple"] = {A=Color3.fromRGB(190,90,255), A2=Color3.fromRGB(230,150,255)},
  ["💙 Cyan"]   = {A=Color3.fromRGB(0,240,255),  A2=Color3.fromRGB(120,255,255)},
  ["❤️ Red"]    = {A=Color3.fromRGB(255,70,90),  A2=Color3.fromRGB(255,160,160)},
  ["💚 Green"]  = {A=Color3.fromRGB(80,255,130), A2=Color3.fromRGB(160,255,180)},
  ["💗 Pink"]   = {A=Color3.fromRGB(255,110,210),A2=Color3.fromRGB(255,180,235)},
  ["🧡 Orange"] = {A=Color3.fromRGB(255,160,60), A2=Color3.fromRGB(255,210,130)},
  ["🤍 White"]  = {A=Color3.fromRGB(250,250,255),A2=Color3.fromRGB(255,255,255)}
}
TLG.Themes = Themes
TLG.CurrentTheme = "👑 Gold"
TLG.CustomAccent = nil
TLG.CustomAccent2 = nil
function TLG.A() return TLG.CustomAccent or Themes[TLG.CurrentTheme].A end
function TLG.A2() return TLG.CustomAccent2 or Themes[TLG.CurrentTheme].A2 end

local C = {
  BG=Color3.fromRGB(12,7,8), BG2=Color3.fromRGB(24,12,13),
  BG3=Color3.fromRGB(39,20,19), BG4=Color3.fromRGB(52,27,23),
  Wh=Color3.fromRGB(255,255,255), Gr=Color3.fromRGB(150,140,110),
  GrD=Color3.fromRGB(70,60,40), Grn=Color3.fromRGB(100,255,140),
  Rd=Color3.fromRGB(255,80,100), Cyan=Color3.fromRGB(0,240,255),
  Yel=Color3.fromRGB(232,170,60)
}
TLG.C = C

local NH = nil
local function getNH()
  if NH and NH.Parent then return NH end
  NH = Instance.new("Frame", SG)
  NH.Size = UDim2.new(0, 280, 1, -80)
  NH.Position = UDim2.new(1, -290, 0, 60)
  NH.BackgroundTransparency = 1
  NH.ZIndex = 9999
  local ll = Instance.new("UIListLayout", NH)
  ll.Padding = UDim.new(0, 8)
  ll.HorizontalAlignment = Enum.HorizontalAlignment.Right
  ll.VerticalAlignment = Enum.VerticalAlignment.Top
  return NH
end

function TLG.PNotif(title, text, color)
  color = color or TLG.A()
  local h = getNH()
  local nf = Instance.new("Frame", h)
  nf.Size = UDim2.new(1, 0, 0, 52)
  nf.BackgroundColor3 = C.BG2
  nf.BorderSizePixel = 0
  nf.ZIndex = 10000
  Instance.new("UICorner", nf).CornerRadius = UDim.new(0, 10)
  local s = Instance.new("UIStroke", nf)
  s.Color = color; s.Thickness = 2
  local bar = Instance.new("Frame", nf)
  bar.Size = UDim2.new(0, 3, 1, -12)
  bar.Position = UDim2.new(0, 0, 0, 6)
  bar.BackgroundColor3 = color; bar.BorderSizePixel = 0
  Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
  local tL = Instance.new("TextLabel", nf)
  tL.Size = UDim2.new(1, -20, 0, 18)
  tL.Position = UDim2.new(0, 14, 0, 6)
  tL.BackgroundTransparency = 1
  tL.Font = Enum.Font.GothamBold
  tL.Text = title; tL.TextColor3 = color; tL.TextSize = 11
  tL.TextXAlignment = Enum.TextXAlignment.Left
  tL.ZIndex = 10001
  local xL = Instance.new("TextLabel", nf)
  xL.Size = UDim2.new(1, -20, 0, 18)
  xL.Position = UDim2.new(0, 14, 0, 24)
  xL.BackgroundTransparency = 1
  xL.Font = Enum.Font.Gotham
  xL.Text = text; xL.TextColor3 = C.Wh; xL.TextSize = 10
  xL.TextXAlignment = Enum.TextXAlignment.Left
  xL.TextTruncate = Enum.TextTruncate.AtEnd
  xL.ZIndex = 10001
  nf.Position = UDim2.new(1, 50, 0, 0)
  TW:Create(nf, TweenInfo.new(0.35, Enum.EasingStyle.Back),
    {Position = UDim2.new(0, 0, 0, 0)}):Play()
  task.delay(2.5, function()
    if not nf.Parent then return end
    TW:Create(nf, TweenInfo.new(0.3),
      {Position = UDim2.new(1, 50, 0, 0),
       BackgroundTransparency = 1}):Play()
    task.wait(0.35); pcall(function() nf:Destroy() end)
  end)
end

function TLG.Ripple(obj)
  obj.Activated:Connect(function()
    local r = Instance.new("Frame", obj)
    r.BackgroundColor3 = TLG.A()
    r.BackgroundTransparency = 0.6
    r.BorderSizePixel = 0
    r.Size = UDim2.new(0, 0, 0, 0)
    r.Position = UDim2.new(0.5, 0, 0.5, 0)
    r.AnchorPoint = Vector2.new(0.5, 0.5)
    r.ZIndex = obj.ZIndex + 5
    Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)
    local ms = math.max(obj.AbsoluteSize.X, obj.AbsoluteSize.Y) * 1.8
    TW:Create(r, TweenInfo.new(0.5),
      {Size = UDim2.new(0, ms, 0, ms), BackgroundTransparency = 1}):Play()
    task.delay(0.5, function() pcall(function() r:Destroy() end) end)
  end)
end

function TLG.PGlow(stroke, minT, maxT, dur)
  minT = minT or 0.2; maxT = maxT or 0.8; dur = dur or 1.5
  task.spawn(function()
    while stroke and stroke.Parent do
      local t1 = TW:Create(stroke,
        TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Transparency = maxT})
      t1:Play(); t1.Completed:Wait()
      if not stroke.Parent then break end
      local t2 = TW:Create(stroke,
        TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
        {Transparency = minT})
      t2:Play(); t2.Completed:Wait()
    end
  end)
end

-- STATS MEME SEA
local function deepScan(inst, s, d)
  if not inst or d > 6 then return end
  for _, v in ipairs(inst:GetChildren()) do
    local cn = v.ClassName
    if cn == "IntValue" or cn == "NumberValue" or cn == "StringValue" then
      local n = v.Name:lower():gsub("[%s_%-%.]", "")
      local num = tonumber(v.Value)
      if num then
        if n == "level" or n == "lvl" then s.Level = num
        elseif n == "gem" or n == "gems" then s.Gems = num
        elseif n == "cash" or n == "money" or n == "coins" or n == "belly" then s.Cash = num
        elseif n == "power" or n == "memepower" or n == "memepowerlevel" or n == "poder" then s.Power = num
        elseif n == "melee" or n == "meleelevel" or n == "fist" or n == "fistslevel" then s.Melee = num
        elseif n == "sword" or n == "swordlevel" or n == "weapon" or n == "weaponlevel" or n == "gun" then s.Weapon = num
        elseif n == "rebirth" or n == "rebirths" or n == "prestige" then s.Rebirths = num
        elseif n == "rank" or n == "ranklevel" then s.Rank = num
        elseif n == "kills" or n == "killcount" then s.Kills = num
        elseif n == "deaths" or n == "deathcount" then s.Deaths = num
        elseif n == "essence" or n == "shards" then s.Essence = num
        elseif n == "tokens" or n == "tickets" then s.Tokens = num
        end
      end
    elseif cn == "Folder" or cn == "Configuration" or cn == "Model" then
      deepScan(v, s, d + 1)
    end
  end
end

function TLG.GetStats(plr)
  local s = {Level=0, Health=0, MaxHealth=0, Gems=0, Cash=0,
    Power=0, Melee=0, Weapon=0, Rebirths=0, Rank=0,
    Kills=0, Deaths=0, Essence=0, Tokens=0}
  pcall(function()
    local ch = plr.Character
    if ch then
      local hu = ch:FindFirstChildOfClass("Humanoid")
      if hu then
        s.Health = math.floor(hu.Health)
        s.MaxHealth = math.floor(hu.MaxHealth)
      end
    end
  end)
  pcall(function()
    local pd = plr:FindFirstChild("PlayerData")
    if pd then deepScan(pd, s, 0) end
  end)
  local fallbacks = {"leaderstats","Stats","Data","Values","SaveData","PlayerStats"}
  for _, n in ipairs(fallbacks) do
    pcall(function() deepScan(plr:FindFirstChild(n), s, 0) end)
  end
  pcall(function()
    local ch = plr.Character
    if ch then
      local attrs = {"Level","Power","Melee","Weapon","Gems","Cash","SwordLevel"}
      for _, attr in ipairs(attrs) do
        local a = ch:GetAttribute(attr)
        if type(a) == "number" then
          if attr == "SwordLevel" then s.Weapon = a
          else s[attr] = a end
        end
      end
    end
  end)
  return s
end

-- AIMBOT — hitbox fantasma (no rompe el movimiento)
local AIM = {
  On = false, Conn = nil, Target = nil,
  HeadSize = 800, MaxTargetRange = 20000, ShowHitbox = false, CharConns = {}
}
TLG.AIM = AIM

local function aimRemoveHitbox(plr)
  local ch = plr.Character
  if not ch then return end
  local old = ch:FindFirstChild("TLG_Hitbox")
  if old then pcall(function() old:Destroy() end) end
end

local function aimExpandHead(plr)
  local ch = plr.Character
  if not ch then return end
  local h = ch:FindFirstChild("Head")
  if not h then return end
  aimRemoveHitbox(plr)
  local s = math.clamp(AIM.HeadSize, 1, 2048)
  local hb = Instance.new("Part")
  hb.Name = "TLG_Hitbox"
  hb.Size = Vector3.new(s, s, s)
  hb.Transparency = AIM.ShowHitbox and 0.7 or 1
  hb.CanCollide = false
  hb.Massless = true
  hb.Anchored = false
  hb.CanQuery = true
  hb.CanTouch = true
  hb.Material = AIM.ShowHitbox and Enum.Material.ForceField
    or Enum.Material.Neon
  hb.Color = TLG.A()
  hb.TopSurface = Enum.SurfaceType.Smooth
  hb.BottomSurface = Enum.SurfaceType.Smooth
  hb.CFrame = h.CFrame
  hb.Parent = ch
  local weld = Instance.new("WeldConstraint")
  weld.Part0 = h
  weld.Part1 = hb
  weld.Parent = hb
  hb.CFrame = h.CFrame
end

local function aimFindTarget()
  local best, bestD = nil, math.huge
  local mc = TLG.LP.Character
  if not mc then return nil end
  local mh = mc:FindFirstChild("HumanoidRootPart")
  if not mh then return nil end
  for _, p in ipairs(PLR:GetPlayers()) do
    if p ~= TLG.LP then
      local ch = p.Character
      local hu = ch and ch:FindFirstChildOfClass("Humanoid")
      local hb = ch and ch:FindFirstChild("TLG_Hitbox")
      local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
      if hu and hu.Health > 0 and (hb or hrp) then
        local pos = (hb or hrp).Position
        local d = (pos - mh.Position).Magnitude
        if d <= AIM.MaxTargetRange and d < bestD then
          bestD = d
          best = p
        end
      end
    end
  end
  return best
end

local function aimLoop()
  if not AIM.On then return end
  for _, p in ipairs(PLR:GetPlayers()) do
    if p ~= TLG.LP and p.Character then
      if not p.Character:FindFirstChild("TLG_Hitbox") then
        pcall(aimExpandHead, p)
      end
    end
  end
  local t = aimFindTarget()
  AIM.Target = t
  if not t then return end
  -- Do not rotate/move the local character here.
  -- The previous Heartbeat CFrame write fought Orbital Map and caused
  -- movement/orbit jitter. The hitbox remains available without forcing
  -- the player's HumanoidRootPart to face the target.
  return
end

function TLG.AIM_Start()
  if AIM.On then return end
  AIM.On = true
  for _, p in ipairs(PLR:GetPlayers()) do
    if p ~= TLG.LP then pcall(aimExpandHead, p) end
  end
  AIM.CharConns = AIM.CharConns or {}
  for _, p in ipairs(PLR:GetPlayers()) do
    if p ~= TLG.LP then
      AIM.CharConns[p] = p.CharacterAdded:Connect(function()
        if AIM.On then task.wait(0.3); pcall(aimExpandHead, p) end
      end)
    end
  end
  AIM.Conn = RS.Heartbeat:Connect(aimLoop)
  TLG.PNotif("🎯 Hitbox", "✅ "..AIM.HeadSize, C.Grn)
end

function TLG.AIM_Stop()
  if not AIM.On then return end
  AIM.On = false
  if AIM.Conn then
    pcall(function() AIM.Conn:Disconnect() end); AIM.Conn = nil
  end
  if AIM.CharConns then
    for _, c in pairs(AIM.CharConns) do
      pcall(function() c:Disconnect() end)
    end
    AIM.CharConns = {}
  end
  for _, p in ipairs(PLR:GetPlayers()) do
    if p ~= TLG.LP then pcall(aimRemoveHitbox, p) end
  end
  AIM.Target = nil
  TLG.PNotif("🎯 Hitbox", "❌ Desactivado", C.Rd)
end

-- HITBOX MANUAL
local HB = {On = false, Sz = 10, Tr = 0.5, Conn = nil, Original = {}} -- tamaño inicial 10, máximo 50
local function applyHB(p)
  if p == TLG.LP then return end
  local ch = p.Character; if not ch then return end
  local h = ch:FindFirstChild("HumanoidRootPart")
  if not h then return end
  local s = math.clamp(HB.Sz, 1, 50)
  pcall(function()
    if HB.Original[h] == nil then
      HB.Original[h] = {
        Size = h.Size,
        Transparency = h.Transparency,
        LocalTransparencyModifier = h.LocalTransparencyModifier,
        Material = h.Material,
        Color = h.Color,
        CanCollide = h.CanCollide,
      }
    end
    h.Size = Vector3.new(s, s, s)
    h.Transparency = HB.Tr
    h.LocalTransparencyModifier = 0
    h.Material = Enum.Material.Neon
    h.Color = TLG.A()
    h.CanCollide = false
  end)
end
function TLG.HBStart()
  if HB.Conn then return end
  HB.On = true
  for _, p in ipairs(PLR:GetPlayers()) do
    if p ~= TLG.LP then pcall(applyHB, p) end
  end
  HB.Conn = RS.Heartbeat:Connect(function()
    if not HB.On then return end
    for _, p in ipairs(PLR:GetPlayers()) do
      if p ~= TLG.LP then pcall(applyHB, p) end
    end
  end)
end
function TLG.HBStop()
  HB.On = false
  if HB.Conn then pcall(function() HB.Conn:Disconnect() end); HB.Conn = nil end
  for part, old in pairs(HB.Original) do
    if part and part.Parent then
      pcall(function()
        part.Size = old.Size
        part.Transparency = old.Transparency
        part.LocalTransparencyModifier = old.LocalTransparencyModifier
        part.Material = old.Material
        part.Color = old.Color
        part.CanCollide = old.CanCollide
      end)
    end
  end
  HB.Original = {}
end

-- GOD ORB
TLG.GO = {T = nil, C = nil, On = false, Ang = 0}
function TLG.GOS()
  TLG.GO.T = nil; TLG.GO.On = false
  if TLG.GO.C then pcall(function() TLG.GO.C:Disconnect() end); TLG.GO.C = nil end
  local ch = TLG.LP.Character
  if ch then
    local h = ch:FindFirstChild("HumanoidRootPart")
    local hu = ch:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h.Anchored = false end) end
    if hu then pcall(function() hu.PlatformStand = false end) end
  end
end
function TLG.GOSt(p)
  if not p or not p.Parent then return end
  TLG.GOS()
  TLG.GO.T = p; TLG.GO.On = true; TLG.GO.Ang = 0
  task.spawn(function()
    local mc = TLG.LP.Character or TLG.LP.CharacterAdded:Wait()
    local mh = mc:WaitForChild("HumanoidRootPart", 5)
    local mhu = mc:FindFirstChildOfClass("Humanoid")
    if not mh or not mhu then TLG.GOS(); return end
    mh.Anchored = true; mhu.PlatformStand = true
    TLG.GO.C = RS.PreSimulation:Connect(function(dt)
      if not TLG.GO.On or not TLG.GO.T or not TLG.GO.T.Parent then
        TLG.GOS(); return
      end
      local tc = TLG.GO.T.Character; if not tc then TLG.GOS(); return end
      local th = tc:FindFirstChild("HumanoidRootPart")
      local thu = tc:FindFirstChildOfClass("Humanoid")
      if not th or not thu or thu.Health <= 0 then TLG.GOS(); return end
      TLG.GO.Ang = TLG.GO.Ang + 5 * dt
      if TLG.GO.Ang > math.pi * 2 then TLG.GO.Ang = TLG.GO.Ang - math.pi * 2 end
      local off = Vector3.new(math.cos(TLG.GO.Ang) * 8, 3,
        math.sin(TLG.GO.Ang) * 8)
      mh.CFrame = CFrame.new(th.Position + off, th.Position) * CFrame.Angles(0, math.pi, 0)
    end)
  end)
end

-- SPECTATE
TLG.Sp = {T = nil, C = nil}
function TLG.SpS()
  if TLG.Sp.C then pcall(function() TLG.Sp.C:Disconnect() end); TLG.Sp.C = nil end
  TLG.Sp.T = nil
  if TLG.LP.Character then
    local hu = TLG.LP.Character:FindFirstChildOfClass("Humanoid")
    if hu and TLG.Cam then TLG.Cam.CameraSubject = hu end
  end
end
function TLG.SpSt(p)
  if not p or not p.Parent then return end
  TLG.SpS(); TLG.Sp.T = p
  TLG.Sp.C = RS.RenderStepped:Connect(function()
    if not TLG.Sp.T or not TLG.Sp.T.Parent then TLG.SpS(); return end
    local ch = TLG.Sp.T.Character; if not ch then TLG.SpS(); return end
    local hu = ch:FindFirstChildOfClass("Humanoid")
    if hu and hu.Health > 0 and TLG.Cam then TLG.Cam.CameraSubject = hu
    elseif hu and hu.Health <= 0 then TLG.SpS() end
  end)
end

-- FLY (con boost Shift)
TLG.Fly = {On=false, Spd=15000, BoostMul=3, Boost=false,
  C=nil, Noclip=true, CollisionOriginal={}, Keys={Up=false, Down=false}}
local function flyCleanup(h)
  if not h then return end
  pcall(function()
    local ns = {"TLG_FlyBV", "TLG_FlyBG", "BodyVelocity", "BodyGyro"}
    for _, n in ipairs(ns) do
      local o = h:FindFirstChild(n); if o then o:Destroy() end
    end
  end)
end
function TLG.FlyE()
  TLG.Fly.On = false
  TLG.Fly.Keys.Up = false; TLG.Fly.Keys.Down = false
  local ch = TLG.LP.Character
  if ch then
    local h = ch:FindFirstChild("HumanoidRootPart")
    local hu = ch:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h.Anchored = false end) end
    flyCleanup(h)
    if hu then pcall(function() hu.PlatformStand = false end) end
    for p, original in pairs(TLG.Fly.CollisionOriginal) do
      if p and p.Parent then
        pcall(function() p.CanCollide = original end)
      end
    end
    TLG.Fly.CollisionOriginal = {}
  end
  if TLG.Fly.C then pcall(function() TLG.Fly.C:Disconnect() end); TLG.Fly.C = nil end
end
local function flyGetMove()
  local mv = Vector3.zero
  local pm = TLG.LP:FindFirstChild("PlayerScripts")
  if pm then
    local pmod = pm:FindFirstChild("PlayerModule")
    if pmod then
      local ok, ctl = pcall(function()
        return require(pmod):GetControls()
      end)
      if ok and ctl then
        local ok2, v = pcall(function() return ctl:GetMoveVector() end)
        if ok2 and v then mv = v end
      end
    end
  end
  return mv
end
function TLG.FlyS()
  if TLG.Fly.On then return end
  TLG.Fly.On = true
  task.spawn(function()
    local ch = TLG.LP.Character or TLG.LP.CharacterAdded:Wait()
    local h = ch:WaitForChild("HumanoidRootPart", 5)
    local hu = ch:FindFirstChildOfClass("Humanoid")
    if not h or not hu then TLG.Fly.On = false; return end
    flyCleanup(h)
    local bg = Instance.new("BodyGyro")
    bg.Name = "TLG_FlyBG"
    bg.MaxTorque = Vector3.new(1e10, 1e10, 1e10)
    bg.P = 9e4
    bg.CFrame = h.CFrame
    bg.Parent = h
    hu.PlatformStand = true
    TLG.Fly.C = RS.RenderStepped:Connect(function()
      if not TLG.Fly.On then TLG.FlyE(); return end
      local curCh = TLG.LP.Character
      if not curCh then return end
      h = curCh:FindFirstChild("HumanoidRootPart")
      hu = curCh:FindFirstChildOfClass("Humanoid")
      if not h or not hu then return end
      bg = h:FindFirstChild("TLG_FlyBG")
      if not bg then
        bg = Instance.new("BodyGyro")
        bg.Name = "TLG_FlyBG"
        bg.MaxTorque = Vector3.new(1e10, 1e10, 1e10)
        bg.P = 9e4
        bg.Parent = h
      end
      if not hu.PlatformStand then hu.PlatformStand = true end
      if TLG.Fly.Noclip then
        for _, p in ipairs(curCh:GetDescendants()) do
          if p:IsA("BasePart") then
            if TLG.Fly.CollisionOriginal[p] == nil then
              TLG.Fly.CollisionOriginal[p] = p.CanCollide
            end
            p.CanCollide = false
          end
        end
      else
        for p, original in pairs(TLG.Fly.CollisionOriginal) do
          if p and p.Parent then pcall(function() p.CanCollide = original end) end
        end
        TLG.Fly.CollisionOriginal = {}
      end
      local cam = TLG.Cam or workspace.CurrentCamera
      if cam then bg.CFrame = cam.CFrame end

      local mv = flyGetMove()
      local dir = Vector3.zero
      if cam then
        dir = (cam.CFrame.LookVector * -mv.Z)
          + (cam.CFrame.RightVector * mv.X)
      end
      local y = 0
      if TLG.Fly.Keys.Up then y = y + 1 end
      if TLG.Fly.Keys.Down then y = y - 1 end
      if y ~= 0 then dir = dir + Vector3.new(0, y, 0) end

      -- Boost con Shift
      TLG.Fly.Boost = UIS:IsKeyDown(Enum.KeyCode.LeftShift)
        or UIS:IsKeyDown(Enum.KeyCode.RightShift)

      if dir.Magnitude > 0.05 then
        if h.Anchored then h.Anchored = false end
        local speed = TLG.Fly.Spd
        if TLG.Fly.Boost then speed = speed * TLG.Fly.BoostMul end
        h.AssemblyLinearVelocity = dir.Unit * speed
      else
        h.AssemblyLinearVelocity = Vector3.zero
        h.AssemblyAngularVelocity = Vector3.zero
        if not h.Anchored then h.Anchored = true end
        if cam then
          h.CFrame = CFrame.new(h.Position,
            h.Position + cam.CFrame.LookVector)
        end
      end
    end)
  end)
end
UIS.InputBegan:Connect(function(i, gp)
  if gp then return end
  if i.KeyCode == Enum.KeyCode.Space then TLG.Fly.Keys.Up = true
  elseif i.KeyCode == Enum.KeyCode.LeftControl
    or i.KeyCode == Enum.KeyCode.C then
    TLG.Fly.Keys.Down = true
  end
end)
UIS.InputEnded:Connect(function(i)
  if i.KeyCode == Enum.KeyCode.Space then TLG.Fly.Keys.Up = false
  elseif i.KeyCode == Enum.KeyCode.LeftControl
    or i.KeyCode == Enum.KeyCode.C then
    TLG.Fly.Keys.Down = false
  end
end)
TLG.LP.CharacterAdded:Connect(function()
  if TLG.Fly.On then
    TLG.Fly.On = false
    if TLG.Fly.C then
      pcall(function() TLG.Fly.C:Disconnect() end); TLG.Fly.C = nil
    end
    task.wait(0.4); TLG.FlyS()
  end
end)

TLG.Speed = {On=false, Val=300, Original=nil}
function TLG.SetSpeedEnabled(enabled)
  local st = TLG.Speed
  enabled = enabled == true
  if enabled then
    if not st.On then
      local hum = TLG.LP.Character and TLG.LP.Character:FindFirstChildOfClass("Humanoid")
      st.Original = hum and hum.WalkSpeed or nil
    end
    st.On = true
  else
    st.On = false
    local hum = TLG.LP.Character and TLG.LP.Character:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum.WalkSpeed = st.Original or 16 end) end
    st.Original = nil
  end
end
RS.RenderStepped:Connect(function()
  if TLG.Speed.On then
    local h = TLG.LP.Character
      and TLG.LP.Character:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = TLG.Speed.Val end
  end
end)

-- ANTI ORBIT
local AntiOrbit = {
  On=false, Conn=nil, Sample=0, LastPos=nil, LastVel=nil,
  AngularScore=0, Radius=0, Threshold=0.65,
  RadiusMin=4, RadiusMax=250, MaxSpeed=350,
  Stabilize=true
}
TLG.AntiOrbit = AntiOrbit
TLG.AntiOrbitState = AntiOrbit

local function antiOrbitRoot()
  local ch = TLG.LP.Character
  return ch and ch:FindFirstChild("HumanoidRootPart")
end

local function antiOrbitReset()
  AntiOrbit.LastPos = nil
  AntiOrbit.LastVel = nil
  AntiOrbit.AngularScore = 0
  AntiOrbit.Radius = 0
end

function TLG.AntiOrbitStart()
  if AntiOrbit.On then return end
  AntiOrbit.On = true
  antiOrbitReset()

  AntiOrbit.Conn = RS.Heartbeat:Connect(function(dt)
    if not AntiOrbit.On then return end
    local root = antiOrbitRoot()
    if not root then
      antiOrbitReset()
      return
    end

    local pos = root.Position
    local vel = root.AssemblyLinearVelocity

    if AntiOrbit.LastPos then
      local delta = pos - AntiOrbit.LastPos
      local speed = delta.Magnitude / math.max(dt, 1/240)

      -- Estimate circular motion around the local player's position.
      local nearbyCount = 0
      local circularScore = 0

      for _, plr in ipairs(PLR:GetPlayers()) do
        if plr ~= TLG.LP then
          local ch = plr.Character
          local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
          local hum = ch and ch:FindFirstChildOfClass("Humanoid")
          if hrp and hum and hum.Health > 0 then
            local offset = hrp.Position - pos
            local r = offset.Magnitude
            if r >= AntiOrbit.RadiusMin and r <= AntiOrbit.RadiusMax then
              nearbyCount += 1
              local tangent = Vector3.new(-offset.Z, 0, offset.X)
              if tangent.Magnitude > 0.01 then
                local alignment = math.abs(
                  vel:Dot(tangent.Unit) /
                  math.max(vel.Magnitude, 1)
                )
                circularScore = math.max(circularScore, alignment)
              end
            end
          end
        end
      end

      AntiOrbit.AngularScore =
        AntiOrbit.AngularScore * 0.88 + circularScore * 0.12

      -- Local stabilization only. It does not claim server authority.
      if AntiOrbit.Stabilize and
         AntiOrbit.AngularScore >= AntiOrbit.Threshold and
         nearbyCount > 0 and speed > 2 and speed < AntiOrbit.MaxSpeed then
        root.AssemblyAngularVelocity =
          root.AssemblyAngularVelocity * 0.25

        if vel.Magnitude > AntiOrbit.MaxSpeed then
          root.AssemblyLinearVelocity =
            vel.Unit * AntiOrbit.MaxSpeed
        end
      end
    end

    AntiOrbit.LastPos = pos
    AntiOrbit.LastVel = vel
  end)

  TLG.PNotif("🛡️ Anti Orbit", "✅ Activado", C.Grn)
end

function TLG.AntiOrbitStop()
  AntiOrbit.On = false
  if AntiOrbit.Conn then
    pcall(function() AntiOrbit.Conn:Disconnect() end)
    AntiOrbit.Conn = nil
  end
  antiOrbitReset()
  TLG.PNotif("🛡️ Anti Orbit", "❌ Desactivado", C.Rd)
end

-- PROTECCIONES
local AntiVoid = {On=false, Conn=nil, Y=-100}
TLG.AntiVoidState = AntiVoid
function TLG.AntiVoidStart()
  if AntiVoid.On then return end
  AntiVoid.On = true
  AntiVoid.Conn = RS.Heartbeat:Connect(function()
    if not AntiVoid.On then return end
    local h = TLG.LP.Character
      and TLG.LP.Character:FindFirstChild("HumanoidRootPart")
    if h and h.Position.Y < AntiVoid.Y then
      h.CFrame = CFrame.new(h.Position.X, 200, h.Position.Z)
      TLG.PNotif("🛡️ Anti-Void", "Rescatado", C.Cyan)
    end
  end)
end
function TLG.AntiVoidStop()
  AntiVoid.On = false
  if AntiVoid.Conn then
    pcall(function() AntiVoid.Conn:Disconnect() end); AntiVoid.Conn = nil
  end
end

local AntiFling = {On=false, Conn=nil}
function TLG.AntiFlingStart()
  if AntiFling.On then return end
  AntiFling.On = true
  AntiFling.Conn = RS.Heartbeat:Connect(function()
    if not AntiFling.On then return end
    local ch = TLG.LP.Character; if not ch then return end
    local h = ch:FindFirstChild("HumanoidRootPart")
    local hu = ch:FindFirstChildOfClass("Humanoid")
    if h and hu and hu.PlatformStand then hu.PlatformStand = false end
    if h then
      local av = h.AssemblyLinearVelocity
      if av.Magnitude > 500 and not TLG.Fly.On then
        h.AssemblyLinearVelocity = av.Unit * 50
      end
    end
  end)
end
function TLG.AntiFlingStop()
  AntiFling.On = false
  if AntiFling.Conn then
    pcall(function() AntiFling.Conn:Disconnect() end); AntiFling.Conn = nil
  end
end

local AntiStun = {On=false, Conn=nil}
TLG.AntiStunState = AntiStun
local function antiStunForce()
  if not AntiStun.On then return end
  local ch = TLG.LP and TLG.LP.Character; if not ch then return end
  local v = ch:FindFirstChild("Stun")
    or ch:FindFirstChild("Stunned")
    or ch:FindFirstChild("StunValue")
  if v then
    pcall(function()
      if v:IsA("BoolValue") then v.Value = false
      elseif v:IsA("NumberValue") or v:IsA("IntValue") then
        v.Value = -1
      end
    end)
  end
end
function TLG.AntiStunStart()
  if AntiStun.On then return end
  AntiStun.On = true
  antiStunForce()
  AntiStun.Conn = RS.Heartbeat:Connect(antiStunForce)
end
function TLG.AntiStunStop()
  AntiStun.On = false
  if AntiStun.Conn then
    pcall(function() AntiStun.Conn:Disconnect() end); AntiStun.Conn = nil
  end
end

-- PANIC
function TLG.Panic()
  pcall(function() TLG.FlyE() end)
  pcall(function() TLG.HBStop() end)
  pcall(function() TLG.GOS() end)
  pcall(function() TLG.SpS() end)
  pcall(function() TLG.AIM_Stop() end)
  pcall(function() TLG.ESPStop() end)
  pcall(function() TLG.AntiVoidStop() end)
  pcall(function() TLG.AntiFlingStop() end)
  pcall(function() TLG.AntiStunStop() end)
  pcall(function() TLG.AntiOrbitStop() end)
  pcall(function() TLG.NoclipStop() end)
  pcall(function() TLG.InfJumpStop() end)
  pcall(function() TLG.ClickTPStop() end)
  pcall(function() TLG.AntiAFKStop() end)
  pcall(function() TLG.NoFallStop() end)
  pcall(function() TLG.FullbrightStop() end)
  pcall(function() TLG.HipHeightStop() end)
  pcall(function() TLG.AutoPromptStop() end)
  pcall(function() TLG.VisualSkillSpeedStop() end)
  pcall(function() TLG.SetSpeedEnabled(false) end)
  if TLG.SkyRestore then pcall(TLG.SkyRestore) end
  if TLG.RestoreOptimize then pcall(TLG.RestoreOptimize) end
  if TLG.AutoRejoinToggle then pcall(TLG.AutoRejoinToggle, false) end
  if TLG.FastAttackStop then pcall(TLG.FastAttackStop) end
  TLG.PNotif("🚨 PANIC", "Módulos desactivados", C.Rd)
end

-- AUTO REJOIN
local AutoRejoin = {On=false}
function TLG.QueueOnTeleport() end
function TLG.AutoRejoinToggle(v)
  AutoRejoin.On = v == true
  if v then TLG.PNotif("🔄 Auto-Rejoin", "Activado", C.Grn) end
end
TPS.TeleportInitFailed:Connect(function()
  if AutoRejoin.On then
    task.wait(3)
    pcall(function() TPS:Teleport(game.PlaceId, TLG.LP) end)
  end
end)
pcall(function()
  TLG.LP.OnTeleport:Connect(function(state)
    if AutoRejoin.On and state == Enum.TeleportState.Failed then
      task.wait(2)
      pcall(function() TPS:Teleport(game.PlaceId, TLG.LP) end)
    end
  end)
end)

-- AUTO COLLECT
local AutoPrompt = {On=false, Conn=nil, Range=25, LastScan=0, Interval=1.0}
function TLG.AutoPromptStart()
  if AutoPrompt.On then return end
  AutoPrompt.On = true
  AutoPrompt.LastScan = 0
  AutoPrompt.Conn = RS.Heartbeat:Connect(function()
    if not AutoPrompt.On then return end
    local now = os.clock()
    if now - AutoPrompt.LastScan < AutoPrompt.Interval then return end
    AutoPrompt.LastScan = now
    local h = TLG.LP.Character
      and TLG.LP.Character:FindFirstChild("HumanoidRootPart")
    if not h then return end
    for _, p in ipairs(workspace:GetDescendants()) do
      if p:IsA("ProximityPrompt") and p.Enabled
        and p.Parent and p.Parent:IsA("BasePart") then
        local d = (p.Parent.Position - h.Position).Magnitude
        if d <= AutoPrompt.Range then
          pcall(function()
            if fireproximityprompt then fireproximityprompt(p)
            else p:InputHoldBegin(); p:InputHoldEnd() end
          end)
        end
      end
    end
  end)
end
function TLG.AutoPromptStop()
  AutoPrompt.On = false
  if AutoPrompt.Conn then
    pcall(function() AutoPrompt.Conn:Disconnect() end); AutoPrompt.Conn = nil
  end
end

-- ⚡ MS (INPUT V9) + AUTO-PAUSA en habilidades
local FA = {
  On = false, Conn = nil, CharConn = nil, AnimConn = nil,
  Stun = nil, BurstCount = 3, BurstInterval = 0.025,
  BurstRate = 0.15, CachedPing = 50,
  LastPing = 0, LastBurst = 0, Tool = nil,
  Paused = false, PausedUntil = 0, PauseDuration = 0.6
}
TLG.FastAttack = FA

local ABILITY_KEYS = {
  [Enum.KeyCode.Z] = true, [Enum.KeyCode.X] = true,
  [Enum.KeyCode.C] = true, [Enum.KeyCode.V] = true,
  [Enum.KeyCode.F] = true, [Enum.KeyCode.G] = true,
  [Enum.KeyCode.Q] = true, [Enum.KeyCode.E] = true,
  [Enum.KeyCode.R] = true,
}

UIS.InputBegan:Connect(function(input, gp)
  if gp then return end
  if not FA.On then return end
  if ABILITY_KEYS[input.KeyCode] then
    FA.Paused = true
    FA.PausedUntil = os.clock() + FA.PauseDuration
  end
end)
UIS.InputBegan:Connect(function(input, gp)
  if gp then return end
  if not FA.On then return end
  if input.UserInputType == Enum.UserInputType.MouseButton2 then
    FA.Paused = true
    FA.PausedUntil = os.clock() + 0.3
  end
end)

local function faPing()
  local p = 0
  pcall(function()
    local st = game:GetService("Stats")
    local net = st:FindFirstChild("Network")
    if net then
      local ss = net:FindFirstChild("ServerStatsItem")
      if ss then
        local dp = ss:FindFirstChild("Data Ping")
        if dp then
          local n = tonumber(string.match(
            dp:GetValueString() or "", "%d+"))
          if n then p = n end
        end
      end
      if p == 0 then
        local dp = net:FindFirstChild("Data Ping")
        if dp then
          local n = tonumber(string.match(
            dp:GetValueString() or "", "%d+"))
          if n then p = n end
        end
      end
    end
  end)
  if p == 0 then p = TLG.getPing() end
  return p
end

local function faAnim(track)
  if not track then return end
  local text = ""
  pcall(function() text = text .. " " .. string.lower(track.Name or "") end)
  pcall(function()
    if track.Animation and track.Animation.Name then
      text = text .. " " .. string.lower(track.Animation.Name)
    end
  end)
  local sp = 1.15
  if string.find(text, "attack", 1, true)
    or string.find(text, "slash", 1, true)
    or string.find(text, "skill", 1, true)
    or string.find(text, "swing", 1, true) then
    sp = 1.40
  elseif string.find(text, "idle", 1, true) then
    sp = 1.00
  elseif string.find(text, "walk", 1, true)
    or string.find(text, "run", 1, true) then
    sp = 1.10
  end
  pcall(function() track:AdjustSpeed(sp) end)
end

local function faSetup(char)
  if not char then return end
  if FA.AnimConn then
    pcall(function() FA.AnimConn:Disconnect() end); FA.AnimConn = nil
  end
  FA.Stun = char:FindFirstChild("Stun") or char:WaitForChild("Stun", 5)
  local hum = char:FindFirstChildOfClass("Humanoid")
  if hum then
    FA.AnimConn = hum.AnimationPlayed:Connect(function(t)
      if FA.On then faAnim(t) end
    end)
  end
end

local function faTool()
  local ch = TLG.LP.Character
  if not ch then FA.Tool = nil; return end
  FA.Tool = ch:FindFirstChildOfClass("Tool")
end

local function faOnce()
  if FA.Paused and os.clock() < FA.PausedUntil then return end
  if FA.Paused then FA.Paused = false end
  local t = FA.Tool
  if not t or not t.Parent then
    faTool(); t = FA.Tool
  end
  if not t or not t.Parent then return end
  pcall(function() t:Activate() end)
end

local function faBurst()
  for i = 1, FA.BurstCount do
    if not FA.On then return end
    if FA.Paused and os.clock() < FA.PausedUntil then return end
    faOnce()
    if i < FA.BurstCount then
      task.wait(FA.BurstInterval)
    end
  end
end

function TLG.FastAttackStart()
  if FA.On then return end
  FA.On = true
  local ch = TLG.LP.Character
  if ch then faSetup(ch) end
  FA.CharConn = TLG.LP.CharacterAdded:Connect(function(c)
    task.wait(0.3)
    if FA.On then faSetup(c) end
  end)
  FA.Conn = RS.Heartbeat:Connect(function()
    if not FA.On then return end
    local now = os.clock()
    if FA.Paused and now >= FA.PausedUntil then
      FA.Paused = false
    end
    if now - FA.LastPing >= 1 then
      FA.CachedPing = faPing()
      FA.LastPing = now
    end
    if FA.Paused then return end
    local iv = FA.BurstRate * (1 + FA.CachedPing / 2000)
    if now - FA.LastBurst >= iv then
      FA.LastBurst = now
      faTool()
      task.spawn(faBurst)
    end
  end)
  TLG.PNotif("⚡ MS", "✅ Auto-burst", C.Grn)
end

function TLG.FastAttackStop()
  if not FA.On then return end
  FA.On = false
  FA.Paused = false
  if FA.Conn then
    pcall(function() FA.Conn:Disconnect() end); FA.Conn = nil
  end
  if FA.CharConn then
    pcall(function() FA.CharConn:Disconnect() end); FA.CharConn = nil
  end
  if FA.AnimConn then
    pcall(function() FA.AnimConn:Disconnect() end); FA.AnimConn = nil
  end
  TLG.PNotif("⚡ MS", "❌ Desactivado", C.Rd)
end

-- JOIN/LEAVE
PLR.PlayerAdded:Connect(function(p)
  if p ~= TLG.LP then
    task.wait(0.3)
    TLG.PNotif("➕ "..p.DisplayName, "Se unió", C.Grn)
  end
end)
PLR.PlayerRemoving:Connect(function(p)
  if p ~= TLG.LP then
    TLG.PNotif("➖ "..p.DisplayName, "Salió", C.Rd)
  end
end)


local function getWindowSize()
  local cam = workspace.CurrentCamera
  local viewport = cam and cam.ViewportSize or Vector2.new(800, 600)
  -- Panel de cristal a la derecha; la órbita de pestañas queda a la izquierda.
  local w = math.clamp(math.floor(viewport.X * 0.5), 300, 520)
  local h = math.clamp(viewport.Y - 40, 280, 460)
  return UDim2.new(0, w, 0, h)
end
local W_S = getWindowSize()
local W_P = UDim2.new(1, -(W_S.X.Offset / 2) - 12, 0.5, 0)


-- ═══════════════════════════════════════════════════════════════
-- SKYBOX TLG
-- ═══════════════════════════════════════════════════════════════
local Sky = {On=false, Ids=nil, Conn=nil, Stashed={}}
local function SkyGet()
    local s = Lighting:FindFirstChild("TLG_Sky")
    if not s then s = Instance.new("Sky"); s.Name = "TLG_Sky" end
    if s.Parent ~= Lighting then s.Parent = Lighting end
    return s
end
-- el juego ya trae su propio Sky y gana sobre el nuestro: lo guardamos aparte
local function SkyStashOthers()
    for _, o in ipairs(Lighting:GetChildren()) do
        if o:IsA("Sky") and o.Name ~= "TLG_Sky" then
            table.insert(Sky.Stashed, o)
            o.Parent = nil
        end
    end
end
local function SkySet(ids)
    local s = SkyGet()
    s.SkyboxBk=ids[1]; s.SkyboxDn=ids[2]; s.SkyboxFt=ids[3]
    s.SkyboxLf=ids[4]; s.SkyboxRt=ids[5]; s.SkyboxUp=ids[6]
    s.SkyboxOrientation = Vector3.new(0,0,0)
    pcall(function() s.CelestialBodiesShown = true; s.StarCount = 3000 end)
end
local function SkyRestoreOriginal()
    Sky.On = false; Sky.Ids = nil
    pcall(function()
        local s = Lighting:FindFirstChild("TLG_Sky")
        if s then s:Destroy() end
        for _, o in ipairs(Sky.Stashed) do
            if o then o.Parent = Lighting end
        end
        Sky.Stashed = {}
    end)
end
TLG.SkyRestore = SkyRestoreOriginal
local function SkyApply(ids)
    if Sky.Conn then pcall(function() Sky.Conn:Disconnect() end); Sky.Conn = nil end
    if not ids then SkyRestoreOriginal(); return end
    Sky.Ids = ids; Sky.On = true
    SkyStashOthers()
    SkySet(ids)
    Sky.Conn = RS.Heartbeat:Connect(function()
        if not Sky.On or not Sky.Ids then return end
        pcall(function()
            SkyStashOthers()
            local s = SkyGet()
            local i = Sky.Ids
            if s.SkyboxBk~=i[1] or s.SkyboxDn~=i[2] or s.SkyboxFt~=i[3]
               or s.SkyboxLf~=i[4] or s.SkyboxRt~=i[5] or s.SkyboxUp~=i[6] then
                SkySet(i)
            end
        end)
    end)
end
TLG.SkyRestore = function()
    SkyApply(nil)
end

local W = Instance.new("Frame", SG)
W.Size = W_S
W.AnchorPoint = Vector2.new(0.5,0.5)
W.Position = UDim2.new(0.5,0,1,W_S.Y.Offset)
W.BackgroundColor3 = C.BG
W.BorderSizePixel = 0
W.ClipsDescendants = true
W.Active = true
W.ZIndex = 1
Instance.new("UICorner", W).CornerRadius = UDim.new(0,12)

local WS = Instance.new("UIStroke", W)
WS.Thickness = 2
WS.Color = Color3.fromRGB(205,112,55)
TLG.PGlow(WS, 0.08, 0.28, 1.5)

local Wgrad = Instance.new("UIGradient", W)
Wgrad.Color = ColorSequence.new(Color3.fromRGB(10,6,7), Color3.fromRGB(42,20,18))
Wgrad.Rotation = 135

TLG.W = W
TLG.W_S = W_S
TLG.W_P = W_P

local function AddPattern(parent, size, color, transp, rotation)
    local holder = Instance.new("Frame", parent)
    holder.Size = UDim2.new(1,0,1,0)
    holder.BackgroundTransparency = 1
    holder.ZIndex = 0
    holder.ClipsDescendants = true
    for i = 0, 10 do
        for j = 0, 8 do
            local icon = Instance.new("TextLabel", holder)
            icon.Size = UDim2.new(0,size,0,size)
            icon.Position = UDim2.new(0, i*size + (j%2)*size/2, 0, j*size)
            icon.BackgroundTransparency = 1
            icon.Text = "💀"
            icon.TextSize = size * 0.7
            icon.TextColor3 = color
            icon.TextTransparency = transp
            icon.Rotation = rotation
            icon.ZIndex = 0
        end
    end
end
-- AddPattern(W, 42, C.Yel, 0.94, 15) (desactivado: estilo cristal)

local TB = Instance.new("Frame", W)
TB.Size = UDim2.new(1,0,0,54)
TB.BackgroundColor3 = C.BG2
TB.BackgroundTransparency = 0.05
TB.BorderSizePixel = 0
TB.ZIndex = 5
Instance.new("UICorner", TB).CornerRadius = UDim.new(0,12)

local HF = Instance.new("Frame", TB)
HF.Size = UDim2.new(1,0,0,12)
HF.Position = UDim2.new(0,0,1,-12)
HF.BackgroundColor3 = C.BG2
HF.BackgroundTransparency = 0.05
HF.BorderSizePixel = 0
HF.ZIndex = 5

-- AddPattern(TB, 32, C.Yel, 0.85, 0) (desactivado: estilo cristal)

local DcIco = Instance.new("TextLabel", TB)
DcIco.Size = UDim2.new(0,26,0,26)
DcIco.Position = UDim2.new(0,10,0.5,-13)
DcIco.BackgroundColor3 = C.BG3
DcIco.Text = "💀"
DcIco.TextSize = 15
DcIco.Font = Enum.Font.GothamBold
DcIco.TextColor3 = C.Yel
DcIco.ZIndex = 10
Instance.new("UICorner", DcIco).CornerRadius = UDim.new(1,0)

local DcS = Instance.new("UIStroke", DcIco)
DcS.Color = C.Yel
DcS.Thickness = 1.5
TLG.PGlow(DcS, 0.1, 0.5, 1.2)

local MainTitle = Instance.new("TextLabel", TB)
MainTitle.Size = UDim2.new(0.52,0,0,23)
MainTitle.Position = UDim2.new(0.24,0,0,3)
MainTitle.AnchorPoint = Vector2.new(0,0)
MainTitle.BackgroundTransparency = 1
MainTitle.Font = Enum.Font.Garamond
MainTitle.Text = "ZTB HUB"
MainTitle.TextSize = 20
MainTitle.TextColor3 = C.Yel
MainTitle.TextXAlignment = Enum.TextXAlignment.Center
MainTitle.ZIndex = 10

local SubTitle = Instance.new("TextLabel", TB)
SubTitle.Size = UDim2.new(0.52,0,0,14)
SubTitle.Position = UDim2.new(0.24,0,0,29)
SubTitle.BackgroundTransparency = 1
SubTitle.Font = Enum.Font.Garamond
SubTitle.Text = "✦ MEME SEA  •  ZTB EDITION ✦"
SubTitle.TextSize = 11
SubTitle.TextColor3 = C.Gr
SubTitle.TextXAlignment = Enum.TextXAlignment.Center
SubTitle.ZIndex = 10

local StatsPanel = Instance.new("Frame", TB)
StatsPanel.Size = UDim2.new(0,112,0,20)
StatsPanel.Position = UDim2.new(1,-154,0,3)
StatsPanel.BackgroundColor3 = C.BG3
StatsPanel.BackgroundTransparency = 0.3
StatsPanel.BorderSizePixel = 0
StatsPanel.ZIndex = 8
Instance.new("UICorner", StatsPanel).CornerRadius = UDim.new(0,6)

local StatS = Instance.new("UIStroke", StatsPanel)
StatS.Color = C.Yel
StatS.Thickness = 1
StatS.Transparency = 0.6

local FpsLabel = Instance.new("TextLabel", StatsPanel)
FpsLabel.Size = UDim2.new(0.5,-6,1,0)
FpsLabel.Position = UDim2.new(0,4,0,0)
FpsLabel.BackgroundTransparency = 1
FpsLabel.Font = Enum.Font.GothamBold
FpsLabel.Text = "FPS: --"
FpsLabel.TextColor3 = C.Grn
FpsLabel.TextSize = 9
FpsLabel.TextXAlignment = Enum.TextXAlignment.Left
FpsLabel.ZIndex = 9

local PingLabel = Instance.new("TextLabel", StatsPanel)
PingLabel.Size = UDim2.new(0.5,-6,1,0)
PingLabel.Position = UDim2.new(0.5,2,0,0)
PingLabel.BackgroundTransparency = 1
PingLabel.Font = Enum.Font.GothamBold
PingLabel.Text = "Ping: --"
PingLabel.TextColor3 = C.Cyan
PingLabel.TextSize = 9
PingLabel.TextXAlignment = Enum.TextXAlignment.Right
PingLabel.ZIndex = 9

task.spawn(function()
    local fc = 0
    local lt = os.clock()
    RS.RenderStepped:Connect(function()
        fc = fc + 1
        local n = os.clock()
        if n - lt >= 1 then
            FpsLabel.Text = "FPS: " .. math.floor(fc / (n - lt))
            PingLabel.Text = "Ping: " .. TLG.getPing() .. "ms"
            fc = 0
            lt = n
        end
    end)
end)

local STtl = Instance.new("TextLabel", TB)
STtl.Size = UDim2.new(0,60,1,0)
STtl.Position = UDim2.new(1,-64,0,0)
STtl.BackgroundTransparency = 1
STtl.Font = Enum.Font.GothamBold
STtl.Text = "👑"
STtl.TextSize = 14
STtl.TextColor3 = C.Yel
STtl.TextXAlignment = Enum.TextXAlignment.Right
STtl.ZIndex = 7

TLG.STtl = STtl

-- Rediseño: botón de cierre visible en la esquina superior derecha.
local CloseBtn = Instance.new("TextButton", TB)
CloseBtn.Name = "ZTB_CloseButton"
CloseBtn.Size = UDim2.new(0,28,0,28)
CloseBtn.Position = UDim2.new(1,-34,0.5,-14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(48,18,20)
CloseBtn.BackgroundTransparency = 0.05
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.Font = Enum.Font.Garamond
CloseBtn.TextSize = 27
CloseBtn.TextColor3 = Color3.fromRGB(255,190,135)
CloseBtn.ZIndex = 20
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,7)
local CloseStroke = Instance.new("UIStroke", CloseBtn)
CloseStroke.Color = Color3.fromRGB(205,112,55)
CloseStroke.Transparency = 0.25
CloseBtn.Activated:Connect(function()
    if TLG.ZTB_SetMin then
        TLG.ZTB_SetMin(true)
    else
        pcall(function() W.Visible = false end)
        pcall(function() WM.Visible = false end)
    end
end)

local DragS = {active=false, start=nil, pos=nil}
local function makeDrag(handle)
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
           or i.UserInputType == Enum.UserInputType.Touch then
            DragS.active = true
            DragS.start = i.Position
            DragS.pos = W.Position
        end
    end)
end
UIS.InputChanged:Connect(function(i)
    if DragS.active and (i.UserInputType == Enum.UserInputType.MouseMovement
       or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - DragS.start
        local cam = workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        local p0 = DragS.pos
        local ap = W.AnchorPoint
        local w, h = W.AbsoluteSize.X, W.AbsoluteSize.Y
        local x = p0.X.Scale * vp.X + p0.X.Offset + d.X
        local y = p0.Y.Scale * vp.Y + p0.Y.Offset + d.Y
        local loX, hiX = ap.X * w, vp.X - (1 - ap.X) * w
        local loY, hiY = ap.Y * h, vp.Y - (1 - ap.Y) * h
        if hiX < loX then hiX = loX end
        if hiY < loY then hiY = loY end
        x = math.clamp(x, loX, hiX)
        y = math.clamp(y, loY, hiY)
        W.Position = UDim2.new(p0.X.Scale, x - p0.X.Scale * vp.X,
                               p0.Y.Scale, y - p0.Y.Scale * vp.Y)
    end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
       or i.UserInputType == Enum.UserInputType.Touch then
        DragS.active = false
    end
end)
makeDrag(TB)

-- PANEL 2: barra lateral + panel de contenido, estilo dashboard oscuro
local SideBar = Instance.new("Frame", W)
SideBar.Name = "ZTB_SideBar"
SideBar.Size = UDim2.new(0, TLG.IsMobile and 112 or 158, 1, -94)
SideBar.Position = UDim2.new(0, 6, 0, 56)
SideBar.BackgroundColor3 = C.BG2
SideBar.BackgroundTransparency = 0.18
SideBar.BorderSizePixel = 0
SideBar.ZIndex = 4
Instance.new("UICorner", SideBar).CornerRadius = UDim.new(0, 10)
local SideStroke = Instance.new("UIStroke", SideBar)
SideStroke.Color = C.Yel; SideStroke.Transparency = 0.78; SideStroke.Thickness = 1

local SideTitle = Instance.new("TextLabel", SideBar)
SideTitle.Size = UDim2.new(1,-12,0,27)
SideTitle.Position = UDim2.new(0,7,0,4)
SideTitle.BackgroundTransparency = 1
SideTitle.Font = Enum.Font.GothamBold
SideTitle.Text = "ZTB  •  MENU"
SideTitle.TextColor3 = C.Yel
SideTitle.TextSize = TLG.IsMobile and 9 or 11
SideTitle.TextXAlignment = Enum.TextXAlignment.Left
SideTitle.ZIndex = 5

local TScr = Instance.new("ScrollingFrame", SideBar)
TScr.Name = "ZTB_Navigation"
TScr.Size = UDim2.new(1,-8,1,-36)
TScr.Position = UDim2.new(0,4,0,32)
TScr.BackgroundTransparency = 1
TScr.BorderSizePixel = 0
TScr.ScrollBarThickness = TLG.IsMobile and 3 or 4
TScr.ScrollBarImageColor3 = C.Yel
TScr.CanvasSize = UDim2.new(0,0,0,0)
TScr.ZIndex = 5
TScr.ScrollingDirection = Enum.ScrollingDirection.Y
pcall(function() TScr.AutomaticCanvasSize = Enum.AutomaticSize.Y end)
local TLy = Instance.new("UIListLayout", TScr)
TLy.FillDirection = Enum.FillDirection.Vertical
TLy.VerticalAlignment = Enum.VerticalAlignment.Top
TLy.HorizontalAlignment = Enum.HorizontalAlignment.Center
TLy.Padding = UDim.new(0,5)

local Cont = Instance.new("Frame", W)
Cont.Name = "ZTB_ContentPanel"
Cont.Size = UDim2.new(1, -(TLG.IsMobile and 128 or 174), 1, -108)
Cont.Position = UDim2.new(0, TLG.IsMobile and 120 or 164, 0, 58)
Cont.BackgroundColor3 = C.BG2
Cont.BackgroundTransparency = 0.34
Cont.BorderSizePixel = 0
Cont.ZIndex = 3
Instance.new("UICorner", Cont).CornerRadius = UDim.new(0,10)
local ContStroke = Instance.new("UIStroke", Cont)
ContStroke.Color = C.Yel; ContStroke.Transparency = 0.82; ContStroke.Thickness = 1
TLG.TabBar = SideBar
TLG.Cont = Cont

local BH = Instance.new("Frame", W)
BH.Name = "ZTB_BottomHandle"
BH.Size = UDim2.new(1,-10,0,12)
BH.Position = UDim2.new(0,5,1,-16)
BH.BackgroundColor3 = C.BG2
BH.BackgroundTransparency = 0.2
BH.BorderSizePixel = 0
BH.ZIndex = 8
Instance.new("UICorner", BH).CornerRadius = UDim.new(1,0)
local BHs = Instance.new("UIStroke", BH)
BHs.Color = C.Yel; BHs.Thickness = 1; BHs.Transparency = 0.75
local BHp = Instance.new("Frame", BH)
BHp.Size = UDim2.new(0,42,0,3)
BHp.Position = UDim2.new(0.5,-21,0.5,-1)
BHp.BackgroundColor3 = C.Yel
BHp.BorderSizePixel = 0
BHp.ZIndex = 9
Instance.new("UICorner", BHp).CornerRadius = UDim.new(1,0)
makeDrag(BH)
TLG.BotHandle = BH

local Tabs = {}

local function Tab(name, icon)
    local b = Instance.new("TextButton", TScr)
    b.Size = UDim2.new(1,-4,0,TLG.IsMobile and 36 or 42)
    b.BackgroundColor3 = C.BG3
    b.BackgroundTransparency = 1
    b.Text = ""
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = 6
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

    local ico = Instance.new("TextLabel", b)
    ico.Size = UDim2.new(0,26,1,0)
    ico.Position = UDim2.new(0,5,0,0)
    ico.BackgroundTransparency = 1
    ico.Text = icon
    ico.TextSize = TLG.IsMobile and 14 or 16
    ico.ZIndex = 7

    local lb = Instance.new("TextLabel", b)
    lb.Size = UDim2.new(1,-34,1,0)
    lb.Position = UDim2.new(0,32,0,0)
    lb.BackgroundTransparency = 1
    lb.Font = Enum.Font.GothamSemibold
    lb.Text = name
    lb.TextColor3 = C.Gr
    lb.TextSize = TLG.IsMobile and 9 or 11
    lb.TextTruncate = Enum.TextTruncate.AtEnd
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.ZIndex = 7

    local ul = Instance.new("Frame", b)
    ul.Size = UDim2.new(0,3,0,0)
    ul.Position = UDim2.new(0,0,0.5,0)
    ul.AnchorPoint = Vector2.new(0,0.5)
    ul.BackgroundColor3 = C.Yel
    ul.BorderSizePixel = 0
    ul.ZIndex = 8
    Instance.new("UICorner", ul).CornerRadius = UDim.new(1,0)

    local pg = Instance.new("ScrollingFrame", Cont)
    pg.Size = UDim2.new(1,0,1,0)
    pg.Position = UDim2.new(0,0,0,0)
    pg.BackgroundTransparency = 1
    pg.BorderSizePixel = 0
    pg.ScrollBarThickness = TLG.IsMobile and 4 or 6
    pg.ScrollBarImageColor3 = C.Yel
    pg.CanvasSize = UDim2.new(0,0,0,0)
    pg.ZIndex = 4
    pcall(function() pg.AutomaticCanvasSize = Enum.AutomaticSize.Y end)
    pg.Visible = false
    local pl = Instance.new("UIListLayout", pg)
    pl.Padding = UDim.new(0,7)
    local pp = Instance.new("UIPadding", pg)
    pp.PaddingTop = UDim.new(0,10)
    pp.PaddingLeft = UDim.new(0,10)
    pp.PaddingRight = UDim.new(0,10)
    pp.PaddingBottom = UDim.new(0,10)

    local entry = {b=b,l=lb,p=pg,u=ul,ico=ico,name=name,icon=icon}
    table.insert(Tabs, entry)
    local function sel()
        for _, t in ipairs(Tabs) do
            t.l.TextColor3 = C.Gr
            t.ico.TextTransparency = 0.25
            t.p.Visible = false
            t.b.BackgroundTransparency = 1
            TW:Create(t.u,TweenInfo.new(0.18),{Size=UDim2.new(0,3,0,0)}):Play()
        end
        lb.TextColor3 = C.Yel
        ico.TextTransparency = 0
        pg.Visible = true
        b.BackgroundTransparency = 0.18
        TW:Create(ul,TweenInfo.new(0.2,Enum.EasingStyle.Quint),{Size=UDim2.new(0,3,0.62,0)}):Play()
    end
    entry.sel = sel
    b.Activated:Connect(sel)
    return pg
end

local function Sec(p, txt, ico)
    local s = Instance.new("Frame", p)
    s.Size = UDim2.new(1,0,0,30)
    s.BackgroundColor3 = C.BG2
    s.BackgroundTransparency = 0.3
    s.BorderSizePixel = 0
    s.ZIndex = 5
    Instance.new("UICorner", s).CornerRadius = UDim.new(0,7)
    local sS = Instance.new("UIStroke", s)
    sS.Thickness = 1
    sS.Transparency = 0.7
    sS.Color = C.Yel
    local bar = Instance.new("Frame", s)
    bar.Size = UDim2.new(0,3,0,16)
    bar.Position = UDim2.new(0,8,0.5,-8)
    bar.BorderSizePixel = 0
    bar.ZIndex = 7
    bar.BackgroundColor3 = C.Yel
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
    local l = Instance.new("TextLabel", s)
    l.Size = UDim2.new(1,-34,1,0)
    l.Position = UDim2.new(0,20,0,0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBold
    l.Text = (ico or "") .. "  " .. txt
    l.TextSize = 11
    l.TextColor3 = C.Wh
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 6
end

local function Lbl(p, txt, col)
    if typeof(col) ~= "Color3" then col = C.Gr end
    local l = Instance.new("TextLabel", p)
    l.Size = UDim2.new(1,0,0,12)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.Gotham
    l.Text = txt
    l.TextColor3 = col
    l.TextSize = 9
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 5
    return l
end

local lastErr = 0
local function safeCB(cb, ...)
    local ok, err = xpcall(cb, function(e) return tostring(e) end, ...)
    if not ok then
        warn("[TLG] " .. tostring(err))
        if os.clock() - lastErr > 1.5 then
            lastErr = os.clock()
            pcall(function() TLG.PNotif("⚠️ Error", tostring(err):sub(1, 70), C.Rd) end)
        end
    end
end

local function Tog(p, txt, def, cb)
    local sv = def == true
    local OFFC = Color3.fromRGB(45,45,45)
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(1,0,0,40)
    f.BackgroundColor3 = Color3.fromRGB(10,10,10)
    f.BackgroundTransparency = 0.05
    f.BorderSizePixel = 0
    f.ZIndex = 5
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
    local fs = Instance.new("UIStroke", f)
    fs.Color = C.Yel; fs.Thickness = 1; fs.Transparency = sv and 0.3 or 0.75
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1,-110,1,0)
    l.Position = UDim2.new(0,14,0,0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamSemibold
    l.Text = txt
    l.TextColor3 = C.Wh
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 7
    local sw = Instance.new("Frame", f)
    sw.Size = UDim2.new(0,46,0,24)
    sw.Position = UDim2.new(1,-78,0.5,-12)
    sw.BackgroundColor3 = sv and C.Yel or OFFC
    sw.BorderSizePixel = 0
    sw.ZIndex = 6
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1,0)
    local kn = Instance.new("Frame", sw)
    kn.Size = UDim2.new(0,18,0,18)
    kn.Position = sv and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    kn.BackgroundColor3 = C.Wh
    kn.BorderSizePixel = 0
    kn.ZIndex = 7
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1,0)
    local dot = Instance.new("Frame", f)
    dot.Size = UDim2.new(0,10,0,10)
    dot.Position = UDim2.new(1,-22,0.5,-5)
    dot.BackgroundColor3 = sv and C.Yel or C.Rd
    dot.BorderSizePixel = 0
    dot.ZIndex = 7
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    local st = sv
    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 10
    btn.Activated:Connect(function()
        st = not st
        TW:Create(sw, TweenInfo.new(0.25, Enum.EasingStyle.Back), {BackgroundColor3 = st and C.Yel or OFFC}):Play()
        TW:Create(kn, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = st and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)}):Play()
        TW:Create(dot, TweenInfo.new(0.25), {BackgroundColor3 = st and C.Yel or C.Rd}):Play()
        TW:Create(fs, TweenInfo.new(0.25), {Transparency = st and 0.3 or 0.75}):Play()
        safeCB(cb, st)
    end)
end

local function Sli(p, txt, mn, mx, def, cb)
    -- Control sin slider: flechas para evitar fallos de arrastre en móvil.
    local value = math.clamp(math.floor(tonumber(def) or mn), mn, mx)
    local step = math.max(1, math.floor((mx - mn) / 20))
    local f = Instance.new("Frame", p)
    f.Size = UDim2.new(1,0,0,38)
    f.BackgroundColor3 = Color3.fromRGB(22,13,15)
    f.BackgroundTransparency = 0.05
    f.BorderSizePixel = 0
    f.ZIndex = 5
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)
    local stroke = Instance.new("UIStroke", f)
    stroke.Color = Color3.fromRGB(180,95,45); stroke.Thickness = 1; stroke.Transparency = 0.45
    local label = Instance.new("TextLabel", f)
    label.Size = UDim2.new(0.48,-8,1,0)
    label.Position = UDim2.new(0,10,0,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Text = txt
    label.TextColor3 = C.Wh
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 7
    local val = Instance.new("TextLabel", f)
    val.Size = UDim2.new(0.22,0,1,0)
    val.Position = UDim2.new(0.49,0,0,0)
    val.BackgroundTransparency = 1
    val.Font = Enum.Font.GothamBold
    val.TextColor3 = Color3.fromRGB(255,170,90)
    val.TextSize = 10
    val.ZIndex = 7
    local function refresh()
        val.Text = tostring(value)
        safeCB(cb, value)
    end
    local function arrow(symbol, x, delta)
        local b = Instance.new("TextButton", f)
        b.Size = UDim2.new(0,28,0,26)
        b.Position = UDim2.new(x,-14,0.5,-13)
        b.BackgroundColor3 = Color3.fromRGB(45,24,23)
        b.Text = symbol; b.TextColor3 = Color3.fromRGB(255,180,100)
        b.TextSize = 16; b.Font = Enum.Font.GothamBold
        b.BorderSizePixel = 0; b.ZIndex = 8
        Instance.new("UICorner", b).CornerRadius = UDim.new(0,6)
        b.Activated:Connect(function()
            value = math.clamp(value + delta * step, mn, mx)
            refresh()
        end)
    end
    arrow("◀", 0.78, -1)
    arrow("▶", 0.92, 1)
    refresh()
end

local function Btn(p, txt, col, cb)
    local b = Instance.new("TextButton", p)
    b.Size = UDim2.new(1,0,0,34)
    b.BackgroundColor3 = Color3.fromRGB(10,10,10)
    b.BackgroundTransparency = 0.1
    b.Font = Enum.Font.GothamBold
    b.Text = txt
    b.TextColor3 = col or C.Wh
    b.TextSize = 10
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.ZIndex = 5
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    local bS = Instance.new("UIStroke", b)
    bS.Thickness = 1
    bS.Transparency = 0.6
    bS.Color = C.Yel
    TLG.Ripple(b)
    b.MouseEnter:Connect(function() TW:Create(bS, TweenInfo.new(0.15), {Transparency = 0.1}):Play() end)
    b.MouseLeave:Connect(function() TW:Create(bS, TweenInfo.new(0.2), {Transparency = 0.6}):Play() end)
    b.Activated:Connect(function() safeCB(cb) end)
    return b
end

TLG.Tabs = Tabs
TLG.Sec = Sec
TLG.Lbl = Lbl
TLG.Tog = Tog
TLG.Sli = Sli
TLG.Btn = Btn

local PInfo = Tab("Info", "👤")
local PCb = Tab("Combat", "⚔️")
local PAb = Tab("Aimbot", "🎯")
local PFl = Tab("Fly", "🚀")
local PIs = Tab("Islands", "🏝️")
local PSc = Tab("Scripts", "💻")
local PTo = Tab("Tools", "🛠️")
local PEs = Tab("ESP", "👁️")
local PVi = Tab("Visuals", "✨")
local POp = Tab("Optimize", "⚡")


task.wait(0.1)
if Tabs[1] then
    Tabs[1].l.TextColor3 = C.Yel
    Tabs[1].ico.TextTransparency = 0
    Tabs[1].p.Visible = true
    Tabs[1].b.BackgroundColor3 = C.BG3
    Tabs[1].b.BackgroundTransparency = 0.18
    TW:Create(Tabs[1].u, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0,3,0.62,0)}):Play()
end

TLG.PInfo = PInfo
TLG.PCb = PCb
TLG.PAb = PAb
TLG.PFl = PFl
TLG.PIs = PIs
TLG.PSc = PSc
TLG.PTo = PTo
TLG.PEs = PEs
TLG.PVi = PVi
TLG.POp = POp


-- INFO TAB (perfil del jugador seleccionado)
local infoOK, infoERR = pcall(function()
  local function fmt(n)
    n = math.floor(tonumber(n) or 0)
    local r = tostring(n):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    return (r:gsub("^,", ""))
  end
  local function short(n)
    n = tonumber(n) or 0
    local a = math.abs(n)
    if a >= 1e12 then return string.format("%.2fT", n / 1e12)
    elseif a >= 1e9 then return string.format("%.2fB", n / 1e9)
    elseif a >= 1e6 then return string.format("%.2fM", n / 1e6)
    elseif a >= 1e4 then return string.format("%.1fK", n / 1e3) end
    return fmt(n)
  end

  local bSp, bGo
  local list, idx = {}, 1
  local nameL, userL, idL, avatar, hpFill, hpText
  local vals = {}
  local avatarFor = nil
  local avatarCache = {}
  local labels = {"Nivel","Power","Melee","Weapon","Cash","Gems"}

  local function rebuild()
    local cur = TLG.SelectedTarget
    list = {}
    for _, p in ipairs(PLR:GetPlayers()) do table.insert(list, p) end
    table.sort(list, function(a, b) return a.Name:lower() < b.Name:lower() end)
    idx = 1
    local found = false
    for i, p in ipairs(list) do
      if p == cur then idx = i; found = true end
    end
    if not found then
      for i, p in ipairs(list) do
        if p ~= TLG.LP then idx = i; break end
      end
    end
    TLG.SelectedTarget = list[idx]
  end

  local function step(d)
    rebuild()
    if #list == 0 then return end
    idx = ((idx - 1 + d) % #list) + 1
    TLG.SelectedTarget = list[idx]
  end

  local function setAvatar(p)
    if avatarFor == p.UserId then return end
    avatarFor = p.UserId
    if avatarCache[p.UserId] then avatar.Image = avatarCache[p.UserId]; return end
    avatar.Image = ""
    task.spawn(function()
      local ok, img = pcall(function()
        return PLR:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
      end)
      if ok and img then
        avatarCache[p.UserId] = img
        if avatarFor == p.UserId then avatar.Image = img end
      end
    end)
  end

  local function refresh()
    local p = TLG.SelectedTarget
    if not p or not p.Parent then rebuild(); p = TLG.SelectedTarget end
    if bSp then bSp.Text = TLG.Sp.T and "🛑 Dejar de espectear" or "👁️ Spectear" end
    if bGo then bGo.Text = TLG.GO.On and "🛑 Detener God Orb" or "🌀 God Orb" end
    if not p then
      nameL.Text = "Sin jugadores"; userL.Text = ""; idL.Text = ""
      for _, v in ipairs(vals) do v.Text = "—" end
      hpText.Text = "—"
      return
    end
    local s = TLG.GetStats(p)
    nameL.Text = p.DisplayName .. (p == TLG.LP and "  (tú)" or "")
    userL.Text = "@" .. p.Name
    idL.Text = "ID: " .. tostring(p.UserId)
    setAvatar(p)
    local ratio = (s.MaxHealth > 0) and math.clamp(s.Health / s.MaxHealth, 0, 1) or 0
    local data = {short(s.Level), short(s.Power), short(s.Melee), short(s.Weapon),
      short(s.Cash), short(s.Gems)}
    for i, v in ipairs(vals) do v.Text = data[i] end
    hpText.Text = "❤ " .. short(s.Health) .. " / " .. short(s.MaxHealth)
    TW:Create(hpFill, TweenInfo.new(0.25), {Size = UDim2.new(ratio, 0, 1, 0),
      BackgroundColor3 = Color3.fromHSV(ratio * 0.33, 0.7, 1)}):Play()
  end

  Sec(PInfo, "JUGADOR SELECCIONADO", "📊")
  local card = Instance.new("Frame", PInfo)
  card.Size = UDim2.new(1, 0, 0, 228)
  card.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
  card.BackgroundTransparency = 0.05
  card.BorderSizePixel = 0
  card.ZIndex = 5
  Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
  local cs = Instance.new("UIStroke", card)
  cs.Color = C.Yel; cs.Thickness = 1.5; cs.Transparency = 0.45

  avatar = Instance.new("ImageLabel", card)
  avatar.Size = UDim2.new(0, 66, 0, 66)
  avatar.Position = UDim2.new(0, 14, 0, 14)
  avatar.BackgroundColor3 = C.BG3
  avatar.BorderSizePixel = 0
  avatar.ZIndex = 7
  Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)
  local avs = Instance.new("UIStroke", avatar)
  avs.Color = C.Yel; avs.Thickness = 2

  local function mkText(size, pos, ts, font, col)
    local t = Instance.new("TextLabel", card)
    t.Size = size
    t.Position = pos
    t.BackgroundTransparency = 1
    t.Font = font
    t.TextSize = ts
    t.TextColor3 = col
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextTruncate = Enum.TextTruncate.AtEnd
    t.Text = ""
    t.ZIndex = 7
    return t
  end
  nameL = mkText(UDim2.new(1, -190, 0, 24), UDim2.new(0, 90, 0, 14), 17, Enum.Font.GothamBold, C.Wh)
  userL = mkText(UDim2.new(1, -190, 0, 16), UDim2.new(0, 90, 0, 40), 11, Enum.Font.Gotham, C.Gr)
  idL = mkText(UDim2.new(1, -190, 0, 16), UDim2.new(0, 90, 0, 58), 10, Enum.Font.Gotham, C.Gr)

  local function mkArrow(txt, pos, d)
    local a = Instance.new("TextButton", card)
    a.Size = UDim2.new(0, 34, 0, 34)
    a.Position = pos
    a.BackgroundColor3 = C.BG3
    a.BackgroundTransparency = 0.2
    a.BorderSizePixel = 0
    a.AutoButtonColor = false
    a.Text = txt
    a.Font = Enum.Font.GothamBold
    a.TextSize = 22
    a.TextColor3 = C.Yel
    a.ZIndex = 8
    Instance.new("UICorner", a).CornerRadius = UDim.new(1, 0)
    local st = Instance.new("UIStroke", a)
    st.Color = C.Yel; st.Thickness = 1; st.Transparency = 0.5
    a.Activated:Connect(function() step(d); pcall(refresh) end)
  end
  mkArrow("‹", UDim2.new(1, -84, 0, 24), -1)
  mkArrow("›", UDim2.new(1, -46, 0, 24), 1)

  local div = Instance.new("Frame", card)
  div.Size = UDim2.new(1, -28, 0, 1)
  div.Position = UDim2.new(0, 14, 0, 92)
  div.BackgroundColor3 = C.Yel
  div.BackgroundTransparency = 0.6
  div.BorderSizePixel = 0
  div.ZIndex = 6

  for i, lab in ipairs(labels) do
    local col, row = (i - 1) % 3, math.floor((i - 1) / 3)
    local cf = Instance.new("Frame", card)
    cf.Size = UDim2.new(1/3, -12, 0, 40)
    cf.Position = UDim2.new(col / 3, 8, 0, 100 + row * 41)
    cf.BackgroundTransparency = 1
    cf.ZIndex = 6
    Instance.new("UICorner", cf).CornerRadius = UDim.new(0, 8)
    local cst = Instance.new("UIStroke", cf)
    cst.Color = C.Yel; cst.Thickness = 1; cst.Transparency = 0.85
    local ll = Instance.new("TextLabel", cf)
    ll.Size = UDim2.new(1, 0, 0, 14)
    ll.Position = UDim2.new(0, 0, 0, 3)
    ll.BackgroundTransparency = 1
    ll.Font = Enum.Font.Gotham
    ll.TextSize = 10
    ll.TextColor3 = C.Gr
    ll.Text = lab
    ll.ZIndex = 7
    local vl = Instance.new("TextLabel", cf)
    vl.Size = UDim2.new(1, 0, 0, 20)
    vl.Position = UDim2.new(0, 0, 0, 17)
    vl.BackgroundTransparency = 1
    vl.Font = Enum.Font.GothamBold
    vl.TextSize = 14
    vl.TextColor3 = C.Wh
    vl.Text = "—"
    vl.ZIndex = 7
    vals[i] = vl
  end

  local hpBg = Instance.new("Frame", card)
  hpBg.Size = UDim2.new(1, -28, 0, 26)
  hpBg.Position = UDim2.new(0, 14, 0, 190)
  hpBg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
  hpBg.BorderSizePixel = 0
  hpBg.ZIndex = 6
  Instance.new("UICorner", hpBg).CornerRadius = UDim.new(0, 8)
  local hpS = Instance.new("UIStroke", hpBg)
  hpS.Color = C.Yel; hpS.Thickness = 1; hpS.Transparency = 0.85
  hpFill = Instance.new("Frame", hpBg)
  hpFill.Size = UDim2.new(0, 0, 1, 0)
  hpFill.BackgroundColor3 = C.Grn
  hpFill.BorderSizePixel = 0
  hpFill.ZIndex = 7
  Instance.new("UICorner", hpFill).CornerRadius = UDim.new(0, 8)
  hpText = Instance.new("TextLabel", hpBg)
  hpText.Size = UDim2.new(1, 0, 1, 0)
  hpText.BackgroundTransparency = 1
  hpText.Font = Enum.Font.GothamBold
  hpText.TextSize = 12
  hpText.TextColor3 = C.Wh
  hpText.Text = "—"
  hpText.ZIndex = 8

  local function otherTarget()
    local p = TLG.SelectedTarget
    if not p or not p.Parent then
      TLG.PNotif("⚠️", "Sin jugador seleccionado", C.Rd); return nil
    end
    if p == TLG.LP then
      TLG.PNotif("⚠️", "Elegí a otro jugador", C.Yel); return nil
    end
    return p
  end

  Sec(PInfo, "ACCIONES", "⚡")
  bSp = Btn(PInfo, "👁️ Spectear", C.Cyan, function()
    if TLG.Sp.T then TLG.SpS(); pcall(refresh); return end
    local p = otherTarget(); if not p then return end
    TLG.SpSt(p); pcall(refresh)
  end)
  bGo = Btn(PInfo, "🌀 God Orb", C.Yel, function()
    if TLG.GO.On then TLG.GOS(); pcall(refresh); return end
    local p = otherTarget(); if not p then return end
    TLG.GOSt(p); pcall(refresh)
  end)
  Btn(PInfo, "📍 Teleport al jugador", C.Wh, function()
    local p = otherTarget(); if not p then return end
    local tr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
    local mr = TLG.LP.Character and TLG.LP.Character:FindFirstChild("HumanoidRootPart")
    if not tr or not mr then TLG.PNotif("⚠️", "Sin personaje", C.Rd); return end
    mr.CFrame = tr.CFrame * CFrame.new(0, 0, 5)
    TLG.PNotif("📍", "TP → " .. p.DisplayName, C.Cyan)
  end)
  Btn(PInfo, "📋 Copiar nombre de usuario", C.Wh, function()
    local p = TLG.SelectedTarget
    if not p then return end
    if setclipboard then
      setclipboard(p.Name)
      TLG.PNotif("📋", "Copiado: " .. p.Name, C.Grn)
    else
      TLG.PNotif("📋", p.Name, C.Yel)
    end
  end)
  Btn(PInfo, "🙋 Ver mis stats", C.Grn, function()
    TLG.SelectedTarget = TLG.LP
    rebuild(); pcall(refresh)
  end)

  rebuild()
  task.spawn(function()
    while card.Parent do
      pcall(refresh)
      task.wait(0.5)
    end
  end)
end)
if not infoOK then
  warn("[TLG] Info: " .. tostring(infoERR))
  local el = Instance.new("TextLabel", PInfo)
  el.Size = UDim2.new(1, 0, 0, 90)
  el.BackgroundTransparency = 1
  el.Font = Enum.Font.Gotham
  el.TextSize = 11
  el.TextWrapped = true
  el.TextColor3 = C.Rd
  el.TextXAlignment = Enum.TextXAlignment.Left
  el.TextYAlignment = Enum.TextYAlignment.Top
  el.Text = "⚠️ Error en la pestaña Info: " .. tostring(infoERR)
  el.ZIndex = 5
end

-- COMBAT TAB
do
  Sec(PCb, "🔵 HITBOX MANUAL", "🔵")
  Tog(PCb, "Activar Hitbox", false, function(v)
    if v then TLG.HBStart() else TLG.HBStop() end
  end)
  local function addArrowAdjust(labelText, initial, minValue, maxValue, step, formatter, callback)
    local value = initial
    local row = Instance.new("Frame", PCb)
    row.Size = UDim2.new(1, 0, 0, 34)
    row.BackgroundColor3 = Color3.fromRGB(10,10,10)
    row.BackgroundTransparency = 0.1
    row.BorderSizePixel = 0
    row.ZIndex = 5
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)
    local label = Instance.new("TextLabel", row)
    label.Size = UDim2.new(0.42, -6, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamSemibold
    label.Text = labelText
    label.TextColor3 = C.Wh
    label.TextSize = 10
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 6
    local display = Instance.new("TextLabel", row)
    display.Size = UDim2.new(0.28, 0, 1, 0)
    display.Position = UDim2.new(0.42, 0, 0, 0)
    display.BackgroundTransparency = 1
    display.Font = Enum.Font.GothamBold
    display.TextColor3 = C.Yel
    display.TextSize = 10
    display.ZIndex = 6
    local function refresh()
      display.Text = formatter(value)
      callback(value)
    end
    local function arrow(text, xScale, delta)
      local b = Instance.new("TextButton", row)
      b.Size = UDim2.new(0, 30, 0, 26)
      b.Position = UDim2.new(xScale, -15, 0.5, -13)
      b.BackgroundColor3 = C.BG3
      b.Text = text
      b.TextColor3 = C.Yel
      b.TextSize = 17
      b.Font = Enum.Font.GothamBold
      b.BorderSizePixel = 0
      b.ZIndex = 7
      Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
      b.Activated:Connect(function()
        value = math.clamp(value + delta * step, minValue, maxValue)
        refresh()
      end)
    end
    arrow("◀", 0.76, -1)
    arrow("▶", 0.92, 1)
    refresh()
  end
  addArrowAdjust("Ajustar tamaño", HB.Sz, 1, 50, 1, function(v) return tostring(v) end,
    function(v) HB.Sz = math.clamp(v, 1, 50) end)
  addArrowAdjust("Ajustar transparencia", 50, 0, 100, 5, function(v) return tostring(v) .. "%" end,
    function(v) HB.Tr = math.clamp(v, 0, 100) / 100 end)
  Lbl(PCb, "Hitbox manual: tamaño máximo 50. Las flechas ajustan tamaño y transparencia.", C.Gr)
  Lbl(PCb, "Para el aimbot, andá al tab 🎯 Aimbot.", C.Yel)

  Sec(PCb, "📷 CAMERA FOV", "📷")

  local CombatFOV = {
    Enabled = false,
    Value = 70,
    BindName = "TLG_CombatFOV"
  }

  local function ApplyCombatFOV()
    if not CombatFOV.Enabled then return end

    local cam = workspace.CurrentCamera
    if not cam then return end

    pcall(function()
      cam.FieldOfView = math.clamp(CombatFOV.Value, 40, 120)
    end)
  end

  local function StopCombatFOV()
    CombatFOV.Enabled = false

    pcall(function()
      RS:UnbindFromRenderStep(CombatFOV.BindName)
    end)

    local cam = workspace.CurrentCamera
    if cam then
      pcall(function()
        cam.FieldOfView = 70
      end)
    end
  end

  local function StartCombatFOV()
    CombatFOV.Enabled = true

    pcall(function()
      RS:UnbindFromRenderStep(CombatFOV.BindName)
    end)

    -- Apply after Roblox's camera update so the game camera does not
    -- immediately overwrite the selected FOV.
    pcall(function()
      RS:BindToRenderStep(
        CombatFOV.BindName,
        Enum.RenderPriority.Camera.Value + 1,
        ApplyCombatFOV
      )
    end)

    ApplyCombatFOV()
  end

  Tog(PCb, "Camera FOV", false, function(v)
    if v then
      StartCombatFOV()
    else
      StopCombatFOV()
    end
  end)

  Sli(PCb, "FOV", 40, 120, 70, function(v)
    CombatFOV.Value = math.clamp(tonumber(v) or 70, 40, 120)
    ApplyCombatFOV()
  end)

  Lbl(PCb, "Asistente visual: el FOV se mantiene activo después de la cámara del juego.", C.Cyan)
end

-- AIMBOT TAB
do
  Sec(PAb, "🎯 HITBOX FANTASMA", "🎯")

  local AB
  AB = Btn(PAb, "🎯 ACTIVAR HITBOX 800", C.Yel, function()
    if AIM.On then
      TLG.AIM_Stop()
      AB.Text = "🎯 ACTIVAR HITBOX 800"
    else
      AIM.MaxTargetRange = 10000
      TLG.AIM_Start()
      AB.Text = "🛑 DESACTIVAR HITBOX 800"
    end
  end)
  AB.Size = UDim2.new(1,0,0,54)
  AB.TextSize = 14

  Lbl(PAb, "Rango de selección: 10,000 studs.", C.Yel)
  Lbl(PAb, "Este módulo crea una hitbox local; no dirige la cámara.", C.Cyan)
end

-- FLY TAB
do
  Sec(PFl, "✈ FLY", "✈")
  Tog(PFl, "Activar Fly", false, function(v)
    if v then TLG.FlyS() else TLG.FlyE() end
  end)
  Sli(PFl, "Velocidad", 100, 50000, 15000, function(v)
    TLG.Fly.Spd = v
  end)
  Sli(PFl, "Multiplicador Boost (Shift)", 2, 10, 3, function(v)
    TLG.Fly.BoostMul = v
  end)
  Tog(PFl, "Noclip al volar", true, function(v)
    TLG.Fly.Noclip = v == true
  end)
  Lbl(PFl, "Space = subir  |  Ctrl/C = bajar", C.Cyan)
  Lbl(PFl, "Shift = Boost (x3 por default)", C.Yel)

  Sec(PFl, "🏃 SPEED", "🏃")
  Tog(PFl, "Activar Speed", false, function(v) TLG.SetSpeedEnabled(v) end)
  Sli(PFl, "Velocidad", 16, 1000, 300, function(v)
    TLG.Speed.Val = v
  end)

  Sec(PFl, "🚀 FUGA", "🚀")
  Btn(PFl, "🚀 Ejecutar Fuga", C.Wh, function()
    if TLG.Fuga and TLG.Fuga() then
      TLG.PNotif("🚀", "Fuga ejecutada", C.Yel)
    end
  end)
end

-- ISLANDS TAB
do
  Sec(PIs, "🏝️ TELETRANSPORTE", "🏝️")
  Lbl(PIs, "Busca el modelo de la isla en el mapa.", C.Gr)
  local islas = {
    {name="Floppa Island", al={"Floppa Island","FloppaIsland","Floppa"}},
    {name="Snow Island", al={"Snow Island","SnowIsland","Snow"}},
    {name="Gorilla Island", al={"Gorilla Island","GorillaIsland","Gorilla"}},
    {name="Sand Island", al={"Sand Island","SandIsland","Sand"}},
    {name="Pumpkin Island", al={"Pumpkin Island","PumpkinIsland","Pumpkin"}},
    {name="Moai Island", al={"Moai Island","MoaiIsland","Moai"}},
    {name="Sus Island", al={"Sus Island","SusIsland","Sus"}},
    {name="Forgotten Island", al={"Forgotten Island","ForgottenIsland","Forgotten"}},
    {name="MrBeast Island", al={"MrBeast Island","MrBeastIsland","MrBeast"}},
    {name="Noob Arena", al={"Noob Arena","NoobArena","Noob"}},
    {name="PVP Arena", al={"PVP Arena","PVPArena","PVP"}},
  }
  local function findPart(inst)
    if not inst then return nil end
    if inst:IsA("BasePart") then return inst end
    if inst:IsA("Model") then
      if inst.PrimaryPart then return inst.PrimaryPart end
      return inst:FindFirstChildWhichIsA("BasePart", true)
    end
    return inst:FindFirstChildWhichIsA("BasePart", true)
  end
  local function findIsland(als)
    for _, a in ipairs(als) do
      local f = workspace:FindFirstChild(a)
      if f then
        local p = findPart(f)
        if p then return p, a end
      end
    end
    for _, a in ipairs(als) do
      local low = a:lower()
      for _, d in ipairs(workspace:GetDescendants()) do
        if (d:IsA("Model") or d:IsA("Folder") or d:IsA("BasePart"))
          and d.Name:lower() == low then
          local p = findPart(d)
          if p then return p, d.Name end
        end
      end
    end
    return nil, nil
  end
  local function tpTo(e)
    local ch = TLG.LP.Character
    if not ch then TLG.PNotif("🏝️", "Sin personaje", C.Rd); return end
    local h = ch:FindFirstChild("HumanoidRootPart")
    if not h then TLG.PNotif("🏝️", "Sin HRP", C.Rd); return end
    local p, name = findIsland(e.al)
    if p then
      h.CFrame = CFrame.new(p.Position + Vector3.new(0, 60, 0))
      TLG.PNotif("🏝️", "TP → "..(name or e.name), C.Cyan)
    else
      TLG.PNotif("🏝️", "No encontrada: "..e.name, C.Rd)
    end
  end
  table.sort(islas, function(a, b) return a.name < b.name end)
  for _, e in ipairs(islas) do
    Btn(PIs, "🏝️ "..e.name, C.Wh, function() tpTo(e) end)
  end
  Btn(PIs, "🔄 Escanear islas", C.Yel, function()
    local n = 0
    for _, e in ipairs(islas) do
      if findIsland(e.al) then n = n + 1 end
    end
    TLG.PNotif("🏝️", "Encontradas "..n.."/"..#islas,
      n > 0 and C.Grn or C.Rd)
  end)
end

-- SCRIPTS TAB
do
  Sec(PSc, "🔄 SERVER", "🔄")
  Btn(PSc, "🔁 Rejoin", C.Cyan, function()
    TLG.QueueOnTeleport()
    task.wait(0.5)
    pcall(function() TPS:Teleport(game.PlaceId, TLG.LP) end)
  end)
  Btn(PSc, "🔄 Cambiar Server", C.Yel, function()
    TLG.QueueOnTeleport()
    task.spawn(function()
      local ok, res = pcall(function()
        return HS:JSONDecode(game:HttpGet(
          "https://games.roblox.com/v1/games/"..game.PlaceId
          .."/servers/Public?sortOrder=Asc&limit=100"))
      end)
      if ok and res and res.data then
        local sv = {}
        for _, s in ipairs(res.data) do
          if s.playing < s.maxPlayers
            and s.id ~= game.JobId and s.playing > 0 then
            table.insert(sv, s)
          end
        end
        if #sv > 0 then
          local el = sv[math.random(1, #sv)]
          pcall(function()
            TPS:TeleportToPlaceInstance(game.PlaceId, el.id, TLG.LP)
          end)
        end
      end
    end)
  end)
end

print("[TLG V7.5] Parte 2 ok")

-- PARTE 3

local Fuga = {On=false, Height=5000}
function TLG.FugaSetHeight(v)
  Fuga.Height = math.clamp(tonumber(v) or 5000, 100, 20000)
end
function TLG.Fuga()
  local ch = TLG.LP and TLG.LP.Character
  local r = ch and ch:FindFirstChild("HumanoidRootPart")
  if not r then return false end
  return pcall(function()
    r.CFrame = r.CFrame + Vector3.new(0, Fuga.Height, 0)
  end)
end

local Noclip = {On=false, Conn=nil, Original={}}
function TLG.NoclipStart()
  if Noclip.On then return end
  Noclip.On = true
  Noclip.Conn = RS.Stepped:Connect(function()
    if not Noclip.On then return end
    local ch = TLG.LP.Character; if not ch then return end
    for _, p in ipairs(ch:GetDescendants()) do
      if p:IsA("BasePart") then
        if Noclip.Original[p] == nil then Noclip.Original[p] = p.CanCollide end
        p.CanCollide = false
      end
    end
  end)
end
function TLG.NoclipStop()
  Noclip.On = false
  if Noclip.Conn then
    pcall(function() Noclip.Conn:Disconnect() end); Noclip.Conn = nil
  end
  for p, original in pairs(Noclip.Original) do
    if p and p.Parent then pcall(function() p.CanCollide = original end) end
  end
  Noclip.Original = {}
end

local InfJump = {On=false, Conn=nil}
function TLG.InfJumpStart()
  if InfJump.On then return end
  InfJump.On = true
  InfJump.Conn = UIS.JumpRequest:Connect(function()
    if not InfJump.On then return end
    local hu = TLG.LP.Character
      and TLG.LP.Character:FindFirstChildOfClass("Humanoid")
    if hu then
      pcall(function()
        hu:ChangeState(Enum.HumanoidStateType.Jumping)
      end)
    end
  end)
end
function TLG.InfJumpStop()
  InfJump.On = false
  if InfJump.Conn then
    pcall(function() InfJump.Conn:Disconnect() end); InfJump.Conn = nil
  end
end

local ClickTP = {On=false, Conn=nil}
function TLG.ClickTPStart()
  if ClickTP.On then return end
  ClickTP.On = true
  ClickTP.Conn = UIS.InputBegan:Connect(function(input, gp)
    if gp or not ClickTP.On then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
      and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
      local cam = TLG.Cam or workspace.CurrentCamera
      if not cam then return end
      local m = TLG.LP:GetMouse()
      local u = cam:ScreenPointToRay(m.X, m.Y)
      local ray = Ray.new(u.Origin, u.Direction * 2000)
      local _, pos = workspace:FindPartOnRayWithIgnoreList(ray,
        {TLG.LP.Character})
      if pos then
        local h = TLG.LP.Character
          and TLG.LP.Character:FindFirstChild("HumanoidRootPart")
        if h then h.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0)) end
      end
    end
  end)
end
function TLG.ClickTPStop()
  ClickTP.On = false
  if ClickTP.Conn then
    pcall(function() ClickTP.Conn:Disconnect() end); ClickTP.Conn = nil
  end
end

local AntiAFK = {On=false, Conn=nil}
function TLG.AntiAFKStart()
  if AntiAFK.On then return end
  AntiAFK.On = true
  local vu = game:GetService("VirtualUser")
  AntiAFK.Conn = TLG.LP.Idled:Connect(function()
    if not AntiAFK.On then return end
    pcall(function()
      vu:CaptureController(); vu:ClickButton2(Vector2.new())
    end)
  end)
end
function TLG.AntiAFKStop()
  AntiAFK.On = false
  if AntiAFK.Conn then
    pcall(function() AntiAFK.Conn:Disconnect() end); AntiAFK.Conn = nil
  end
end

local NoFall = {On=false, Conn=nil, CharConn=nil}
function TLG.NoFallStart()
  if NoFall.On then return end
  NoFall.On = true
  local function hook(hu)
    if not hu then return end
    if NoFall.Conn then
      pcall(function() NoFall.Conn:Disconnect() end)
    end
    NoFall.Conn = hu.StateChanged:Connect(function(_, new)
      if not NoFall.On then return end
      if new == Enum.HumanoidStateType.Freefall
        or new == Enum.HumanoidStateType.FallingDown then
        pcall(function()
          hu:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
      end
    end)
  end
  local ch = TLG.LP.Character
  if ch then hook(ch:FindFirstChildOfClass("Humanoid")) end
  if NoFall.CharConn then pcall(function() NoFall.CharConn:Disconnect() end) end
  NoFall.CharConn = TLG.LP.CharacterAdded:Connect(function(c)
    task.wait(0.3)
    if NoFall.On then hook(c:FindFirstChildOfClass("Humanoid")) end
  end)
end
function TLG.NoFallStop()
  NoFall.On = false
  if NoFall.Conn then
    pcall(function() NoFall.Conn:Disconnect() end); NoFall.Conn = nil
  end
  if NoFall.CharConn then
    pcall(function() NoFall.CharConn:Disconnect() end); NoFall.CharConn = nil
  end
end

local FB = {On=false, Orig=nil}
function TLG.FullbrightStart()
  if FB.On then return end
  FB.On = true
  FB.Orig = {
    Brightness = LIGHT.Brightness,
    ClockTime = LIGHT.ClockTime,
    FogEnd = LIGHT.FogEnd,
    GlobalShadows = LIGHT.GlobalShadows,
    Ambient = LIGHT.Ambient
  }
  LIGHT.Brightness = 2
  LIGHT.ClockTime = 14
  LIGHT.FogEnd = 1000000
  LIGHT.GlobalShadows = false
  LIGHT.Ambient = Color3.fromRGB(180, 180, 180)
end
function TLG.FullbrightStop()
  FB.On = false
  if FB.Orig then
    pcall(function()
      LIGHT.Brightness = FB.Orig.Brightness
      LIGHT.ClockTime = FB.Orig.ClockTime
      LIGHT.FogEnd = FB.Orig.FogEnd
      LIGHT.GlobalShadows = FB.Orig.GlobalShadows
      LIGHT.Ambient = FB.Orig.Ambient
    end)
  end
end

local function removeFog()
  pcall(function()
    LIGHT.FogEnd = 1000000; LIGHT.FogStart = 0
    local atmo = LIGHT:FindFirstChildOfClass("Atmosphere")
    if atmo then atmo.Density = 0; atmo.Haze = 0 end
  end)
  TLG.PNotif("Fog", "Niebla eliminada", C.Cyan)
end

local HH = {On=false, Val=2, Conn=nil}
function TLG.HipHeightSet(v) HH.Val = tonumber(v) or 2 end
function TLG.HipHeightStart()
  if HH.On then return end
  HH.On = true
  HH.Conn = RS.Heartbeat:Connect(function()
    if not HH.On then return end
    local hu = TLG.LP.Character
      and TLG.LP.Character:FindFirstChildOfClass("Humanoid")
    if hu then pcall(function() hu.HipHeight = HH.Val end) end
  end)
end
function TLG.HipHeightStop()
  HH.On = false
  if HH.Conn then
    pcall(function() HH.Conn:Disconnect() end); HH.Conn = nil
  end
  local hu = TLG.LP.Character
    and TLG.LP.Character:FindFirstChildOfClass("Humanoid")
  if hu then pcall(function() hu.HipHeight = 2 end) end
end

local OM = {On=false, Distance=250, Height=80, Speed=35,
  Angle=0, Connection=nil}
TLG.OrbitalMapState = OM
local function omRoot()
  local ch = TLG.LP and TLG.LP.Character
  return ch and ch:FindFirstChild("HumanoidRootPart")
end
function TLG.OrbitalMapStart()
  if OM.On then return end
  local r = omRoot()
  if not r then return end

  OM.On = true
  OM.Angle = 0

  local center = r.Position
  OM.Connection = RS.RenderStepped:Connect(function(dt)
    if not OM.On then return end

    local cur = omRoot()
    if not cur or not cur.Parent then
      TLG.OrbitalMapStop()
      return
    end

    -- Skip movement writes while the humanoid is being removed/replaced.
    local hum = cur.Parent:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then
      TLG.OrbitalMapStop()
      return
    end

    OM.Angle = (OM.Angle + math.rad(OM.Speed) * dt) % (math.pi * 2)

    local x = math.cos(OM.Angle) * OM.Distance
    local z = math.sin(OM.Angle) * OM.Distance
    local targetPos = center + Vector3.new(x, OM.Height, z)

    pcall(function()
      cur.CFrame = CFrame.lookAt(targetPos, center)
    end)
  end)
end
function TLG.OrbitalMapStop()
  OM.On = false
  if OM.Connection then
    pcall(function() OM.Connection:Disconnect() end); OM.Connection = nil
  end
end
function TLG.OrbitalMapSetDistance(v)
  OM.Distance = math.clamp(tonumber(v) or 250, 25, 2000)
end
function TLG.OrbitalMapSetHeight(v)
  OM.Height = math.clamp(tonumber(v) or 80, -500, 1000)
end
function TLG.OrbitalMapSetSpeed(v)
  OM.Speed = math.clamp(tonumber(v) or 35, 1, 20000)
end

-- TOOLS TAB
do
  Sec(PTo, "💀 FABS", "💀")
  Tog(PTo, "Activar / Desactivar FABS", false, function(v)
    TLG.FAB_SetVisible(v)
  end)
  Lbl(PTo, "Muestra u oculta los botones rápidos flotantes.", C.Gr)

  Sec(PTo, "🔧 MOVIMIENTO", "🔧")
  Tog(PTo, "Fly", false, function(v)
    if v then TLG.FlyS() else TLG.FlyE() end
  end)
  Sli(PTo, "Velocidad Fly", 100, 20000, TLG.Fly.Spd,
    function(v) TLG.Fly.Spd = v end)
  Tog(PTo, "Speed", false, function(v) TLG.SetSpeedEnabled(v) end)
  Sli(PTo, "Velocidad", 16, 1000, TLG.Speed.Val,
    function(v) TLG.Speed.Val = v end)

  Sec(PTo, "⚡ MS (AUTO-BURST)", "⚡")
  Tog(PTo, "Activar MS", false, function(v)
    if v then TLG.FastAttackStart() else TLG.FastAttackStop() end
  end)
  Sli(PTo, "Ráfaga cada (ms)", 50, 500, 150, function(v)
    FA.BurstRate = v / 1000
  end)
  Sli(PTo, "Activaciones por ráfaga", 1, 10, 3, function(v)
    FA.BurstCount = v
  end)
  Lbl(PTo, "• 3 activaciones por ráfaga", C.Cyan)
  Lbl(PTo, "• Stun = -1 + anim acelerada", C.Grn)
  Lbl(PTo, "• Pausa auto en habilidades (Z X C V...)", C.Yel)

  Sec(PTo, "🚀 FUGA", "🚀")
  Btn(PTo, "🚀 Ejecutar Fuga", C.Yel, function()
    if TLG.Fuga() then TLG.PNotif("🚀", "Fuga ejecutada", C.Yel) end
  end)
  Sli(PTo, "Altura de Fuga", 100, 20000, 5000,
    function(v) TLG.FugaSetHeight(v) end)

  Sec(PTo, "🌀 ORBITAL MAP", "🌀")
  Lbl(PTo, "Movimiento estable: no fuerza el giro del aimbot.", C.Gr)

  Tog(PTo, "Orbital Mapa", false, function(v)
    if v then TLG.OrbitalMapStart() else TLG.OrbitalMapStop() end
  end)
  Sli(PTo, "Distancia", 25, 2000, 250,
    function(v) TLG.OrbitalMapSetDistance(v) end)
  Sli(PTo, "Altura", -500, 1000, 80,
    function(v) TLG.OrbitalMapSetHeight(v) end)
  Sli(PTo, "Velocidad", 1, 20000, 35,
    function(v) TLG.OrbitalMapSetSpeed(v) end)

  Sec(PTo, "👻 NOCLIP / JUMP", "👻")
  Tog(PTo, "Noclip", false, function(v)
    if v then TLG.NoclipStart() else TLG.NoclipStop() end
  end)
  Tog(PTo, "Infinite Jump", false, function(v)
    if v then TLG.InfJumpStart() else TLG.InfJumpStop() end
  end)
  Tog(PTo, "Click TP (Ctrl+Click)", false, function(v)
    if v then TLG.ClickTPStart() else TLG.ClickTPStop() end
  end)

  Sec(PTo, "🛡️ PROTECCIÓN", "🛡️")
  Tog(PTo, "Anti-Void", false, function(v)
    if v then TLG.AntiVoidStart() else TLG.AntiVoidStop() end
  end)
  Tog(PTo, "Anti-Fling", false, function(v)
    if v then TLG.AntiFlingStart() else TLG.AntiFlingStop() end
  end)
  Tog(PTo, "Anti Orbit", false, function(v)
    if v then TLG.AntiOrbitStart() else TLG.AntiOrbitStop() end
  end)
  Sli(PTo, "Sensibilidad Anti Orbit", 20, 95, 65, function(v)
    AntiOrbit.Threshold = v / 100
  end)
  Sli(PTo, "Radio Anti Orbit", 10, 250, 80, function(v)
    AntiOrbit.RadiusMax = v
  end)
  Tog(PTo, "Estabilización local", true, function(v)
    AntiOrbit.Stabilize = v == true
  end)
  Tog(PTo, "Anti-Stun", false, function(v)
    if v then TLG.AntiStunStart() else TLG.AntiStunStop() end
  end)
  Tog(PTo, "Anti AFK", false, function(v)
    if v then TLG.AntiAFKStart() else TLG.AntiAFKStop() end
  end)
  Tog(PTo, "No Fall Damage", false, function(v)
    if v then TLG.NoFallStart() else TLG.NoFallStop() end
  end)

  Sec(PTo, "🎁 AUTO-COLLECT", "🎁")
  Tog(PTo, "Auto-Collect Prompts", false, function(v)
    if v then TLG.AutoPromptStart() else TLG.AutoPromptStop() end
  end)
  Sli(PTo, "Rango Collect", 5, 100, 25,
    function(v) AutoPrompt.Range = v end)
  Lbl(PTo, "Recoge prompts cercanos (Meme Sea).", C.Gr)

  Sec(PTo, "💡 VISIÓN", "💡")
  Tog(PTo, "Fullbright", false, function(v)
    if v then TLG.FullbrightStart() else TLG.FullbrightStop() end
  end)
  Btn(PTo, "🌫 Quitar Niebla", C.Cyan, removeFog)

  Sec(PTo, "📏 HIP HEIGHT", "📏")
  Tog(PTo, "Activar HipHeight", false, function(v)
    if v then TLG.HipHeightStart() else TLG.HipHeightStop() end
  end)
  Sli(PTo, "Altura cadera", 0, 50, 2,
    function(v) TLG.HipHeightSet(v) end)

  Sec(PTo, "⚙️ UTILIDADES", "⚙️")
  Btn(PTo, "🔄 Reset Character", C.Rd, function()
    local ch = TLG.LP.Character
    if ch then
      local hu = ch:FindFirstChildOfClass("Humanoid")
      if hu then hu.Health = 0 end
    end
    TLG.PNotif("🔄", "Reset", C.Rd)
  end)
  Btn(PTo, "🪑 Sit / Unsit", C.Wh, function()
    local hu = TLG.LP.Character
      and TLG.LP.Character:FindFirstChildOfClass("Humanoid")
    if hu then
      hu.Sit = not hu.Sit
      TLG.PNotif("🪑", hu.Sit and "Sentado" or "De pie", C.Yel)
    end
  end)
  Btn(PTo, "📍 TP a Spawn", C.Cyan, function()
    local h = TLG.LP.Character
      and TLG.LP.Character:FindFirstChild("HumanoidRootPart")
    if h then
      local s = workspace:FindFirstChildWhichIsA("SpawnLocation", true)
      if s then
        h.CFrame = s.CFrame + Vector3.new(0, 5, 0)
        TLG.PNotif("📍", "TP a Spawn", C.Cyan)
      else
        TLG.PNotif("📍", "Spawn no encontrado", C.Rd)
      end
    end
  end)
end


  Tog(PTo, "⚡ Visual Skill Speed", false, function(v)
    if v then
      TLG.VisualSkillSpeedStart()
    else
      TLG.VisualSkillSpeedStop()
    end
  end)

-- ESP
local ESP = {
  On=false, Names=true, Distance=true, Health=true,
  Box=false, Tracer=false, Fill=true, FillTransparency=0.78,
  MaxDistance=math.huge, Objects={}
}
TLG.ESP = ESP

local TracerConn = nil
local function updateTracers()
  if not ESP.On or not ESP.Tracer then
    if TracerConn then TracerConn:Disconnect(); TracerConn = nil end
    return
  end
  if TracerConn then return end
  TracerConn = RS.RenderStepped:Connect(function()
    if not ESP.On or not ESP.Tracer then return end
    local cam = workspace.CurrentCamera
    for _, p in ipairs(PLR:GetPlayers()) do
      if p ~= TLG.LP then
        local pk = ESP.Objects[p]
        if pk and pk.Tracer and pk.Tracer.Parent then
          local ch = p.Character
          local r = ch and ch:FindFirstChild("HumanoidRootPart")
          if r then
            local pos, on = cam:WorldToViewportPoint(r.Position)
            if on then
              pk.Tracer.Position = UDim2.new(0, pos.X, 0, pos.Y)
              pk.Tracer.Visible = true
            else
              pk.Tracer.Visible = false
            end
          end
        end
      end
    end
  end)
end

local function espDestroy(p)
  local pk = ESP.Objects[p]
  if not pk then return end
  for _, o in pairs(pk) do
    pcall(function() if o and o.Parent then o:Destroy() end end)
  end
  ESP.Objects[p] = nil
end

local function espCreate(p)
  if p == TLG.LP or not ESP.On then return end
  espDestroy(p)
  local ch = p.Character
  local head = ch and ch:FindFirstChild("Head")
  local root = ch and ch:FindFirstChild("HumanoidRootPart")
  local hum = ch and ch:FindFirstChildOfClass("Humanoid")
  if not ch or not head or not root or not hum then return end
  local color = TLG.A()

  local hl = Instance.new("Highlight")
  hl.Name = "TLG_ESP_HL"
  hl.Adornee = ch
  hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
  hl.FillColor = color
  hl.FillTransparency = ESP.Fill and ESP.FillTransparency or 1
  hl.OutlineColor = color
  hl.OutlineTransparency = 0
  hl.Parent = ch

  local bb = Instance.new("BillboardGui")
  bb.Name = "TLG_ESP_Info"
  bb.Adornee = head
  bb.AlwaysOnTop = true
  bb.Size = UDim2.new(0, 180, 0, 55)
  bb.StudsOffset = Vector3.new(0, 3, 0)
  bb.MaxDistance = math.huge
  bb.Parent = head

  local label = Instance.new("TextLabel")
  label.Size = UDim2.new(1,0,1,0)
  label.BackgroundTransparency = 1
  label.Font = Enum.Font.GothamBold
  label.TextSize = 12
  label.TextColor3 = color
  label.TextStrokeTransparency = 0.25
  label.TextStrokeColor3 = Color3.new(0,0,0)
  label.TextYAlignment = Enum.TextYAlignment.Center
  label.Parent = bb

  local box = Instance.new("Frame")
  box.Name = "TLG_ESP_Box"
  box.BackgroundTransparency = 1
  box.BorderSizePixel = 0
  box.Visible = false
  box.ZIndex = 100
  box.Parent = SG
  local bs = Instance.new("UIStroke", box)
  bs.Color = color; bs.Thickness = 1.5

  local tr = Instance.new("Frame")
  tr.Name = "TLG_ESP_Tr"
  tr.Size = UDim2.new(0, 1, 0, 1)
  tr.BackgroundColor3 = color
  tr.BorderSizePixel = 0
  tr.Visible = false
  tr.ZIndex = 100
  tr.Parent = SG

  ESP.Objects[p] = {
    Highlight=hl, Billboard=bb, Label=label,
    Box=box, BoxStroke=bs, Tracer=tr
  }
end

local function espUpdate(p)
  if not ESP.On then return end
  local pk = ESP.Objects[p]
  local ch = p.Character
  local root = ch and ch:FindFirstChild("HumanoidRootPart")
  local head = ch and ch:FindFirstChild("Head")
  local hum = ch and ch:FindFirstChildOfClass("Humanoid")
  if not ch or not root or not head or not hum then
    espCreate(p); return
  end
  if not pk or not pk.Highlight or not pk.Highlight.Parent then
    espCreate(p); pk = ESP.Objects[p]
  end
  if not pk then return end
  local color = TLG.A()
  pk.Highlight.FillColor = color
  pk.Highlight.OutlineColor = color
  pk.Highlight.FillTransparency = ESP.Fill
    and ESP.FillTransparency or 1
  pk.Label.TextColor3 = color
  pk.BoxStroke.Color = color
  pk.Tracer.BackgroundColor3 = color

  local mh = TLG.LP.Character
    and TLG.LP.Character:FindFirstChild("HumanoidRootPart")
  local dist = mh and math.floor((mh.Position - root.Position).Magnitude)
    or 0
  if ESP.MaxDistance ~= math.huge and dist > ESP.MaxDistance then
    pk.Billboard.Enabled = false
    pk.Highlight.Enabled = false
    pk.Box.Visible = false
    pk.Tracer.Visible = false
    return
  end
  pk.Billboard.Enabled = true
  pk.Highlight.Enabled = true
  pk.Billboard.MaxDistance = ESP.MaxDistance

  local lines = {}
  if ESP.Names then
    table.insert(lines, p.DisplayName.."  @"..p.Name)
  end
  if ESP.Distance then
    table.insert(lines, "📏 "..dist.." studs")
  end
  if ESP.Health then
    local hp = math.floor(hum.Health)
    local mx = math.max(1, math.floor(hum.MaxHealth))
    table.insert(lines, "❤ "..hp.."/"..mx)
  end
  pk.Label.Text = table.concat(lines, "\n")

  if ESP.Box then
    local cam = workspace.CurrentCamera
    if cam then
      local top = head.Position
        + Vector3.new(0, head.Size.Y/2 + 0.5, 0)
      local bot = root.Position
        - Vector3.new(0, root.Size.Y/2, 0)
      local tp, to = cam:WorldToViewportPoint(top)
      local bp, bo = cam:WorldToViewportPoint(bot)
      if to and bo then
        local hh = math.abs(bp.Y - tp.Y)
        local ww = hh * 0.55
        pk.Box.Size = UDim2.new(0, ww, 0, hh)
        pk.Box.Position = UDim2.new(0, tp.X - ww/2, 0, tp.Y)
        pk.Box.Visible = true
      else
        pk.Box.Visible = false
      end
    end
  else
    pk.Box.Visible = false
  end
  pk.Tracer.Visible = ESP.Tracer
end

function TLG.ESPStart()
  if ESP.On then return end
  ESP.On = true
  for _, p in ipairs(PLR:GetPlayers()) do
    if p ~= TLG.LP then pcall(espCreate, p) end
  end
  ESP.PlayerAdded = PLR.PlayerAdded:Connect(function(p)
    if ESP.On then task.wait(0.15); pcall(espCreate, p) end
  end)
  ESP.PlayerRemoving = PLR.PlayerRemoving:Connect(function(p)
    espDestroy(p)
  end)
  ESP.CharacterConnections = ESP.CharacterConnections or {}
  for _, p in ipairs(PLR:GetPlayers()) do
    if p ~= TLG.LP then
      ESP.CharacterConnections[p] = p.CharacterAdded:Connect(function()
        if ESP.On then task.wait(0.25); pcall(espCreate, p) end
      end)
    end
  end
  ESP.Render = RS.RenderStepped:Connect(function()
    if not ESP.On then return end
    for _, p in ipairs(PLR:GetPlayers()) do
      if p ~= TLG.LP then pcall(espUpdate, p) end
    end
  end)
  updateTracers()
end

function TLG.ESPStop()
  ESP.On = false
  if ESP.PlayerAdded then
    pcall(function() ESP.PlayerAdded:Disconnect() end); ESP.PlayerAdded = nil
  end
  if ESP.PlayerRemoving then
    pcall(function() ESP.PlayerRemoving:Disconnect() end)
    ESP.PlayerRemoving = nil
  end
  if ESP.Render then
    pcall(function() ESP.Render:Disconnect() end); ESP.Render = nil
  end
  if TracerConn then
    pcall(function() TracerConn:Disconnect() end); TracerConn = nil
  end
  for _, c in pairs(ESP.CharacterConnections or {}) do
    pcall(function() c:Disconnect() end)
  end
  ESP.CharacterConnections = {}
  for p in pairs(ESP.Objects) do espDestroy(p) end
end

TLG.ESPToggleNames = function(v) ESP.Names = v == true end
TLG.ESPToggleDistance = function(v) ESP.Distance = v == true end
TLG.ESPToggleHealth = function(v) ESP.Health = v == true end
TLG.ESPToggleBox = function(v) ESP.Box = v == true end
TLG.ESPToggleTracer = function(v)
  ESP.Tracer = v == true; updateTracers()
end
TLG.ESPToggleFill = function(v) ESP.Fill = v == true end
TLG.ESPSetDistance = function(v)
  local n = tonumber(v)
  ESP.MaxDistance = (not n or n <= 0) and math.huge or n
end

do
  Sec(PEs, "👁️ PLAYER ESP", "👁️")
  Tog(PEs, "Activar ESP", false, function(v)
    if v then TLG.ESPStart() else TLG.ESPStop() end
  end)
  Tog(PEs, "Nombres", true, function(v) TLG.ESPToggleNames(v) end)
  Tog(PEs, "Distancia", true, function(v) TLG.ESPToggleDistance(v) end)
  Tog(PEs, "Vida", true, function(v) TLG.ESPToggleHealth(v) end)
  Tog(PEs, "Box ESP", false, function(v) TLG.ESPToggleBox(v) end)
  Tog(PEs, "Tracer", false, function(v) TLG.ESPToggleTracer(v) end)
  Tog(PEs, "Relleno", true, function(v) TLG.ESPToggleFill(v) end)
  Sli(PEs, "Rango ESP", 100, 10000, 5000,
    function(v) TLG.ESPSetDistance(v) end)
  Sli(PEs, "Transparencia relleno", 0, 100, 78,
    function(v) ESP.FillTransparency = v / 100 end)
end

-- VISUALS TAB
do
  Sec(PVi, "🎨 LIGHTING", "🎨")
  local presets = {
    {"❌ Ninguno", function()
      LIGHT.Brightness=1
      LIGHT.Ambient=Color3.fromRGB(70,70,70)
      LIGHT.OutdoorAmbient=Color3.fromRGB(128,128,128)
      LIGHT.ClockTime=14 end},
    {"🌅 Atardecer", function()
      LIGHT.Brightness=2
      LIGHT.Ambient=Color3.fromRGB(200,150,100)
      LIGHT.OutdoorAmbient=Color3.fromRGB(255,150,100)
      LIGHT.ClockTime=18 end},
    {"🌙 Noche", function()
      LIGHT.Brightness=0.5
      LIGHT.Ambient=Color3.fromRGB(30,30,50)
      LIGHT.OutdoorAmbient=Color3.fromRGB(50,50,100)
      LIGHT.ClockTime=0 end},
    {"🔥 Infierno", function()
      LIGHT.Brightness=2
      LIGHT.Ambient=Color3.fromRGB(150,50,20)
      LIGHT.OutdoorAmbient=Color3.fromRGB(255,100,50)
      LIGHT.ClockTime=16 end},
    {"❄️ Hielo", function()
      LIGHT.Brightness=2.5
      LIGHT.Ambient=Color3.fromRGB(150,180,220)
      LIGHT.OutdoorAmbient=Color3.fromRGB(200,220,255)
      LIGHT.ClockTime=12 end}
  }
  for _, p in ipairs(presets) do
    Btn(PVi, p[1], C.Yel, p[2])
  end

  Sec(PVi, "🌌 SKYBOX", "🌌")
  local skies = {
    {name="❌ Ninguno", ids=nil},
    {name="🏠 Sample", ids={"rbxassetid://162001887","rbxassetid://161998893","rbxassetid://162001897","rbxassetid://162001904","rbxassetid://162001919","rbxassetid://162001926"}},
    {name="🌌 Galaxia", ids={"rbxassetid://159454299","rbxassetid://159454296","rbxassetid://159454293","rbxassetid://159454286","rbxassetid://159454300","rbxassetid://159454288"}},
    {name="🌠 Vaporwave", ids={"rbxassetid://8631780182","rbxassetid://8631784904","rbxassetid://8631769834","rbxassetid://8631777199","rbxassetid://8631735555","rbxassetid://8631782345"}},
    {name="🌅 Sunset", ids={"rbxassetid://323494035","rbxassetid://323494368","rbxassetid://323494130","rbxassetid://323494252","rbxassetid://323494067","rbxassetid://323493360"}},
    {name="🔵 Blue Space", ids={"rbxassetid://135483466","rbxassetid://135483484","rbxassetid://135483461","rbxassetid://135483495","rbxassetid://135483499","rbxassetid://135483475"}},
    {name="🪐 Blue Planet", ids={"rbxassetid://218955819","rbxassetid://218953419","rbxassetid://218954524","rbxassetid://218958493","rbxassetid://218957134","rbxassetid://218950090"}}
  }
  for _, s in ipairs(skies) do
    Btn(PVi, s.name, C.Yel, function()
      SkyApply(s.ids)
      TLG.PNotif("🌌", s.name, C.Yel)
      if s.ids then
        task.spawn(function()
          local sk = Lighting:FindFirstChild("TLG_Sky")
          if not sk then TLG.PNotif("🌌", "No se creó el Sky", C.Rd); return end
          local bad = 0
          pcall(function()
            game:GetService("ContentProvider"):PreloadAsync({sk}, function(_, st)
              if st ~= Enum.AssetFetchStatus.Success then bad = bad + 1 end
            end)
          end)
          if bad > 0 then
            TLG.PNotif("🌌 Sky", bad .. " texturas no cargaron", C.Rd)
          else
            TLG.PNotif("🌌 Sky", "Texturas cargadas OK", C.Grn)
          end
        end)
      end
    end)
  end

end

-- OPTIMIZE
do
  local function ramMB()
    local ok, v = pcall(function() return game:GetService("Stats"):GetTotalMemoryUsageMb() end)
    if ok and type(v) == "number" then return math.floor(v) end
    return math.floor(collectgarbage("count") / 1024)
  end
  Sec(POp, "📈 MONITOR EN VIVO", "📈")
  do
    local mon = Instance.new("Frame", POp)
    mon.Size = UDim2.new(1, 0, 0, 54)
    mon.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    mon.BackgroundTransparency = 0.1
    mon.BorderSizePixel = 0
    mon.ZIndex = 5
    Instance.new("UICorner", mon).CornerRadius = UDim.new(0, 10)
    local ms = Instance.new("UIStroke", mon)
    ms.Color = C.Yel; ms.Thickness = 1; ms.Transparency = 0.55
    local function stat(idx, title)
      local t = Instance.new("TextLabel", mon)
      t.Size = UDim2.new(1/3, 0, 0, 14)
      t.Position = UDim2.new((idx - 1) / 3, 0, 0, 7)
      t.BackgroundTransparency = 1
      t.Font = Enum.Font.GothamBold
      t.Text = title
      t.TextSize = 9
      t.TextColor3 = C.Gr
      t.ZIndex = 7
      local v = Instance.new("TextLabel", mon)
      v.Size = UDim2.new(1/3, 0, 0, 26)
      v.Position = UDim2.new((idx - 1) / 3, 0, 0, 21)
      v.BackgroundTransparency = 1
      v.Font = Enum.Font.GothamBlack
      v.Text = "--"
      v.TextSize = 18
      v.TextColor3 = C.Wh
      v.ZIndex = 7
      return v
    end
    local vF, vP, vR = stat(1, "FPS"), stat(2, "PING"), stat(3, "RAM (MB)")
    task.spawn(function()
      while mon.Parent do
        local fps = tonumber(string.match(FpsLabel.Text, "%d+")) or 0
        local ping = tonumber(string.match(PingLabel.Text, "%d+")) or 0
        vF.Text = tostring(fps)
        vF.TextColor3 = fps >= 45 and C.Grn or (fps >= 25 and Color3.fromRGB(255, 210, 80) or C.Rd)
        vP.Text = tostring(ping)
        vP.TextColor3 = ping <= 90 and C.Grn or (ping <= 180 and Color3.fromRGB(255, 210, 80) or C.Rd)
        vR.Text = tostring(ramMB())
        task.wait(1)
      end
    end)
  end

  Sec(POp, "⚡ FPS", "⚡")
  local orig = {}
  local shadowsOriginal = nil
  Tog(POp, "Quitar Texturas", false, function(v)
    if v then
      for _, d in ipairs(workspace:GetDescendants()) do
        if d:IsA("Decal") or d:IsA("Texture") then
          if not orig[d] then orig[d] = d.Transparency end
          d.Transparency = 1
        end
      end
    else
      for d, t in pairs(orig) do
        if d.Parent then
          pcall(function() d.Transparency = t end)
        end
      end
      orig = {}
    end
  end)
  Tog(POp, "Quitar Sombras", false, function(v)
    if v then
      if shadowsOriginal == nil then shadowsOriginal = LIGHT.GlobalShadows end
      LIGHT.GlobalShadows = false
    elseif shadowsOriginal ~= nil then
      LIGHT.GlobalShadows = shadowsOriginal
      shadowsOriginal = nil
    end
  end)

  -- 🚀 ANTI-LAG SUPER POTENTE (reversible: al apagarlo restaura todo)
  Sec(POp, "🚀 ANTI-LAG", "🚀")
  local AL = {
    On = false, Conn = nil, Token = 0,
    Parts = setmetatable({}, {__mode = "k"}),
    Decals = setmetatable({}, {__mode = "k"}),
    Fx = setmetatable({}, {__mode = "k"}),
    Cloth = setmetatable({}, {__mode = "k"}),
    Post = {}, Light = nil, Terr = nil, Quality = nil,
  }
  local function alApply(o)
    if o:IsA("BasePart") then
      if not AL.Parts[o] then AL.Parts[o] = {o.Material, o.Reflectance, o.CastShadow} end
      o.Material = Enum.Material.SmoothPlastic
      o.Reflectance = 0
      o.CastShadow = false
    elseif o:IsA("Decal") or o:IsA("Texture") then
      if AL.Decals[o] == nil then AL.Decals[o] = o.Transparency end
      o.Transparency = 1
    elseif o:IsA("ParticleEmitter") or o:IsA("Trail") or o:IsA("Smoke")
      or o:IsA("Fire") or o:IsA("Sparkles") then
      if AL.Fx[o] == nil then AL.Fx[o] = o.Enabled end
      o.Enabled = false
    elseif o:IsA("Shirt") or o:IsA("Pants") or o:IsA("ShirtGraphic") then
      if o.Parent then
        AL.Cloth[o] = o.Parent
        o.Parent = nil
      end
    end
  end
  local function alStart()
    if AL.On then return end
    AL.On = true
    AL.Token = AL.Token + 1
    local my = AL.Token
    -- Iluminación
    pcall(function()
      AL.Light = {LIGHT.GlobalShadows, LIGHT.FogEnd, LIGHT.Brightness}
      LIGHT.GlobalShadows = false
      LIGHT.FogEnd = 9e9
      LIGHT.Brightness = 1
    end)
    AL.Post = {}
    for _, e in ipairs(LIGHT:GetChildren()) do
      if e:IsA("PostEffect") or e:IsA("BlurEffect") or e:IsA("SunRaysEffect")
        or e:IsA("ColorCorrectionEffect") or e:IsA("DepthOfFieldEffect") then
        pcall(function() AL.Post[e] = e.Enabled; e.Enabled = false end)
      end
    end
    -- Terreno (agua y pasto)
    local terr = workspace:FindFirstChildOfClass("Terrain")
    if terr then
      pcall(function()
        AL.Terr = {Terrain = terr, WaveSize = terr.WaterWaveSize,
          WaveSpeed = terr.WaterWaveSpeed, Refl = terr.WaterReflectance,
          Trans = terr.WaterTransparency}
        if gethiddenproperty then
          pcall(function() AL.Terr.Deco = gethiddenproperty(terr, "Decoration") end)
        end
        terr.WaterWaveSize = 0
        terr.WaterWaveSpeed = 0
        terr.WaterReflectance = 0
        terr.WaterTransparency = 0
        if sethiddenproperty then
          pcall(function() sethiddenproperty(terr, "Decoration", false) end)
        end
      end)
    end
    -- Calidad gráfica mínima
    pcall(function()
      local r = settings().Rendering
      AL.Quality = r.QualityLevel
      r.QualityLevel = Enum.QualityLevel.Level01
    end)
    -- Mapa actual (por tandas para no congelar el juego)
    task.spawn(function()
      local n = 0
      for _, d in ipairs(workspace:GetDescendants()) do
        if not AL.On or AL.Token ~= my then return end
        pcall(alApply, d)
        n = n + 1
        if n % 1500 == 0 then task.wait() end
      end
    end)
    -- Objetos nuevos
    AL.Conn = workspace.DescendantAdded:Connect(function(d)
      task.defer(function()
        if AL.On then pcall(alApply, d) end
      end)
    end)
    TLG.PNotif("🚀 Anti-Lag", "✅ Activado", C.Grn)
  end
  local function alStop(silent)
    if not AL.On then return end
    AL.On = false
    AL.Token = AL.Token + 1
    if AL.Conn then pcall(function() AL.Conn:Disconnect() end); AL.Conn = nil end
    for p, o in pairs(AL.Parts) do
      if p.Parent then pcall(function()
        p.Material = o[1]; p.Reflectance = o[2]; p.CastShadow = o[3]
      end) end
    end
    for d, t in pairs(AL.Decals) do
      if d.Parent then pcall(function() d.Transparency = t end) end
    end
    for f, en in pairs(AL.Fx) do
      if f.Parent then pcall(function() f.Enabled = en end) end
    end
    for c, par in pairs(AL.Cloth) do
      if par and par.Parent then pcall(function() c.Parent = par end) end
    end
    AL.Parts = setmetatable({}, {__mode = "k"})
    AL.Decals = setmetatable({}, {__mode = "k"})
    AL.Fx = setmetatable({}, {__mode = "k"})
    AL.Cloth = setmetatable({}, {__mode = "k"})
    for e, en in pairs(AL.Post) do
      if e.Parent then pcall(function() e.Enabled = en end) end
    end
    AL.Post = {}
    if AL.Light then
      pcall(function()
        -- si "Quitar Sombras" sigue activo, no le devolvemos las sombras
        if shadowsOriginal == nil then LIGHT.GlobalShadows = AL.Light[1] end
        LIGHT.FogEnd = AL.Light[2]
        LIGHT.Brightness = AL.Light[3]
      end)
      AL.Light = nil
    end
    local t = AL.Terr
    if t and t.Terrain and t.Terrain.Parent then
      pcall(function()
        t.Terrain.WaterWaveSize = t.WaveSize
        t.Terrain.WaterWaveSpeed = t.WaveSpeed
        t.Terrain.WaterReflectance = t.Refl
        t.Terrain.WaterTransparency = t.Trans
        if sethiddenproperty and t.Deco ~= nil then
          pcall(function() sethiddenproperty(t.Terrain, "Decoration", t.Deco) end)
        end
      end)
    end
    AL.Terr = nil
    if AL.Quality then
      pcall(function() settings().Rendering.QualityLevel = AL.Quality end)
      AL.Quality = nil
    end
    if not silent then TLG.PNotif("🚀 Anti-Lag", "❌ Desactivado", C.Rd) end
  end
  Tog(POp, "🚀 Anti-Lag Super Potente", false, function(v)
    if v then alStart() else alStop() end
  end)
  Lbl(POp, "Quita materiales, sombras, efectos, partículas y baja la calidad. Al apagarlo se restaura todo.", C.Gr)


  -- ═══════════ RENDIMIENTO EXTRA ═══════════
  local perfRestore

  -- 🔋 Modo ahorro: apaga el render 3D y tapa la pantalla (ideal para AFK)
  Sec(POp, "🔋 MODO AHORRO", "🔋")
  local Saver = {On = false}
  local saverGui
  local function saverStop()
    if not Saver.On then return end
    Saver.On = false
    pcall(function() RS:Set3dRenderingEnabled(true) end)
    if saverGui then pcall(function() saverGui:Destroy() end); saverGui = nil end
    TLG.PNotif("🔋 Ahorro", "❌ Desactivado", C.Rd)
  end
  local function saverStart()
    if Saver.On then return end
    Saver.On = true
    if TLG.ZTB_SetMin then pcall(TLG.ZTB_SetMin, true) end
    local b = Instance.new("TextButton", SG)
    b.Name = "ZTB_Saver"
    b.Size = UDim2.new(1, 0, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Text = ""
    b.ZIndex = 900
    saverGui = b
    local sk = Instance.new("TextLabel", b)
    sk.AnchorPoint = Vector2.new(0.5, 0.5)
    sk.Position = UDim2.new(0.5, 0, 0.42, 0)
    sk.Size = UDim2.fromOffset(120, 100)
    sk.BackgroundTransparency = 1
    sk.Text = "💀"
    sk.TextSize = 64
    sk.TextTransparency = 0.35
    sk.ZIndex = 901
    TW:Create(sk, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
      {TextTransparency = 0.85}):Play()
    local tl = Instance.new("TextLabel", b)
    tl.AnchorPoint = Vector2.new(0.5, 0)
    tl.Position = UDim2.new(0.5, 0, 0.42, 58)
    tl.Size = UDim2.new(1, 0, 0, 40)
    tl.BackgroundTransparency = 1
    tl.Font = Enum.Font.GothamBold
    tl.TextSize = 12
    tl.TextColor3 = Color3.fromRGB(150, 130, 90)
    tl.Text = "MODO AHORRO • toca la pantalla para volver"
    tl.ZIndex = 901
    local t0 = os.clock()
    task.spawn(function()
      while Saver.On and b.Parent do
        local s = math.floor(os.clock() - t0)
        tl.Text = string.format("MODO AHORRO  %d:%02d\ntoca la pantalla para volver", math.floor(s / 60), s % 60)
        task.wait(1)
      end
    end)
    b.Activated:Connect(saverStop)
    pcall(function() RS:Set3dRenderingEnabled(false) end)
    TLG.PNotif("🔋 Ahorro", "✅ Pantalla negra activada", C.Grn)
  end
  Btn(POp, "🔋 Activar modo ahorro (pantalla negra)", C.Yel, saverStart)
  Lbl(POp, "Apaga el 3D para gastar menos batería y calor. Toca la pantalla para volver.", C.Gr)

  local mute = {old = nil}
  Tog(POp, "🔇 Silenciar el juego", false, function(v)
    pcall(function()
      local gs = UserSettings():GetService("UserGameSettings")
      if v then
        if mute.old == nil then mute.old = gs.MasterVolume end
        gs.MasterVolume = 0
      elseif mute.old ~= nil then
        gs.MasterVolume = mute.old
        mute.old = nil
      end
    end)
  end)

  -- 👥 Ocultar a los demás jugadores (solo en tu pantalla)
  Sec(POp, "👥 JUGADORES", "👥")
  local HO = {On = false, Saved = setmetatable({}, {__mode = "k"}), Conns = {}}
  local function hoHide(d)
    if d:IsA("BasePart") or d:IsA("Decal") then
      if HO.Saved[d] == nil then HO.Saved[d] = d.Transparency end
      d.Transparency = 1
    end
  end
  local function hoChar(ch)
    for _, d in ipairs(ch:GetDescendants()) do pcall(hoHide, d) end
    table.insert(HO.Conns, ch.DescendantAdded:Connect(function(d)
      if HO.On then task.defer(function() pcall(hoHide, d) end) end
    end))
  end
  local function hoPlayer(p)
    if p == TLG.LP then return end
    if p.Character then pcall(hoChar, p.Character) end
    table.insert(HO.Conns, p.CharacterAdded:Connect(function(ch)
      if not HO.On then return end
      task.wait(0.3)
      pcall(hoChar, ch)
    end))
  end
  local function hoStop()
    if not HO.On then return end
    HO.On = false
    for _, c in ipairs(HO.Conns) do pcall(function() c:Disconnect() end) end
    HO.Conns = {}
    for d, t in pairs(HO.Saved) do
      if d.Parent then pcall(function() d.Transparency = t end) end
    end
    HO.Saved = setmetatable({}, {__mode = "k"})
  end
  Tog(POp, "👻 Ocultar otros jugadores", false, function(v)
    if v then
      HO.On = true
      for _, p in ipairs(PLR:GetPlayers()) do hoPlayer(p) end
      table.insert(HO.Conns, PLR.PlayerAdded:Connect(hoPlayer))
    else
      hoStop()
    end
  end)
  Lbl(POp, "Menos personajes que dibujar = más FPS en zonas llenas.", C.Gr)

  -- 🎛 Límite de FPS
  Sec(POp, "🎛 LÍMITE DE FPS", "🎛")
  local capL = Lbl(POp, "Límite actual: sin cambios", C.Gr)
  local function setCap(n, txt)
    if setfpscap then
      pcall(setfpscap, n)
      capL.Text = "Límite actual: " .. txt
    else
      capL.Text = "Tu ejecutor no soporta cambiar el límite de FPS"
    end
  end
  Btn(POp, "🔋 30 FPS (ahorra batería)", C.Wh, function() setCap(30, "30 FPS") end)
  Btn(POp, "⚖️ 60 FPS (equilibrado)", C.Wh, function() setCap(60, "60 FPS") end)
  Btn(POp, "🚀 Sin límite", C.Wh, function() setCap(0, "sin límite") end)

  -- 🎚 Ajustes avanzados
  Sec(POp, "🎚 AJUSTES AVANZADOS", "🎚")
  local Q = {orig = nil, mesh = nil}
  local qReady = false
  Sli(POp, "Calidad gráfica (1-10)", 1, 10, 5, function(v)
    if not qReady then return end
    pcall(function()
      local r = settings().Rendering
      if Q.orig == nil then Q.orig = r.QualityLevel end
      r.QualityLevel = Enum.QualityLevel["Level" .. string.format("%02d", v)]
    end)
  end)
  qReady = true
  Tog(POp, "🧩 Mallas en baja calidad", false, function(v)
    pcall(function()
      local r = settings().Rendering
      if v then
        if Q.mesh == nil then Q.mesh = r.MeshPartDetailLevel end
        r.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
      elseif Q.mesh ~= nil then
        r.MeshPartDetailLevel = Q.mesh
        Q.mesh = nil
      end
    end)
  end)

  -- 🧹 Memoria
  Sec(POp, "🧹 MEMORIA", "🧹")
  Btn(POp, "🧹 Limpiar memoria ahora", C.Wh, function()
    local before = ramMB()
    collectgarbage("collect")
    collectgarbage("collect")
    task.wait(0.2)
    TLG.PNotif("🧹 Memoria", before .. " MB → " .. ramMB() .. " MB", C.Grn)
  end)

  perfRestore = function()
    pcall(saverStop)
    pcall(hoStop)
    pcall(function()
      if mute.old ~= nil then
        UserSettings():GetService("UserGameSettings").MasterVolume = mute.old
        mute.old = nil
      end
    end)
    pcall(function()
      local r = settings().Rendering
      if Q.orig ~= nil then r.QualityLevel = Q.orig; Q.orig = nil end
      if Q.mesh ~= nil then r.MeshPartDetailLevel = Q.mesh; Q.mesh = nil end
    end)
  end

  TLG.RestoreOptimize = function()
    pcall(alStop, true)
    if perfRestore then pcall(perfRestore) end
    for d, transparency in pairs(orig) do
      if d and d.Parent then pcall(function() d.Transparency = transparency end) end
    end
    orig = {}
    if shadowsOriginal ~= nil then
      pcall(function() LIGHT.GlobalShadows = shadowsOriginal end)
      shadowsOriginal = nil
    end
  end
end

-- ═══════════ V9: CONFIG / ESTILO ═══════════
local V9ok, V9err = pcall(function()
  local function myRoot()
    local ch = TLG.LP.Character
    return ch and ch:FindFirstChild("HumanoidRootPart")
  end

  -- CONFIG GUARDADA
  local CFG_FILE = "ZTB_Hub_Config.json"
  local CFG = {}
  pcall(function()
    if isfile and readfile and isfile(CFG_FILE) then
      local d = HS:JSONDecode(readfile(CFG_FILE))
      if type(d) == "table" then CFG = d end
    end
  end)
  local pending = false
  local function saveSoon()
    if pending then return end
    pending = true
    task.delay(1, function()
      pending = false
      pcall(function()
        if writefile then writefile(CFG_FILE, HS:JSONEncode(CFG)) end
      end)
    end)
  end
  TLG.CFG = CFG
  TLG.saveSoon = saveSoon

  -- TEMAS (recolora todo lo que use el acento actual)
  local curAccent = C.Yel
  local function applyAccent(newc, a2)
    local old = curAccent
    if old == newc then return end
    for _, root in ipairs({SG, _G.TLG_FAB_GUI}) do
      if root then
        for _, d in ipairs(root:GetDescendants()) do
          pcall(function()
            if d:IsA("UIStroke") and d.Color == old then d.Color = newc end
            if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.TextColor3 == old then d.TextColor3 = newc end
            if d:IsA("GuiObject") and d.BackgroundColor3 == old then d.BackgroundColor3 = newc end
            if d:IsA("ScrollingFrame") and d.ScrollBarImageColor3 == old then d.ScrollBarImageColor3 = newc end
          end)
        end
      end
    end
    C.Yel = newc; curAccent = newc
    TLG.CustomAccent = newc; TLG.CustomAccent2 = a2
  end

  -- FUENTE ELEGANTE (serif)
  local okSerif, SERIF = pcall(function() return Enum.Font.Garamond end)
  local fontMemo = {}
  local function applyFont(serif)
    if not okSerif then return end
    for _, root in ipairs({SG, _G.TLG_FAB_GUI}) do
      if root then
        for _, d in ipairs(root:GetDescendants()) do
          if d:IsA("TextLabel") or d:IsA("TextButton") then
            pcall(function()
              if serif then
                if not fontMemo[d] and d.Font ~= SERIF then
                  fontMemo[d] = {d.Font, d.TextSize}
                  d.Font = SERIF; d.TextSize = d.TextSize + 1
                end
              else
                local m = fontMemo[d]
                if m then d.Font = m[1]; d.TextSize = m[2]; fontMemo[d] = nil end
              end
            end)
          end
        end
      end
    end
  end

  
--==================================================
-- VISUAL SKILL SPEED V9.7
-- Visual/local animation speed only.
-- No Tool:Activate(), no auto-clicking, no attack automation.
--==================================================

local VSS = {
    On = false,
    Ping = 50,
    Multiplier = 1.15,
    AttackMultiplier = 1.35,
    SkillMultiplier = 1.30,
    WalkMultiplier = 1.08,
    IdleMultiplier = 1.00,
    Original = {},
    Conn = nil,
    CharConns = {},
    LastPing = 0
}
TLG.VisualSkillSpeed = VSS

local function vssDisconnect()
    for _, c in ipairs(VSS.CharConns) do
        pcall(function() c:Disconnect() end)
    end
    table.clear(VSS.CharConns)
end

local function vssPing()
    local ok, value = pcall(function()
        if TLG.LP and TLG.LP.GetNetworkPing then
            return math.floor(TLG.LP:GetNetworkPing() * 1000 + 0.5)
        end
        return nil
    end)
    if ok and value and value > 0 then
        VSS.Ping = value
    end
    return VSS.Ping
end

local function vssText(track)
    local parts = {}
    pcall(function()
        if track.Name then parts[#parts+1] = string.lower(track.Name) end
    end)
    pcall(function()
        if track.Animation and track.Animation.Name then
            parts[#parts+1] = string.lower(track.Animation.Name)
        end
    end)
    return table.concat(parts, " ")
end

local function vssSpeed(track)
    local text = vssText(track)

    if text:find("attack", 1, true)
        or text:find("slash", 1, true)
        or text:find("swing", 1, true)
        or text:find("sword", 1, true) then
        return VSS.AttackMultiplier
    end

    if text:find("skill", 1, true)
        or text:find("ability", 1, true)
        or text:find("power", 1, true)
        or text:find("cast", 1, true) then
        return VSS.SkillMultiplier
    end

    if text:find("walk", 1, true)
        or text:find("run", 1, true) then
        return VSS.WalkMultiplier
    end

    if text:find("idle", 1, true) then
        return VSS.IdleMultiplier
    end

    return VSS.Multiplier
end

local function vssApply(track)
    if not VSS.On or not track then return end

    local speed = vssSpeed(track)
    local ok, old = pcall(function()
        return track.Speed
    end)

    if ok and old and VSS.Original[track] == nil then
        VSS.Original[track] = old
    end

    pcall(function()
        track:AdjustSpeed(speed)
    end)
end

function TLG.VisualSkillSpeedStop()
    VSS.On = false

    for track, old in pairs(VSS.Original) do
        pcall(function()
            if track and track.Parent then
                track:AdjustSpeed(old)
            end
        end)
    end

    table.clear(VSS.Original)
    vssDisconnect()

    if VSS.Conn then
        pcall(function() VSS.Conn:Disconnect() end)
        VSS.Conn = nil
    end
end

function TLG.VisualSkillSpeedStart()
    if VSS.On then return end

    VSS.On = true
    vssPing()

    local function hookCharacter(char)
        vssDisconnect()

        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        table.insert(VSS.CharConns, hum.AnimationPlayed:Connect(function(track)
            if VSS.On then
                vssApply(track)
            end
        end))

        -- Apply to tracks already playing.
        pcall(function()
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                vssApply(track)
            end
        end)
    end

    if TLG.LP.Character then
        hookCharacter(TLG.LP.Character)
    end

    table.insert(VSS.CharConns, TLG.LP.CharacterAdded:Connect(function(char)
        task.wait(0.25)
        if VSS.On then hookCharacter(char) end
    end))

    VSS.Conn = RS.Heartbeat:Connect(function()
        if not VSS.On then return end

        local now = os.clock()
        if now - VSS.LastPing >= 1 then
            VSS.LastPing = now
            vssPing()
        end

        local char = TLG.LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        pcall(function()
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                vssApply(track)
            end
        end)
    end)
end


-- UI: pestaña CONFIG
  -- La pestaña nunca se creaba (PCf era nil) y por eso Config no aparecía en el menú.
  local PCf = Tab("Config", "⚙️")
  TLG.PCf = PCf
  Sec(PCf, "🎨 COLOR DEL MENÚ", "🎨")
  local grid = Instance.new("Frame", PCf)
  grid.Size = UDim2.new(1, 0, 0, 0)
  grid.AutomaticSize = Enum.AutomaticSize.Y
  grid.BackgroundTransparency = 1
  grid.ZIndex = 5
  local gl = Instance.new("UIGridLayout", grid)
  gl.CellSize = UDim2.new(0.5, -4, 0, 34)
  gl.CellPadding = UDim2.new(0, 6, 0, 6)
  local tnames = {}
  for n in pairs(Themes) do table.insert(tnames, n) end
  table.sort(tnames)
  for _, n in ipairs(tnames) do
    local t = Themes[n]
    Btn(grid, n, t.A, function()
      applyAccent(t.A, t.A2)
      CFG.theme = n; saveSoon()
      TLG.PNotif("🎨", n, t.A)
    end)
  end

  Sec(PCf, "🖋 ESTILO", "🖋")
  Tog(PCf, "Fuente elegante (serif)", CFG.serif ~= false, function(v)
    CFG.serif = v; saveSoon(); applyFont(v)
  end)

  Sec(PCf, "💾 CONFIGURACIÓN", "💾")
  Lbl(PCf, "Se guarda en ZTB_Hub_Config.json (si tu ejecutor lo permite).", C.Gr)
  Btn(PCf, "🗑 Borrar configuración guardada", C.Rd, function()
    for k in pairs(CFG) do CFG[k] = nil end
    pcall(function() if writefile then writefile(CFG_FILE, "{}") end end)
    TLG.PNotif("🗑", "Configuración borrada", C.Rd)
  end)

  Sec(PCf, "🚨 SEGURIDAD", "🚨")
  Btn(PCf, "🚨 PANIC (apagar todo)", C.Rd, function() TLG.Panic() end)
  Btn(PCf, "✖ Cerrar hub", C.Rd, function()
    pcall(function() TLG.Panic() end)
    pcall(function() if _G.TLG_FAB_GUI then _G.TLG_FAB_GUI:Destroy() end end)
    pcall(function() SG:Destroy() end)
  end)

  TLG._postBuild = function()
    local n = CFG.theme
    if n and Themes[n] then pcall(applyAccent, Themes[n].A, Themes[n].A2) end
    if CFG.serif ~= false then pcall(applyFont, true) end
  end
end)
if not V9ok then
  warn("[TLG] V9: " .. tostring(V9err))
  pcall(function() TLG.PNotif("⚠️ V9", tostring(V9err):sub(1, 70), C.Rd) end)
end

-- FAB desactivados por defecto para que no estorben la pantalla.
local FSG = Instance.new("ScreenGui")

FSG.Name = "TLG_FAB_Float"
_G.TLG_FAB_GUI = FSG
FSG.ResetOnSpawn = false
FSG.DisplayOrder = 999
FSG.IgnoreGuiInset = true
FSG.Enabled = false
pcall(function() FSG.Parent = TLG.SP end)
if not FSG.Parent then pcall(function() FSG.Parent = CG end) end

-- FAB GROUP 1 - MOVIMIENTO (God Orb, Fuga, Fly, Orbit Map)
local FM = Instance.new("Frame", FSG)
FM.Name = "FAB_Group1"
FM.Size = UDim2.new(0,260,0,72)
FM.Position = UDim2.new(0,10,1,-155)
FM.BackgroundColor3 = C.BG
FM.BackgroundTransparency = 0.2
FM.BorderSizePixel = 0
FM.ZIndex = 10
FM.Visible = false

-- FAB GROUP 2 - PROTECCION (Anti Stun, Buff Tools, Anti Void, Anti Orbit)
local FM2 = Instance.new("Frame", FSG)
FM2.Name = "FAB_Group2"
FM2.Size = UDim2.new(0,260,0,72)
FM2.Position = UDim2.new(0,10,1,-75)
FM2.BackgroundColor3 = C.BG
FM2.BackgroundTransparency = 0.2
FM2.BorderSizePixel = 0
FM2.ZIndex = 10
FM2.Visible = false
TLG.FAB_Toggle_State = false
TLG.FAB_Frame_Ref = FM
TLG.FAB_SetVisible = function(v)
  TLG.FAB_Toggle_State = v == true
  if _G.TLG_FAB_GUI and _G.TLG_FAB_GUI.Parent then
    _G.TLG_FAB_GUI.Enabled = TLG.FAB_Toggle_State
  end
  if TLG.FAB_Frame_Ref and TLG.FAB_Frame_Ref.Parent then
    TLG.FAB_Frame_Ref.Visible = TLG.FAB_Toggle_State
  end
end

Instance.new("UICorner", FM).CornerRadius = UDim.new(0,12)
Instance.new("UICorner", FM2).CornerRadius = UDim.new(0,12)
local FStr = Instance.new("UIStroke", FM)
local FStr2 = Instance.new("UIStroke", FM2)
FStr2.Thickness = 2
FStr2.Color = C.Yel
FStr2.Transparency = 0.2
FStr.Thickness = 2
FStr.Color = C.Yel
FStr.Transparency = 0.2
TLG.PGlow(FStr, 0.1, 0.5, 1.5)

local FH = Instance.new("TextLabel", FM)
FH.Size = UDim2.new(1,0,0,14)
FH.Position = UDim2.new(0,0,0,2)
FH.BackgroundTransparency = 1
FH.Font = Enum.Font.GothamBold
FH.Text = "💀 ACCIONES RÁPIDAS"
FH.TextColor3 = C.Yel
FH.TextSize = 8
FH.ZIndex = 12

local FHo = Instance.new("Frame", FM)
FHo.Size = UDim2.new(1,-10,1,-20)
FHo.Position = UDim2.new(0,5,0,18)
FHo.BackgroundTransparency = 1
FHo.ZIndex = 11
local FLy = Instance.new("UIListLayout", FHo)
FLy.FillDirection = Enum.FillDirection.Horizontal
FLy.Padding = UDim.new(0,4)
FLy.HorizontalAlignment = Enum.HorizontalAlignment.Center
FLy.VerticalAlignment = Enum.VerticalAlignment.Center

local FH2 = Instance.new("TextLabel", FM2)
FH2.Size = UDim2.new(1,0,0,14)
FH2.Position = UDim2.new(0,0,0,2)
FH2.BackgroundTransparency = 1
FH2.Font = Enum.Font.GothamBold
FH2.Text = "🛡️ PROTECCION"
FH2.TextColor3 = C.Yel
FH2.TextSize = 8
FH2.ZIndex = 12

local FHo2 = Instance.new("Frame", FM2)
FHo2.Size = UDim2.new(1,-10,1,-20)
FHo2.Position = UDim2.new(0,5,0,18)
FHo2.BackgroundTransparency = 1
FHo2.ZIndex = 11
local FLy2 = Instance.new("UIListLayout", FHo2)
FLy2.FillDirection = Enum.FillDirection.Horizontal
FLy2.Padding = UDim.new(0,4)
FLy2.HorizontalAlignment = Enum.HorizontalAlignment.Center
FLy2.VerticalAlignment = Enum.VerticalAlignment.Center

local function CF(i, t, cb, parent)
  local targetParent = parent or FHo
  local b = Instance.new("TextButton", targetParent)
  b.Size = UDim2.new(0,55,0,46)
  b.BackgroundColor3 = C.BG2
  b.Text = ""
  b.BorderSizePixel = 0
  b.AutoButtonColor = false
  b.ZIndex = 12
  b.ClipsDescendants = true
  Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
  local bS = Instance.new("UIStroke", b)
  bS.Thickness = 2; bS.Color = C.Yel; bS.Transparency = 0.4
  local iL = Instance.new("TextLabel", b)
  iL.Size = UDim2.new(1,0,0,22)
  iL.Position = UDim2.new(0,0,0,4)
  iL.BackgroundTransparency = 1
  iL.Text = i; iL.TextSize = 18
  iL.TextColor3 = C.Wh
  iL.Font = Enum.Font.GothamBold
  iL.ZIndex = 13
  local nL = Instance.new("TextLabel", b)
  nL.Size = UDim2.new(1,0,0,10)
  nL.Position = UDim2.new(0,0,1,-14)
  nL.BackgroundTransparency = 1
  nL.Text = t; nL.TextColor3 = C.Wh
  nL.TextSize = 7
  nL.Font = Enum.Font.GothamBold
  nL.ZIndex = 13
  local function SA(s)
    if s then
      b.BackgroundColor3 = C.Yel
      iL.TextColor3 = C.BG
      nL.TextColor3 = C.BG
      bS.Color = C.Wh; bS.Transparency = 0
    else
      b.BackgroundColor3 = C.BG2
      iL.TextColor3 = C.Wh
      nL.TextColor3 = C.Wh
      bS.Color = C.Yel; bS.Transparency = 0.4
    end
  end
  b.Activated:Connect(function()
    local ns = cb()
    if ns ~= nil then SA(ns) end
  end)
  SA(false)
  return b
end

CF("🚀", "FUGA", function()
  if TLG.Fuga then TLG.Fuga() end
end)
CF("✈", "FLY", function()
  if TLG.Fly.On then
    TLG.FlyE()
    return false
  else
    TLG.FlyS()
    return true
  end
end)
CF("🌀", "GOD ORB", function()
  local target = TLG.SelectedTarget
  if not target or target == TLG.LP or not target.Parent then
    TLG.PNotif("🌀 God Orb", "Seleccioná un jugador primero", C.Yel)
    return false
  end
  local ch=target.Character
  local hu=ch and ch:FindFirstChildOfClass("Humanoid")
  local root=ch and ch:FindFirstChild("HumanoidRootPart")
  if not hu or hu.Health<=0 or not root then
    TLG.PNotif("🌀 God Orb", "El objetivo no está listo", C.Yel)
    return false
  end
  if TLG.GO.On then
    TLG.GOS()
    return false
  end
  TLG.GOSt(target)
  return true
end)

CF("🪐", "ORBIT MAP", function()
  if OM.On then
    TLG.OrbitalMapStop()
    return false
  else
    TLG.OrbitalMapStart()
    return OM.On
  end
end)

-- FAB GROUP 2 - Anti Stun, Buff Tools, Anti Void, Anti Orbit
CF("💫", "ANTI STUN", function()
  if TLG.AntiStunState.On then
    TLG.AntiStunStop()
    return false
  else
    TLG.AntiStunStart()
    return TLG.AntiStunState.On
  end
end, FHo2)

CF("🔧", "VISUAL SPEED", function()
  local state = TLG.VisualSkillSpeed
  if not state then
    TLG.PNotif("🔧 Visual Speed", "Módulo no disponible", C.Rd)
    return false
  end
  if state.On then
    TLG.VisualSkillSpeedStop()
    return false
  else
    TLG.VisualSkillSpeedStart()
    return state.On
  end
end, FHo2)

CF("🕳️", "ANTI VOID", function()
  if TLG.AntiVoidState.On then
    TLG.AntiVoidStop()
    return false
  else
    TLG.AntiVoidStart()
    return TLG.AntiVoidState.On
  end
end, FHo2)

CF("🚫", "ANTI ORBIT", function()
  if TLG.AntiOrbitState.On then
    TLG.AntiOrbitStop()
    return false
  else
    TLG.AntiOrbitStart()
    return TLG.AntiOrbitState.On
  end
end, FHo2)

local fdg, fs, fp = false, nil, nil
local fdg2, fs2, fp2 = false, nil, nil
FH.InputBegan:Connect(function(i)
  if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
    fdg = true; fs = i.Position; fp = FM.Position
  end
end)
UIS.InputChanged:Connect(function(i)
  if fdg and (i.UserInputType == Enum.UserInputType.MouseMovement
    or i.UserInputType == Enum.UserInputType.Touch) then
    local d = i.Position - fs
    FM.Position = UDim2.new(fp.X.Scale, fp.X.Offset + d.X,
      fp.Y.Scale, fp.Y.Offset + d.Y)
  end
end)
UIS.InputEnded:Connect(function(i)
  if i.UserInputType == Enum.UserInputType.MouseButton1
    or i.UserInputType == Enum.UserInputType.Touch then
    fdg = false
  end
end)


-- WATERMARK
local WM = Instance.new("Frame", SG)
WM.Name = "ZTB_Watermark"
WM.Size = UDim2.new(0,180,0,28)
WM.Position = UDim2.new(0,10,0,10)
WM.BackgroundColor3 = C.BG2
WM.BackgroundTransparency = 0.2
WM.BorderSizePixel = 0
WM.ZIndex = 50
Instance.new("UICorner", WM).CornerRadius = UDim.new(0,8)
local WMS = Instance.new("UIStroke", WM)
WMS.Color = C.Yel; WMS.Thickness = 2; WMS.Transparency = 0.2
TLG.PGlow(WMS, 0.1, 0.6, 1.5)
local WIc = Instance.new("TextLabel", WM)
WIc.Size = UDim2.new(0,22,1,0)
WIc.Position = UDim2.new(0,4,0,0)
WIc.BackgroundTransparency = 1
WIc.Text = "💀"; WIc.TextSize = 13
WIc.Font = Enum.Font.GothamBold
WIc.TextColor3 = C.Yel; WIc.ZIndex = 51
local WTx = Instance.new("TextLabel", WM)
WTx.Size = UDim2.new(1,-56,1,0)
WTx.Position = UDim2.new(0,28,0,0)
WTx.BackgroundTransparency = 1
WTx.Font = Enum.Font.GothamBold
WTx.Text = "ZTB SKULL EDITION"
WTx.TextSize = 9; WTx.TextColor3 = C.Wh
WTx.TextXAlignment = Enum.TextXAlignment.Left
WTx.ZIndex = 51
local WTm = Instance.new("TextLabel", WM)
WTm.Size = UDim2.new(0,46,1,0)
WTm.Position = UDim2.new(1,-50,0,0)
WTm.BackgroundTransparency = 1
WTm.Font = Enum.Font.GothamBold
WTm.TextSize = 9; WTm.TextColor3 = C.Yel
WTm.TextXAlignment = Enum.TextXAlignment.Right
WTm.ZIndex = 51
task.spawn(function()
  while WTm.Parent do
    WTm.Text = os.date("%H:%M")
    task.wait(30)
  end
end)

-- ═══════════ PESTAÑA GAMPI ═══════════
do
  local GAMPI_B64 = [==[
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
]==]

  local b64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  local function b64decode(data)
    local map = {}
    for i = 1, #b64chars do map[string.byte(b64chars, i)] = i - 1 end
    local out, n, buf, bits = {}, 0, 0, 0
    for i = 1, #data do
      local v = map[string.byte(data, i)]
      if v then
        buf = buf * 64 + v
        bits = bits + 6
        if bits >= 8 then
          bits = bits - 8
          local p = 2 ^ bits
          n = n + 1
          out[n] = string.char(math.floor(buf / p) % 256)
          buf = buf % p
        end
      end
    end
    return table.concat(out)
  end

  -- Guarda la foto como archivo y la muestra con getcustomasset (necesita un ejecutor compatible)
  local assetUrl
  pcall(function()
    local fname = "ZTB_Gampi.jpg"
    if not (isfile and isfile(fname)) then
      writefile(fname, b64decode((GAMPI_B64:gsub("%s", ""))))
    end
    assetUrl = getcustomasset(fname)
  end)

  local PGm = Tab("Gampi", "🐶")
  TLG.PGm = PGm
  Sec(PGm, "🐶 GAMPI", "🐶")

  local GOLD2 = Color3.fromRGB(255, 217, 120)
  local card = Instance.new("Frame", PGm)
  card.Size = UDim2.new(1, 0, 0, 204)
  card.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
  card.BackgroundTransparency = 0.25
  card.BorderSizePixel = 0
  card.ZIndex = 5
  Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)
  local cst = Instance.new("UIStroke", card)
  cst.Color = Color3.fromRGB(255, 255, 255); cst.Thickness = 1.5
  if TLG.SpinGrad then pcall(TLG.SpinGrad, cst, GOLD2, Color3.fromRGB(110, 70, 20), 5) end

  local holder = Instance.new("Frame", card)
  holder.AnchorPoint = Vector2.new(0.5, 0)
  holder.Position = UDim2.new(0.5, 0, 0, 8)
  holder.Size = UDim2.fromOffset(160, 153)
  holder.BackgroundColor3 = Color3.fromRGB(26, 18, 16)
  holder.BorderSizePixel = 0
  holder.ZIndex = 6
  Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 14)
  local hst = Instance.new("UIStroke", holder)
  hst.Color = Color3.fromRGB(255, 190, 120); hst.Thickness = 2; hst.Transparency = 0.1
  local scale = Instance.new("UIScale", holder)

  if assetUrl then
    local img = Instance.new("ImageLabel", holder)
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.Image = assetUrl
    img.ScaleType = Enum.ScaleType.Crop
    img.ZIndex = 7
    Instance.new("UICorner", img).CornerRadius = UDim.new(0, 14)
  else
    local fb = Instance.new("TextLabel", holder)
    fb.Size = UDim2.new(1, 0, 1, 0)
    fb.BackgroundTransparency = 1
    fb.Text = "🐶"
    fb.TextSize = 72
    fb.ZIndex = 7
    local warnL = Instance.new("TextLabel", holder)
    warnL.Size = UDim2.new(1, -12, 0, 26)
    warnL.Position = UDim2.new(0, 6, 1, -34)
    warnL.BackgroundTransparency = 1
    warnL.Font = Enum.Font.GothamSemibold
    warnL.TextSize = 9
    warnL.TextWrapped = true
    warnL.TextColor3 = Color3.fromRGB(180, 160, 120)
    warnL.Text = "Tu ejecutor no permite mostrar la foto (falta getcustomasset)."
    warnL.ZIndex = 8
  end

  local name = Instance.new("TextLabel", card)
  name.AnchorPoint = Vector2.new(0.5, 0)
  name.Position = UDim2.new(0.5, 0, 0, 168)
  name.Size = UDim2.new(1, -20, 0, 14)
  name.BackgroundTransparency = 1
  name.Font = Enum.Font.GothamBold
  name.TextSize = 12
  name.TextColor3 = Color3.fromRGB(255, 190, 120)
  name.Text = "GAMPI 🐾"
  name.ZIndex = 7
  local phrase = Instance.new("TextLabel", card)
  phrase.AnchorPoint = Vector2.new(0.5, 0)
  phrase.Position = UDim2.new(0.5, 0, 0, 184)
  phrase.Size = UDim2.new(1, -20, 0, 14)
  phrase.BackgroundTransparency = 1
  phrase.Font = Enum.Font.Gotham
  phrase.TextSize = 10
  phrase.TextColor3 = Color3.fromRGB(165, 150, 120)
  phrase.Text = "Tócalo para acariciarlo"
  phrase.ZIndex = 7

  -- Interacción: toca la foto
  local pets = 0
  local phrases = {"¡Guau! 🐶", "Gampi te cuida 🐾", "Gampi aprueba 👍", "¿Ya hiciste farm hoy? 💪",
    "Gampi tiene hambre 🍖", "Gampi dice: no te rindas 💀", "Qué buen jefe eres 🥹"}
  local busy = false
  local btn = Instance.new("TextButton", holder)
  btn.Size = UDim2.new(1, 0, 1, 0)
  btn.BackgroundTransparency = 1
  btn.Text = ""
  btn.ZIndex = 12
  btn.Activated:Connect(function()
    pets = pets + 1
    phrase.Text = phrases[(pets - 1) % #phrases + 1] .. "  ·  " .. pets .. (pets == 1 and " caricia" or " caricias")
    -- rebote
    scale.Scale = 0.9
    TW:Create(scale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
    -- corazones que suben
    for k = 1, 4 do
      task.spawn(function()
        local h = Instance.new("TextLabel", card)
        h.AnchorPoint = Vector2.new(0.5, 0.5)
        h.BackgroundTransparency = 1
        h.Text = (k % 2 == 0) and "💛" or "🧡"
        h.TextSize = 16 + k * 2
        h.Size = UDim2.fromOffset(24, 24)
        h.ZIndex = 20
        local x = 0.5 + math.random(-25, 25) / 100
        h.Position = UDim2.new(x, 0, 0, 120)
        task.wait(k * 0.06)
        local tw = TW:Create(h, TweenInfo.new(1.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
          {Position = UDim2.new(x + math.random(-8, 8) / 100, 0, 0, 20), TextTransparency = 1})
        tw:Play()
        task.wait(1.15)
        h:Destroy()
      end)
    end
    if pets % 10 == 0 then TLG.PNotif("🐶 Gampi", pets .. " caricias, ¡te quiere mucho!", Color3.fromRGB(255, 190, 120)) end
  end)
end

-- ═══════════════════════════════════════════════════════════════
-- MENÚ ORBITAL ZTB: calavera central + pestañas en órbita (izquierda)
-- y panel de cristal con el contenido (derecha).
-- ═══════════════════════════════════════════════════════════════
local Orbit = {Open = false, Sel = 1, Orbs = {}, Ang = -90}
do
  local GOLD  = Color3.fromRGB(232, 170, 60)
  local GOLD2 = Color3.fromRGB(255, 217, 120)
  local DARK  = Color3.fromRGB(14, 11, 13)
  local WHITE = Color3.fromRGB(255, 255, 255)
  local QUINT = Enum.EasingStyle.Quint
  local BACK  = Enum.EasingStyle.Back
  local OUT   = Enum.EasingDirection.Out
  local LIN   = Enum.EasingStyle.Linear
  local SINE  = Enum.EasingStyle.Sine
  local INOUT = Enum.EasingDirection.InOut

  -- Color propio de cada pestaña
  local ACC = {
    Info = Color3.fromRGB(110, 185, 255), Combat = Color3.fromRGB(255, 92, 100),
    Aimbot = Color3.fromRGB(255, 150, 60), Fly = Color3.fromRGB(90, 225, 235),
    Islands = Color3.fromRGB(100, 225, 150), Scripts = Color3.fromRGB(185, 140, 255),
    Tools = Color3.fromRGB(255, 200, 80), ESP = Color3.fromRGB(255, 105, 190),
    Visuals = Color3.fromRGB(255, 235, 150), Optimize = Color3.fromRGB(170, 255, 100),
    Config = Color3.fromRGB(205, 210, 225),
    Gampi = Color3.fromRGB(255, 190, 120),
  }
  local function accOf(t) return ACC[t and t.name or ""] or GOLD2 end

  local function kp(t, c) return ColorSequenceKeypoint.new(t, c) end
  -- Degradado giratorio sobre un UIStroke (brillo dorado que recorre el borde)
  local function spinGrad(stroke, a, b, secs)
    local g = Instance.new("UIGradient", stroke)
    g.Color = ColorSequence.new({kp(0, a), kp(0.5, b), kp(1, a)})
    TW:Create(g, TweenInfo.new(secs, LIN, OUT, -1), {Rotation = 360}):Play()
    return g
  end
  TLG.SpinGrad = spinGrad

  local cam = workspace.CurrentCamera
  local vp = cam and cam.ViewportSize or Vector2.new(800, 400)
  local panelW = W_S.X.Offset
  local ORB = TLG.IsMobile and 38 or 44
  local freeW = vp.X - panelW - 24
  local R = math.clamp(math.min(vp.Y * 0.5 - ORB - 6, freeW / 2 - ORB / 2 - 4), 74, 128)
  local CORE = math.floor(R * 0.86)
  local cx = math.max(R + ORB / 2 + 6, freeW / 2 + 6)
  local BOX = math.floor(R * 2 + ORB + 10)

  -- ── Estilo cristal del panel derecho ──
  W.BackgroundColor3 = WHITE
  W.BackgroundTransparency = 0.22
  Wgrad.Color = ColorSequence.new(Color3.fromRGB(38, 29, 33), Color3.fromRGB(9, 7, 9))
  Wgrad.Rotation = 135
  WS.Color = WHITE
  WS.Thickness = 1.6
  spinGrad(WS, GOLD2, Color3.fromRGB(110, 70, 20), 6)
  TB.BackgroundTransparency = 1
  HF.BackgroundTransparency = 1
  SideBar.Visible = false
  Cont.Position = UDim2.new(0, 10, 0, 60)
  Cont.Size = UDim2.new(1, -20, 1, -82)
  Cont.BackgroundTransparency = 0.55

  -- Reflejo de cristal en la parte alta
  local sheen = Instance.new("Frame", W)
  sheen.Name = "ZTB_Sheen"
  sheen.Size = UDim2.new(1, 0, 0.5, 0)
  sheen.BackgroundColor3 = WHITE
  sheen.BorderSizePixel = 0
  sheen.ZIndex = 2
  Instance.new("UICorner", sheen).CornerRadius = UDim.new(0, 12)
  local shg = Instance.new("UIGradient", sheen)
  shg.Rotation = 90
  shg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.88), NumberSequenceKeypoint.new(1, 1)})

  local hair = Instance.new("Frame", W)
  hair.Size = UDim2.new(1, -24, 0, 1)
  hair.Position = UDim2.new(0, 12, 0, 54)
  hair.BackgroundColor3 = GOLD2
  hair.BackgroundTransparency = 0.55
  hair.BorderSizePixel = 0
  hair.ZIndex = 6

  -- Título con destello que lo recorre
  MainTitle.TextColor3 = WHITE
  local tg = Instance.new("UIGradient", MainTitle)
  tg.Color = ColorSequence.new({kp(0, GOLD), kp(0.5, Color3.fromRGB(255, 250, 225)), kp(1, GOLD)})
  tg.Offset = Vector2.new(-1, 0)
  TW:Create(tg, TweenInfo.new(2.4, SINE, INOUT, -1, true), {Offset = Vector2.new(1, 0)}):Play()

  -- ── Contenedor de la órbita ──
  local OR = Instance.new("Frame", SG)
  OR.Name = "ZTB_Orbit"
  OR.AnchorPoint = Vector2.new(0.5, 0.5)
  OR.Position = UDim2.new(0, cx, 0.5, 0)
  OR.Size = UDim2.fromOffset(BOX, BOX)
  OR.BackgroundTransparency = 1
  OR.Visible = false
  OR.ZIndex = 20
  Orbit.Root = OR

  local function circle(parent, size, bg, bgT, z)
    local f = Instance.new("Frame", parent)
    f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Position = UDim2.new(0.5, 0, 0.5, 0)
    f.Size = UDim2.fromOffset(size, size)
    f.BackgroundColor3 = bg
    f.BackgroundTransparency = bgT
    f.BorderSizePixel = 0
    f.ZIndex = z
    Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
    return f
  end

  -- Disco de cristal con borde dorado giratorio
  local disc = circle(OR, R * 2, DARK, 0.4, 20)
  local ds = Instance.new("UIStroke", disc)
  ds.Color = WHITE; ds.Thickness = 1.6; ds.Transparency = 0.3
  spinGrad(ds, GOLD2, Color3.fromRGB(90, 58, 18), 8)
  local dg = Instance.new("UIGradient", disc)
  dg.Color = ColorSequence.new(Color3.fromRGB(46, 36, 40), Color3.fromRGB(8, 6, 8))
  dg.Rotation = 120
  local inner = circle(OR, R * 2 - ORB - 18, DARK, 1, 20)
  local is = Instance.new("UIStroke", inner)
  is.Color = GOLD; is.Thickness = 1; is.Transparency = 0.8

  -- Anillo exterior de puntos que gira despacio
  local spin = Instance.new("Frame", OR)
  spin.AnchorPoint = Vector2.new(0.5, 0.5)
  spin.Position = UDim2.new(0.5, 0, 0.5, 0)
  spin.Size = UDim2.fromOffset(BOX, BOX)
  spin.BackgroundTransparency = 1
  spin.ZIndex = 21
  local rr = BOX / 2 - 3
  for k = 0, 35 do
    local a = math.rad(k * 10)
    local big = (k % 3 == 0)
    local sz = big and 4 or 2
    local d = Instance.new("Frame", spin)
    d.AnchorPoint = Vector2.new(0.5, 0.5)
    d.Position = UDim2.new(0.5, math.floor(math.cos(a) * rr + 0.5), 0.5, math.floor(math.sin(a) * rr + 0.5))
    d.Size = UDim2.fromOffset(sz, sz)
    d.BackgroundColor3 = big and GOLD2 or GOLD
    d.BackgroundTransparency = big and 0.1 or 0.55
    d.BorderSizePixel = 0
    d.ZIndex = 21
    Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
  end
  TW:Create(spin, TweenInfo.new(60, LIN, OUT, -1), {Rotation = 360}):Play()

  -- Aura que respira detrás de la calavera
  local aura = circle(OR, CORE * 1.25, GOLD, 0.82, 22)
  TW:Create(aura, TweenInfo.new(1.7, SINE, INOUT, -1, true),
    {Size = UDim2.fromOffset(CORE * 1.6, CORE * 1.6), BackgroundTransparency = 0.96}):Play()

  -- Haz de luz desde la calavera hacia la pestaña activa + halo que se desliza
  local beamLen = math.max(10, R - CORE / 2 - ORB / 2 - 8)
  local beam = Instance.new("Frame", OR)
  beam.AnchorPoint = Vector2.new(0, 0.5)
  beam.Size = UDim2.fromOffset(beamLen, 3)
  beam.BackgroundColor3 = GOLD2
  beam.BackgroundTransparency = 0.1
  beam.BorderSizePixel = 0
  beam.ZIndex = 22
  Instance.new("UICorner", beam).CornerRadius = UDim.new(1, 0)
  local bg = Instance.new("UIGradient", beam)
  bg.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.9), NumberSequenceKeypoint.new(1, 0)})
  local function beamPos(deg)
    local a = math.rad(deg)
    local off = CORE / 2 + 2
    return UDim2.new(0.5, math.cos(a) * off, 0.5, math.sin(a) * off)
  end
  beam.Position = beamPos(-90)
  beam.Rotation = -90

  local halo = circle(OR, ORB + 18, GOLD2, 0.8, 25)
  local hs = Instance.new("UIStroke", halo)
  hs.Color = GOLD2; hs.Thickness = 2; hs.Transparency = 0.15

  -- Calavera central (cierra el menú)
  local core = Instance.new("TextButton", OR)
  core.Name = "ZTB_OrbitCore"
  core.AnchorPoint = Vector2.new(0.5, 0.5)
  core.Position = UDim2.new(0.5, 0, 0.5, -8)
  core.Size = UDim2.fromOffset(CORE, CORE)
  core.BackgroundColor3 = Color3.fromRGB(18, 13, 16)
  core.AutoButtonColor = false
  core.Text = "💀"
  core.TextSize = math.floor(CORE * 0.58)
  core.Font = Enum.Font.GothamBold
  core.TextColor3 = WHITE
  core.BorderSizePixel = 0
  core.ZIndex = 24
  Instance.new("UICorner", core).CornerRadius = UDim.new(1, 0)
  local cs = Instance.new("UIStroke", core)
  cs.Color = WHITE; cs.Thickness = 2
  spinGrad(cs, GOLD2, Color3.fromRGB(110, 70, 20), 3.5)

  local nameL = Instance.new("TextLabel", OR)
  nameL.AnchorPoint = Vector2.new(0.5, 0)
  nameL.Position = UDim2.new(0.5, 0, 0.5, math.floor(CORE / 2) - 2)
  nameL.Size = UDim2.fromOffset(R * 1.5, 18)
  nameL.BackgroundTransparency = 1
  nameL.Font = Enum.Font.GothamBold
  nameL.TextSize = TLG.IsMobile and 10 or 12
  nameL.TextColor3 = GOLD2
  nameL.Text = ""
  nameL.ZIndex = 24

  -- Chispas doradas que suben dentro del disco
  for k = 1, 7 do
    task.spawn(function()
      local e = circle(OR, 3, GOLD2, 1, 23)
      task.wait(k * 0.45)
      while OR.Parent do
        if not Orbit.Open then
          task.wait(0.5)
        else
          local x = math.random(-math.floor(R * 0.5), math.floor(R * 0.5))
          local dur = 2.6 + math.random(0, 20) / 10
          e.Position = UDim2.new(0.5, x, 0.5, math.floor(R * 0.55))
          e.BackgroundTransparency = 0.1
          local t = TW:Create(e, TweenInfo.new(dur, SINE, OUT),
            {Position = UDim2.new(0.5, x + math.random(-12, 12), 0.5, -math.floor(R * 0.5)), BackgroundTransparency = 1})
          t:Play()
          task.wait(dur)
        end
      end
    end)
  end

  -- ── Orbes (una por pestaña) ──
  local N = #Tabs
  local function ang(i) return -90 + (i - 1) * 360 / N end
  local function orbPos(i)
    local a = math.rad(ang(i))
    return UDim2.new(0.5, math.floor(math.cos(a) * R + 0.5), 0.5, math.floor(math.sin(a) * R + 0.5))
  end

  local function style(i, active)
    local o = Orbit.Orbs[i]
    if not o then return end
    local s = active and ORB + 6 or ORB
    TW:Create(o.btn, TweenInfo.new(0.28, BACK, OUT), {
      BackgroundColor3 = active and o.acc or Color3.fromRGB(14, 11, 13),
      Size = UDim2.fromOffset(s, s),
    }):Play()
    o.stroke.Color = active and WHITE or o.acc
    o.stroke.Transparency = active and 0.05 or 0.35
    o.btn.TextTransparency = active and 0 or 0.08
  end

  function Orbit.Select(i)
    local t = Tabs[i]
    if not t then return end
    local acc = accOf(t)
    for j = 1, #Tabs do style(j, j == i) end
    Orbit.Sel = i

    -- halo y haz de luz hacia la pestaña activa
    local target = ang(i)
    local delta = ((target - Orbit.Ang + 180) % 360) - 180
    Orbit.Ang = Orbit.Ang + delta
    local ti = TweenInfo.new(0.38, QUINT, OUT)
    TW:Create(halo, ti, {Position = Orbit.Orbs[i].pos, BackgroundColor3 = acc}):Play()
    hs.Color = acc
    TW:Create(beam, ti, {Rotation = Orbit.Ang, Position = beamPos(Orbit.Ang), BackgroundColor3 = acc}):Play()

    -- acentos del panel
    TW:Create(hair, TweenInfo.new(0.3), {BackgroundColor3 = acc}):Play()
    TW:Create(ContStroke, TweenInfo.new(0.3), {Color = acc}):Play()
    ContStroke.Transparency = 0.6
    local up = string.upper(tostring(t.name or ""))
    nameL.Text = up
    nameL.TextColor3 = acc
    pcall(function() SubTitle.Text = "✦ " .. up .. " ✦"; SubTitle.TextColor3 = acc end)
    pcall(function()
      DcIco.Text = tostring(t.icon or "💀")
      DcS.Color = acc
      DcIco.Size = UDim2.new(0, 14, 0, 14)
      DcIco.Position = UDim2.new(0, 16, 0.5, -7)
      TW:Create(DcIco, TweenInfo.new(0.4, BACK, OUT),
        {Size = UDim2.new(0, 26, 0, 26), Position = UDim2.new(0, 10, 0.5, -13)}):Play()
    end)

    -- contenido: aparece deslizándose desde la derecha
    if t.sel then t.sel() end
    pcall(function()
      t.p.Position = UDim2.new(0, 22, 0, 0)
      TW:Create(t.p, TweenInfo.new(0.34, QUINT, OUT), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    end)
  end

  for i, t in ipairs(Tabs) do
    local acc = accOf(t)
    local b = Instance.new("TextButton", OR)
    b.Name = "ZTB_Orb_" .. tostring(t.name)
    b.AnchorPoint = Vector2.new(0.5, 0.5)
    b.Position = orbPos(i)
    b.Size = UDim2.fromOffset(ORB, ORB)
    b.BackgroundColor3 = Color3.fromRGB(14, 11, 13)
    b.AutoButtonColor = false
    b.Text = tostring(t.icon or "•")
    b.TextSize = math.floor(ORB * 0.5)
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = WHITE
    b.BorderSizePixel = 0
    b.ZIndex = 26
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    local st = Instance.new("UIStroke", b)
    st.Color = acc; st.Thickness = 1.6; st.Transparency = 0.35
    Orbit.Orbs[i] = {btn = b, stroke = st, pos = orbPos(i), acc = acc}
    b.Activated:Connect(function() Orbit.Select(i) end)
  end
  halo.Position = Orbit.Orbs[1] and Orbit.Orbs[1].pos or UDim2.new(0.5, 0, 0.5, 0)

  core.Activated:Connect(function()
    if TLG.ZTB_SetMin then TLG.ZTB_SetMin(true) end
  end)

  -- Mostrar / ocultar con animación (las orbes salen disparadas desde la calavera)
  function Orbit.Show(on)
    on = on == true
    Orbit.Open = on
    if not on then
      OR.Visible = false
      return
    end
    OR.Visible = true
    halo.Visible = false
    for i, o in ipairs(Orbit.Orbs) do
      o.btn.Position = UDim2.new(0.5, 0, 0.5, 0)
      o.btn.Size = UDim2.fromOffset(4, 4)
      o.btn.TextTransparency = 1
      task.delay((i - 1) * 0.035, function()
        if not Orbit.Open then return end
        local active = (i == Orbit.Sel)
        local s = active and ORB + 6 or ORB
        TW:Create(o.btn, TweenInfo.new(0.42, BACK, OUT),
          {Position = o.pos, Size = UDim2.fromOffset(s, s), TextTransparency = active and 0 or 0.08}):Play()
      end)
    end
    task.delay(0.5, function()
      if not Orbit.Open then return end
      local o = Orbit.Orbs[Orbit.Sel]
      if o then halo.Position = o.pos end
      halo.Visible = true
    end)
    core.Size = UDim2.fromOffset(CORE * 0.4, CORE * 0.4)
    core.Rotation = -200
    TW:Create(core, TweenInfo.new(0.5, BACK, OUT),
      {Size = UDim2.fromOffset(CORE, CORE), Rotation = 0}):Play()
  end

  TLG.ZTB_OrbitShow = Orbit.Show
  TLG.ZTB_OrbitSelect = Orbit.Select
  Orbit.Select(1)
end

-- BOTON FLOTANTE ZTB: abre/cierra el menu (sin barra minimizada)
local min = true
local setMin
do
  local BTN_SIZE = 42
  local EASE = Enum.EasingStyle
  local DIR = Enum.EasingDirection
  local lastWPos = W_P
  local token = 0

  local function tw(o, t, style, dir, props)
    local tween = TW:Create(o, TweenInfo.new(t, style, dir), props)
    tween:Play()
    return tween
  end

  local ToggleButton = Instance.new("TextButton", SG)
  ToggleButton.Name = "ZTB_MenuToggleButton"
  ToggleButton.Size = UDim2.fromOffset(BTN_SIZE, BTN_SIZE)
  ToggleButton.Position = UDim2.new(0, 14, 0.5, -BTN_SIZE / 2)
  ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 12, 14)
  ToggleButton.BackgroundTransparency = 0.08
  ToggleButton.BorderSizePixel = 0
  ToggleButton.AutoButtonColor = false
  ToggleButton.Text = "💀"
  ToggleButton.Font = Enum.Font.GothamBlack
  ToggleButton.TextSize = 22
  ToggleButton.TextColor3 = Color3.fromRGB(255, 218, 120)
  ToggleButton.TextStrokeTransparency = 0.85
  ToggleButton.Visible = true
  ToggleButton.ZIndex = 200
  Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0, 11)
  local ButtonStroke = Instance.new("UIStroke", ToggleButton)
  ButtonStroke.Color = Color3.fromRGB(224, 166, 55)
  ButtonStroke.Thickness = 1.2
  ButtonStroke.Transparency = 0.08
  if TLG.SpinGrad then
    ButtonStroke.Color = Color3.fromRGB(255, 255, 255)
    pcall(TLG.SpinGrad, ButtonStroke, Color3.fromRGB(255, 217, 120), Color3.fromRGB(110, 70, 20), 3)
  end
  TLG.PGlow(ButtonStroke, 0.0, 0.45, 1.2)

  local function isPointer(i)
    return i.UserInputType == Enum.UserInputType.MouseButton1
      or i.UserInputType == Enum.UserInputType.Touch
  end

  local dragging, moved, dragInput = false, false, nil
  local startMouse, startPos = Vector2.zero, Vector2.zero
  ToggleButton.InputBegan:Connect(function(i)
    if dragging or not isPointer(i) then return end
    dragging, moved, dragInput = true, false, i
    startMouse = Vector2.new(i.Position.X, i.Position.Y)
    startPos = ToggleButton.AbsolutePosition - SG.AbsolutePosition
  end)

  UIS.InputChanged:Connect(function(i)
    if not dragging then return end
    local same = (i == dragInput) or
      (dragInput.UserInputType == Enum.UserInputType.MouseButton1
        and i.UserInputType == Enum.UserInputType.MouseMovement)
    if not same then return end
    local delta = Vector2.new(i.Position.X, i.Position.Y) - startMouse
    if not moved and delta.Magnitude > 8 then moved = true end
    if moved then
      local vp = SG.AbsoluteSize
      local x = math.clamp(startPos.X + delta.X, 0, math.max(0, vp.X - BTN_SIZE))
      local y = math.clamp(startPos.Y + delta.Y, 0, math.max(0, vp.Y - BTN_SIZE))
      ToggleButton.Position = UDim2.fromOffset(x, y)
    end
  end)

  UIS.InputEnded:Connect(function(i)
    if not dragging then return end
    local same = (i == dragInput) or
      (dragInput.UserInputType == Enum.UserInputType.MouseButton1
        and i.UserInputType == Enum.UserInputType.MouseButton1)
    if not same then return end
    dragging = false
    -- No cambiar el estado aquí: Activated gestiona el toque/clic.
    -- Hacerlo en ambos eventos provocaba dos toggles y el menú parecía no abrir.
  end)

  -- Asigna Visible solo si el objeto existe (evita "attempt to index nil with 'Visible'").
  local function setVis(o, v)
    if o then pcall(function() o.Visible = v end) end
  end

  setMin = function(st)
    st = st == true
    if st == min then return end
    min = st
    token += 1
    local my = token
    if st then
      pcall(function() lastWPos = W.Position end)
      setVis(WM, false)
      setVis(ToggleButton, true)
      setVis(W, false)
      pcall(function() W.Size = W_S end)
      if TLG.ZTB_OrbitShow then pcall(TLG.ZTB_OrbitShow, false) end
    else
      setVis(ToggleButton, false)
      pcall(function()
        W.Size = UDim2.fromOffset(1, 1)
        W.Position = lastWPos
      end)
      setVis(W, true)
      -- Restaurar los elementos del menu usando los nombres reales.
      -- (TabBar no existe: la barra lateral se llama SideBar.)
      setVis(Cont, true)
      setVis(BH, true)
      setVis(WM, true)
      if STtl and STtl.Parent then STtl.Text = "💀" end
      pcall(tw, W, 0.32, EASE.Back, DIR.Out, {Size = W_S, Position = lastWPos})
      if TLG.ZTB_OrbitShow then pcall(TLG.ZTB_OrbitShow, true) end
    end
  end
  TLG.ZTB_SetMin = setMin

  -- Estado inicial: menú oculto, botón flotante visible.
  setVis(W, false)
  setVis(WM, false)
  setVis(ToggleButton, true)
  min = true

  -- Activated funciona mejor en pantalla táctil que depender solo de InputEnded.
  ToggleButton.Activated:Connect(function()
    if dragging and moved then return end
    setMin(not min)
  end)
end

local CB = Instance.new("TextButton", DcIco)
CB.Size = UDim2.new(1,0,1,0)
CB.BackgroundTransparency = 1
CB.Text = ""; CB.ZIndex = 10
CB.Activated:Connect(function() setMin(not min) end)

if UIS.KeyboardEnabled then
  UIS.InputBegan:Connect(function(i, gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.RightShift then setMin(not min) end
  end)
end

if TLG._postBuild then pcall(TLG._postBuild) end

task.spawn(function()
  pcall(function()
    local fr = Instance.new("Frame", SG)
    fr.Name = "ZTB_Intro"
    fr.Size = UDim2.new(1, 0, 1, 0)
    fr.BackgroundColor3 = Color3.new(0, 0, 0)
    fr.BackgroundTransparency = 1
    fr.BorderSizePixel = 0
    fr.ZIndex = 500
    local t1 = Instance.new("TextLabel", fr)
    t1.Size = UDim2.new(1, 0, 0, 50)
    t1.Position = UDim2.new(0, 0, 0.5, -40)
    t1.BackgroundTransparency = 1
    t1.Font = Enum.Font.GothamBold
    t1.TextSize = 34
    t1.TextColor3 = C.Yel
    t1.Text = "💀 ZTB SKULL EDITION"
    t1.TextTransparency = 1
    t1.ZIndex = 501
    local t2 = Instance.new("TextLabel", fr)
    t2.Size = UDim2.new(1, 0, 0, 20)
    t2.Position = UDim2.new(0, 0, 0.5, 14)
    t2.BackgroundTransparency = 1
    t2.Font = Enum.Font.Gotham
    t2.TextSize = 14
    t2.TextColor3 = C.Gr
    t2.Text = "MEME SEA • DARK GOLD UI"
    t2.TextTransparency = 1
    t2.ZIndex = 501
    local ti = TweenInfo.new(0.45)
    TW:Create(fr, ti, {BackgroundTransparency = 0.4}):Play()
    TW:Create(t1, ti, {TextTransparency = 0}):Play()
    TW:Create(t2, ti, {TextTransparency = 0}):Play()
    task.wait(1.1)
    local to = TweenInfo.new(0.5)
    TW:Create(fr, to, {BackgroundTransparency = 1}):Play()
    TW:Create(t1, to, {TextTransparency = 1}):Play()
    TW:Create(t2, to, {TextTransparency = 1}):Play()
    task.wait(0.55)
    fr:Destroy()
  end)
end)

pcall(function()
  TW:Create(W, TweenInfo.new(0.8, Enum.EasingStyle.Back),
    {Size = W_S, Position = W_P}):Play()
end)
task.wait(0.9)
TLG.PNotif("💀 ZTB SKULL EDITION", "Menú listo • botón flotante compacto", C.Yel)

print("[ZTB SKULL EDITION] 💀 Cargado")
