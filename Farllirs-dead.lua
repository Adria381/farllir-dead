
----------------------------------------------------------
-- UTILIDADES
----------------------------------------------------------
local function calcularDistancia(pos1, pos2)
	return (pos1 - pos2).Magnitude
end

----------------------------------------------------------
-- PANTALLA DE CARGA MEJORADA (CENTRADA, CON ICONO)
----------------------------------------------------------
local LoadingScreen = Instance.new("ScreenGui")
LoadingScreen.Name = "LoadingScreen"
LoadingScreen.ResetOnSpawn = false
LoadingScreen.Parent = game.CoreGui

local loadingFrame = Instance.new("Frame", LoadingScreen)
loadingFrame.Size = UDim2.new(0.5,0,0.3,0)
loadingFrame.Position = UDim2.new(0.25,0,0.35,0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)
loadingFrame.BackgroundTransparency = 0.2
loadingFrame.BorderSizePixel = 0
loadingFrame.AnchorPoint = Vector2.new(0.5,0.5)
	
-- Agregar UICorner para redondear bordes
local loadingCorner = Instance.new("UICorner", loadingFrame)
loadingCorner.CornerRadius = UDim.new(0, 10)

-- Icono Farllir
local icon = Instance.new("ImageLabel", loadingFrame)
icon.Size = UDim2.new(0, 80, 0, 80)
icon.Position = UDim2.new(0.5, -40, 0, 20)
icon.BackgroundTransparency = 1
-- Cambia el siguiente AssetId o URL por el de tu farllir.png
icon.Image = "rbxassetid://18733920817" 

-- Texto de carga
local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(1,0,0,40)
loadingText.Position = UDim2.new(0,0,0,110)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Farllir dead"
loadingText.TextColor3 = Color3.new(1,1,1)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.GothamBold

-- Barra de progreso
local progressBar = Instance.new("Frame", loadingFrame)
progressBar.Size = UDim2.new(0.8,0,0,20)
progressBar.Position = UDim2.new(0.1,0,1,-40)
progressBar.BackgroundColor3 = Color3.fromRGB(60,0,80)
progressBar.BorderSizePixel = 0

local progressFill = Instance.new("Frame", progressBar)
progressFill.Size = UDim2.new(0,0,1,0)
progressFill.BackgroundColor3 = Color3.fromRGB(180,100,255)
progressFill.BorderSizePixel = 0

-- Simulación de carga (tiempo aleatorio entre 2 y 5 segundos)
local loadTime = math.random(2, 5)
local startTime = tick()
while tick() - startTime < loadTime do
	local progress = (tick() - startTime) / loadTime
	progressFill.Size = UDim2.new(progress, 0, 1, 0)
	wait(0.03)
end
LoadingScreen:Destroy()

----------------------------------------------------------
-- ELIMINAR SHADERS
----------------------------------------------------------
local Lighting = game:GetService("Lighting")
for _, effect in pairs(Lighting:GetChildren()) do
	if effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") or 
	   effect:IsA("ColorCorrectionEffect") or effect:IsA("DepthOfFieldEffect") then
		effect:Destroy()
	end
end

----------------------------------------------------------
-- SERVICIOS Y VARIABLES
----------------------------------------------------------
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variables funcionales
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

----------------------------------------------------------
-- CONFIGURACIÓN DE LA CÁMARA
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
-- ELIMINAR NIEBLA Y SOMBRAS
----------------------------------------------------------
Lighting.FogStart = 0
Lighting.FogEnd = 1e6
Lighting.GlobalShadows = false

----------------------------------------------------------
-- DIBUJO DEL FOV (UTILIZADO PARA AIMBOT)
----------------------------------------------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(128, 0, 128)
FOVCircle.Filled = false
FOVCircle.Radius = FOV_RADIUS
FOVCircle.Position = Camera.ViewportSize / 2

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

