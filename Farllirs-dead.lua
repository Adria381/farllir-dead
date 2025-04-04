----------------------------------------------------------
-- Farllir Dead - Menú Lateral Compacto Mejorado (Mobile)
----------------------------------------------------------
--[[
Funciones incluidas:
• Pantalla de carga con icono y barra de progreso.
• Menú lateral amplio, con opciones en fuentes más pequeñas.
• ScrollFrame para moverse en el menú.
• Botón de abrir/cerrar menú en la esquina superior derecha.
• Funciones: Aimbot, ESP, Aura, WeaponMod, AutoHeal, Radar, FPS y opciones extra en la sección "Misc".
]]

----------------------------------------------------------
-- CONFIGURACIONES DE INTERFAZ
----------------------------------------------------------
local SIDE_MENU_WIDTH = 280            -- Menú lateral más ancho
local SIDE_MENU_BG_TRANSPARENCY = 0.3  
local BUTTON_BG_TRANSPARENCY = 0.4     
local MENU_PADDING_TOP = 10            
local FONT_SIZE = 14                   -- Tamaño de fuente reducido

----------------------------------------------------------
-- PANTALLA DE CARGA
----------------------------------------------------------
local LoadingScreen = Instance.new("ScreenGui")
LoadingScreen.Name = "LoadingScreen"
LoadingScreen.ResetOnSpawn = false
LoadingScreen.Parent = game.CoreGui

local loadingFrame = Instance.new("Frame", LoadingScreen)
loadingFrame.Size = UDim2.new(0.5, 0, 0.3, 0)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
loadingFrame.BackgroundTransparency = 0.2
loadingFrame.BorderSizePixel = 0

local loadingCorner = Instance.new("UICorner", loadingFrame)
loadingCorner.CornerRadius = UDim.new(0, 10)

local icon = Instance.new("ImageLabel", loadingFrame)
icon.Size = UDim2.new(0, 80, 0, 80)
icon.Position = UDim2.new(0.5, -40, 0, 20)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://123456789"  -- Reemplaza con tu asset

local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(1, 0, 0, 40)
loadingText.Position = UDim2.new(0, 0, 0, 110)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Farllir dead"
loadingText.TextColor3 = Color3.new(1,1,1)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.GothamBold

local progressBar = Instance.new("Frame", loadingFrame)
progressBar.Size = UDim2.new(0.8, 0, 0, 20)
progressBar.Position = UDim2.new(0.1, 0, 1, -40)
progressBar.BackgroundColor3 = Color3.fromRGB(60,0,80)
progressBar.BorderSizePixel = 0
local barCorner = Instance.new("UICorner", progressBar)
barCorner.CornerRadius = UDim.new(0,5)

local progressFill = Instance.new("Frame", progressBar)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(180,100,255)
progressFill.BorderSizePixel = 0
local fillCorner = Instance.new("UICorner", progressFill)
fillCorner.CornerRadius = UDim.new(0,5)

local loadTime = math.random(2,5)
local startTime = tick()
while tick() - startTime < loadTime do
	local p = (tick() - startTime) / loadTime
	progressFill.Size = UDim2.new(p, 0, 1, 0)
	wait(0.03)
end
LoadingScreen:Destroy()

----------------------------------------------------------
-- AJUSTES AMBIENTALES (SHADERS, NIEBLA, ETC.)
----------------------------------------------------------
local Lighting = game:GetService("Lighting")
for _, effect in pairs(Lighting:GetChildren()) do
	if effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect")
	   or effect:IsA("ColorCorrectionEffect")
	   or effect:IsA("DepthOfFieldEffect") then
		effect:Destroy()
	end
end
Lighting.FogStart = 0
Lighting.FogEnd = 1e6
Lighting.GlobalShadows = false

