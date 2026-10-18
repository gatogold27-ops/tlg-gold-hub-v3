-- ZTB SKULL EDITION EXTREME | UI DEMO ONLY | Android + PC
-- Los botones son demostrativos y NO ejecutan acciones del juego.
local Players=game:GetService('Players')
local TweenService=game:GetService('TweenService')
local UIS=game:GetService('UserInputService')
local CoreGui=game:GetService('CoreGui')
local player=Players.LocalPlayer
if not player then return end
for _,p in ipairs({CoreGui,player:FindFirstChildOfClass('PlayerGui')}) do if p and p:FindFirstChild('ZTB_SKULL_EXTREME_DEMO') then p.ZTB_SKULL_EXTREME_DEMO:Destroy() end end
local GOLD=Color3.fromRGB(255,184,45); local LIGHT=Color3.fromRGB(255,220,105); local BG=Color3.fromRGB(9,9,11); local PANEL=Color3.fromRGB(17,17,20); local CARD=Color3.fromRGB(25,25,28); local WHITE=Color3.fromRGB(245,245,247); local MUTED=Color3.fromRGB(165,165,172)
local gui=Instance.new('ScreenGui'); gui.Name='ZTB_SKULL_EXTREME_DEMO'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
if not pcall(function() gui.Parent=CoreGui end) or not gui.Parent then gui.Parent=player:WaitForChild('PlayerGui') end
local function corner(o,r) local c=Instance.new('UICorner'); c.CornerRadius=UDim.new(0,r or 10); c.Parent=o end
local function outline(o,col,t) local s=Instance.new('UIStroke'); s.Color=col or GOLD; s.Thickness=t or 1; s.Parent=o; return s end
local function text(p,txt,size,pos,font,col) local l=Instance.new('TextLabel'); l.BackgroundTransparency=1; l.Text=txt; l.TextSize=size or 14; l.Position=pos or UDim2.new(); l.Size=UDim2.new(1,0,0,26); l.Font=font or Enum.Font.Gotham; l.TextColor3=col or WHITE; l.TextXAlignment=Enum.TextXAlignment.Left; l.TextWrapped=true; l.Parent=p; return l end
local function btn(p,txt,h) local b=Instance.new('TextButton'); b.Size=UDim2.new(1,0,0,h or 42); b.BackgroundColor3=CARD; b.Text=txt; b.TextColor3=WHITE; b.TextSize=13; b.Font=Enum.Font.GothamSemibold; b.TextXAlignment=Enum.TextXAlignment.Left; b.AutoButtonColor=false; b.Parent=p; corner(b,9); outline(b,Color3.fromRGB(115,78,20),1); local pad=Instance.new('UIPadding'); pad.PaddingLeft=UDim.new(0,12); pad.Parent=b; b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=Color3.fromRGB(53,37,13)}):Play() end); b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(.12),{BackgroundColor3=CARD}):Play() end); return b end
local toast=Instance.new('TextLabel'); toast.AnchorPoint=Vector2.new(.5,1); toast.Position=UDim2.new(.5,0,1,-18); toast.Size=UDim2.new(.8,0,0,40); toast.BackgroundColor3=Color3.fromRGB(30,22,9); toast.TextColor3=LIGHT; toast.TextSize=13; toast.Font=Enum.Font.GothamBold; toast.Visible=false; toast.ZIndex=20; toast.Parent=gui; corner(toast,10); outline(toast,GOLD)
local toastId=0; local function notify(s) toastId+=1; local id=toastId; toast.Text='☠  '..s; toast.Visible=true; toast.TextTransparency=0; task.delay(1.6,function() if id==toastId and toast.Parent then local t=TweenService:Create(toast,TweenInfo.new(.2),{TextTransparency=1}); t:Play(); t.Completed:Wait(); if id==toastId then toast.Visible=false end end end) end
local main=Instance.new('Frame'); main.Name='MainWindow'; main.AnchorPoint=Vector2.new(.5,.5); main.Position=UDim2.fromScale(.5,.52); main.Size=UDim2.new(.92,0,.78,0); main.BackgroundColor3=BG; main.Parent=gui; corner(main,15); outline(main,GOLD,2)
local limit=Instance.new('UISizeConstraint'); limit.MinSize=Vector2.new(310,300); limit.MaxSize=Vector2.new(980,680); limit.Parent=main
local head=Instance.new('Frame'); head.Size=UDim2.new(1,0,0,74); head.BackgroundColor3=Color3.fromRGB(30,21,7); head.Parent=main; corner(head,14)
text(head,'☠  ZTB SKULL EDITION',22,UDim2.new(0,15,0,7),Enum.Font.GothamBlack,LIGHT).Size=UDim2.new(1,-110,0,31)
text(head,'🔥 EXTREME  •  MEME SEA  •  UI TEST',11,UDim2.new(0,17,0,42),Enum.Font.Gotham,MUTED)
local line=Instance.new('Frame'); line.Position=UDim2.new(0,0,1,-3); line.Size=UDim2.new(1,0,0,3); line.BackgroundColor3=GOLD; line.Parent=head
local mini=Instance.new('TextButton'); mini.Text='—'; mini.Size=UDim2.fromOffset(32,28); mini.Position=UDim2.new(1,-73,0,20); mini.BackgroundColor3=CARD; mini.TextColor3=LIGHT; mini.Parent=head; corner(mini,7)
local close=Instance.new('TextButton'); close.Text='×'; close.Size=UDim2.fromOffset(32,28); close.Position=UDim2.new(1,-37,0,20); close.BackgroundColor3=Color3.fromRGB(55,20,14); close.TextColor3=WHITE; close.Parent=head; corner(close,7)
-- Drag window by its header (touch + mouse)
do local drag,origin,start; head.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; start=i.Position; origin=main.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end) end end); UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-start; main.Position=UDim2.new(origin.X.Scale,origin.X.Offset+d.X,origin.Y.Scale,origin.Y.Offset+d.Y) end end) end
local body=Instance.new('Frame'); body.Position=UDim2.new(0,10,0,84); body.Size=UDim2.new(1,-20,1,-94); body.BackgroundTransparency=1; body.Parent=main
local side=Instance.new('Frame'); side.Size=UDim2.new(0,145,1,0); side.BackgroundColor3=PANEL; side.Parent=body; corner(side,10); outline(side,Color3.fromRGB(90,62,20),1)
local sl=Instance.new('UIListLayout'); sl.Padding=UDim.new(0,6); sl.Parent=side; local sp=Instance.new('UIPadding'); sp.PaddingTop=UDim.new(0,8); sp.PaddingLeft=UDim.new(0,7); sp.PaddingRight=UDim.new(0,7); sp.Parent=side
local content=Instance.new('ScrollingFrame'); content.Position=UDim2.new(0,153,0,0); content.Size=UDim2.new(1,-153,1,0); content.BackgroundColor3=PANEL; content.BorderSizePixel=0; content.ScrollBarThickness=4; content.ScrollBarImageColor3=GOLD; content.AutomaticCanvasSize=Enum.AutomaticSize.Y; content.CanvasSize=UDim2.new(); content.Parent=body; corner(content,10); outline(content,Color3.fromRGB(90,62,20),1)
local cp=Instance.new('UIPadding'); cp.PaddingTop=UDim.new(0,10); cp.PaddingLeft=UDim.new(0,10); cp.PaddingRight=UDim.new(0,10); cp.PaddingBottom=UDim.new(0,12); cp.Parent=content
local cl=Instance.new('UIListLayout'); cl.Padding=UDim.new(0,8); cl.Parent=content
local pages, tabs={},{}; local selected
local names={'Inicio','Combate','Movimiento','Visuales','Herramientas','Jugador','Utilidades','Configuración'}
local function section(p,title,sub) local f=Instance.new('Frame'); f.Size=UDim2.new(1,0,0,sub and 58 or 34); f.BackgroundColor3=Color3.fromRGB(34,24,8); f.Parent=p; corner(f,8); outline(f,GOLD,1); text(f,title,14,UDim2.new(0,10,0,4),Enum.Font.GothamBold,LIGHT); if sub then text(f,sub,11,UDim2.new(0,10,0,30),Enum.Font.Gotham,MUTED) end end
for _,name in ipairs(names) do
 local page=Instance.new('Frame'); page.Name=name; page.Size=UDim2.new(1,0,0,0); page.AutomaticSize=Enum.AutomaticSize.Y; page.BackgroundTransparency=1; page.Visible=false; page.Parent=content; local lay=Instance.new('UIListLayout'); lay.Padding=UDim.new(0,8); lay.Parent=page; pages[name]=page
 local tb=btn(side,({Inicio='⌂  Inicio',Combate='⚔  Combate',Movimiento='➤  Movimiento',Visuales='◉  Visuales',Herramientas='⚙  Herramientas',Jugador='♟  Jugador',Utilidades='✦  Utilidades',['Configuración']='☼  Configuración'})[name],36); tb.TextSize=11; tabs[name]=tb
 tb.MouseButton1Click:Connect(function() if selected then pages[selected].Visible=false end; selected=name; page.Visible=true; for n,b in pairs(tabs) do b.BackgroundColor3=n==name and Color3.fromRGB(76,49,8) or CARD; b.TextColor3=n==name and LIGHT or WHITE end; content.CanvasPosition=Vector2.new() end)