----------------------------------------------------------
-- MENÚ EMERGENTE MODERNO Y ORGANIZADO (PARA MÓVILES)
----------------------------------------------------------
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "FarllirMenu"
MenuGui.Parent = game.CoreGui
MenuGui.ResetOnSpawn = false

local MenuFrame = Instance.new("Frame", MenuGui)
MenuFrame.Size = UDim2.new(0, 350, 0, 500)
MenuFrame.Position = UDim2.new(0.5, -175, 0.1, 0)
MenuFrame.BackgroundColor3 = Color3.fromRGB(40,0,60)
MenuFrame.BackgroundTransparency = 0.2
MenuFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", MenuFrame)
UICorner.CornerRadius = UDim.new(0, 8)

-- Layout para secciones
local UIList = Instance.new("UIListLayout", MenuFrame)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.Padding = UDim.new(0, 10)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Título del menú
local TitleLabel = Instance.new("TextLabel", MenuFrame)
TitleLabel.Size = UDim2.new(1, -20, 0, 50)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Farllir Menu"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextScaled = true

-- Función para crear secciones
local function crearSeccion(titulo)
	local seccion = Instance.new("Frame", MenuFrame)
	seccion.Size = UDim2.new(1, -20, 0, 40)
	seccion.BackgroundTransparency = 1
	
	local label = Instance.new("TextLabel", seccion)
	label.Size = UDim2.new(1,0,1,0)
	label.BackgroundTransparency = 1
	label.Text = titulo
	label.TextColor3 = Color3.fromRGB(240,200,255)
	label.Font = Enum.Font.GothamSemibold
	label.TextScaled = true
	
	return seccion
end

-- Secciones principales
local mainSeccion = crearSeccion("Main")
local espSeccion = crearSeccion("ESP")
local aimbotSeccion = crearSeccion("Aimbot")
local extrasSeccion = crearSeccion("Extras")

-- Botones agrupados en un contenedor (usando UIListLayout) para cada sección
local function crearContenedor(parent)
	local contenedor = Instance.new("Frame", parent)
	contenedor.Size = UDim2.new(1, -20, 0, 180)
	contenedor.BackgroundTransparency = 1
	
	local layout = Instance.new("UIListLayout", contenedor)
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 5)
	return contenedor
end

local mainCont = crearContenedor(mainSeccion)
local espCont = crearContenedor(espSeccion)
local aimbotCont = crearContenedor(aimbotSeccion)
local extrasCont = crearContenedor(extrasSeccion)

-- Función para crear botones modernos
local function crearBoton(texto, parent)
	local boton = Instance.new("TextButton", parent)
	boton.Size = UDim2.new(1, 0, 0, 40)
	boton.BackgroundColor3 = Color3.fromRGB(50,20,80)
	boton.BackgroundTransparency = 0.3
	boton.Text = texto
	boton.TextColor3 = Color3.fromRGB(240,200,255)
	boton.Font = Enum.Font.GothamBold
	boton.TextScaled = true
	
	local corner = Instance.new("UICorner", boton)
	corner.CornerRadius = UDim.new(0, 6)
	
	return boton
end

-- Botones en sección Main
local ToggleCameraButton = crearBoton("Toggle Vista (1ª/3ª)", mainCont)
local ResetConfigButton = crearBoton("Reiniciar Config", mainCont)

-- Botones en sección ESP
local ToggleESPButton = crearBoton("Toggle ESP", espCont)
local ToggleRadarButton = crearBoton("Toggle Radar", espCont)

-- Botones en sección Aimbot
local ToggleAimbotButton = crearBoton("Toggle Aimbot", aimbotCont)
local ToggleImprovedButton = crearBoton("Toggle Modo Mejorado", aimbotCont)

-- Botones en sección Extras
local ToggleWeaponModButton = crearBoton("Toggle Armas Mod", extrasCont)
local ToggleAuraButton = crearBoton("Toggle Aura Kills", extrasCont)
local ToggleAutoHealButton = crearBoton("Toggle Auto Heal", extrasCont)
local ToggleFPSButton = crearBoton("Toggle FPS Visor", extrasCont)

