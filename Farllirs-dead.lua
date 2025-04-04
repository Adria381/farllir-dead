--[[
Script: Farllir dead - Versión Mobile & Modern v3
Mejoras visuales:
• Pantalla de carga con animación suave, gradientes y transiciones
• Interfaz con tema oscuro moderno y acentos de color púrpura
• Iconos mejorados y efectos visuales para botones
• Mejor organización visual de secciones
• Indicadores de estado más claros
--]]

----------------------------------------------------------
-- UTILIDADES
----------------------------------------------------------
local function calcularDistancia(pos1, pos2)
	return (pos1 - pos2).Magnitude
end

local function crearGradiente(parent, colorTop, colorBottom)
    local gradient = Instance.new("UIGradient", parent)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, colorTop),
        ColorSequenceKeypoint.new(1, colorBottom)
    })
    gradient.Rotation = 90
    return gradient
end

----------------------------------------------------------
-- PANTALLA DE CARGA MEJORADA (MODERNA Y ANIMADA)
----------------------------------------------------------
local LoadingScreen = Instance.new("ScreenGui")
LoadingScreen.Name = "LoadingScreen"
LoadingScreen.ResetOnSpawn = false
LoadingScreen.Parent = game.CoreGui

local loadingFrame = Instance.new("Frame", LoadingScreen)
loadingFrame.Size = UDim2.new(0.5, 0, 0.4, 0)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
loadingFrame.BackgroundTransparency = 0.1
loadingFrame.BorderSizePixel = 0
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)

-- Agregar UICorner para redondear bordes
local loadingCorner = Instance.new("UICorner", loadingFrame)
loadingCorner.CornerRadius = UDim.new(0, 15)

-- Agregar gradiente al fondo
crearGradiente(loadingFrame, Color3.fromRGB(40, 10, 60), Color3.fromRGB(15, 5, 30))

-- Borde brillante
local glowBorder = Instance.new("Frame", loadingFrame)
glowBorder.Size = UDim2.new(1, 6, 1, 6)
glowBorder.Position = UDim2.new(0.5, 0, 0.5, 0)
glowBorder.AnchorPoint = Vector2.new(0.5, 0.5)
glowBorder.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
glowBorder.BackgroundTransparency = 0.7
glowBorder.BorderSizePixel = 0
glowBorder.ZIndex = 0

local glowCorner = Instance.new("UICorner", glowBorder)
glowCorner.CornerRadius = UDim.new(0, 18)

-- Icono Farllir con contenedor
local iconContainer = Instance.new("Frame", loadingFrame)
iconContainer.Size = UDim2.new(0, 100, 0, 100)
iconContainer.Position = UDim2.new(0.5, 0, 0.3, 0)
iconContainer.AnchorPoint = Vector2.new(0.5, 0.5)
iconContainer.BackgroundColor3 = Color3.fromRGB(30, 10, 50)
iconContainer.BackgroundTransparency = 0.2
iconContainer.BorderSizePixel = 0

local iconContainerCorner = Instance.new("UICorner", iconContainer)
iconContainerCorner.CornerRadius = UDim.new(1, 0)

local icon = Instance.new("ImageLabel", iconContainer)
icon.Size = UDim2.new(0.8, 0, 0.8, 0)
icon.Position = UDim2.new(0.5, 0, 0.5, 0)
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.BackgroundTransparency = 1
-- Cambia el siguiente AssetId o URL por el de tu farllir.png
icon.Image = "rbxassetid://123456789"

-- Efecto de brillo alrededor del icono
local iconGlow = Instance.new("ImageLabel", iconContainer)
iconGlow.Size = UDim2.new(1.2, 0, 1.2, 0)
iconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
iconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
iconGlow.BackgroundTransparency = 1
iconGlow.Image = "rbxassetid://4695575676" -- Efecto de brillo circular
iconGlow.ImageColor3 = Color3.fromRGB(180, 100, 255)
iconGlow.ImageTransparency = 0.6
iconGlow.ZIndex = 0

