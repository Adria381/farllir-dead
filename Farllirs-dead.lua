--[[
  Script: Farllir dead - Versión Ultimate
  Funciones:
    • Pantalla de carga inicial.
    • Eliminación de shaders.
    • Menú emergente draggable con interfaz en tonos lila/violeta/morado y transparencia.
    • Aimbot mejorado con opción de suavizado configurable.
    • Modificación de armas (cooldown = 0, daño = 100).
    • Alternar entre vista en primera y tercera persona.
    • Nuevo: Botón para reiniciar configuración.
    • Nuevo: Botón para alternar ESP (resalta NPCs).
--]]

------------------ PANTALLA DE CARGA ------------------
local LoadingScreen = Instance.new("ScreenGui")
local LoadingLabel = Instance.new("TextLabel")
LoadingScreen.Parent = game.CoreGui
LoadingLabel.Parent = LoadingScreen
LoadingLabel.Size = UDim2.new(1, 0, 1, 0)
LoadingLabel.BackgroundColor3 = Color3.new(0, 0, 0)
LoadingLabel.Text = "Farllir dead"
LoadingLabel.TextColor3 = Color3.new(1, 1, 1)
LoadingLabel.TextScaled = true
LoadingLabel.Font = Enum.Font.GothamBold

delay(3, function() 
    LoadingScreen:Destroy() 
end)

------------------ ELIMINAR SHADERS ------------------
local Lighting = game:GetService("Lighting")
for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") or 
       effect:IsA("ColorCorrectionEffect") or effect:IsA("DepthOfFieldEffect") then
        effect:Destroy()
    end
end

------------------ SERVICIOS Y VARIABLES ------------------
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variables de funcionalidades
local FOV_RADIUS = 136
local isAimbotActive = false
local isAimbotImproved = false
local validNPCs = {}
local isWeaponModActive = true  -- siempre activo
local isFirstPerson = false      -- false = tercera, true = primera
local isESPActive = false        -- estado del ESP

------------------ CONFIGURACIÓN DE LA CÁMARA ------------------
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

------------------ ELIMINAR NIEBLA Y SOMBRAS ------------------
Lighting.FogStart = 0
Lighting.FogEnd = 1e6
Lighting.GlobalShadows = false

------------------ DIBUJO DEL FOV ------------------
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(128, 0, 128)
FOVCircle.Filled = false
FOVCircle.Radius = FOV_RADIUS
FOVCircle.Position = Camera.ViewportSize / 2

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

------------------ MENÚ EMERGENTE ------------------
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "FarllirMenu"
MenuGui.Parent = game.CoreGui

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 300, 0, 360)
MenuFrame.Position = UDim2.new(0, 10, 0, 10)
MenuFrame.BackgroundColor3 = Color3.fromRGB(50, 0, 75) -- tono oscuro violeta
MenuFrame.BackgroundTransparency = 0.3
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = MenuGui

-- Título del menú
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(70, 20, 100)
TitleLabel.BackgroundTransparency = 0.2
TitleLabel.Text = "Farllir Menu"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextScaled = true
TitleLabel.Parent = MenuFrame

-- Botón para ocultar el menú
local HideMenuButton = Instance.new("TextButton")
HideMenuButton.Size = UDim2.new(0, 100, 0, 30)
HideMenuButton.Position = UDim2.new(1, -110, 0, 5)
HideMenuButton.Text = "Ocultar"
HideMenuButton.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
HideMenuButton.BackgroundTransparency = 0.2
HideMenuButton.TextColor3 = Color3.new(1,1,1)
HideMenuButton.Font = Enum.Font.GothamBold
HideMenuButton.TextScaled = true
HideMenuButton.Parent = MenuFrame

-- Botón para mostrar el menú (aparece cuando se oculta)
local ShowMenuButton = Instance.new("TextButton")
ShowMenuButton.Size = UDim2.new(0, 120, 0, 30)
ShowMenuButton.Position = UDim2.new(0, 10, 0, 10)
ShowMenuButton.Text = "Mostrar Menu"
ShowMenuButton.BackgroundColor3 = Color3.fromRGB(60, 0, 90)
ShowMenuButton.BackgroundTransparency = 0.2
ShowMenuButton.TextColor3 = Color3.new(1,1,1)
ShowMenuButton.Font = Enum.Font.GothamBold
ShowMenuButton.TextScaled = true
ShowMenuButton.Visible = false
ShowMenuButton.Parent = MenuGui