-- Botón para ocultar/mostrar menú (pequeño, en la esquina inferior)
local HideMenuButton = Instance.new("TextButton", MenuGui)
HideMenuButton.Size = UDim2.new(0, 120, 0, 40)
HideMenuButton.Position = UDim2.new(0.5, -60, 0.9, 0)
HideMenuButton.BackgroundColor3 = Color3.fromRGB(60,0,90)
HideMenuButton.BackgroundTransparency = 0.2
HideMenuButton.Text = "Ocultar Menu"
HideMenuButton.TextColor3 = Color3.new(1,1,1)
HideMenuButton.Font = Enum.Font.GothamBold
HideMenuButton.TextScaled = true

HideMenuButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
	if MenuFrame.Visible then
		HideMenuButton.Text = "Ocultar Menu"
	else
		HideMenuButton.Text = "Mostrar Menu"
	end
end)

----------------------------------------------------------
-- DRAG DEL MENÚ (adaptable para móvil)
----------------------------------------------------------
local dragging = false
local dragInput, dragStart, startPos
MenuFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MenuFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
MenuFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MenuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

----------------------------------------------------------
-- FUNCIONES DE NPC, AIMBOT, ESP, ETC.
----------------------------------------------------------
local function isValidNPC(model)
	local humanoid = model:FindFirstChild("Humanoid")
	local head = model:FindFirstChild("Head")
	local hrp = model:FindFirstChild("HumanoidRootPart")
	return model:IsA("Model") and humanoid and humanoid.Health > 0 and head and hrp and not Players:GetPlayerFromCharacter(model)
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
				if ray and ray.Instance:IsDescendantOf(npc) then
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
	local smooth = isAimbotImproved and 0.85 or 0.581
	local newLook = currentCF.LookVector:Lerp(dir, smooth)
	Camera.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLook)
end

-- ESP Avanzado: Dibuja círculo y texto (nombre y distancia) sobre cada NPC
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
						espDrawings[npc].text.Text = npc.Name .. " [" .. dist .. "]"
					else
						espDrawings[npc].circle.Visible = false
						espDrawings[npc].text.Visible = false
					end
				end
			end
		end
	else
		for npc, drawing in pairs(espDrawings) do
			drawing.circle:Remove()
			drawing.text:Remove()
		end
		espDrawings = {}
	end
end

-- Aura Kills: Si un NPC entra en rango, fuerza su muerte
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
		local playerHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
		for _, npc in ipairs(validNPCs) do
			if npc and npc.Parent then
				local hrp = npc:FindFirstChild("HumanoidRootPart")
				local humanoid = npc:FindFirstChild("Humanoid")
				if hrp and humanoid and calcularDistancia(hrp.Position, playerHRP) <= auraRange then
					humanoid.Health = 0
				end
			end
		end
	else
		auraDrawing.Visible = false
	end
end

-- FPS Counter
local lastTime = tick()
local frameCount = 0
local function updateFPS()
	frameCount = frameCount + 1
	local currentTime = tick()
	if currentTime - lastTime >= 1 then
		local fps = frameCount
		fpsText.Text = "FPS: " .. fps
		frameCount = 0
		lastTime = currentTime
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

-- Radar de NPCs: Actualiza un listado en el menú con NPCs cercanos y su distancia
local RadarLabel = Instance.new("TextLabel", MenuFrame)
RadarLabel.Size = UDim2.new(1, -20, 0, 80)
RadarLabel.BackgroundColor3 = Color3.fromRGB(40,0,60)
RadarLabel.BackgroundTransparency = 0.5
RadarLabel.TextColor3 = Color3.fromRGB(240,200,255)
RadarLabel.Font = Enum.Font.Gotham
RadarLabel.TextScaled = true
RadarLabel.Text = "Radar:\nNingún NPC cercano"

