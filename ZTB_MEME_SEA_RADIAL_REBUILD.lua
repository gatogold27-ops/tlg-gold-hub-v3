-- ZTB SKULL EDITION | MEME SEA | Radial UI rebuild
-- Clean UI foundation. Existing game-action callbacks must be reconnected in ACTIONS.
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
if not player then return end
local pg = player:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("ZTB_MemeSea_Radial")
if old then old:Destroy() end
local GOLD = Color3.fromRGB(255,190,35)
local BRIGHT = Color3.fromRGB(255,225,95)
local BG = Color3.fromRGB(10,10,14)
local CARD = Color3.fromRGB(26,24,27)
local TEXT = Color3.fromRGB(245,240,225)
local ACTIONS = {} -- Add verified callbacks from the previous script here.
local gui = Instance.new("ScreenGui")
gui.Name = "ZTB_MemeSea_Radial"; gui.ResetOnSpawn = false; gui.IgnoreGuiInset = true; gui.DisplayOrder = 999; gui.Parent = pg
local function corner(o,r) local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,r); c.Parent=o end
local function outline(o,color,thick) local s=Instance.new("UIStroke"); s.Color=color or GOLD; s.Thickness=thick or 1.5; s.Parent=o; return s end
local root=Instance.new("Frame"); root.Name="RadialRoot"; root.AnchorPoint=Vector2.new(.5,.5); root.Position=UDim2.fromScale(.5,.5); root.Size=UDim2.fromOffset(360,360); root.BackgroundColor3=BG; root.Parent=gui; corner(root,180); outline(root,GOLD,2)
local ring=Instance.new("Frame"); ring.AnchorPoint=Vector2.new(.5,.5); ring.Position=UDim2.fromScale(.5,.5); ring.Size=UDim2.fromOffset(270,270); ring.BackgroundTransparency=1; ring.Parent=root; corner(ring,135); outline(ring,Color3.fromRGB(135,85,10),2)
local center=Instance.new("TextButton"); center.AnchorPoint=Vector2.new(.5,.5); center.Position=UDim2.fromScale(.5,.5); center.Size=UDim2.fromOffset(108,108); center.BackgroundColor3=Color3.fromRGB(35,25,9); center.Text="💀\nZTB SKULL\nMEME SEA"; center.TextColor3=BRIGHT; center.TextSize=15; center.Font=Enum.Font.GothamBlack; center.Parent=root; corner(center,54); outline(center,GOLD,2)
local panel=Instance.new("Frame"); panel.Name="CategoryPanel"; panel.AnchorPoint=Vector2.new(.5,.5); panel.Position=UDim2.fromScale(.5,.5); panel.Size=UDim2.new(.88,0,.72,0); panel.BackgroundColor3=BG; panel.Visible=false; panel.Parent=gui; corner(panel,14); outline(panel,GOLD,2)
local constraint=Instance.new("UISizeConstraint",panel); constraint.MinSize=Vector2.new(280,250); constraint.MaxSize=Vector2.new(520,430)
local head=Instance.new("Frame",panel); head.Size=UDim2.new(1,0,0,48); head.BackgroundColor3=Color3.fromRGB(40,29,10); corner(head,12)
local title=Instance.new("TextLabel",head); title.Name="PanelTitle"; title.Position=UDim2.fromOffset(12,0); title.Size=UDim2.new(1,-110,1,0); title.BackgroundTransparency=1; title.Text="ZTB • MEME SEA"; title.TextColor3=BRIGHT; title.TextSize=16; title.Font=Enum.Font.GothamBold; title.TextXAlignment=Enum.TextXAlignment.Left
local back=Instance.new("TextButton",head); back.AnchorPoint=Vector2.new(1,.5); back.Position=UDim2.new(1,-8,.5,0); back.Size=UDim2.fromOffset(86,30); back.BackgroundColor3=Color3.fromRGB(95,60,8); back.Text="◀ RADIAL"; back.TextColor3=TEXT; back.TextSize=11; back.Font=Enum.Font.GothamBold; corner(back,8)
local body=Instance.new("ScrollingFrame",panel); body.Position=UDim2.fromOffset(10,58); body.Size=UDim2.new(1,-20,1,-68); body.BackgroundTransparency=1; body.BorderSizePixel=0; body.ScrollBarThickness=4; body.ScrollBarImageColor3=GOLD; body.AutomaticCanvasSize=Enum.AutomaticSize.Y
local layout=Instance.new("UIListLayout",body); layout.Padding=UDim.new(0,8); layout.SortOrder=Enum.SortOrder.LayoutOrder
local function info(text,order)
 local l=Instance.new("TextLabel"); l.LayoutOrder=order or 1; l.Size=UDim2.new(1,-5,0,58); l.BackgroundColor3=CARD; l.TextColor3=TEXT; l.Text=text; l.TextSize=13; l.Font=Enum.Font.Gotham; l.TextWrapped=true; l.Parent=body; corner(l,9); return l
