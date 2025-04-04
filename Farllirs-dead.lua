--[[
Script: Farllir dead - Versión Mobile & Modern v3
Funciones:
• Pantalla de carga moderna con animación fluida, icono centrado y barra de progreso estilizada
• Interfaz adaptativa para móviles con secciones organizadas y diseño moderno
• Optimización de rendimiento y corrección de errores
• Aimbot mejorado, ESP avanzado, Aura Kills, Weapon Mod, Auto Heal, Radar y Visor de FPS
• Transiciones suaves y efectos visuales mejorados
--]]

----------------------------------------------------------
-- UTILIDADES Y CONFIGURACIÓN
----------------------------------------------------------
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuración de colores (tema morado moderno)
local COLORS = {
    primary = Color3.fromRGB(100, 0, 150),       -- Morado principal
    secondary = Color3.fromRGB(180, 100, 255),   -- Morado claro
    background = Color3.fromRGB(30, 0, 50),      -- Fondo oscuro
    text = Color3.fromRGB(240, 220, 255),        -- Texto claro
    accent = Color3.fromRGB(255, 100, 255),      -- Acento rosa
    success = Color3.fromRGB(100, 255, 150),     -- Verde éxito
    warning = Color3.fromRGB(255, 200, 50),      -- Amarillo advertencia
    danger = Color3.fromRGB(255, 80, 120)        -- Rojo peligro
}

-- Funciones de utilidad
local function calcularDistancia(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function crearEfectoRipple(boton)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.7
    ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
    ripple.Size = UDim2.new(0, 0, 0, 0)
    
    local corner = Instance.new("UICorner", ripple)
    corner.CornerRadius = UDim.new(1, 0)
    
    ripple.Parent = boton
    
    local targetSize = UDim2.new(2, 0, 2, 0)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(ripple, tweenInfo, {Size = targetSize, BackgroundTransparency = 1})
    tween:Play()
    
    tween.Completed:Connect(function()
        ripple:Destroy()
    end)
end

----------------------------------------------------------
-- PANTALLA DE CARGA MEJORADA Y MODERNA
----------------------------------------------------------
local LoadingScreen = Instance.new("ScreenGui")
LoadingScreen.Name = "FarllirLoading"
LoadingScreen.ResetOnSpawn = false
LoadingScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
LoadingScreen.Parent = game.CoreGui

-- Fondo con gradiente
local background = Instance.new("Frame", LoadingScreen)
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = COLORS.background
background.BorderSizePixel = 0

local gradient = Instance.new("UIGradient", background)
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 0, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 0, 30))
})
gradient.Rotation = 45

-- Contenedor principal centrado
local loadingFrame = Instance.new("Frame", background)
loadingFrame.Size = UDim2.new(0.8, 0, 0.4, 0)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.BackgroundColor3 = COLORS.primary
loadingFrame.BackgroundTransparency = 0.7

-- Bordes redondeados
local loadingCorner = Instance.new("UICorner", loadingFrame)
loadingCorner.CornerRadius = UDim.new(0, 16)

-- Sombra
local shadow = Instance.new("ImageLabel", loadingFrame)
shadow.Size = UDim2.new(1, 40, 1, 40)
shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://6014261993"
shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(49, 49, 450, 450)
shadow.ZIndex = 0

-- Icono Farllir (usando un placeholder, reemplazar con el ID correcto)
local icon = Instance.new("ImageLabel", loadingFrame)
icon.Size = UDim2.new(0, 120, 0, 120)
icon.Position = UDim2.new(0.5, 0, 0.3, 0)
icon.AnchorPoint = Vector2.new(0.5, 0.5)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://123456789" -- Reemplazar con el ID correcto de farllir.png
icon.ZIndex = 2

-- Efecto de brillo alrededor del icono
local glow = Instance.new("ImageLabel", icon)
glow.Size = UDim2.new(1.5, 0, 1.5, 0)
glow.Position = UDim2.new(0.5, 0, 0.5, 0)
glow.AnchorPoint = Vector2.new(0.5, 0.5)
glow.BackgroundTransparency = 1
glow.Image = "rbxassetid://5028857084" -- Efecto de brillo circular
glow.ImageColor3 = COLORS.secondary
glow.ImageTransparency = 0.5
glow.ZIndex = 1

-- Animación de rotación para el brillo
spawn(function()
    local rotation = 0
    while LoadingScreen.Parent do
        rotation = (rotation + 1) % 360
        glow.Rotation = rotation
        wait(0.03)
    end
end)

-- Título con efecto de gradiente
local loadingTitle = Instance.new("TextLabel", loadingFrame)
loadingTitle.Size = UDim2.new(0.8, 0, 0, 50)
loadingTitle.Position = UDim2.new(0.5, 0, 0.55, 0)
loadingTitle.AnchorPoint = Vector2.new(0.5, 0.5)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "FARLLIR DEAD"
loadingTitle.TextColor3 = COLORS.text
loadingTitle.TextSize = 36
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.ZIndex = 2

local titleGradient = Instance.new("UIGradient", loadingTitle)
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.secondary),
    ColorSequenceKeypoint.new(0.5, COLORS.accent),
    ColorSequenceKeypoint.new(1, COLORS.secondary)
})

-- Animación del gradiente del título
spawn(function()
    local offset = 0
    while LoadingScreen.Parent do
        offset = (offset + 0.01) % 1
        titleGradient.Offset = Vector2.new(offset, 0)
        wait(0.03)
    end
end)

-- Subtítulo
local subtitle = Instance.new("TextLabel", loadingFrame)
subtitle.Size = UDim2.new(0.8, 0, 0, 24)
subtitle.Position = UDim2.new(0.5, 0, 0.65, 0)
subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Versión Mobile & Modern v3"
subtitle.TextColor3 = COLORS.text
subtitle.TextSize = 18
subtitle.Font = Enum.Font.Gotham
subtitle.TextTransparency = 0.2
subtitle.ZIndex = 2