----------------------------------------------------------
-- SERVICIOS Y VARIABLES
----------------------------------------------------------
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local FOV_RADIUS = 136
local isAimbotActive = false
local isAimbotImproved = false
local validNPCs = {}
local isWeaponModActive = true
local isFirstPerson = false
local isESPActive = false
local isAuraActive = false
local auraRange = 50
local autoHealActive = false

----------------------------------------------------------
-- VISOR DE FPS
----------------------------------------------------------
local fpsText = Drawing.new("Text")
fpsText.Visible = true
fpsText.Size = 20
fpsText.Color = Color3.fromRGB(255,255,255)
fpsText.Position = Vector2.new(10, Camera.ViewportSize.Y - 30)
fpsText.Font = Drawing.Fonts.Plex
fpsText.Text = "FPS: 0"

----------------------------------------------------------
-- CONFIGURACIÓN DE CÁMARA
----------------------------------------------------------
local function updateCameraMode()
	if isFirstPerson then
		LocalPlayer.CameraMinZoomDistance = 0
		LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
	else
		LocalPlayer.CameraMinZoomDistance = 10
		LocalPlayer.CameraMode = Enum.CameraMode.Classic
	end
end
updateCameraMode()

----------------------------------------------------------
-- FOV (AIMBOT)
----------------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(128,0,128)
FOVCircle.Filled = false
FOVCircle.Radius = FOV_RADIUS
FOVCircle.Position = Camera.ViewportSize / 2

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

----------------------------------------------------------
-- UTILIDAD: DISTANCIA
----------------------------------------------------------
local function calcularDistancia(p1, p2)
	return (p1 - p2).Magnitude
end

----------------------------------------------------------
-- MENÚ LATERAL COMPACTO
----------------------------------------------------------
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "FarllirSideMenu"
MenuGui.Parent = game.CoreGui
MenuGui.ResetOnSpawn = false

-- Botón de abrir/cerrar menú (ahora en la esquina superior derecha)
local MenuToggleButton = Instance.new("TextButton", MenuGui)
MenuToggleButton.Size = UDim2.new(0, 50, 0, 40)
MenuToggleButton.Position = UDim2.new(1, -60, 0, 10)  -- Esquina superior derecha
MenuToggleButton.AnchorPoint = Vector2.new(1, 0)
MenuToggleButton.BackgroundColor3 = Color3.fromRGB(60,0,80)
MenuToggleButton.BackgroundTransparency = 0.2
MenuToggleButton.Text = "≡"
MenuToggleButton.TextColor3 = Color3.fromRGB(255,255,255)
MenuToggleButton.Font = Enum.Font.GothamBold
MenuToggleButton.TextSize = FONT_SIZE + 4

-- Panel lateral
local SideMenuFrame = Instance.new("Frame", MenuGui)
SideMenuFrame.Size = UDim2.new(0, SIDE_MENU_WIDTH, 1, -MENU_PADDING_TOP*2)
SideMenuFrame.Position = UDim2.new(0, -SIDE_MENU_WIDTH, 0, MENU_PADDING_TOP)
SideMenuFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
SideMenuFrame.BackgroundTransparency = SIDE_MENU_BG_TRANSPARENCY
SideMenuFrame.BorderSizePixel = 0

local sideCorner = Instance.new("UICorner", SideMenuFrame)
sideCorner.CornerRadius = UDim.new(0,8)

-- ScrollFrame para secciones (rollball)
local ScrollFrame = Instance.new("ScrollingFrame", SideMenuFrame)
ScrollFrame.Size = UDim2.new(1,0,1,0)
ScrollFrame.CanvasSize = UDim2.new(0,0,0,0)
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y

local menuLayout = Instance.new("UIListLayout", ScrollFrame)
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.Padding = UDim.new(0,5)
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function actualizarCanvas()
	ScrollFrame.CanvasSize = UDim2.new(0,0,0,menuLayout.AbsoluteContentSize.Y + 10)
end
menuLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(actualizarCanvas)