end
local function demo(p,title,desc) local b=btn(p,title..'   ›\n'..desc,47); b.MouseButton1Click:Connect(function() notify(title..' • solo prueba') end); return b end
section(pages.Inicio,'☠  BIENVENIDO A SKULL EXTREME','Interfaz de prueba: las funciones del juego están apagadas.')
section(pages.Inicio,'🔥  BOTONES DE MUESTRA','Pulsa para probar el aspecto y las notificaciones.')
for _,x in ipairs({{'Auto Farm','Demostración visual'},{'Auto Rebirth','Demostración visual'},{'Teletransporte','Demostración visual'},{'Herramientas','Demostración visual'}}) do demo(pages.Inicio,x[1],x[2]) end
section(pages.Inicio,'✓  ESTADO','Interfaz cargada • modo seguro de prueba')
for _,name in ipairs({'Combate','Movimiento','Visuales','Herramientas','Jugador','Utilidades'}) do section(pages[name],'☠  '..string.upper(name),'Panel de prueba: sin acciones reales'); demo(pages[name],'Botón de prueba A','Solo demostración'); demo(pages[name],'Botón de prueba B','Solo demostración') end
section(pages['Configuración'],'⚙  TEMAS','Cambian el color de los bordes de la demo')
for _,theme in ipairs({{'Dorado',Color3.fromRGB(255,184,45)},{'Rojo',Color3.fromRGB(255,65,65)},{'Púrpura',Color3.fromRGB(180,90,255)},{'Cian',Color3.fromRGB(35,220,255)},{'Verde',Color3.fromRGB(65,235,125)}}) do local b=demo(pages['Configuración'],'Tema: '..theme[1],'Aplicar color'); b.MouseButton1Click:Connect(function() for _,o in ipairs(gui:GetDescendants()) do if o:IsA('UIStroke') then o.Color=theme[2] end end; notify('Tema '..theme[1]..' seleccionado') end) end
local float=Instance.new('TextButton'); float.Name='FloatingSkull'; float.Size=UDim2.fromOffset(54,54); float.Position=UDim2.new(0,14,.45,0); float.BackgroundColor3=Color3.fromRGB(34,22,5); float.Text='☠'; float.TextColor3=LIGHT; float.TextSize=29; float.Parent=gui; corner(float,28); outline(float,GOLD,2); float.Visible=false
local minimized=false; mini.MouseButton1Click:Connect(function() main.Visible=false; float.Visible=true; minimized=true; notify('Menú minimizado') end); close.MouseButton1Click:Connect(function() gui:Destroy() end); float.MouseButton1Click:Connect(function() main.Visible=true; float.Visible=false; minimized=false; notify('Menú abierto') end)
-- Responsive mobile layout
local function resize() local cam=workspace.CurrentCamera; if not cam then return end; local small=cam.ViewportSize.X<560; side.Size=UDim2.new(0,small and 105 or 145,1,0); content.Position=UDim2.new(0,small and 113 or 153,0,0); content.Size=UDim2.new(1,-(small and 113 or 153),1,0); for _,b in pairs(tabs) do b.TextSize=small and 9 or 11 end end
resize(); if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(resize) end
-- Drag floating skull
 do local drag,start,origin; float.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then drag=true; start=i.Position; origin=float.Position; i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false end end) end end); UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-start; float.Position=UDim2.new(origin.X.Scale,origin.X.Offset+d.X,origin.Y.Scale,origin.Y.Offset+d.Y) end end) end
selected='Inicio'; pages.Inicio.Visible=true; tabs.Inicio.BackgroundColor3=Color3.fromRGB(76,49,8); tabs.Inicio.TextColor3=LIGHT
notify('Modo de prueba activo • acciones desactivadas')
print('[ZTB SKULL EDITION EXTREME] Demo UI cargada; sin acciones del juego.')