-- Contenedor de la barra de progreso
local progressContainer = Instance.new("Frame", loadingFrame)
progressContainer.Size = UDim2.new(0.8, 0, 0, 12)
progressContainer.Position = UDim2.new(0.5, 0, 0.8, 0)
progressContainer.AnchorPoint = Vector2.new(0.5, 0.5)
progressContainer.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
progressContainer.BackgroundTransparency = 0.5
progressContainer.ZIndex = 2

local progressCorner = Instance.new("UICorner", progressContainer)
progressCorner.CornerRadius = UDim.new(1, 0)

-- Barra de progreso con efecto de brillo
local progressFill = Instance.new("Frame", progressContainer)
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = COLORS.secondary
progressFill.ZIndex = 3

local progressFillCorner = Instance.new("UICorner", progressFill)
progressFillCorner.CornerRadius = UDim.new(1, 0)

local progressGradient = Instance.new("UIGradient", progressFill)
progressGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.secondary),
    ColorSequenceKeypoint.new(0.5, COLORS.accent),
    ColorSequenceKeypoint.new(1, COLORS.secondary)
})
progressGradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 0.2)
})

-- Texto de porcentaje
local percentText = Instance.new("TextLabel", progressContainer)
percentText.Size = UDim2.new(1, 0, 1, 0)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = COLORS.text
percentText.TextSize = 14
percentText.Font = Enum.Font.GothamBold
percentText.ZIndex = 4

-- Animación de la barra de progreso
local loadTime = math.random(3, 5)
local startTime = tick()

spawn(function()
    local offset = 0
    while LoadingScreen.Parent do
        offset = (offset + 0.01) % 1
        progressGradient.Offset = Vector2.new(offset, 0)
        wait(0.03)
    end
end)

-- Simulación de carga con mensajes
local loadingMessages = {
    "Inicializando sistemas...",
    "Cargando recursos...",
    "Optimizando rendimiento...",
    "Preparando interfaz...",
    "Configurando aimbot...",
    "Activando ESP avanzado...",
    "Casi listo..."
}

local statusText = Instance.new("TextLabel", loadingFrame)
statusText.Size = UDim2.new(0.8, 0, 0, 20)
statusText.Position = UDim2.new(0.5, 0, 0.9, 0)
statusText.AnchorPoint = Vector2.new(0.5, 0.5)
statusText.BackgroundTransparency = 1
statusText.TextColor3 = COLORS.text
statusText.TextSize = 16
statusText.Font = Enum.Font.Gotham
statusText.TextTransparency = 0.2
statusText.Text = loadingMessages[1]
statusText.ZIndex = 2

-- Animación de carga
spawn(function()
    while tick() - startTime < loadTime do
        local progress = (tick() - startTime) / loadTime
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(progressFill, tweenInfo, {Size = UDim2.new(progress, 0, 1, 0)})
        tween:Play()
        
        percentText.Text = math.floor(progress * 100) .. "%"
        
        -- Actualizar mensaje de estado
        local messageIndex = math.ceil(progress * #loadingMessages)
        if messageIndex > 0 and messageIndex <= #loadingMessages then
            statusText.Text = loadingMessages[messageIndex]
        end
        
        wait(0.05)
    end
    
    -- Completar la barra al 100%
    local finalTween = TweenService:Create(progressFill, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 1, 0)})
    finalTween:Play()
    percentText.Text = "100%"
    statusText.Text = "¡Listo para usar!"
    
    -- Esperar un momento y luego desvanecer
    wait(0.8)
    
    -- Animación de desvanecimiento
    local fadeTween = TweenService:Create(background, TweenInfo.new(0.5), {BackgroundTransparency = 1})
    fadeTween:Play()
    
    for _, obj in pairs(LoadingScreen:GetDescendants()) do
        if obj:IsA("Frame") or obj:IsA("TextLabel") or obj:IsA("ImageLabel") then
            TweenService:Create(obj, TweenInfo.new(0.5), {BackgroundTransparency = 1, TextTransparency = 1, ImageTransparency = 1}):Play()
        end
    end
    
    wait(0.5)
    LoadingScreen:Destroy()
end)

----------------------------------------------------------
-- ELIMINAR SHADERS Y OPTIMIZAR RENDIMIENTO
----------------------------------------------------------
for _, effect in pairs(Lighting:GetChildren()) do
    if effect:IsA("BloomEffect") or effect:IsA("SunRaysEffect") or 
       effect:IsA("ColorCorrectionEffect") or effect:IsA("DepthOfFieldEffect") then
        effect:Destroy()
    end
end

-- Optimizar rendimiento
Lighting.FogStart = 0
Lighting.FogEnd = 1e6
Lighting.GlobalShadows = false
settings().Rendering.QualityLevel = 1

----------------------------------------------------------
-- VARIABLES Y CONFIGURACIÓN PRINCIPAL
----------------------------------------------------------
local CONFIG = {
    -- Aimbot
    aimbot = {
        active = false,
        improved = false,
        fov = 136,
        smoothness = 0.581,
        improvedSmoothness = 0.85,
        prediction = 0.02
    },
    
    -- ESP
    esp = {
        active = false,
        boxColor = COLORS.secondary,
        textColor = COLORS.text,
        textSize = 20,
        boxThickness = 2
    },
    
    -- Aura
    aura = {
        active = false,
        range = 50,
        color = COLORS.danger
    },
    
    -- Armas
    weapons = {
        modActive = true,
        damage = 100,
        cooldown = 0
    },
    
    -- Cámara
    camera = {
        firstPerson = false
    },
    
    -- Extras
    autoHeal = false,
    showFPS = true
}

-- Variables de estado
local validNPCs = {}
local espDrawings = {}
local radarActive = true

----------------------------------------------------------
-- DIBUJOS Y ELEMENTOS VISUALES
----------------------------------------------------------
-- FOV Circle para Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = CONFIG.aimbot.active
FOVCircle.Thickness = 2
FOVCircle.Color = COLORS.primary
FOVCircle.Filled = false
FOVCircle.Radius = CONFIG.aimbot.fov
FOVCircle.Position = Camera.ViewportSize / 2
FOVCircle.NumSides = 60

