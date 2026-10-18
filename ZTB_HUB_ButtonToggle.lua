
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