-- Texto de carga con estilo moderno
local loadingText = Instance.new("TextLabel", loadingFrame)
loadingText.Size = UDim2.new(0.8, 0, 0, 50)
loadingText.Position = UDim2.new(0.5, 0, 0.55, 0)
loadingText.AnchorPoint = Vector2.new(0.5, 0.5)
loadingText.BackgroundTransparency = 1
loadingText.Text = "FARLLIR DEAD"
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 28

-- Subtítulo
local subtitleText = Instance.new("TextLabel", loadingFrame)
subtitleText.Size = UDim2.new(0.8, 0, 0, 30)
subtitleText.Position = UDim2.new(0.5, 0, 0.65, 0)
subtitleText.AnchorPoint = Vector2.new(0.5, 0.5)
subtitleText.BackgroundTransparency = 1
subtitleText.Text = "VERSIÓN MOBILE & MODERN v3"
subtitleText.TextColor3 = Color3.fromRGB(180, 100, 255)
subtitleText.Font = Enum.Font.Gotham
subtitleText.TextSize = 16

-- Barra de progreso moderna
local progressBarContainer = Instance.new("Frame", loadingFrame)
progressBarContainer.Size = UDim2.new(0.8, 0, 0, 10)
progressBarContainer.Position = UDim2.new(0.5, 0, 0.8, 0)
progressBarContainer.AnchorPoint = Vector2.new(0.5, 0.5)
progressBarContainer.BackgroundColor3 = Color3.fromRGB(40, 10, 60)
progressBarContainer.BorderSizePixel = 0

local progressBarCorner = Instance.new("UICorner", progressBarContainer)
progressBarCorner.CornerRadius = UDim.new(0, 5)

local progressFill = Instance.new("Frame", progressBarContainer)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
progressFill.BorderSizePixel = 0

local progressFillCorner = Instance.new("UICorner", progressFill)
progressFillCorner.CornerRadius = UDim.new(0, 5)

-- Gradiente para la barra de progreso
crearGradiente(progressFill, Color3.fromRGB(200, 120, 255), Color3.fromRGB(140, 60, 210))

-- Texto de estado de carga
local statusText = Instance.new("TextLabel", loadingFrame)
statusText.Size = UDim2.new(0.8, 0, 0, 20)
statusText.Position = UDim2.new(0.5, 0, 0.9, 0)
statusText.AnchorPoint = Vector2.new(0.5, 0.5)
statusText.BackgroundTransparency = 1
statusText.Text = "Inicializando..."
statusText.TextColor3 = Color3.fromRGB(200, 200, 200)
statusText.Font = Enum.Font.Gotham
statusText.TextSize = 14

-- Animación de carga mejorada
local loadTime = math.random(2, 5)
local startTime = tick()
local statusMessages = {
    "Inicializando...",
    "Cargando recursos...",
    "Configurando interfaz...",
    "Preparando funciones...",
    "Casi listo..."
}

spawn(function()
    local msgIndex = 1
    while tick() - startTime < loadTime do
        local progress = (tick() - startTime) / loadTime
        progressFill.Size = UDim2.new(progress, 0, 1, 0)
        
        -- Actualizar mensaje de estado cada 20%
        local newMsgIndex = math.floor(progress * 5) + 1
        if newMsgIndex ~= msgIndex and newMsgIndex <= #statusMessages then
            msgIndex = newMsgIndex
            statusText.Text = statusMessages[msgIndex]
        end
        
        -- Efecto de pulso en el icono
        local pulse = (math.sin(tick() * 4) * 0.05) + 1
        iconGlow.Size = UDim2.new(1.2 * pulse, 0, 1.2 * pulse, 0)
        
        wait(0.03)
    end
    
    -- Animación de desvanecimiento al finalizar
    for i = 0, 1, 0.05 do
        loadingFrame.BackgroundTransparency = i
        glowBorder.BackgroundTransparency = 0.7 + (i * 0.3)
        progressBarContainer.BackgroundTransparency = i
        progressFill.BackgroundTransparency = i
        loadingText.TextTransparency = i
        subtitleText.TextTransparency = i
        statusText.TextTransparency = i
        iconContainer.BackgroundTransparency = 0.2 + (i * 0.8)
        icon.ImageTransparency = i
        iconGlow.ImageTransparency = 0.6 + (i * 0.4)
        wait(0.01)
    end
    
    LoadingScreen:Destroy()
end)

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
local TweenService = game:GetService("TweenService")

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
local isRadarActive = true
local isFPSVisible = true