-- Título del menú
local MenuTitle = Instance.new("TextLabel", ScrollFrame)
MenuTitle.Size = UDim2.new(1, -10, 0, 40)
MenuTitle.BackgroundTransparency = 1
MenuTitle.Text = "Farllir Menu"
MenuTitle.TextColor3 = Color3.new(1,1,1)
MenuTitle.Font = Enum.Font.GothamBold
MenuTitle.TextSize = FONT_SIZE + 2
MenuTitle.LayoutOrder = 1

-- Función para crear secciones (categorías)
local function crearSeccion(titulo, order)
	local seccion = Instance.new("Frame")
	seccion.Size = UDim2.new(1, -10, 0, 30)
	seccion.BackgroundTransparency = 1
	seccion.LayoutOrder = order or 2
	
	local label = Instance.new("TextLabel", seccion)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = titulo
	label.TextColor3 = Color3.fromRGB(240,200,255)
	label.Font = Enum.Font.GothamSemibold
	label.TextSize = FONT_SIZE
	label.TextScaled = false
	
	return seccion
end

-- Contenedor de botones
local function crearContenedor(parent, height, order)
	local cont = Instance.new("Frame", parent)
	cont.Size = UDim2.new(1, -10, 0, height)
	cont.BackgroundTransparency = 1
	cont.LayoutOrder = order or 2
	
	local layout = Instance.new("UIListLayout", cont)
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0,3)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	return cont
end

-- Función para crear botón
local function crearBoton(texto, parent)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(50,20,80)
	btn.BackgroundTransparency = BUTTON_BG_TRANSPARENCY
	btn.Text = texto
	btn.TextColor3 = Color3.fromRGB(240,200,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = FONT_SIZE
	btn.TextScaled = false
	
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0,4)
	return btn
end

----------------------------------------------------------
-- CREACIÓN DE SECCIONES Y BOTONES
----------------------------------------------------------
-- Sección: Main
local mainSeccion = crearSeccion("Main", 2)
mainSeccion.Parent = ScrollFrame
local mainCont = crearContenedor(ScrollFrame, 60, 3)
local ToggleCameraButton = crearBoton("Toggle Vista (3ª) [OFF]", mainCont)
local ResetConfigButton = crearBoton("Reiniciar Config", mainCont)

-- Sección: ESP
local espSeccion = crearSeccion("ESP", 4)
espSeccion.Parent = ScrollFrame
local espCont = crearContenedor(ScrollFrame, 60, 5)
local ToggleESPButton = crearBoton("Toggle ESP (OFF)", espCont)
local ToggleRadarButton = crearBoton("Toggle Radar (ON)", espCont)

-- Sección: Aimbot
local aimbotSeccion = crearSeccion("Aimbot", 6)
aimbotSeccion.Parent = ScrollFrame
local aimbotCont = crearContenedor(ScrollFrame, 60, 7)
local ToggleAimbotButton = crearBoton("Toggle Aimbot (OFF)", aimbotCont)
local ToggleImprovedButton = crearBoton("Modo Mejorado (OFF)", aimbotCont)

-- Sección: Extras
local extrasSeccion = crearSeccion("Extras", 8)
extrasSeccion.Parent = ScrollFrame
local extrasCont = crearContenedor(ScrollFrame, 80, 9)
local ToggleWeaponModButton = crearBoton("Armas Mod (ON)", extrasCont)
local ToggleAuraButton = crearBoton("Aura Kills (OFF)", extrasCont)
local ToggleAutoHealButton = crearBoton("Auto Heal (OFF)", extrasCont)
local ToggleFPSButton = crearBoton("FPS Visor (ON)", extrasCont)

-- Sección: Misc (nuevas funciones)
local miscSeccion = crearSeccion("Misc", 10)
miscSeccion.Parent = ScrollFrame
local miscCont = crearContenedor(ScrollFrame, 80, 11)
local ToggleFlyButton = crearBoton("Toggle Fly (OFF)", miscCont)
local ToggleNoClipButton = crearBoton("Toggle NoClip (OFF)", miscCont)
local ToggleSpeedButton = crearBoton("Toggle Speed (OFF)", miscCont)

