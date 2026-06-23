-- =============================================
-- MOBILE GRAPHICS OPTIMIZER PRO + NETWORK BOOST
-- Enhanced 2026 Edition - Graphics + Low Ping
-- =============================================

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

Lighting.Technology = Enum.Technology.Future

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Mobile Graphics Optimizer Pro",
   LoadingTitle = "Carregando Perfis Avançados...",
   LoadingSubtitle = "Máxima Fidelidade + Low Ping • 2026",
   ConfigurationSaving = { Enabled = true, Folder = "GraphicsOptimizerPro" },
   KeySystem = false
})

-- =============================================
-- FAST FLAGS - PING & PERFORMANCE (Integrado)
-- =============================================
local function applyFastFlags()
    local flags = {
        -- === REDE / PING / LATÊNCIA ===
        ["DFIntConnectionMTUSize"] = "900",
        ["DFIntRakNetResendBufferArrayLength"] = "128",
        ["DFIntRakNetResendRttMultiple"] = "1",
        ["DFIntRaknetBandwidthPingSendEveryXSeconds"] = "1",
        ["DFIntNetworkLatencyTolerance"] = "0",
        ["DFIntNetworkPrediction"] = "0",
        ["FFlagReducePacketLoss"] = "True",
        ["FFlagEnableFastGameJoin"] = "True",
        ["FFlagOptimizeNetwork"] = "True",
        ["FFlagOptimizeNetworkRouting"] = "True",
        ["FFlagOptimizeNetworkTransport"] = "True",
        ["FFlagOptimizeServerTickRate"] = "True",

        -- === REDUÇÃO DE INPUT LAG ===
        ["DFIntMaxFrameBufferSize"] = "4",
        ["FIntSmoothMouseSpringFrequencyTenths"] = "100",

        -- === FPS & PERFORMANCE ===
        ["DFIntTaskSchedulerTargetFps"] = "240",           -- Alto para desbloqueio externo
        ["DFIntDebugFRMQualityLevelOverride"] = "1",
        ["DFIntTextureQualityOverride"] = "0",

        -- === DESATIVAR TELEMETRIA (melhora estabilidade) ===
        ["FFlagDebugDisableTelemetryV2Event"] = "True",
        ["FFlagDebugDisableTelemetryV2Stat"] = "True",
        ["FFlagDebugDisableTelemetryEphemeralCounter"] = "True",
        ["FFlagDebugDisableTelemetryEphemeralStat"] = "True",
    }

    if setfflag then
        print("✅ Aplicando Fast Flags de Low Ping + Performance...")
        for k, v in pairs(flags) do
            setfflag(k, v)
        end
        Rayfield:Notify({
            Title = "Fast Flags Aplicadas",
            Content = "Otimizações de rede e FPS ativadas!\nReinicie o Roblox para efeito completo.",
            Duration = 5,
            Image = 4483362458,
        })
    else
        warn("❌ setfflag não disponível. Use Bloxstrap / Voidstrap / Executor com suporte.")
        Rayfield:Notify({
            Title = "Aviso",
            Content = "Fast Flags requer executor com setfflag ou bootstrapper (Bloxstrap/Voidstrap).",
            Duration = 6,
        })
    end
end

-- =============================================
-- QUALITY PROFILES (mesmo do anterior, mantido aprimorado)
-- =============================================
local QualitySettings = {
	["Low"] = { ... },          -- (mantido igual ao anterior)
	["Balanced"] = { ... },
	["RTX Ultra"] = { ... }
}

-- (Cole aqui as mesmas tabelas QualitySettings e funções applyProfile / applyPostProcessing do script anterior que eu te passei)

local CurrentProfile = "Balanced"
local AutoOptimize = true

-- =============================================
-- UI
-- =============================================
local MainTab = Window:CreateTab("Graphics Optimizer", 4483362458)

MainTab:CreateSection("Quality Profiles")
-- ... (Dropdown de profiles igual ao anterior)

MainTab:CreateSection("Network & Low Ping")

local FlagsToggle = MainTab:CreateToggle({
   Name = "Ativar Fast Flags (Low Ping + FPS)",
   CurrentValue = true,
   Callback = function(Value)
      if Value then
         applyFastFlags()
      end
   end,
})

MainTab:CreateButton({
   Name = "Aplicar Fast Flags Agora",
   Callback = function()
      applyFastFlags()
   end,
})

MainTab:CreateSection("FPS Unlock")
MainTab:CreateLabel("Para FPS acima de 60-120 use: Bloxstrap, Voidstrap ou rbxfpsunlocker + DFIntTaskSchedulerTargetFps alto.")

-- =============================================
-- Performance Monitor (mesmo do anterior)
-- =============================================
task.spawn(function()
	while true do
		task.wait(3)
		if AutoOptimize then
			local currentFPS = Workspace:GetRealPhysicsFPS() or 60
			-- lógica de downgrade/upgrade de perfil...
		end
	end
end)

-- =============================================
-- Inicialização
-- =============================================
applyProfile("Balanced")

-- Aplicar Fast Flags automaticamente se toggle estiver ligado
task.delay(1.5, function()
    if FlagsToggle.CurrentValue then
        applyFastFlags()
    end
end)

print("🚀 Mobile Graphics Optimizer Pro + Low Ping carregado!")