----------------------------------------------------------
-- VISOR DE FPS
----------------------------------------------------------
local fpsText = Drawing.new("Text")
fpsText.Visible = true
fpsText.Size = 20
fpsText.Color = Color3.fromRGB(180, 100, 255)
fpsText.Position = Vector2.new(10, Camera.ViewportSize.Y - 30)
fpsText.Font = Drawing.Fonts.Plex
fpsText.Outline = true
fpsText.OutlineColor = Color3.fromRGB(20, 20, 30)

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
FOVCircle.Color = Color3.fromRGB(180, 100, 255)
FOVCircle.Filled = false
FOVCircle.Radius = FOV_RADIUS
FOVCircle.Position = Camera.ViewportSize / 2
FOVCircle.NumSides = 48 -- Más lados para un círculo más suave

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
MenuFrame.BackgroundColor3 = Color3.fromRGB(25, 10, 40)
MenuFrame.BackgroundTransparency = 0.1
MenuFrame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", MenuFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Agregar gradiente al menú
crearGradiente(MenuFrame, Color3.fromRGB(40, 15, 60), Color3.fromRGB(20, 5, 35))

-- Borde brillante para el menú
local menuGlow = Instance.new("Frame", MenuFrame)
menuGlow.Size = UDim2.new(1, 6, 1, 6)
menuGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
menuGlow.AnchorPoint = Vector2.new(0.5, 0.5)
menuGlow.BackgroundColor3 = Color3.fromRGB(180, 100, 255)
menuGlow.BackgroundTransparency = 0.8
menuGlow.BorderSizePixel = 0
menuGlow.ZIndex = 0

local menuGlowCorner = Instance.new("UICorner", menuGlow)
menuGlowCorner.CornerRadius = UDim.new(0, 15)

-- Layout para secciones
local UIList = Instance.new("UIListLayout", MenuFrame)
UIList.FillDirection = Enum.FillDirection.Vertical
UIList.Padding = UDim.new(0, 12)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Título del menú con icono
local TitleContainer = Instance.new("Frame", MenuFrame)
TitleContainer.Size = UDim2.new(1, -20, 0, 60)
TitleContainer.BackgroundTransparency = 1

local TitleIcon = Instance.new("ImageLabel", TitleContainer)
TitleIcon.Size = UDim2.new(0, 40, 0, 40)
TitleIcon.Position = UDim2.new(0, 10, 0.5, 0)
TitleIcon.AnchorPoint = Vector2.new(0, 0.5)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Image = "rbxassetid://123456789" -- Mismo icono que en la pantalla de carga
TitleIcon.ImageColor3 = Color3.fromRGB(180, 100, 255)