-- Radar
local RadarLabel = Instance.new("TextLabel", ScrollFrame)
RadarLabel.Size = UDim2.new(1, -10, 0, 60)
RadarLabel.BackgroundColor3 = Color3.fromRGB(40,0,60)
RadarLabel.BackgroundTransparency = 0.4
RadarLabel.TextColor3 = Color3.fromRGB(240,200,255)
RadarLabel.Font = Enum.Font.Gotham
RadarLabel.TextSize = FONT_SIZE
RadarLabel.TextScaled = false
RadarLabel.Text = "Radar:\nNingún NPC cercano"
RadarLabel.LayoutOrder = 12

actualizarCanvas()

----------------------------------------------------------
-- MOSTRAR/OCULTAR MENÚ CON TWEEN
----------------------------------------------------------
local menuOpen = false
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

MenuToggleButton.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	if menuOpen then
		-- Mostrar el menú: se desliza hacia adentro (x = 10)
		TweenService:Create(SideMenuFrame, tweenInfo, {Position = UDim2.new(0, 10, 0, MENU_PADDING_TOP)}):Play()
	else
		-- Ocultar el menú: se desliza hacia la izquierda (fuera)
		TweenService:Create(SideMenuFrame, tweenInfo, {Position = UDim2.new(0, -SIDE_MENU_WIDTH, 0, MENU_PADDING_TOP)}):Play()
	end
end)

----------------------------------------------------------
-- FUNCIONES DE NPC, AIMBOT, ESP, ETC.
----------------------------------------------------------
local function isValidNPC(model)
	local humanoid = model:FindFirstChild("Humanoid")
	local head = model:FindFirstChild("Head")
	local hrp = model:FindFirstChild("HumanoidRootPart")
	return model:IsA("Model") and humanoid and humanoid.Health > 0
	       and head and hrp and not Players:GetPlayerFromCharacter(model)
end

local function updateNPCList()
	local npcSet = {}
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if isValidNPC(obj) then
			npcSet[obj] = true
		end
	end
	for i = #validNPCs, 1, -1 do
		if not npcSet[validNPCs[i]] then
			table.remove(validNPCs, i)
		end
	end
	for npc in pairs(npcSet) do
		if not table.find(validNPCs, npc) then
			table.insert(validNPCs, npc)
		end
	end
end

Workspace.DescendantAdded:Connect(function(descendant)
	if isValidNPC(descendant) then
		table.insert(validNPCs, descendant)
		local humanoid = descendant:WaitForChild("Humanoid")
		humanoid.Destroying:Connect(function()
			for i = #validNPCs, 1, -1 do
				if validNPCs[i] == descendant then
					table.remove(validNPCs, i)
					break
				end
			end
		end)
	end
end)

local function updateDrawing()
	FOVCircle.Position = Camera.ViewportSize / 2
	FOVCircle.Radius = FOV_RADIUS * (Camera.ViewportSize.Y / 1080)
end

local function predictPosition(target)
	local hrp = target:FindFirstChild("HumanoidRootPart")
	local head = target:FindFirstChild("Head")
	if not hrp then
		return head and head.Position or nil
	end
	local predictionTime = 0.02
	local predicted = hrp.Position + hrp.Velocity * predictionTime
	local offset = head and (head.Position - hrp.Position) or Vector3.new(0,0,0)
	return predicted + offset
end

local function getNearestTarget()
	local closestTarget = nil
	local minDist = math.huge
	local center = Camera.ViewportSize / 2
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
	for _, npc in ipairs(validNPCs) do
		local predicted = predictPosition(npc)
		if predicted then
			local screenPos, onScreen = Camera:WorldToViewportPoint(predicted)
			if onScreen and screenPos.Z > 0 then
				local direction = (predicted - Camera.CFrame.Position).Unit
				local ray = Workspace:Raycast(Camera.CFrame.Position, direction * 1000, raycastParams)
				if ray and ray.Instance and ray.Instance:IsDescendantOf(npc) then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
					if dist < minDist and dist < FOV_RADIUS then
						minDist = dist
						closestTarget = npc
					end
				end
			end
		end
	end
	return closestTarget
