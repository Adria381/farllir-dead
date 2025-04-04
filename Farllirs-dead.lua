
------------------ PANTALLA DE CARGA MEJORADA ------------------
local LoadingScreen = Instance.new("ScreenGui")
local LoadingFrame = Instance.new("Frame")
local LoadingLabel = Instance.new("TextLabel")
local ProgressBar = Instance.new("Frame")
local ProgressFill = Instance.new("Frame")

LoadingScreen.Parent = game.CoreGui
LoadingScreen.Name = "LoadingScreen"

LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
LoadingFrame.BackgroundColor3 = Color3.new(0, 0, 0)
LoadingFrame.Parent = LoadingScreen

LoadingLabel.Size = UDim2.new(1, 0, 0, 50)
LoadingLabel.Position = UDim2.new(0, 0, 0.4, 0)
LoadingLabel.BackgroundTransparency = 1
LoadingLabel.Text = "Farllir dead"
LoadingLabel.TextColor3 = Color3.new(1, 1, 1)
LoadingLabel.TextScaled = true
LoadingLabel.Font = Enum.Font.GothamBold
LoadingLabel.Parent = LoadingScreen

ProgressBar.Size = UDim2.new(0.6, 0, 0, 20)
ProgressBar.Position = UDim2.new(0.2, 0, 0.5, 0)
ProgressBar.BackgroundColor3 = Color3.fromRGB(60, 0, 80)
ProgressBar.Parent = LoadingScreen

ProgressFill.Size = UDim2.new(0, 0, 1, 0)
ProgressFill.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
ProgressFill.Parent = ProgressBar

local loadTime = math.random(2, 5)
local startTime = tick()
while tick() - startTime < loadTime do
    local progress = (tick() - startTime) / loadTime
    ProgressFill.Size = UDim2.new(progress, 0, 1, 0)
    wait(0.03)
end
LoadingScreen:Destroy()

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
local isWeaponModActive = true   -- siempre activo
local isFirstPerson = false      -- false = tercera, true = primera
local isESPActive = false        -- para ESP avanzado
local isAuraActive = false       -- para Aura Kills
local auraRange = 50             -- rango del aura (studs)

-- Para el FPS Counter
local fpsText = Drawing.new("Text")
fpsText.Visible = true
fpsText.Size = 20
fpsText.Color = Color3.fromRGB(255, 255, 255)
fpsText.Position = Vector2.new(10, Camera.ViewportSize.Y - 30)
fpsText.Font = Drawing.Fonts.Plex

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

------------------ MENÚ EMERGENTE MINIMALISTA ------------------
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "FarllirMenu"
MenuGui.Parent = game.CoreGui

local MenuFrame = Instance.new("Frame")
MenuFrame.Size = UDim2.new(0, 320, 0, 420)
MenuFrame.Position = UDim2.new(0, 10, 0, 10)
MenuFrame.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
MenuFrame.BackgroundTransparency = 0.3
MenuFrame.BorderSizePixel = 0
MenuFrame.Parent = MenuGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(50, 20, 80)
TitleLabel.BackgroundTransparency = 0.2
TitleLabel.Text = "Farllir Menu"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextScaled = true
TitleLabel.Parent = MenuFrame

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

local function crearBoton(nombre, posY, textoInicial, parent)
    local boton = Instance.new("TextButton")
    boton.Size = UDim2.new(1, -20, 0, 30)
    boton.Position = UDim2.new(0, 10, 0, posY)
    boton.Text = textoInicial
    boton.BackgroundColor3 = Color3.fromRGB(50, 20, 80)
    boton.BackgroundTransparency = 0.3
    boton.TextColor3 = Color3.fromRGB(240, 200, 255)
    boton.Font = Enum.Font.GothamBold
    boton.TextScaled = true
    boton.Parent = parent
    return boton
end

-- Botones de funciones
local ToggleAimbotButton = crearBoton("AimbotToggle", 50, "AIMBOT: OFF", MenuFrame)
local ToggleImprovedButton = crearBoton("AimbotImproved", 90, "Modo Mejorado: OFF", MenuFrame)
local ToggleWeaponModButton = crearBoton("WeaponMod", 130, "Armas Mod: ON", MenuFrame)
local ToggleCameraButton = crearBoton("CameraToggle", 170, "Vista: Tercera", MenuFrame)
local ResetConfigButton = crearBoton("ResetConfig", 210, "Reiniciar Config", MenuFrame)
local ToggleESPButton = crearBoton("ToggleESP", 250, "ESP: OFF", MenuFrame)
local ToggleAuraButton = crearBoton("ToggleAura", 290, "Aura Kills: OFF", MenuFrame)
local ToggleRadarButton = crearBoton("ToggleRadar", 330, "Radar: OFF", MenuFrame)
local ToggleAutoHealButton = crearBoton("ToggleAutoHeal", 370, "Auto Heal: OFF", MenuFrame)

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

------------------ FUNCIONES DE NPC, AIMBOT Y ESP ------------------
local function isValidNPC(model)
    local humanoid = model:FindFirstChild("Humanoid")
    local head = model:FindFirstChild("Head")
    local humanoidRoot = model:FindFirstChild("HumanoidRootPart")
    return model:IsA("Model") and humanoid and humanoid.Health > 0 and head and humanoidRoot and not Players:GetPlayerFromCharacter(model)
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

