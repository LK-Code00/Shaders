-- 📱 MOBILE FPS UNLOCK + INTERACTIVE TEMPLATE SELECTOR (Rayfield UI)
-- Touch-optimized for Delta, Trigon, Synapse on Android

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Device Detection
local function getDeviceInfo()
    local screenSize = workspace.CurrentCamera.ViewportSize
    local device = "Unknown Mobile"
    local recommended = "MEDIUM"
    
    if screenSize.Y <= 960 then
        device = "Low-End (540p)"
        recommended = "POTATO"
    elseif screenSize.Y <= 1280 then
        device = "Mid-Range (720p)"
        recommended = "MEDIUM"
    else
        device = "High-End (1080p+)"
        recommended = "MEDIUM"
    end
    
    return device, recommended
end

-- Graphics Templates
local templates = {
    {id = 1, name = "1️⃣ POTATO MODE", desc = "Gráficos minimalistas (120+ FPS)", quality = 1, visual = "████░", fpsTarget = "120+"},
    {id = 2, name = "2️⃣ LOW GRAPHICS", desc = "Básico mas funcional (100+ FPS)", quality = 2, visual = "█████░", fpsTarget = "100+"},
    {id = 3, name = "3️⃣ MEDIUM ⭐", desc = "Bom balanço (RECOMENDADO)", quality = 4, visual = "███████░", fpsTarget = "60-90"},
    {id = 4, name = "4️⃣ HIGH", desc = "Qualidade bonita (40-60 FPS)", quality = 7, visual = "█████████░", fpsTarget = "40-60"},
    {id = 5, name = "5️⃣ RTX ULTRA", desc = "Máximo visual (30-60 FPS)", quality = 10, visual = "██████████", fpsTarget = "30-60"}
}

local currentTemplate = 3

-- Apply Template
local function applyTemplate(id)
    local tpl = templates[id]
    if not tpl then return end
    
    currentTemplate = id
    
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel["Level0" .. tpl.quality] or Enum.QualityLevel.Level04
        UserSettings().GameSettings.GraphicsMode = Enum.GraphicsMode.Manual
    end)
    
    pcall(function()
        Lighting.GlobalShadows = (id >= 4)
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
    end)
    
    for _, v in ipairs(Workspace:GetDescendants()) do
        pcall(function()
            if v:IsA("BasePart") then
                v.CastShadow = false
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = (id >= 4)
            end
        end)
    end
    
    pcall(function()
        setfpscap(999)
    end)
    
    Rayfield:Notify({
        Title = "✅ Template Aplicado",
        Content = tpl.name .. "\nFPS Alvo: " .. tpl.fpsTarget,
        Duration = 4,
        Image = 4483362458
    })
end

-- Create Rayfield Window
local Window = Rayfield:CreateWindow({
    Name = "📱 Mobile FPS Unlock",
    LoadingTitle = "Carregando Interface Mobile...",
    LoadingSubtitle = "Otimizado para toque",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MobileFPSUnlock",
        FileName = "Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local MainTab = Window:CreateTab("Templates", 4483362458)
local StatusTab = Window:CreateTab("Status", 4483362458)

-- Device Info
local device, rec = getDeviceInfo()
MainTab:CreateSection("Dispositivo: " .. device .. " | Recomendado: " .. rec)

-- Template Buttons (Large & Touch Friendly)
for _, tpl in ipairs(templates) do
    MainTab:CreateButton({
        Name = tpl.name .. " - " .. tpl.desc,
        Callback = function()
            applyTemplate(tpl.id)
        end
    })
end

MainTab:CreateButton({
    Name = "🤖 AUTO SELECT (Smart)",
    Callback = function()
        if device:find("Low") then
            applyTemplate(1)
        else
            applyTemplate(3)
        end
    end
})

-- FPS Counter (Live)
local fpsLabel = StatusTab:CreateLabel("FPS: Calculando...")

local fps = 0
local frameCount = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
    frameCount += 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frameCount
        frameCount = 0
        lastTime = now
        fpsLabel:Set("FPS: " .. fps .. " | Template Atual: " .. templates[currentTemplate].name)
    end
end)

-- Quick Actions
local ActionsTab = Window:CreateTab("Ações Rápidas", 4483362458)

ActionsTab:CreateButton({
    Name = "🔄 Reaplicar Template Atual",
    Callback = function()
        applyTemplate(currentTemplate)
    end
})

ActionsTab:CreateButton({
    Name = "✕ Fechar Interface",
    Callback = function()
        Rayfield:Destroy()
    end
})

-- Initial Apply
task.wait(0.8)
applyTemplate(3)

Rayfield:Notify({
    Title = "🎮 Mobile FPS Unlock",
    Content = "Interface carregada com sucesso!\nToque nos botões grandes para selecionar.",
    Duration = 6
})

print("✅ Rayfield Mobile FPS Unlocker carregado!")