end

local function aimAt(targetPos)
	local currentCF = Camera.CFrame
	local dir = (targetPos - currentCF.Position).Unit
	local smooth = isAimbotImproved and 0.85 or 0.58
	local newLook = currentCF.LookVector:Lerp(dir, smooth)
	Camera.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLook)
end

-- ESP: Dibuja círculo y texto sobre cada NPC
local espDrawings = {}
local function updateESP()
	for npc, drawing in pairs(espDrawings) do
		if not npc or not npc.Parent then
			drawing.circle:Remove()
			drawing.text:Remove()
			espDrawings[npc] = nil
		end
	end
	if isESPActive then
		for _, npc in ipairs(validNPCs) do
			if npc and npc.Parent then
				local head = npc:FindFirstChild("Head")
				if head then
					if not espDrawings[npc] then
						espDrawings[npc] = {
							circle = Drawing.new("Circle"),
							text = Drawing.new("Text")
						}
						espDrawings[npc].circle.Thickness = 2
						espDrawings[npc].circle.Color = Color3.fromRGB(240,200,255)
						espDrawings[npc].circle.Filled = false
						espDrawings[npc].text.Size = 20
						espDrawings[npc].text.Color = Color3.fromRGB(240,200,255)
						espDrawings[npc].text.Font = Drawing.Fonts.Plex
					end
					local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
					if onScreen then
						espDrawings[npc].circle.Visible = true
						espDrawings[npc].text.Visible = true
						espDrawings[npc].circle.Position = Vector2.new(screenPos.X, screenPos.Y)
						espDrawings[npc].circle.Radius = 30
						local dist = math.floor(calcularDistancia(head.Position, Camera.CFrame.Position))
						espDrawings[npc].text.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
						espDrawings[npc].text.Text = npc.Name.." ["..dist.."]"
					else
						espDrawings[npc].circle.Visible = false
						espDrawings[npc].text.Visible = false
					end
				end
			end
		end
	else
		for _, drawing in pairs(espDrawings) do
			drawing.circle:Remove()
			drawing.text:Remove()
		end
		espDrawings = {}
	end
end

-- Aura Kills: Fuerza la muerte de NPCs en rango
local auraDrawing = Drawing.new("Circle")
auraDrawing.Visible = false
auraDrawing.Thickness = 2
auraDrawing.Color = Color3.fromRGB(255,0,0)
auraDrawing.Filled = false
auraDrawing.Radius = auraRange
auraDrawing.Position = Camera.ViewportSize / 2

local function updateAura()
	if isAuraActive then
		auraDrawing.Visible = true
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local playerPos = hrp and hrp.Position or Vector3.new(0,0,0)
		for _, npc in ipairs(validNPCs) do
			local npcHRP = npc:FindFirstChild("HumanoidRootPart")
			local humanoid = npc:FindFirstChild("Humanoid")
			if npcHRP and humanoid and calcularDistancia(npcHRP.Position, playerPos) <= auraRange then
				humanoid.Health = 0
			end
		end
	else
		auraDrawing.Visible = false
	end
end

-- Auto Heal: Restaura salud si baja de 50
local function autoHeal()
	if autoHealActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		local humanoid = LocalPlayer.Character.Humanoid
		if humanoid.Health < 50 then
			humanoid.Health = humanoid.MaxHealth
		end
	end
end