-- Aura Circle
local auraDrawing = Drawing.new("Circle")
auraDrawing.Visible = CONFIG.aura.active
auraDrawing.Thickness = 2
auraDrawing.Color = CONFIG.aura.color
auraDrawing.Filled = false
auraDrawing.Transparency = 0.7
auraDrawing.Radius = CONFIG.aura.range
auraDrawing.Position = Camera.ViewportSize / 2
auraDrawing.NumSides = 60

-- FPS Counter
local fpsText = Drawing.new("Text")
fpsText.Visible = CONFIG.showFPS
fpsText.Size = 20
fpsText.Color = COLORS.text
fpsText.Position = Vector2.new(10, Camera.ViewportSize.Y - 30)
fpsText.Font = Drawing.Fonts.Plex
fpsText.Outline = true
fpsText.OutlineColor = Color3.new(0, 0, 0)

-- Parámetros para Raycast
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

----------------------------------------------------------
-- MENÚ PRINCIPAL MODERNO Y ADAPTATIVO
----------------------------------------------------------
local MenuGui = Instance.new("ScreenGui")
MenuGui.Name = "FarllirMenu"
MenuGui.ResetOnSpawn = false
MenuGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MenuGui.Parent = game.CoreGui

-- Contenedor principal
local MenuFrame = Instance.new("Frame", MenuGui)
MenuFrame.Size = UDim2.new(0, 350, 0, 500)
MenuFrame.Position = UDim2.new(0.5, -175, 0.1, 0)
MenuFrame.BackgroundColor3 = COLORS.background
MenuFrame.BackgroundTransparency = 0.1
MenuFrame.BorderSizePixel = 0
MenuFrame.ClipsDescendants = true

-- Efecto de sombra
local menuShadow = Instance.new("ImageLabel", MenuFrame)
menuShadow.Size = UDim2.new(1, 40, 1, 40)
menuShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
menuShadow.AnchorPoint = Vector2.new(0.5, 0.5)
menuShadow.BackgroundTransparency = 1
menuShadow.Image = "rbxassetid://6014261993"
menuShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
menuShadow.ImageTransparency = 0.5
menuShadow.ScaleType = Enum.ScaleType.Slice
menuShadow.SliceCenter = Rect.new(49, 49, 450, 450)
menuShadow.ZIndex = 0

-- Bordes redondeados
local UICorner = Instance.new("UICorner", MenuFrame)
UICorner.CornerRadius = UDim.new(0, 12)

-- Barra superior con título
local titleBar = Instance.new("Frame", MenuFrame)
titleBar.Size = UDim2.new(1, 0, 0, 50)
titleBar.BackgroundColor3 = COLORS.primary
titleBar.BackgroundTransparency = 0.2
titleBar.BorderSizePixel = 0

local titleBarCorner = Instance.new("UICorner", titleBar)
titleBarCorner.CornerRadius = UDim.new(0, 12)

-- Corrección para que solo se redondeen las esquinas superiores
local titleBarFix = Instance.new("Frame", titleBar)
titleBarFix.Size = UDim2.new(1, 0, 0.5, 0)
titleBarFix.Position = UDim2.new(0, 0, 0.5, 0)
titleBarFix.BackgroundColor3 = COLORS.primary
titleBarFix.BackgroundTransparency = 0.2
titleBarFix.BorderSizePixel = 0

-- Título del menú con gradiente
local TitleLabel = Instance.new("TextLabel", titleBar)
TitleLabel.Size = UDim2.new(1, -20, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "FARLLIR MENU"
TitleLabel.TextColor3 = COLORS.text
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 24
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local titleGradient = Instance.new("UIGradient", TitleLabel)
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, COLORS.text),
    ColorSequenceKeypoint.new(1, COLORS.secondary)
})

-- Contenedor para las pestañas
local tabContainer = Instance.new("Frame", MenuFrame)
tabContainer.Size = UDim2.new(1, 0, 0, 40)
tabContainer.Position = UDim2.new(0, 0, 0, 50)
tabContainer.BackgroundColor3 = COLORS.primary
tabContainer.BackgroundTransparency = 0.5
tabContainer.BorderSizePixel = 0

-- Layout horizontal para las pestañas
local tabLayout = Instance.new("UIListLayout", tabContainer)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabLayout.Padding = UDim.new(0, 5)

-- Función para crear pestañas
local function crearPestaña(nombre)
    local tab = Instance.new("TextButton", tabContainer)
    tab.Size = UDim2.new(0.23, 0, 0.8, 0)
    tab.BackgroundColor3 = COLORS.primary
    tab.BackgroundTransparency = 0.7
    tab.Text = nombre
    tab.TextColor3 = COLORS.text
    tab.Font = Enum.Font.GothamSemibold
    tab.TextSize = 14
    tab.Name = nombre
    
    local tabCorner = Instance.new("UICorner", tab)
    tabCorner.CornerRadius = UDim.new(0, 8)
    
    return tab
end

-- Crear pestañas
local mainTab = crearPestaña("Main")
local aimbotTab = crearPestaña("Aimbot")
local espTab = crearPestaña("ESP")
local extrasTab = crearPestaña("Extras")

-- Contenedor para el contenido de las pestañas
local contentContainer = Instance.new("Frame", MenuFrame)
contentContainer.Size = UDim2.new(1, -20, 1, -100)
contentContainer.Position = UDim2.new(0, 10, 0, 90)
contentContainer.BackgroundTransparency = 1
contentContainer.ClipsDescendants = true

-- Crear páginas para cada pestaña
local pages = {}

