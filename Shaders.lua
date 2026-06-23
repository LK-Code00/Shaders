-- Services
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Force Future Lighting Technology for the best look possible on the engine
Lighting.Technology = Enum.Technology.Future

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Mobile Graphics Optimizer",
   LoadingTitle = "Loading Engine Profiles...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

-- Graphic Profiles Data
local QualitySettings = {
	["Low"] = {
		Shadows = false,
		EnvironmentDiffuseScale = 0.3,
		EnvironmentSpecularScale = 0.3,
		Bloom = false,
		Blur = false
	},
	["Balanced"] = {
		Shadows = true,
		EnvironmentDiffuseScale = 0.7,
		EnvironmentSpecularScale = 0.6,
		Bloom = true,
		Blur = false
	},
	["RTX Ultra"] = {
		Shadows = true,
		EnvironmentDiffuseScale = 1.0,
		EnvironmentSpecularScale = 1.0,
		Bloom = true,
		Blur = true
	}
}

-- Global State
local CurrentProfile = "Balanced"
local AutoOptimize = true
local FpsThreshold = 55

-- Apply Profile Function
local function applyProfile(profileName)
	local config = QualitySettings[profileName]
	if not config then return end
	
	CurrentProfile = profileName
	Lighting.GlobalShadows = config.Shadows
	
	-- Smoothly transition ambient light intensities
	local tween = TweenService:Create(Lighting, TweenInfo.new(0.5), {
		EnvironmentDiffuseScale = config.EnvironmentDiffuseScale,
		EnvironmentSpecularScale = config.EnvironmentSpecularScale
	})
	tween:Play()
	
	-- Post-Processing Toggles
	local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
	if bloom then bloom.Enabled = config.Bloom end
	
	local blur = Lighting:FindFirstChildOfClass("BlurEffect")
	if blur then blur.Enabled = config.Blur end
	
	Rayfield:Notify({
		Title = "Profile Changed",
		Content = "Graphics set to: " .. profileName,
		Duration = 2,
		Image = 4483362458,
	})
end

-- Tab Setup
local MainTab = Window:CreateTab("Graphics", 4483362458) -- Main Icon

MainTab:CreateSection("Profiles")

-- Profile Dropdown Menu
local ProfileDropdown = MainTab:CreateDropdown({
   Name = "Visual Profile",
   Options = {"Low", "Balanced", "RTX Ultra"},
   CurrentOption = {"Balanced"},
   MultipleOptions = false,
   Callback = function(Option)
      applyProfile(Option[1])
   end,
})

MainTab:CreateSection("Automation")

-- Auto-Optimization Toggle
local Toggle = MainTab:CreateToggle({
   Name = "Adaptive 60 FPS Lock",
   CurrentValue = true,
   Flag = "AutoOpt", 
   Callback = function(Value)
      AutoOptimize = Value
   end,
})

-- Background Performance Monitor Loop
task.spawn(function()
	while true do
		task.wait(4) -- Sample frame rate stability every 4 seconds
		if AutoOptimize then
			local currentFPS = workspace:GetRealPhysicsFPS()
			
			-- Drop down a tier if performance dips heavily below the 60fps target
			if currentFPS < FpsThreshold then
				if CurrentProfile == "RTX Ultra" then
					applyProfile("Balanced")
					ProfileDropdown:Set({"Balanced"})
				elseif CurrentProfile == "Balanced" then
					applyProfile("Low")
					ProfileDropdown:Set({"Low"})
				end
			end
		end
	end
end)

-- Initialize Default Settings
applyProfile("Balanced")