-- Radar: Lista NPCs cercanos y su distancia
local function updateRadar()
	local txt = ""
	for _, npc in ipairs(validNPCs) do
		if npc and npc.Parent then
			local head = npc:FindFirstChild("Head")
			if head then
				local dist = math.floor(calcularDistancia(head.Position, Camera.CFrame.Position))
				if dist < 200 then
					txt = txt..npc.Name.." - "..dist.." studs\n"
				end
			end
		end
	end
	if txt == "" then txt = "Ningún NPC cercano" end
	RadarLabel.Text = "Radar:\n"..txt
end

-- Weapon Mod: Forzar cooldown 0 y daño 100
local function modifyWeapon(weapon)
	if weapon:FindFirstChild("Cooldown") then
		weapon.Cooldown.Value = 0
	end
	if weapon:FindFirstChild("Damage") then
		weapon.Damage.Value = 100
	end
end

local function updateWeapons()
	local function processContainer(container)
		for _, item in ipairs(container:GetChildren()) do
			if item:IsA("Tool") then
				modifyWeapon(item)
			end
		end
	end
	processContainer(LocalPlayer.Backpack)
	if LocalPlayer.Character then
		processContainer(LocalPlayer.Character)
	end
end

spawn(function()
	while wait(0.5) do
		if isWeaponModActive then
			updateWeapons()
		end
	end
end)

-- Opciones adicionales en "Misc" (puedes agregar tus funciones reales)
local function toggleFly()
	-- Función dummy
	print("Toggle Fly")
end

local function toggleNoClip()
	-- Función dummy
	print("Toggle NoClip")
end

local function toggleSpeed()
	-- Función dummy
	print("Toggle Speed")
end

----------------------------------------------------------
-- RESET CONFIG: Reinicia todas las variables
----------------------------------------------------------
local function resetConfig()
	isAimbotActive = false
	isAimbotImproved = false
	isWeaponModActive = true
	isFirstPerson = false
	isESPActive = false
	isAuraActive = false
	autoHealActive = false
	updateCameraMode()
	FOVCircle.Visible = false

	ToggleCameraButton.Text = "Toggle Vista (3ª) [OFF]"
	ToggleAimbotButton.Text = "Toggle Aimbot (OFF)"
	ToggleImprovedButton.Text = "Modo Mejorado (OFF)"
	ToggleWeaponModButton.Text = "Armas Mod (ON)"
	ToggleESPButton.Text = "Toggle ESP (OFF)"
	ToggleAuraButton.Text = "Aura Kills (OFF)"
	ToggleAutoHealButton.Text = "Auto Heal (OFF)"
	ToggleFPSButton.Text = "FPS Visor (ON)"
	ToggleRadarButton.Text = "Toggle Radar (ON)"
	ToggleFlyButton.Text = "Toggle Fly (OFF)"
	ToggleNoClipButton.Text = "Toggle NoClip (OFF)"
	ToggleSpeedButton.Text = "Toggle Speed (OFF)"
end

----------------------------------------------------------
-- BUCLE PRINCIPAL
----------------------------------------------------------
local lastTime = tick()
local frameCount = 0
local accumulatedTime = 0
local UPDATE_INTERVAL = 0.4

RunService.Heartbeat:Connect(function(dt)
	updateDrawing()
	-- Actualizar FPS
	frameCount = frameCount + 1
	local now = tick()
	if now - lastTime >= 1 then
		fpsText.Text = "FPS: "..frameCount
		frameCount = 0
		lastTime = now
	end

	autoHeal()
	updateRadar()
	updateNPCList()

	accumulatedTime = accumulatedTime + dt
	if accumulatedTime >= UPDATE_INTERVAL then
		accumulatedTime = 0
	end

	if isAimbotActive then
		local target = getNearestTarget()
		if target then
			local predicted = predictPosition(target)
			if predicted then
				aimAt(predicted)
			end
		end
	end
	if isESPActive then
		updateESP()
	end
	if isAuraActive then
		updateAura()
	end
end)