local TitleLabel = Instance.new("TextLabel", TitleContainer)
TitleLabel.Size = UDim2.new(1, -70, 1, 0)
TitleLabel.Position = UDim2.new(0, 60, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "FARLLIR MENU"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 24
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Función para crear secciones con estilo moderno
local function crearSeccion(titulo, icono)
	local seccion = Instance.new("Frame", MenuFrame)
	seccion.Size = UDim2.new(1, -20, 0, 50)
	seccion.BackgroundColor3 = Color3.fromRGB(50, 20, 80)
	seccion.BackgroundTransparency = 0.7
    
    local seccionCorner = Instance.new("UICorner", seccion)
    seccionCorner.CornerRadius = UDim.new(0, 8)
    
    local iconLabel = Instance.new("ImageLabel", seccion)
    iconLabel.Size = UDim2.new(0, 24, 0, 24)
    iconLabel.Position = UDim2.new(0, 15, 0.5, 0)
    iconLabel.AnchorPoint = Vector2.new(0, 0.5)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Image = icono
    iconLabel.ImageColor3 = Color3.fromRGB(180, 100, 255)
	
	local label = Instance.new("TextLabel", seccion)
	label.Size = UDim2.new(1, -50, 1, 0)
	label.Position = UDim2.new(0, 50, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = titulo
	label.TextColor3 = Color3.fromRGB(240, 200, 255)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	
	return seccion
end

-- Secciones principales con iconos
local mainSeccion = crearSeccion("MAIN", "rbxassetid://7733715400") -- Icono de engranaje
local espSeccion = crearSeccion("ESP", "rbxassetid://7733774602") -- Icono de ojo
local aimbotSeccion = crearSeccion("AIMBOT", "rbxassetid://7734053495") -- Icono de objetivo
local extrasSeccion = crearSeccion("EXTRAS", "rbxassetid://7734068649") -- Icono de más opciones

-- Botones agrupados en un contenedor (usando UIListLayout) para cada sección
local function crearContenedor(parent)
	local contenedor = Instance.new("Frame", parent)
	contenedor.Size = UDim2.new(1, 0, 0, 0) -- Altura automática
	contenedor.AutomaticSize = Enum.AutomaticSize.Y
	contenedor.BackgroundTransparency = 1
	
	local layout = Instance.new("UIListLayout", contenedor)
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 8)
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	
	return contenedor
end

local mainCont = crearContenedor(mainSeccion)
local espCont = crearContenedor(espSeccion)
local aimbotCont = crearContenedor(aimbotSeccion)
local extrasCont = crearContenedor(extrasSeccion)

-- Función para crear botones modernos con indicador de estado
local function crearBoton(texto, parent, icono)
	local boton = Instance.new("TextButton", parent)
	boton.Size = UDim2.new(1, -20, 0, 45)
	boton.BackgroundColor3 = Color3.fromRGB(60, 30, 90)
	boton.BackgroundTransparency = 0.3
	boton.Text = ""
	boton.AutoButtonColor = false
	
	local corner = Instance.new("UICorner", boton)
	corner.CornerRadius = UDim.new(0, 8)
	
	local iconLabel = Instance.new("ImageLabel", boton)
	iconLabel.Size = UDim2.new(0, 20, 0, 20)
	iconLabel.Position = UDim2.new(0, 15, 0.5, 0)
	iconLabel.AnchorPoint = Vector2.new(0, 0.5)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Image = icono or "rbxassetid://7734110748" -- Icono predeterminado
	iconLabel.ImageColor3 = Color3.fromRGB(200, 150, 255)
	
	local textLabel = Instance.new("TextLabel", boton)
	textLabel.Size = UDim2.new(1, -100, 1, 0)
	textLabel.Position = UDim2.new(0, 45, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = texto
	textLabel.TextColor3 = Color3.fromRGB(240, 200, 255)
	textLabel.Font = Enum.Font.GothamSemibold
	textLabel.TextSize = 16
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	
	-- Indicador de estado (círculo)
	local statusIndicator = Instance.new("Frame", boton)
	statusIndicator.Size = UDim2.new(0, 16, 0, 16)
	statusIndicator.Position = UDim2.new(1, -25, 0.5, 0)
	statusIndicator.AnchorPoint = Vector2.new(0.5, 0.5)
	statusIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris por defecto
	statusIndicator.BorderSizePixel = 0
	
	local statusCorner = Instance.new("UICorner", statusIndicator)
	statusCorner.CornerRadius = UDim.new(1, 0)
	
	-- Efecto hover
	boton.MouseEnter:Connect(function()
		TweenService:Create(boton, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
	end)
	
	boton.MouseLeave:Connect(function()
		TweenService:Create(boton, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
	end)
	
	-- Efecto click
	boton.MouseButton1Down:Connect(function()
		TweenService:Create(boton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 40, 120)}):Play()
	end)
	
	boton.MouseButton1Up:Connect(function()
		TweenService:Create(boton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 30, 90)}):Play()
	end)
	
	return boton, statusIndicator
end

-- Botones en sección Main con iconos específicos
local ToggleCameraButton, cameraStatus = crearBoton("Toggle Vista (3ª Persona)", mainCont, "rbxassetid://7743878358")
local ResetConfigButton = crearBoton("Reiniciar Config", mainCont, "rbxassetid://7743872936")

-- Botones en sección ESP
local ToggleESPButton, espStatus = crearBoton("Toggle ESP", espCont, "rbxassetid://7733774602")
local ToggleRadarButton, radarStatus = crearBoton("Toggle Radar", espCont, "rbxassetid://7743866242")