-- ESP Avanzado: Dibuja un círculo y texto (nombre y distancia) sobre la cabeza de cada NPC
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
                        espDrawings[npc].circle.Color = Color3.fromRGB(240, 200, 255)
                        espDrawings[npc].circle.Filled = false
                        espDrawings[npc].text.Size = 20
                        espDrawings[npc].text.Color = Color3.fromRGB(240, 200, 255)
                        espDrawings[npc].text.Font = Drawing.Fonts.Plex
                    end
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        espDrawings[npc].circle.Visible = true
                        espDrawings[npc].text.Visible = true
                        espDrawings[npc].circle.Position = Vector2.new(screenPos.X, screenPos.Y)
                        espDrawings[npc].circle.Radius = 30
                        local distance = (head.Position - Camera.CFrame.Position).Magnitude
                        espDrawings[npc].text.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
                        espDrawings[npc].text.Text = npc.Name .. " [" .. math.floor(distance) .. "]"
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

-- Aura Kills: Dibuja un aura alrededor del jugador; si un NPC entra en el rango, se resalta y se le fuerza la muerte.
local auraDrawing = Drawing.new("Circle")
auraDrawing.Visible = false
auraDrawing.Thickness = 2
auraDrawing.Color = Color3.fromRGB(255, 0, 0)
auraDrawing.Filled = false
auraDrawing.Radius = auraRange
auraDrawing.Position = Camera.ViewportSize / 2

local function updateAura()
    if isAuraActive then
        auraDrawing.Visible = true
        local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)
        for _, npc in ipairs(validNPCs) do
            if npc and npc.Parent then
                local humanoid = npc:FindFirstChild("Humanoid")
                local npcPos = npc:FindFirstChild("HumanoidRootPart") and npc.HumanoidRootPart.Position
                if npcPos and humanoid and (npcPos - playerPos).Magnitude <= auraRange then
                    -- Resalta al NPC (podrías agregar más efectos)
                    humanoid.Health = 0  -- Fuerza la muerte del NPC
                end
            end
        end
    else
        auraDrawing.Visible = false
    end
end

-- FPS Counter: Se actualiza en cada heartbeat
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

-- Auto Heal: Si la salud baja de 50, la reestablece al máximo
local function autoHeal()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        if humanoid.Health < 50 then
            humanoid.Health = humanoid.MaxHealth
        end
    end
end

-- Radar de NPCs: Actualiza un listado en el menú de NPCs cercanos y su distancia.
local RadarLabel = Instance.new("TextLabel")
RadarLabel.Size = UDim2.new(1, -20, 0, 80)
RadarLabel.Position = UDim2.new(0, 10, 0, 410)
RadarLabel.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
RadarLabel.BackgroundTransparency = 0.5
RadarLabel.TextColor3 = Color3.fromRGB(240, 200, 255)
RadarLabel.Font = Enum.Font.Gotham
RadarLabel.TextScaled = true
RadarLabel.Text = "Radar: Ningún NPC cercano"
RadarLabel.Parent = MenuFrame

local function updateRadar()
    local radarText = ""
    for _, npc in ipairs(validNPCs) do
        if npc and npc.Parent then
            local head = npc:FindFirstChild("Head")
            if head then
                local distance = (head.Position - Camera.CFrame.Position).Magnitude
                if distance < 200 then  -- muestra solo NPC cercanos
                    radarText = radarText .. npc.Name .. " - " .. math.floor(distance) .. " studs\n"
                end
            end
        end
    end
    if radarText == "" then
        radarText = "Ningún NPC cercano"
    end
    RadarLabel.Text = "Radar:\n" .. radarText
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

------------------ NUEVA FUNCIÓN: Reset Config ------------------
local function resetConfig()
    isAimbotActive = false
    isAimbotImproved = false
    isWeaponModActive = true
    isFirstPerson = false
    isESPActive = false
    isAuraActive = false
    updateCameraMode()
    FOVCircle.Visible = false
    ToggleAimbotButton.Text = "AIMBOT: OFF"
    ToggleImprovedButton.Text = "Modo Mejorado: OFF"
    ToggleWeaponModButton.Text = "Armas Mod: ON"
    ToggleCameraButton.Text = "Vista: Tercera"
    ToggleESPButton.Text = "ESP: OFF"
    ToggleAuraButton.Text = "Aura Kills: OFF"
    ToggleRadarButton.Text = "Radar: OFF"
    ToggleAutoHealButton.Text = "Auto Heal: OFF"
end

------------------ BUCLE PRINCIPAL ------------------
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
            local predictedPosition = predictPosition(target)
            if predictedPosition then
                aimAt(predictedPosition)
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

ToggleAuraButton.MouseButton1Click:Connect(function()
    isAuraActive = not isAuraActive
    ToggleAuraButton.Text = "Aura Kills: " .. (isAuraActive and "ON" or "OFF")
    ToggleAuraButton.TextColor3 = isAuraActive and Color3.fromRGB(50,255,50) or Color3.fromRGB(255,50,50)
end)

ToggleRadarButton.MouseButton1Click:Connect(function()
    if RadarLabel.Visible == true then
        RadarLabel.Visible = false
        ToggleRadarButton.Text = "Radar: OFF"
    else
        RadarLabel.Visible = true
        ToggleRadarButton.Text = "Radar: ON"
    end
end)

ToggleAutoHealButton.MouseButton1Click:Connect(function()
    if ToggleAutoHealButton.Text:find("OFF") then
        ToggleAutoHealButton.Text = "Auto Heal: ON"
        ToggleAutoHealButton.TextColor3 = Color3.fromRGB(50,255,50)
    else
        ToggleAutoHealButton.Text = "Auto Heal: OFF"
        ToggleAutoHealButton.TextColor3 = Color3.fromRGB(255,50,50)
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
    fpsText:Remove()
end)