------------------ BOTONES DE FUNCIONES ------------------
local function crearBoton(nombre, posY, textoInicial, parent)
    local boton = Instance.new("TextButton")
    boton.Size = UDim2.new(1, -20, 0, 30)
    boton.Position = UDim2.new(0, 10, 0, posY)
    boton.Text = textoInicial
    boton.BackgroundColor3 = Color3.fromRGB(70, 20, 100)
    boton.BackgroundTransparency = 0.3
    boton.TextColor3 = Color3.fromRGB(240, 200, 255)
    boton.Font = Enum.Font.GothamBold
    boton.TextScaled = true
    boton.Parent = parent
    return boton
end

local ToggleAimbotButton = crearBoton("AimbotToggle", 50, "AIMBOT: OFF", MenuFrame)
local ToggleImprovedButton = crearBoton("AimbotImproved", 90, "Modo Mejorado: OFF", MenuFrame)
local ToggleWeaponModButton = crearBoton("WeaponMod", 130, "Armas Mod: ON", MenuFrame)
local ToggleCameraButton = crearBoton("CameraToggle", 170, "Vista: Tercera", MenuFrame)
local ResetConfigButton = crearBoton("ResetConfig", 210, "Reiniciar Config", MenuFrame)
local ToggleESPButton = crearBoton("ToggleESP", 250, "ESP: OFF", MenuFrame)

------------------ DRAG DEL MENÚ ------------------
local dragging = false
local dragInput, dragStart, startPos
MenuFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MenuFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

------------------ FUNCIONES DE NPC Y AIMBOT ------------------
local function isValidNPC(model)
    local humanoid = model:FindFirstChild("Humanoid")
    local head = model:FindFirstChild("Head")
    local humanoidRoot = model:FindFirstChild("HumanoidRootPart")
    return model:IsA("Model") and humanoid and humanoid.Health > 0 
           and head and humanoidRoot 
           and not Players:GetPlayerFromCharacter(model)
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
    local humanoidRoot = target:FindFirstChild("HumanoidRootPart")
    local head = target:FindFirstChild("Head")
    if not humanoidRoot then
        return head and head.Position or nil
    end
    local predictionTime = 0.02
    local predictedRootPos = humanoidRoot.Position + humanoidRoot.Velocity * predictionTime
    local headOffset = head and (head.Position - humanoidRoot.Position) or Vector3.new(0, 0, 0)
    return predictedRootPos + headOffset
end

local function getNearestTarget()
    local closestTarget = nil
    local minScreenDistance = math.huge
    local viewportCenter = Camera.ViewportSize / 2
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    
    for _, npc in ipairs(validNPCs) do
        local predictedPos = predictPosition(npc)
        if predictedPos then
            local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
            if onScreen and screenPos.Z > 0 then
                local direction = (predictedPos - Camera.CFrame.Position).Unit
                local ray = Workspace:Raycast(Camera.CFrame.Position, direction * 1000, raycastParams)
                if ray and ray.Instance:IsDescendantOf(npc) then
                    local screenDistance = (Vector2.new(screenPos.X, screenPos.Y) - viewportCenter).Magnitude
                    if screenDistance < minScreenDistance and screenDistance < FOV_RADIUS then
                        minScreenDistance = screenDistance
                        closestTarget = npc
                    end
                end
            end
        end
    end
    
    return closestTarget
end

local function aimAt(targetPosition)
    local currentCF = Camera.CFrame
    local directionToTarget = (targetPosition - currentCF.Position).Unit
    local smoothFactor = isAimbotImproved and 0.85 or 0.581
    local newLookVector = currentCF.LookVector:Lerp(directionToTarget, smoothFactor)
    Camera.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLookVector)
end

------------------ MODIFICACIÓN DE ARMAS ------------------
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

------------------ NUEVAS FUNCIONES ------------------
-- Reiniciar configuración: reinicia variables a sus valores predeterminados.
local function resetConfig()
    isAimbotActive = false
    isAimbotImproved = false
    isWeaponModActive = true
    isFirstPerson = false
    updateCameraMode()
    FOVCircle.Visible = false
    ToggleAimbotButton.Text = "AIMBOT: OFF"
    ToggleImprovedButton.Text = "Modo Mejorado: OFF"
    ToggleWeaponModButton.Text = "Armas Mod: ON"
    ToggleCameraButton.Text = "Vista: Tercera"