-- Botones en sección Aimbot
local ToggleAimbotButton, aimbotStatus = crearBoton("Toggle Aimbot", aimbotCont, "rbxassetid://7734053495")
local ToggleImprovedButton, improvedStatus = crearBoton("Toggle Modo Mejorado", aimbotCont, "rbxassetid://7743875093")

-- Botones en sección Extras
local ToggleWeaponModButton, weaponStatus = crearBoton("Toggle Armas Mod", extrasCont, "rbxassetid://7743870085")
local ToggleAuraButton, auraStatus = crearBoton("Toggle Aura Kills", extrasCont, "rbxassetid://7743877687")
local ToggleAutoHealButton, healStatus = crearBoton("Toggle Auto Heal", extrasCont, "rbxassetid://7743871898")
local ToggleFPSButton, fpsStatus = crearBoton("Toggle FPS Visor", extrasCont, "rbxassetid://7743873964")

-- Actualizar estados iniciales
cameraStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
espStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
radarStatus.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Verde (ON)
aimbotStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
improvedStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
weaponStatus.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Verde (ON)
auraStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
healStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
fpsStatus.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Verde (ON)

-- Botón para ocultar/mostrar menú (flotante, con estilo moderno)
local HideMenuButton = Instance.new("TextButton", MenuGui)
HideMenuButton.Size = UDim2.new(0, 140, 0, 45)
HideMenuButton.Position = UDim2.new(0.5, -70, 0.9, 0)
HideMenuButton.BackgroundColor3 = Color3.fromRGB(60, 20, 90)
HideMenuButton.BackgroundTransparency = 0.2
HideMenuButton.Text = ""
HideMenuButton.AutoButtonColor = false

local hideButtonCorner = Instance.new("UICorner", HideMenuButton)
hideButtonCorner.CornerRadius = UDim.new(0, 22)

-- Gradiente para el botón
crearGradiente(HideMenuButton, Color3.fromRGB(80, 30, 120), Color3.fromRGB(50, 15, 80))

-- Icono para el botón
local hideButtonIcon = Instance.new("ImageLabel", HideMenuButton)
hideButtonIcon.Size = UDim2.new(0, 20, 0, 20)
hideButtonIcon.Position = UDim2.new(0, 15, 0.5, 0)
hideButtonIcon.AnchorPoint = Vector2.new(0, 0.5)
hideButtonIcon.BackgroundTransparency = 1
hideButtonIcon.Image = "rbxassetid://7734111908" -- Icono de menú
hideButtonIcon.ImageColor3 = Color3.fromRGB(240, 200, 255)

local hideButtonText = Instance.new("TextLabel", HideMenuButton)
hideButtonText.Size = UDim2.new(1, -45, 1, 0)
hideButtonText.Position = UDim2.new(0, 45, 0, 0)
hideButtonText.BackgroundTransparency = 1
hideButtonText.Text = "Ocultar Menu"
hideButtonText.TextColor3 = Color3.fromRGB(240, 200, 255)
hideButtonText.Font = Enum.Font.GothamSemibold
hideButtonText.TextSize = 16
hideButtonText.TextXAlignment = Enum.TextXAlignment.Left

-- Efecto hover para el botón de ocultar
HideMenuButton.MouseEnter:Connect(function()
	TweenService:Create(HideMenuButton, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)

HideMenuButton.MouseLeave:Connect(function()
	TweenService:Create(HideMenuButton, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
end)

-- Efecto click para el botón de ocultar
HideMenuButton.MouseButton1Down:Connect(function()
	TweenService:Create(HideMenuButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 40, 120)}):Play()
end)

HideMenuButton.MouseButton1Up:Connect(function()
	TweenService:Create(HideMenuButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 20, 90)}):Play()
en  TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 20, 90)}):Play()
end)

HideMenuButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
	if MenuFrame.Visible then
		hideButtonText.Text = "Ocultar Menu"
		hideButtonIcon.Image = "rbxassetid://7734111908" -- Icono de menú
	else
		hideButtonText.Text = "Mostrar Menu"
		hideButtonIcon.Image = "rbxassetid://7734110748" -- Icono de mostrar
	end
end)