----------------------------------------------------------
-- ASIGNACIÓN DE BOTONES
----------------------------------------------------------
ToggleCameraButton.MouseButton1Click:Connect(function()
	isFirstPerson = not isFirstPerson
	updateCameraMode()
	if isFirstPerson then
		ToggleCameraButton.Text = "Toggle Vista (1ª) [ON]"
	else
		ToggleCameraButton.Text = "Toggle Vista (3ª) [OFF]"
	end
end)

ResetConfigButton.MouseButton1Click:Connect(function()
	resetConfig()
end)

ToggleESPButton.MouseButton1Click:Connect(function()
	isESPActive = not isESPActive
	ToggleESPButton.Text = "Toggle ESP ("..(isESPActive and "ON" or "OFF")..")"
end)

ToggleRadarButton.MouseButton1Click:Connect(function()
	RadarLabel.Visible = not RadarLabel.Visible
	ToggleRadarButton.Text = "Toggle Radar ("..(RadarLabel.Visible and "ON" or "OFF")..")"
end)

ToggleAimbotButton.MouseButton1Click:Connect(function()
	isAimbotActive = not isAimbotActive
	FOVCircle.Visible = isAimbotActive
	ToggleAimbotButton.Text = "Toggle Aimbot ("..(isAimbotActive and "ON" or "OFF")..")"
end)

ToggleImprovedButton.MouseButton1Click:Connect(function()
	isAimbotImproved = not isAimbotImproved
	ToggleImprovedButton.Text = "Modo Mejorado ("..(isAimbotImproved and "ON" or "OFF")..")"
end)

ToggleWeaponModButton.MouseButton1Click:Connect(function()
	isWeaponModActive = not isWeaponModActive
	ToggleWeaponModButton.Text = "Armas Mod ("..(isWeaponModActive and "ON" or "OFF")..")"
end)

ToggleAuraButton.MouseButton1Click:Connect(function()
	isAuraActive = not isAuraActive
	ToggleAuraButton.Text = "Aura Kills ("..(isAuraActive and "ON" or "OFF")..")"
end)

ToggleAutoHealButton.MouseButton1Click:Connect(function()
	autoHealActive = not autoHealActive
	ToggleAutoHealButton.Text = "Auto Heal ("..(autoHealActive and "ON" or "OFF")..")"
end)

ToggleFPSButton.MouseButton1Click:Connect(function()
	fpsText.Visible = not fpsText.Visible
	ToggleFPSButton.Text = "FPS Visor ("..(fpsText.Visible and "ON" or "OFF")..")"
end)

-- Funciones en "Misc"
ToggleFlyButton.MouseButton1Click:Connect(function()
	-- Llama a tu función real de fly
	toggleFly()
	-- Cambia el texto (aquí se asume que se alterna)
	if ToggleFlyButton.Text:find("OFF") then
		ToggleFlyButton.Text = "Toggle Fly (ON)"
	else
		ToggleFlyButton.Text = "Toggle Fly (OFF)"
	end
end)

ToggleNoClipButton.MouseButton1Click:Connect(function()
	toggleNoClip()
	if ToggleNoClipButton.Text:find("OFF") then
		ToggleNoClipButton.Text = "Toggle NoClip (ON)"
	else
		ToggleNoClipButton.Text = "Toggle NoClip (OFF)"
	end
end)

ToggleSpeedButton.MouseButton1Click:Connect(function()
	toggleSpeed()
	if ToggleSpeedButton.Text:find("OFF") then
		ToggleSpeedButton.Text = "Toggle Speed (ON)"
	else
		ToggleSpeedButton.Text = "Toggle Speed (OFF)"
	end
end)

----------------------------------------------------------
-- LIMPIEZA FINAL
----------------------------------------------------------
Workspace.DescendantRemoved:Connect(function(descendant)
	if isValidNPC(descendant) then
		for i = #validNPCs, 1, -1 do
			if validNPCs[i] == descendant then
				table.remove(validNPCs, i)
				break
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function()
	FOVCircle:Remove()
	MenuGui:Destroy()
	fpsText:Remove()
end)