end
local cats={
 {"INICIO","⌂","Estado general y accesos rápidos."},
 {"COMBATE","⚔","Funciones de combate originales."},
 {"MOVIMIENTO","➤","Opciones de movimiento originales."},
 {"VISUALES","◉","Efectos y ajustes visuales."},
 {"HERRAMIENTAS","⚒","Herramientas recuperadas del script anterior."},
 {"JUGADOR","♙","Opciones del personaje."},
 {"UTILIDADES","✦","Utilidades y controles generales."},
 {"CONFIGURACIÓN","⚙","Ajustes de la interfaz radial."},
}
local function openCat(cat)
 root.Visible=false; panel.Visible=true; title.Text="✦  "..cat[1]
 for _,v in ipairs(body:GetChildren()) do if v~=layout then v:Destroy() end end
 info(cat[3],1)
 local cb=ACTIONS[cat[1]]
 if cb then
  local b=Instance.new("TextButton"); b.LayoutOrder=2; b.Size=UDim2.new(1,-5,0,44); b.BackgroundColor3=Color3.fromRGB(70,47,8); b.Text="EJECUTAR "..cat[1]; b.TextColor3=BRIGHT; b.TextSize=13; b.Font=Enum.Font.GothamBold; b.Parent=body; corner(b,9)
  b.Activated:Connect(function() local ok,err=pcall(cb); b.Text=ok and "✓ EJECUTADO" or ("ERROR: "..tostring(err)) end)
 else info("La interfaz está lista, pero las acciones de esta pestaña deben conectarse desde el código original. No se han inventado remotos ni funciones.",2) end
end
for i,cat in ipairs(cats) do
 local a=math.rad(-90+(i-1)*45); local b=Instance.new("TextButton"); b.Name="Radial_"..cat[1]; b.AnchorPoint=Vector2.new(.5,.5); b.Position=UDim2.fromOffset(180+math.cos(a)*139,180+math.sin(a)*139); b.Size=UDim2.fromOffset(82,54); b.BackgroundColor3=Color3.fromRGB(28,23,15); b.Text=cat[2].."\n"..cat[1]; b.TextColor3=TEXT; b.TextSize=10; b.Font=Enum.Font.GothamBold; b.TextWrapped=true; b.Parent=root; corner(b,11); local s=outline(b,GOLD,1.3)
 b.Activated:Connect(function() openCat(cat) end)
 b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(78,51,9)}):Play(); s.Transparency=0 end)
 b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(28,23,15)}):Play(); s.Transparency=.15 end)
end
center.Activated:Connect(function() root.Visible=false end)
back.Activated:Connect(function() panel.Visible=false; root.Visible=true end)
local toggle=Instance.new("TextButton"); toggle.Name="ZTB_FloatingToggle"; toggle.AnchorPoint=Vector2.new(0,0.5); toggle.Position=UDim2.new(0,14,.58,0); toggle.Size=UDim2.fromOffset(52,52); toggle.BackgroundColor3=Color3.fromRGB(28,21,8); toggle.Text="💀"; toggle.TextSize=27; toggle.TextColor3=BRIGHT; toggle.Parent=gui; corner(toggle,26); outline(toggle,GOLD,2)
toggle.Activated:Connect(function() if panel.Visible then panel.Visible=false; root.Visible=true else root.Visible=not root.Visible end end)
-- Draggable floating button for touch and mouse.
local dragging, dragStart, startPos = false, nil, nil
toggle.InputBegan:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true; dragStart=input.Position; startPos=toggle.Position end
end)
UIS.InputChanged:Connect(function(input)
 if dragging and (input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseMovement) then
  local d=input.Position-dragStart
  if math.abs(d.X)+math.abs(d.Y)>8 then toggle.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end
 end
end)
UIS.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.Touch or input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
root.Visible=true
print("[ZTB SKULL EDITION] Meme Sea radial UI loaded")