----------------------------------------------------------
-- DRAG DEL MENÚ (adaptable para móvil con animaciones)
----------------------------------------------------------
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
	if dragging then
		local delta = input.Position - dragStart
		local targetPosition = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		
		-- Animación suave al arrastrar
		TweenService:Create(MenuFrame, TweenInfo.new(0.1), {Position = targetPosition}):Play()
	end
end

MenuFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MenuFrame.Position
		
		-- Efecto visual al comenzar a arrastrar
		TweenService:Create(menuGlow, TweenInfo.new(0.2), {BackgroundTransparency = 0.6}):Play()
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				-- Restaurar efecto visual
				TweenService:Create(menuGlow, TweenInfo.new(0.2), {BackgroundTransparency = 0.8}):Play()
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
		updateDrag(input)
	end
end)

----------------------------------------------------------
-- RADAR DE NPCS MEJORADO
----------------------------------------------------------
local RadarFrame = Instance.new("Frame", MenuFrame)
RadarFrame.Size = UDim2.new(1, -40, 0, 120)
RadarFrame.BackgroundColor3 = Color3.fromRGB(30, 10, 50)
RadarFrame.BackgroundTransparency = 0.3
RadarFrame.BorderSizePixel = 0

local radarCorner = Instance.new("UICorner", RadarFrame)
radarCorner.CornerRadius = UDim.new(0, 8)

local radarTitle = Instance.new("TextLabel", RadarFrame)
radarTitle.Size = UDim2.new(1, 0, 0, 30)
radarTitle.BackgroundTransparency = 1
radarTitle.Text = "RADAR"
radarTitle.TextColor3 = Color3.fromRGB(180, 100, 255)
radarTitle.Font = Enum.Font.GothamBold
radarTitle.TextSize = 16

local radarContent = Instance.new("ScrollingFrame", RadarFrame)
radarContent.Size = UDim2.new(1, -10, 1, -35)
radarContent.Position = UDim2.new(0, 5, 0, 30)
radarContent.BackgroundTransparency = 1
radarContent.BorderSizePixel = 0
radarContent.ScrollBarThickness = 4
radarContent.ScrollBarImageColor3 = Color3.fromRGB(180, 100, 255)
radarContent.CanvasSize = UDim2.new(0, 0, 0, 0)
radarContent.AutomaticCanvasSize = Enum.AutomaticSize.Y

local radarList = Instance.new("UIListLayout", radarContent)
radarList.Padding = UDim.new(0, 5)