for _, tabName in ipairs({"Main", "Aimbot", "ESP", "Extras"}) do
    local page = Instance.new("ScrollingFrame", contentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = COLORS.secondary
    page.Visible = tabName == "Main" -- Solo la primera página visible por defecto
    page.Name = tabName .. "Page"
    
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.FillDirection = Enum.FillDirection.Vertical
    pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    pageLayout.Padding = UDim.new(0, 10)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    
    pages[tabName] = page
end

-- Función para cambiar de pestaña
local function cambiarPestaña(nombrePestaña)
    for nombre, pagina in pairs(pages) do
        pagina.Visible = (nombre == nombrePestaña)
    end
    
    -- Actualizar apariencia de las pestañas
    for _, tab in ipairs(tabContainer:GetChildren()) do
        if tab:IsA("TextButton") then
            if tab.Name == nombrePestaña then
                tab.BackgroundTransparency = 0.3
                tab.TextSize = 16
            else
                tab.BackgroundTransparency = 0.7
                tab.TextSize = 14
            end
        end
    end
end

-- Conectar eventos de las pestañas
mainTab.MouseButton1Click:Connect(function()
    cambiarPestaña("Main")
    crearEfectoRipple(mainTab)
end)

aimbotTab.MouseButton1Click:Connect(function()
    cambiarPestaña("Aimbot")
    crearEfectoRipple(aimbotTab)
end)

espTab.MouseButton1Click:Connect(function()
    cambiarPestaña("ESP")
    crearEfectoRipple(espTab)
end)

extrasTab.MouseButton1Click:Connect(function()
    cambiarPestaña("Extras")
    crearEfectoRipple(extrasTab)
end)

-- Función para crear secciones en las páginas
local function crearSeccion(titulo, pagina, orden)
    local seccion = Instance.new("Frame", pagina)
    seccion.Size = UDim2.new(1, 0, 0, 30)
    seccion.BackgroundTransparency = 1
    seccion.LayoutOrder = orden
    
    local label = Instance.new("TextLabel", seccion)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = titulo
    label.TextColor3 = COLORS.secondary
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    return seccion
end

-- Función para crear botones modernos
local function crearBoton(texto, pagina, orden, callback)
    local boton = Instance.new("TextButton", pagina)
    boton.Size = UDim2.new(1, 0, 0, 45)
    boton.BackgroundColor3 = COLORS.primary
    boton.BackgroundTransparency = 0.5
    boton.Text = texto
    boton.TextColor3 = COLORS.text
    boton.Font = Enum.Font.GothamSemibold
    boton.TextSize = 16
    boton.ClipsDescendants = true
    boton.LayoutOrder = orden
    
    local corner = Instance.new("UICorner", boton)
    corner.CornerRadius = UDim.new(0, 8)
    
    -- Icono de estado (círculo)
    local statusIcon = Instance.new("Frame", boton)
    statusIcon.Size = UDim2.new(0, 12, 0, 12)
    statusIcon.Position = UDim2.new(0, 15, 0.5, 0)
    statusIcon.AnchorPoint = Vector2.new(0, 0.5)
    statusIcon.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    statusIcon.Name = "StatusIcon"
    
    local statusCorner = Instance.new("UICorner", statusIcon)
    statusCorner.CornerRadius = UDim.new(1, 0)
    
    -- Texto centrado
    local textLabel = Instance.new("TextLabel", boton)
    textLabel.Size = UDim2.new(1, -60, 1, 0)
    textLabel.Position = UDim2.new(0, 40, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = texto
    textLabel.TextColor3 = COLORS.text
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = 16
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    boton.MouseButton1Click:Connect(function()
        crearEfectoRipple(boton)
        if callback then callback() end
    end)
    
    return boton, statusIcon
end

-- Función para crear sliders
local function crearSlider(texto, pagina, orden, valorMin, valorMax, valorInicial, callback)
    local container = Instance.new("Frame", pagina)
    container.Size  valorInicial, callback)
    local container = Instance.new("Frame", pagina)
    container.Size = UDim2.new(1, 0, 0, 70)
    container.BackgroundTransparency = 1
    container.LayoutOrder = orden
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = texto
    label.TextColor3 = COLORS.text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valueLabel = Instance.new("TextLabel", container)
    valueLabel.Size = UDim2.new(0, 50, 0, 25)
    valueLabel.Position = UDim2.new(1, -50, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(valorInicial)
    valueLabel.TextColor3 = COLORS.secondary
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    
    local sliderBack = Instance.new("Frame", container)
    sliderBack.Size = UDim2.new(1, 0, 0, 10)
    sliderBack.Position = UDim2.new(0, 0, 0, 35)
    sliderBack.BackgroundColor3 = COLORS.primary
    sliderBack.BackgroundTransparency = 0.7
    
    local sliderBackCorner = Instance.new("UICorner", sliderBack)
    sliderBackCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderFill = Instance.new("Frame", sliderBack)
    sliderFill.Size = UDim2.new((valorInicial - valorMin) / (valorMax - valorMin), 0, 1, 0)
    sliderFill.BackgroundColor3 = COLORS.secondary
    
    local sliderFillCorner = Instance.new("UICorner", sliderFill)
    sliderFillCorner.CornerRadius = UDim.new(1, 0)
    
    local sliderButton = Instance.new("TextButton", container)
    sliderButton.Size = UDim2.new(1, 0, 0, 20)
    sliderButton.Position = UDim2.new(0, 0, 0, 30)
    sliderButton.BackgroundTransparency = 1
    sliderButton.Text = ""
    
    local isDragging = false
    
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    
    sliderButton.MouseMoved:Connect(function(x)
        if isDragging then
            local relativeX = math.clamp((x - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor(valorMin + (relativeX * (valorMax - valorMin)))
            
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            valueLabel.Text = tostring(value)
            
            if callback then
                callback(value)
            end
        end
    end)
    
    return container, valueLabel
end

-- Función para crear interruptores (switches)
local function crearSwitch(texto, pagina, orden, valorInicial, callback)
    local container = Instance.new("Frame", pagina)
    container.Size = UDim2.new(1, 0, 0, 45)
    container.BackgroundColor3 = COLORS.primary
    container.BackgroundTransparency = 0.5
    container.LayoutOrder = orden
    
    local corner = Instance.new("UICorner", container)
    corner.CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = texto
    label.TextColor3 = COLORS.text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local switchBack = Instance.new("Frame", container)
    switchBack.Size = UDim2.new(0, 44, 0, 24)
    switchBack.Position = UDim2.new(1, -55, 0.5, 0)
    switchBack.AnchorPoint = Vector2.new(0, 0.5)
    switchBack.BackgroundColor3 = valorInicial and COLORS.secondary or Color3.fromRGB(80, 80, 80)
    
    local switchCorner = Instance.new("UICorner", switchBack)
    switchCorner.CornerRadius = UDim.new(1, 0)
    
    local switchKnob = Instance.new("Frame", switchBack)
    switchKnob.Size = UDim2.new(0, 20, 0, 20)
    switchKnob.Position = UDim2.new(valorInicial and 1 or 0, valorInicial and -22 or 2, 0.5, 0)
    switchKnob.AnchorPoint = Vector2.new(0, 0.5)
    switchKnob.BackgroundColor3 = COLORS.text
    
    local knobCorner = Instance.new("UICorner", switchKnob)
    knobCorner.CornerRadius = UDim.new(1, 0)
    
    local button = Instance.new("TextButton", container)
    button.Size = UDim2.new(1, 0, 1, 0)
    button.BackgroundTransparency = 1
    button.Text = ""
    
    local isOn = valorInicial
    
    button.MouseButton1Click:Connect(function()
        isOn = not isOn
        
        local targetPos = isOn and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        local targetColor = isOn and COLORS.secondary or Color3.fromRGB(80, 80, 80)
        
        TweenService:Create(switchKnob, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(switchBack, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        
        if callback then
            callback(isOn)
        end
    end)
    
    return container, switchBack, switchKnob
end

----------------------------------------------------------
-- CREAR ELEMENTOS DE LA INTERFAZ
----------------------------------------------------------

-- Página Main
crearSeccion("Configuración General", pages["Main"], 1)

local toggleCameraBtn, toggleCameraStatus = crearBoton("Vista en Primera Persona", pages["Main"], 2, function()
    CONFIG.camera.firstPerson = not CONFIG.camera.firstPerson
    toggleCameraStatus.BackgroundColor3 = CONFIG.camera.firstPerson and COLORS.success or COLORS.danger
    
    -- Actualizar cámara
    if CONFIG.camera.firstPerson then
        LocalPlayer.CameraMinZoomDistance = 0
        LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    else
        LocalPlayer.CameraMinZoomDistance = 10
        LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end
end)
toggleCameraStatus.BackgroundColor3 = CONFIG.camera.firstPerson and COLORS.success or COLORS.danger

local resetConfigBtn = crearBoton("Reiniciar Configuración", pages["Main"], 3, function()
    -- Reiniciar todas las configuraciones
    CONFIG.aimbot.active = false
    CONFIG.aimbot.improved = false
    CONFIG.esp.active = false
    CONFIG.aura.active = false
    CONFIG.weapons.modActive = true
    CONFIG.camera.firstPerson = false
    CONFIG.autoHeal = false
    CONFIG.showFPS = true
    
    -- Actualizar interfaz
    cambiarPestaña("Main")
    
    -- Actualizar visuales
    FOVCircle.Visible = false
    auraDrawing.Visible = false
    fpsText.Visible = true
    
    -- Actualizar cámara
    LocalPlayer.CameraMinZoomDistance = 10
    LocalPlayer.CameraMode = Enum.CameraMode.Classic
    
    -- Limpiar ESP
    for npc, drawing in pairs(espDrawings) do
        drawing.circle:Remove()
        drawing.text:Remove()
    end
    espDrawings = {}
    
    -- Notificación
    mostrarNotificacion("Configuración reiniciada", COLORS.success)
end)

crearSeccion("Radar", pages["Main"], 4)

-- Radar de NPCs
local radarFrame = Instance.new("Frame", pages["Main"])
radarFrame.Size = UDim2.new(1, 0, 0, 150)
radarFrame.BackgroundColor3 = COLORS.primary
radarFrame.BackgroundTransparency = 0.7
radarFrame.LayoutOrder = 5

local radarCorner = Instance.new("UICorner", radarFrame)
radarCorner.CornerRadius = UDim.new(0, 8)

local radarTitle = Instance.new("TextLabel", radarFrame)
radarTitle.Size = UDim2.new(1, 0, 0, 30)
radarTitle.BackgroundTransparency = 1
radarTitle.Text = "Radar de NPCs"
radarTitle.TextColor3 = COLORS.text
radarTitle.Font = Enum.Font.GothamBold
radarTitle.TextSize = 16

local radarContent = Instance.new("ScrollingFrame", radarFrame)
radarContent.Size = UDim2.new(1, -20, 1, -40)
radarContent.Position = UDim2.new(0, 10, 0, 30)
radarContent.BackgroundTransparency = 1
radarContent.BorderSizePixel = 0
radarContent.ScrollBarThickness = 4
radarContent.ScrollBarImageColor3 = COLORS.secondary

local radarLayout = Instance.new("UIListLayout", radarContent)
radarLayout.FillDirection = Enum.FillDirection.Vertical
radarLayout.Padding = UDim.new(0, 5)

-- Página Aimbot
crearSeccion("Configuración de Aimbot", pages["Aimbot"], 1)

local toggleAimbotSwitch, aimbotBack, aimbotKnob = crearSwitch("Activar Aimbot", pages["Aimbot"], 2, CONFIG.aimbot.active, function(estado)
    CONFIG.aimbot.active = estado
    FOVCircle.Visible = estado
    mostrarNotificacion("Aimbot " .. (estado and "activado" or "desactivado"), estado and COLORS.success or COLORS.danger)
end)

local toggleImprovedSwitch, improvedBack, improvedKnob = crearSwitch("Modo Mejorado", pages["Aimbot"], 3, CONFIG.aimbot.improved, function(estado)
    CONFIG.aimbot.improved = estado
    mostrarNotificacion("Modo mejorado " .. (estado and "activado" or "desactivado"), COLORS.secondary)
end)

local fovSlider, fovValue = crearSlider("Radio FOV", pages["Aimbot"], 4, 50, 300, CONFIG.aimbot.fov, function(valor)
    CONFIG.aimbot.fov = valor
    FOVCircle.Radius = valor
end)

local smoothnessSlider, smoothnessValue = crearSlider("Suavidad", pages["Aimbot"], 5, 1, 100, math.floor(CONFIG.aimbot.smoothness * 100), function(valor)
    CONFIG.aimbot.smoothness = valor / 100
end)

-- Página ESP
crearSeccion("Configuración de ESP", pages["ESP"], 1)

local toggleESPSwitch, espBack, espKnob = crearSwitch("Activar ESP", pages["ESP"], 2, CONFIG.esp.active, function(estado)
    CONFIG.esp.active = estado
    
    if not estado then
        for npc, drawing in pairs(espDrawings) do
            drawing.circle:Remove()
            drawing.text:Remove()
        end
        espDrawings = {}
    end
    
    mostrarNotificacion("ESP " .. (estado and "activado" or "desactivado"), estado and COLORS.success or COLORS.danger)
end)

-- Página Extras
crearSeccion("Funciones Adicionales", pages["Extras"], 1)

local toggleWeaponModSwitch, weaponBack, weaponKnob = crearSwitch("Modificar Armas", pages["Extras"], 2, CONFIG.weapons.modActive, function(estado)
    CONFIG.weapons.modActive = estado
    mostrarNotificacion("Mod de armas " .. (estado and "activado" or "desactivado"), estado and COLORS.success or COLORS.danger)
end)

local toggleAuraSwitch, auraBack, auraKnob = crearSwitch("Aura Kills", pages["Extras"], 3, CONFIG.aura.active, function(estado)
    CONFIG.aura.active = estado
    auraDrawing.Visible = estado
    mostrarNotificacion("Aura Kills " .. (estado and "activado" or "desactivado"), estado and COLORS.success or COLORS.danger)
end)

local auraRangeSlider, auraRangeValue = crearSlider("Rango de Aura", pages["Extras"], 4, 10, 100, CONFIG.aura.range, function(valor)
    CONFIG.aura.range = valor
    auraDrawing.Radius = valor
end)

local toggleAutoHealSwitch, autoHealBack, autoHealKnob = crearSwitch("Auto Heal", pages["Extras"], 5, CONFIG.autoHeal, function(estado)
    CONFIG.autoHeal = estado
    mostrarNotificacion("Auto Heal " .. (estado and "activado" or "desactivado"), estado and COLORS.success or COLORS.danger)
end)

local toggleFPSSwitch, fpsBack, fpsKnob = crearSwitch("Mostrar FPS", pages["Extras"], 6, CONFIG.showFPS, function(estado)
    CONFIG.showFPS = estado
    fpsText.Visible = estado
end)

-- Botón flotante para mostrar/ocultar menú
local toggleButton = Instance.new("ImageButton", MenuGui)
toggleButton.Size = UDim2.new(0, 50, 0, 50)
toggleButton.Position = UDim2.new(0, 20, 0.5, 0)
toggleButton.AnchorPoint = Vector2.new(0, 0.5)
toggleButton.BackgroundColor3 = COLORS.primary
toggleButton.BackgroundTransparency = 0.2
toggleButton.Image = "rbxassetid://7733715400" -- Icono de menú
toggleButton.ImageColor3 = COLORS.text
toggleButton.ImageTransparency = 0.1

local toggleCorner = Instance.new("UICorner", toggleButton)
toggleCorner.CornerRadius = UDim.new(1, 0)

local toggleShadow = Instance.new("ImageLabel", toggleButton)
toggleShadow.Size = UDim2.new(1, 20, 1, 20)
toggleShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
toggleShadow.AnchorPoint = Vector2.new(0.5, 0.5)
toggleShadow.BackgroundTransparency = 1
toggleShadow.Image = "rbxassetid://6014261993"
toggleShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
toggleShadow.ImageTransparency = 0.5
toggleShadow.ScaleType = Enum.ScaleType.Slice
toggleShadow.SliceCenter = Rect.new(49, 49, 450, 450)
toggleShadow.ZIndex = 0

local menuVisible = true
toggleButton.MouseButton1Click:Connect(function()
    menuVisible = not menuVisible
    
    local targetPos = menuVisible and UDim2.new(0.5, -175, 0.1, 0) or UDim2.new(-0.5, 0, 0.1, 0)
    TweenService:Create(MenuFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    
    crearEfectoRipple(toggleButton)
end)

-- Sistema de notificaciones
local notificationsFrame = Instance.new("Frame", MenuGui)
notificationsFrame.Size = UDim2.new(0, 300, 1, 0)
notificationsFrame.Position = UDim2.new(1, -320, 0, 0)
notificationsFrame.BackgroundTransparency = 1

local notificationsLayout = Instance.new("UIListLayout", notificationsFrame)
notificationsLayout.FillDirection = Enum.FillDirection.Vertical
notificationsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
notificationsLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notificationsLayout.Padding = UDim.new(0, 10)
notificationsLayout.SortOrder = Enum.SortOrder.LayoutOrder

function mostrarNotificacion(mensaje, color)
    local notif = Instance.new("Frame", notificationsFrame)
    notif.Size = UDim2.new(0, 280, 0, 60)
    notif.BackgroundColor3 = COLORS.background
    notif.BackgroundTransparency = 0.2
    notif.Position = UDim2.new(0, 0, 0, -60)
    
    local notifCorner = Instance.new("UICorner", notif)
    notifCorner.CornerRadius = UDim.new(0, 8)
    
    local colorBar = Instance.new("Frame", notif)
    colorBar.Size = UDim2.new(0, 5, 1, 0)
    colorBar.BackgroundColor3 = color or COLORS.secondary
    
    local colorCorner = Instance.new("UICorner", colorBar)
    colorCorner.CornerRadius = UDim.new(0, 8)
    
    local fixCorner = Instance.new("Frame", colorBar)
    fixCorner.Size = UDim2.new(0.5, 0, 1, 0)
    fixCorner.Position = UDim2.new(0.5, 0, 0, 0)
    fixCorner.BackgroundColor3 = color or COLORS.secondary
    fixCorner.BorderSizePixel = 0
    
    local icon = Instance.new("ImageLabel", notif)
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0, 15, 0.5, 0)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://7733658504" -- Icono de info
    icon.ImageColor3 = color or COLORS.secondary
    
    local text = Instance.new("TextLabel", notif)
    text.Size = UDim2.new(1, -60, 1, 0)
    text.Position = UDim2.new(0, 50, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = mensaje
    text.TextColor3 = COLORS.text
    text.Font = Enum.Font.GothamSemibold
    text.TextSize = 16
    text.TextWrapped = true
    text.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Animación de entrada
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    
    -- Temporizador para eliminar la notificación
    spawn(function()
        wait(3)
        TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 0, 0, 0), Transparency = 1}):Play()
        wait(0.3)
        notif:Destroy()
    end)
end

----------------------------------------------------------
-- FUNCIONES PRINCIPALES
----------------------------------------------------------
-- Función para verificar si un NPC es válido
local function isValidNPC(model)
    if not model or not model:IsA("Model") then return false end
    
    local humanoid = model:FindFirstChild("Humanoid")
    local head = model:FindFirstChild("Head")
    local hrp = model:FindFirstChild("HumanoidRootPart")
    
    return humanoid and humanoid.Health > 0 and head and hrp and not Players:GetPlayerFromCharacter(model)
end

-- Actualizar lista de NPCs
local function updateNPCList()
    local npcSet = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if isValidNPC(obj) then
            npcSet[obj] = true
        end
    end
    
    -- Eliminar NPCs que ya no son válidos
    for i = #validNPCs, 1, -1 do
        if not npcSet[validNPCs[i]] then
            table.remove(validNPCs, i)
        end
    end
    
    -- Agregar nuevos NPCs
    for npc in pairs(npcSet) do
        if not table.find(validNPCs, npc) then
            table.insert(validNPCs, npc)
        end
    end
end

-- Monitorear nuevos NPCs
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

-- Actualizar elementos visuales
local function updateDrawing()
    FOVCircle.Position = Camera.ViewportSize / 2
    FOVCircle.Radius = CONFIG.aimbot.fov * (Camera.ViewportSize.Y / 1080)
    auraDrawing.Position = Camera.ViewportSize / 2
end

-- Predecir posición de un objetivo
local function predictPosition(target)
    local hrp = target:FindFirstChild("HumanoidRootPart")
    local head = target:FindFirstChild("Head")
    
    if not hrp then
        return head and head.Position or nil
    end
    
    local predictionTime = CONFIG.aimbot.prediction
    local predicted = hrp.Position + hrp.Velocity * predictionTime
    local offset = head and (head.Position - hrp.Position) or Vector3.new(0, 0, 0)
    
    return predicted + offset
end

-- Obtener el objetivo más cercano
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
                    
                    if dist < minDist and dist < CONFIG.aimbot.fov then
                        minDist = dist
                        closestTarget = npc
                    end
                end
            end
        end
    end
    
    return closestTarget
end

-- Apuntar a un objetivo
local function aimAt(targetPos)
    local currentCF = Camera.CFrame
    local dir = (targetPos - currentCF.Position).Unit
    local smooth = CONFIG.aimbot.improved and CONFIG.aimbot.improvedSmoothness or CONFIG.aimbot.smoothness
    local newLook = currentCF.LookVector:Lerp(dir, smooth)
    
    Camera.CFrame = CFrame.new(currentCF.Position, currentCF.Position + newLook)
end

-- Actualizar ESP
local function updateESP()
    -- Limpiar ESP para NPCs que ya no existen
    for npc, drawing in pairs(espDrawings) do
        if not npc or not npc.Parent then
            drawing.circle:Remove()
            drawing.text:Remove()
            espDrawings[npc] = nil
        end
    end
    
    if CONFIG.esp.active then
        for _, npc in ipairs(validNPCs) do
            if npc and npc.Parent then
                local head = npc:FindFirstChild("Head")
                
                if head then
                    -- Crear dibujos si no existen
                    if not espDrawings[npc] then
                        espDrawings[npc] = {
                            circle = Drawing.new("Circle"),
                            text = Drawing.new("Text")
                        }
                        
                        espDrawings[npc].circle.Thickness = CONFIG.esp.boxThickness
                        espDrawings[npc].circle.Color = CONFIG.esp.boxColor
                        espDrawings[npc].circle.Filled = false
                        espDrawings[npc].circle.NumSides = 20
                        
                        espDrawings[npc].text.Size = CONFIG.esp.textSize
                        espDrawings[npc].text.Color = CONFIG.esp.textColor
                        espDrawings[npc].text.Font = Drawing.Fonts.Plex
                        espDrawings[npc].text.Outline = true
                        espDrawings[npc].text.OutlineColor = Color3.new(0, 0, 0)
                    end
                    
                    -- Actualizar posición
                    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                    
                    if onScreen then
                        espDrawings[npc].circle.Visible = true
                        espDrawings[npc].text.Visible = true
                        
                        espDrawings[npc].circle.Position = Vector2.new(screenPos.X, screenPos.Y)
                        espDrawings[npc].circle.Radius = 30 / (screenPos.Z * 0.1)
                        
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
        -- Desactivar todos los ESP
        for npc, drawing in pairs(espDrawings) do
            drawing.circle.Visible = false
            drawing.text.Visible = false
        end
    end
end

-- Actualizar Aura Kills
local function updateAura()
    if CONFIG.aura.active then
        auraDrawing.Visible = true
        
        local playerHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if playerHRP then
            for _, npc in ipairs(validNPCs) do
                if npc and npc.Parent then
                    local hrp = npc:FindFirstChild("HumanoidRootPart")
                    local humanoid = npc:FindFirstChild("Humanoid")
                    
                    if hrp and humanoid and calcularDistancia(hrp.Position, playerHRP.Position) <= CONFIG.aura.range then
                        humanoid.Health = 0
                    end
                end
            end
        end
    else
        auraDrawing.Visible = false
    end
end

-- Actualizar contador de FPS
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

-- Auto Heal
local function autoHeal()
    if CONFIG.autoHeal and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = LocalPlayer.Character.Humanoid
        
        if humanoid.Health < 50 then
            humanoid.Health = humanoid.MaxHealth
        end
    end
end

-- Actualizar Radar
local function updateRadar()
    -- Limpiar radar
    for _, child in pairs(radarContent:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Ordenar NPCs por distancia
    local npcsWithDistance = {}
    local playerPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
    
    if playerPos then
        for _, npc in ipairs(validNPCs) do
            if npc and npc.Parent then
                local head = npc:FindFirstChild("Head")
                
                if head then
                    local dist = calcularDistancia(head.Position, playerPos)
                    
                    if dist < 200 then
                        table.insert(npcsWithDistance, {
                            npc = npc,
                            distance = dist
                        })
                    end
                end
            end
        end
        
        -- Ordenar por distancia
        table.sort(npcsWithDistance, function(a, b)
            return a.distance < b.distance
        end)
        
        -- Crear elementos del radar
        for i, data in ipairs(npcsWithDistance) do
            local npc = data.npc
            local dist = math.floor(data.distance)
            
            local radarItem = Instance.new("Frame", radarContent)
            radarItem.Size = UDim2.new(1, 0, 0, 25)
            radarItem.BackgroundTransparency = 0.8
            radarItem.BackgroundColor3 = COLORS.primary
            
            local itemCorner = Instance.new("UICorner", radarItem)
            itemCorner.CornerRadius = UDim.new(0, 4)
            
            local nameLabel = Instance.new("TextLabel", radarItem)
            nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = npc.Name
            nameLabel.TextColor3 = COLORS.text
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextSize = 14
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Position = UDim2.new(0, 10, 0, 0)
            
            local distLabel = Instance.new("TextLabel", radarItem)
            distLabel.Size = UDim2.new(0.3, -10, 1, 0)
            distLabel.Position = UDim2.new(0.7, 0, 0, 0)
            distLabel.BackgroundTransparency = 1
            distLabel.Text = dist .. "m"
            distLabel.TextColor3 = COLORS.secondary
            distLabel.Font = Enum.Font.GothamBold
            distLabel.TextSize = 14
            distLabel.TextXAlignment = Enum.TextXAlignment.Right
        end
    end
    
    -- Mostrar mensaje si no hay NPCs cercanos
    if #radarContent:GetChildren() <= 1 then
        local emptyLabel = Instance.new("TextLabel", radarContent)
        emptyLabel.Size = UDim2.new(1, 0, 0, 30)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "Ningún NPC cercano"
        emptyLabel.TextColor3 = COLORS.text
        emptyLabel.Font = Enum.Font.Gotham
        emptyLabel.TextSize = 14
    end
end

-- Modificar armas
local function modifyWeapon(weapon)
    if CONFIG.weapons.modActive then
        if weapon:FindFirstChild("Cooldown") then
            weapon.Cooldown.Value = CONFIG.weapons.cooldown
        end
        
        if weapon:FindFirstChild("Damage") then
            weapon.Damage.Value = CONFIG.weapons.damage
        end
    end
end

local function updateWeapons()
    if CONFIG.weapons.modActive then
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
end

-- Monitorear armas nuevas
LocalPlayer.Backpack.ChildAdded:Connect(function(child)
    if child:IsA("Tool") and CONFIG.weapons.modActive then
        modifyWeapon(child)
    end
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") and CONFIG.weapons.modActive then
            modifyWeapon(child)
        end
    end)
end

----------------------------------------------------------
-- BUCLE PRINCIPAL
----------------------------------------------------------
local accumulatedTime = 0
local UPDATE_INTERVAL = 0.4

RunService.Heartbeat:Connect(function(dt)
    -- Actualizaciones en cada frame
    updateDrawing()
    updateFPS()
    autoHeal()
    
    -- Acumular tiempo para actualizaciones menos frecuentes
    accumulatedTime = accumulatedTime + dt
    
    if accumulatedTime >= UPDATE_INTERVAL then
        updateNPCList()
        updateRadar()
        updateWeapons()
        accumulatedTime = 0
    end
    
    -- Aimbot
    if CONFIG.aimbot.active then
        local target = getNearestTarget()
        
        if target then
            local predicted = predictPosition(target)
            
            if predicted then
                aimAt(predicted)
            end
        end
    end
    
    -- ESP
    if CONFIG.esp.active then
        updateESP()
    end
    
    -- Aura Kills
    if CONFIG.aura.active then
        updateAura()
    end
end)

----------------------------------------------------------
-- LIMPIEZA Y MANEJO DE EVENTOS
----------------------------------------------------------
Workspace.DescendantRemoved:Connect(function(descendant)
    if table.find(validNPCs, descendant) then
        for i = #validNPCs, 1, -1 do
            if validNPCs[i] == descendant then
                table.remove(validNPCs, i)
                break
            end
        end
    end
end)

-- Limpiar al salir
local function limpiarRecursos()
    FOVCircle:Remove()
    auraDrawing:Remove()
    fpsText:Remove()
    
    for npc, drawing in pairs(espDrawings) do
        drawing.circle:Remove()
        drawing.text:Remove()
    end
    
    MenuGui:Destroy()
end

Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        limpiarRecursos()
    end
end)

-- Mostrar notificación inicial
mostrarNotificacion("Farllir dead v3 cargado correctamente", COLORS.success)
