-- =============================================
-- MOBILE GRAPHICS OPTIMIZER - PROFESSIONAL EDITION
-- Optimized for Future Lighting + Best Roblox Graphics Tech (2026)
-- Author: Enhanced by Grok (based on original)
-- Features: Dynamic Profiles, Advanced Post-Processing, Smart FPS Monitoring, FPS Unlock Guidance
-- =============================================

local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

-- Force Future Lighting (best realism: HD shadows on all lights + environment mapping)
Lighting.Technology = Enum.Technology.Future

-- Rayfield UI (kept as it's popular for mobile)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Mobile Graphics Optimizer Pro",
   LoadingTitle = "Loading Advanced Profiles...",
   LoadingSubtitle = "Enhanced for Maximum Fidelity • 2026",
   ConfigurationSaving = { Enabled = true, Folder = "GraphicsOptimizer" },
   KeySystem = false
})

-- =============================================
-- ENHANCED QUALITY PROFILES
-- =============================================
local QualitySettings = {
	["Low"] = {
		GlobalShadows = false,
		EnvironmentDiffuseScale = 0.4,
		EnvironmentSpecularScale = 0.35,
		Brightness = 1.5,
		Ambient = Color3.fromRGB(80, 80, 80),
		OutdoorAmbient = Color3.fromRGB(70, 70, 80),
		ShadowSoftness = 0.5,
		Bloom = false,
		Blur = false,
		SunRays = false,
		DepthOfField = false,
		ColorCorrection = {Enabled = true, Saturation = -0.1, Contrast = 0.05, Brightness = 0.05}
	},
	["Balanced"] = {
		GlobalShadows = true,
		EnvironmentDiffuseScale = 0.75,
		EnvironmentSpecularScale = 0.65,
		Brightness = 2.0,
		Ambient = Color3.fromRGB(100, 100, 100),
		OutdoorAmbient = Color3.fromRGB(90, 90, 100),
		ShadowSoftness = 0.8,
		Bloom = true,
		Blur = false,
		SunRays = true,
		DepthOfField = true,
		ColorCorrection = {Enabled = true, Saturation = 0.15, Contrast = 0.1, Brightness = 0.02}
	},
	["RTX Ultra"] = {
		GlobalShadows = true,
		EnvironmentDiffuseScale = 1.0,
		EnvironmentSpecularScale = 1.0,
		Brightness = 2.8,
		Ambient = Color3.fromRGB(120, 120, 120),
		OutdoorAmbient = Color3.fromRGB(110, 110, 120),
		ShadowSoftness = 1.0,
		Bloom = true,
		Blur = true,
		SunRays = true,
		DepthOfField = true,
		ColorCorrection = {Enabled = true, Saturation = 0.25, Contrast = 0.15, Brightness = 0.0}
	}
}

-- Global State
local CurrentProfile = "Balanced"
local AutoOptimize = true
local FpsThresholdLow = 45
local FpsThresholdMedium = 55
local TargetFPS = 60
local LastFPS = 60

-- =============================================
-- POST-PROCESSING HELPERS
-- =============================================
local function getOrCreateEffect(className, name)
	local effect = Lighting:FindFirstChild(name) or Instance.new(className)
	effect.Name = name
	effect.Parent = Lighting
	return effect
end

local function applyPostProcessing(config)
	-- Bloom
	local bloom = getOrCreateEffect("BloomEffect", "BloomEffect")
	bloom.Enabled = config.Bloom
	bloom.Intensity = config.Bloom and 0.8 or 0.3
	bloom.Threshold = 1.5
	bloom.Size = 24

	-- Blur (for cinematic feel in Ultra)
	local blur = getOrCreateEffect("BlurEffect", "BlurEffect")
	blur.Enabled = config.Blur
	blur.Size = config.Blur and 4 or 0

	-- SunRays
	local sunRays = getOrCreateEffect("SunRaysEffect", "SunRaysEffect")
	sunRays.Enabled = config.SunRays
	sunRays.Intensity = 0.25
	sunRays.Spread = 0.8

	-- DepthOfField
	local dof = getOrCreateEffect("DepthOfFieldEffect", "DepthOfFieldEffect")
	dof.Enabled = config.DepthOfField
	dof.FocusDistance = 50
	dof.InFocusRadius = 20
	dof.NearIntensity = 0.5
	dof.FarIntensity = 0.8

	-- ColorCorrection
	local cc = getOrCreateEffect("ColorCorrectionEffect", "ColorCorrectionEffect")
	cc.Enabled = config.ColorCorrection.Enabled
	cc.Saturation = config.ColorCorrection.Saturation
	cc.Contrast = config.ColorCorrection.Contrast
	cc.Brightness = config.ColorCorrection.Brightness