local function updateRadar()
    if not isRadarActive then
        RadarFrame.Visible = false
        return
    end
    
    RadarFrame.Visible = true
    
    -- Limpiar entradas anteriores
    for _, child in pairs(radarContent:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    local count = 0
    for _, npc in ipairs(validNPCs) do
        if npc and npc.Parent then
            local head = npc:FindFirstChild("Head")
            if head then
                local dist = math.floor(calcularDistancia(head.Position, Camera.CFrame.Position))
                if dist < 200 then
                    count = count + 1
                    
                    -- Crear entrada de radar
                    local entry = Instance.new("Frame", radarContent)
                    entry.Size = UDim2.new(1, 0, 0, 24)
                    entry.BackgroundColor3 = Color3.fromRGB(50, 20, 80)
                    entry.BackgroundTransparency = 0.7
                    
                    local entryCorner = Instance.new("UICorner", entry)
                    entryCorner.CornerRadius = UDim.new(0, 4)
                    
                    -- Indicador de distancia (color basado en cercanía)
                    local distColor
                    if dist < 50 then
                        distColor = Color3.fromRGB(255, 50, 50) -- Rojo (cercano)
                    elseif dist < 100 then
                        distColor = Color3.fromRGB(255, 200, 50) -- Amarillo (medio)
                    else
                        distColor = Color3.fromRGB(50, 200, 50) -- Verde (lejano)
                    end
                    
                    local distIndicator = Instance.new("Frame", entry)
                    distIndicator.Size = UDim2.new(0, 8, 0, 8)
                    distIndicator.Position = UDim2.new(0, 8, 0.5, 0)
                    distIndicator.AnchorPoint = Vector2.new(0, 0.5)
                    distIndicator.BackgroundColor3 = distColor
                    distIndicator.BorderSizePixel = 0
                    
                    local distCorner = Instance.new("UICorner", distIndicator)
                    distCorner.CornerRadius = UDim.new(1, 0)
                    
                    -- Nombre del NPC
                    local nameLabel = Instance.new("TextLabel", entry)
                    nameLabel.Size = UDim2.new(0.7, -20, 1, 0)
                    nameLabel.Position = UDim2.new(0, 20, 0, 0)
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.Text = npc.Name
                    nameLabel.TextColor3 = Color3.fromRGB(240, 200, 255)
                    nameLabel.Font = Enum.Font.Gotham
                    nameLabel.TextSize = 14
                    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                    
                    -- Distancia
                    local distLabel = Instance.new("TextLabel", entry)
                    distLabel.Size = UDim2.new(0.3, 0, 1, 0)
                    distLabel.Position = UDim2.new(0.7, 0, 0, 0)
                    distLabel.BackgroundTransparency = 1
                    distLabel.Text = dist .. " m"
                    distLabel.TextColor3 = distColor
                    distLabel.Font = Enum.Font.GothamSemibold
                    distLabel.TextSize = 14
                    distLabel.TextXAlignment = Enum.TextXAlignment.Right
                end
            end
        end
    end
    
    if count == 0 then
        local emptyLabel = Instance.new("TextLabel", radarContent)
        emptyLabel.Size = UDim2.new(1, 0, 0, 30)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "Ningún NPC cercano"
        emptyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 14
    end
end

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
						espDrawings[npc].circle.Color = Color3.fromRGB(180, 100, 255)
						espDrawings[npc].circle.Filled = false
						espDrawings[npc].circle.NumSides = 24
						espDrawings[npc].text.Size = 20
						espDrawings[npc].text.Color = Color3.fromRGB(240, 200, 255)
						espDrawings[npc].text.Font = Drawing.Fonts.Plex
						espDrawings[npc].text.Outline = true
						espDrawings[npc].text.OutlineColor = Color3.fromRGB(20, 20, 30)
					end
					local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
					if onScreen then
						espDrawings[npc].circle.Visible = true
						espDrawings[npc].text.Visible = true
						espDrawings[npc].circle.Position = Vector2.new(screenPos.X, screenPos.Y)
						espDrawings[npc].circle.Radius = 30
						local dist = math.floor(calcularDistancia(head.Position, Camera.CFrame.Position))
						espDrawings[npc].text.Position = Vector2.new(screenPos.X, screenPos.Y - 40)
						espDrawings[npc].text.Text = npc.Name .. " [" .. dist .. "m]"
					else
						espDrawings[npc].circle.Visible = false
						espDrawings[npc].text.Visible = false
					end
				end
			end
		end
	else
		for npc, drawing in pairs(espDrawings) do
			drawing.circle.Visible = false
			drawing.text.Visible = false
		end
	end
end

-- Aura Kills: Si un NPC entra en rango, fuerza su muerte
local auraDrawing = Drawing.new("Circle")
auraDrawing.Visible = false
auraDrawing.Thickness = 2
auraDrawing.Color = Color3.fromRGB(255, 50, 50)
auraDrawing.Filled = false
auraDrawing.Radius = auraRange
auraDrawing.Position = Camera.ViewportSize / 2
auraDrawing.NumSides = 48
auraDrawing.Transparency = 0.7

local function updateAura()
	if isAuraActive then
		auraDrawing.Visible = true
		auraDrawing.Position = Camera.ViewportSize / 2
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

-- FPS Counter con animación suave
local lastTime = tick()
local frameCount = 0
local smoothFPS = 60
local function updateFPS()
	frameCount = frameCount + 1
	local currentTime = tick()
	if currentTime - lastTime >= 0.5 then
		local instantFPS = frameCount / (currentTime - lastTime)
		smoothFPS = smoothFPS * 0.9 + instantFPS * 0.1 -- Suavizado
		fpsText.Text = "FPS: " .. math.floor(smoothFPS)
		frameCount = 0
		lastTime = currentTime
		
		-- Cambiar color según rendimiento
		if smoothFPS >= 50 then
			fpsText.Color = Color3.fromRGB(50, 200, 50) -- Verde (buen rendimiento)
		elseif smoothFPS >= 30 then
			fpsText.Color = Color3.fromRGB(255, 200, 50) -- Amarillo (rendimiento medio)
		else
			fpsText.Color = Color3.fromRGB(255, 50, 50) -- Rojo (mal rendimiento)
		end
	end
	
	fpsText.Visible = isFPSVisible
	fpsText.Position = Vector2.new(10, Camera.ViewportSize.Y - 30)
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
	isRadarActive = true
	isFPSVisible = true
	
	updateCameraMode()
	FOVCircle.Visible = false
	
	-- Actualizar indicadores visuales
	cameraStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
	espStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
	radarStatus.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Verde (ON)
	aimbotStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
	improvedStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
	weaponStatus.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Verde (ON)
	auraStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
	healStatus.BackgroundColor3 = Color3.fromRGB(100, 100, 100) -- Gris (OFF)
	fpsStatus.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Verde (ON)
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
	updateESP()
	updateAura()
	
	accumulatedTime = accumulatedTime + dt
	if accumulatedTime >= UPDATE_INTERVAL then
		updateRadar()
		updateNPCList()
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
end)