end

-- Alternar ESP: resalta los NPCs válidos dibujando un círculo en sus cabezas.
local espDrawings = {}
local function updateESP()
    -- Elimina dibujos anteriores
    for npc, drawing in pairs(espDrawings) do
        if not npc or not npc.Parent then
            drawing:Remove()
            espDrawings[npc] = nil
        end
    end
    if isESPActive then
        for _, npc in ipairs(validNPCs) do
            if npc and npc.Parent then
                local head = npc:FindFirstChild("Head")
                if head then
                    if not espDrawings[npc] then
                        local circle = Drawing.new("Circle")
                        circle.Thickness = 2
                        circle.Color = Color3.fromRGB(240, 200, 255)
                        circle.Filled = false
                        espDrawings[npc] = circle
                    end
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        espDrawings[npc].Visible = true
                        espDrawings[npc].Position = Vector2.new(screenPos.X, screenPos.Y)
                        espDrawings[npc].Radius = 30
                    else
                        espDrawings[npc].Visible = false
                    end
                end
            end
        end
    else
        -- Si se desactiva, se eliminan los dibujos
        for npc, drawing in pairs(espDrawings) do
            drawing:Remove()
        end
        espDrawings = {}
    end
end

------------------ BUCLE PRINCIPAL ------------------
local accumulatedTime = 0
local UPDATE_INTERVAL = 0.4
RunService.Heartbeat:Connect(function(dt)
    updateDrawing()
    accumulatedTime = accumulatedTime + dt
    if accumulatedTime >= UPDATE_INTERVAL then
        updateNPCList()
        accumulatedTime = 0
    end
    if isAimbotActive then
        local target = getNearestTarget()
        if target then
            local predictedPosition = predictPosition(target)
            if predictedPosition then
                aimAt(predictedPosition)
            end
        end
    end
    if isESPActive then
        updateESP()
    end
end)

------------------ FUNCIONALIDAD DE BOTONES ------------------
ToggleAimbotButton.MouseButton1Click:Connect(function()
    isAimbotActive = not isAimbotActive
    FOVCircle.Visible = isAimbotActive
    ToggleAimbotButton.Text = "AIMBOT: " .. (isAimbotActive and "ON" or "OFF")
    ToggleAimbotButton.TextColor3 = isAimbotActive and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,50,50)
end)

ToggleImprovedButton.MouseButton1Click:Connect(function()
    isAimbotImproved = not isAimbotImproved
    ToggleImprovedButton.Text = "Modo Mejorado: " .. (isAimbotImproved and "ON" or "OFF")
    ToggleImprovedButton.TextColor3 = isAimbotImproved and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,50,50)
end)

ToggleWeaponModButton.MouseButton1Click:Connect(function()
    isWeaponModActive = not isWeaponModActive
    ToggleWeaponModButton.Text = "Armas Mod: " .. (isWeaponModActive and "ON" or "OFF")
    ToggleWeaponModButton.TextColor3 = isWeaponModActive and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,50,50)
end)

ToggleCameraButton.MouseButton1Click:Connect(function()
    isFirstPerson = not isFirstPerson
    updateCameraMode()
    ToggleCameraButton.Text = "Vista: " .. (isFirstPerson and "Primera" or "Tercera")
    ToggleCameraButton.TextColor3 = isFirstPerson and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,50,50)
end)

ResetConfigButton.MouseButton1Click:Connect(function()
    resetConfig()
end)

ToggleESPButton.MouseButton1Click:Connect(function()
    isESPActive = not isESPActive
    ToggleESPButton.Text = "ESP: " .. (isESPActive and "ON" or "OFF")
    ToggleESPButton.TextColor3 = isESPActive and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,50,50)
    if not isESPActive then
        updateESP()
    end
end)

HideMenuButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = false
    ShowMenuButton.Visible = true
end)

ShowMenuButton.MouseButton1Click:Connect(function()
    MenuFrame.Visible = true
    ShowMenuButton.Visible = false
end)

------------------ LIMPIEZA FINAL ------------------
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
end)