local function updateRadar()
	local txt = ""
	for _, npc in ipairs(validNPCs) do
		if npc and npc.Parent then
			local head = npc:FindFirstChild("Head")
			if head then
				local dist = math.floor(calcularDistancia(head.Position, Camera.CFrame.Position))
				if dist < 200 then
					txt = txt .. npc.Name .. " - " .. dist .. " studs\n"
				end
			end
		end
	end
	if txt == "" then txt = "Ningún NPC cercano" end
	RadarLabel.Text = "Radar:\n" .. txt
end

-- Modificación de Armas: Forzar cooldown 0 y daño 100
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

-- Función Reset Config
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
	ToggleAimbotButton.Text = "Toggle Aimbot"
	ToggleImprovedButton.Text = "Toggle Modo Mejorado"
	ToggleWeaponModButton.Text = "Toggle Armas Mod"
	ToggleCameraButton.Text = "Toggle Vista (1ª/3ª)"
	ToggleESPButton.Text = "Toggle ESP"
	ToggleAuraButton.Text = "Toggle Aura Kills"
	ToggleAutoHealButton.Text = "Toggle Auto Heal"
	ToggleFPSButton.Text = "Toggle FPS Visor"
end

----------------------------------------------------------
-- BUCLE PRINCIPAL
----------------------------------------------------------
local accumulatedTime = 0
local UPDATE_INTERVAL = 0.4
RunService.Heartbeat:Connect(function(dt)
	updateDrawing()
	updateFPS()
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
-- FUNCIONALIDAD DE BOTONES
----------------------------------------------------------
ToggleCameraButton.MouseButton1Click:Connect(function()
	isFirstPerson = not isFirstPerson
	updateCameraMode()
	ToggleCameraButton.Text = "Toggle Vista (" .. (isFirstPerson and "1ª" or "3ª") .. ")"
end)

ResetConfigButton.MouseButton1Click:Connect(function()
	resetConfig()
end)

ToggleESPButton.MouseButton1Click:Connect(function()
	isESPActive = not isESPActive
	ToggleESPButton.Text = "Toggle ESP (" .. (isESPActive and "ON" or "OFF") .. ")"
end)

ToggleAimbotButton.MouseButton1Click:Connect(function()
	isAimbotActive = not isAimbotActive
	FOVCircle.Visible = isAimbotActive
	ToggleAimbotButton.Text = "Toggle Aimbot (" .. (isAimbotActive and "ON" or "OFF") .. ")"
end)

ToggleImprovedButton.MouseButton1Click:Connect(function()
	isAimbotImproved = not isAimbotImproved
	ToggleImprovedButton.Text = "Toggle Modo Mejorado (" .. (isAimbotImproved and "ON" or "OFF") .. ")"
end)

ToggleWeaponModButton.MouseButton1Click:Connect(function()
	isWeaponModActive = not isWeaponModActive
	ToggleWeaponModButton.Text = "Toggle Armas Mod (" .. (isWeaponModActive and "ON" or "OFF") .. ")"
end)

ToggleAuraButton.MouseButton1Click:Connect(function()
	isAuraActive = not isAuraActive
	ToggleAuraButton.Text = "Toggle Aura Kills (" .. (isAuraActive and "ON" or "OFF") .. ")"
end)

ToggleAutoHealButton.MouseButton1Click:Connect(function()
	autoHealActive = not autoHealActive
	ToggleAutoHealButton.Text = "Toggle Auto Heal (" .. (autoHealActive and "ON" or "OFF") .. ")"
end)

ToggleFPSButton.MouseButton1Click:Connect(function()
	fpsText.Visible = not fpsText.Visible
	ToggleFPSButton.Text = "Toggle FPS Visor (" .. (fpsText.Visible and "ON" or "OFF") .. ")"
end)

HideMenuButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
	if MenuFrame.Visible then
		HideMenuButton.Text = "Ocultar Menu"
	else
		HideMenuButton.Text = "Mostrar Menu"
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