----------------------------------------------------------
-- FUNCIONALIDAD DE BOTONES
----------------------------------------------------------
ToggleCameraButton.MouseButton1Click:Connect(function()
	isFirstPerson = not isFirstPerson
	updateCameraMode()
	ToggleCameraButton.Children[3].Text = "Toggle Vista (" .. (isFirstPerson and "1ª" or "3ª") .. " Persona)"
	cameraStatus.BackgroundColor3 = isFirstPerson and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
end)

ResetConfigButton.MouseButton1Click:Connect(function()
	resetConfig()
end)

ToggleESPButton.MouseButton1Click:Connect(function()
	isESPActive = not isESPActive
	ToggleESPButton.Children[3].Text = "Toggle ESP"
	espStatus.BackgroundColor3 = isESPActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
end)

ToggleRadarButton.MouseButton1Click:Connect(function()
	isRadarActive = not isRadarActive
	ToggleRadarButton.Children[3].Text = "Toggle Radar"
	radarStatus.BackgroundColor3 = isRadarActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
	RadarFrame.Visible = isRadarActive
end)

ToggleAimbotButton.MouseButton1Click:Connect(function()
	isAimbotActive = not isAimbotActive
	FOVCircle.Visible = isAimbotActive
	ToggleAimbotButton.Children[3].Text = "Toggle Aimbot"
	aimbotStatus.BackgroundColor3 = isAimbotActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
end)

ToggleImprovedButton.MouseButton1Click:Connect(function()
	isAimbotImproved = not isAimbotImproved
	ToggleImprovedButton.Children[3].Text = "Toggle Modo Mejorado"
	improvedStatus.BackgroundColor3 = isAimbotImproved and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
end)

ToggleWeaponModButton.MouseButton1Click:Connect(function()
	isWeaponModActive = not isWeaponModActive
	ToggleWeaponModButton.Children[3].Text = "Toggle Armas Mod"
	weaponStatus.BackgroundColor3 = isWeaponModActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
end)

ToggleAuraButton.MouseButton1Click:Connect(function()
	isAuraActive = not isAuraActive
	ToggleAuraButton.Children[3].Text = "Toggle Aura Kills"
	auraStatus.BackgroundColor3 = isAuraActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
end)

ToggleAutoHealButton.MouseButton1Click:Connect(function()
	autoHealActive = not autoHealActive
	ToggleAutoHealButton.Children[3].Text = "Toggle Auto Heal"
	healStatus.BackgroundColor3 = autoHealActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
end)

ToggleFPSButton.MouseButton1Click:Connect(function()
	isFPSVisible = not isFPSVisible
	ToggleFPSButton.Children[3].Text = "Toggle FPS Visor"
	fpsStatus.BackgroundColor3 = isFPSVisible and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(100, 100, 100)
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
	auraDrawing:Remove()
	fpsText:Remove()
	for npc, drawing in pairs(espDrawings) do
		drawing.circle:Remove()
		drawing.text:Remove()
	end
	MenuGui:Destroy()
end)