end

-- =============================================
-- APPLY PROFILE (with smooth transitions)
-- =============================================
local function applyProfile(profileName)
	local config = QualitySettings[profileName]
	if not config then return end
	
	CurrentProfile = profileName
	
	-- Core Lighting
	Lighting.GlobalShadows = config.GlobalShadows
	Lighting.Brightness = config.Brightness
	Lighting.Ambient = config.Ambient
	Lighting.OutdoorAmbient = config.OutdoorAmbient
	Lighting.ShadowSoftness = config.ShadowSoftness
	
	-- Smooth tween for diffuse/specular
	local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local tween = TweenService:Create(Lighting, tweenInfo, {
		EnvironmentDiffuseScale = config.EnvironmentDiffuseScale,
		EnvironmentSpecularScale = config.EnvironmentSpecularScale
	})
	tween:Play()
	
	applyPostProcessing(config)
	
	Rayfield:Notify({
		Title = "Profile Applied",
		Content = "Graphics set to: " .. profileName .. "\nFuture Lighting • Max Fidelity",
		Duration = 3,
		Image = 4483362458,
	})
end

-- =============================================
-- UI SETUP
-- =============================================
local MainTab = Window:CreateTab("Graphics Optimizer", 4483362458)

MainTab:CreateSection("Quality Profiles")

local ProfileDropdown = MainTab:CreateDropdown({
   Name = "Visual Profile",
   Options = {"Low", "Balanced", "RTX Ultra"},
   CurrentOption = {"Balanced"},
   MultipleOptions = false,
   Callback = function(Option)
      applyProfile(Option[1])
   end,
})

MainTab:CreateSection("Advanced Controls")

local AutoToggle = MainTab:CreateToggle({
   Name = "Adaptive Performance (60 FPS Target)",
   CurrentValue = true,
   Callback = function(Value)
      AutoOptimize = Value
   end,
})

-- FPS Cap Info (scripts can't directly unlock, but we can guide)
MainTab:CreateSection("FPS Unlock")
MainTab:CreateLabel("For true FPS unlock (>60), use external tools like rbxfpsunlocker or ClientAppSettings.json (DFIntTaskSchedulerTargetFps: 240+)")
MainTab:CreateButton({
   Name = "Recommended: Target 120+ FPS",
   Callback = function()
      Rayfield:Notify({
         Title = "FPS Unlock Tip",
         Content = "External unlock required for >60 FPS. In-game script optimizes within Roblox limits.",
         Duration = 5
      })
   end
})

-- =============================================
-- PERFORMANCE MONITOR (Improved)
-- =============================================
task.spawn(function()
	while true do
		task.wait(3) -- Balanced sampling
		
		if AutoOptimize then
			local currentFPS = Workspace:GetRealPhysicsFPS() or RunService:GetRealFps() or 60
			LastFPS = currentFPS
			
			if currentFPS < FpsThresholdLow and CurrentProfile == "RTX Ultra" then
				applyProfile("Balanced")
				ProfileDropdown:Set({"Balanced"})
			elseif currentFPS < FpsThresholdMedium and CurrentProfile == "Balanced" then
				applyProfile("Low")
				ProfileDropdown:Set({"Low"})
			elseif currentFPS > 70 and CurrentProfile == "Low" then
				applyProfile("Balanced")
				ProfileDropdown:Set({"Balanced"})
			end
		end
	end
end)

-- =============================================
-- INITIALIZATION
-- =============================================
applyProfile("Balanced")

-- Optional: Auto-detect device performance on start
task.delay(2, function()
	if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
		-- Mobile device - start conservative
		Rayfield:Notify({
			Title = "Mobile Detected",
			Content = "Starting in Balanced. Auto-optimization enabled.",
			Duration = 4
		})
	end
end)

print("✅ Mobile Graphics Optimizer Pro Loaded Successfully")
