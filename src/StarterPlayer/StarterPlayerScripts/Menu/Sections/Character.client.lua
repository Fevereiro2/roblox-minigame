local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local uiRoot = game:GetService("StarterGui"):WaitForChild("UI")
local Theme = require(uiRoot:WaitForChild("Theme"))
local components = uiRoot:WaitForChild("Components")
local Panel = require(components:WaitForChild("Panel"))
local Colors = Theme.Colors
local Fonts = Theme.Fonts
local BACKGROUND_IMAGE = Theme.Assets.Wallpaper

local root = script:FindFirstAncestor("StarterPlayerScripts") or script.Parent.Parent.Parent
local UIBus = require(root:WaitForChild("Systems"):WaitForChild("UIBus"))
local uiBus = UIBus.Get()

local function playClick()
	local sound = SoundService:FindFirstChild("UIClick")
	if sound then
		sound:Play()
	end
end

local function getBlur()
	local blur = Lighting:FindFirstChild("MenuBlur")
	if not blur then
		blur = Instance.new("BlurEffect")
		blur.Name = "MenuBlur"
		blur.Size = 0
		blur.Parent = Lighting
	end
	return blur
end

local function getDepth()
	local depth = Lighting:FindFirstChild("MenuDepth")
	if not depth then
		depth = Instance.new("DepthOfFieldEffect")
		depth.Name = "MenuDepth"
		depth.FarIntensity = 0
		depth.NearIntensity = 0
		depth.InFocusRadius = 30
		depth.FocusDistance = 10
		depth.Parent = Lighting
	end
	return depth
end

local gui = Instance.new("ScreenGui")
gui.Name = "CharacterUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Enabled = false
gui.Parent = playerGui

local function addFade(parent)
	local fade = Instance.new("Frame")
	fade.Name = "Fade"
	fade.Size = UDim2.fromScale(1, 1)
	fade.BackgroundColor3 = Colors.Fade
	fade.BackgroundTransparency = 1
	fade.BorderSizePixel = 0
	fade.ZIndex = 20
	fade.Parent = parent
	return fade
end

local background = Instance.new("Frame")
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Colors.Background
background.BorderSizePixel = 0
background.Parent = gui

local wallpaper = Instance.new("ImageLabel")
wallpaper.Name = "Wallpaper"
wallpaper.Size = UDim2.fromScale(1, 1)
wallpaper.BackgroundTransparency = 1
wallpaper.Image = BACKGROUND_IMAGE
wallpaper.ScaleType = Enum.ScaleType.Crop
wallpaper.ImageTransparency = 0.2
wallpaper.Parent = background

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new(Theme.Gradients.Primary)
gradient.Rotation = 120
gradient.Parent = background

local fade = addFade(background)

local frame = Panel.Create(background, UDim2.new(0.6, 0, 0.6, 0), UDim2.new(0.5, 0, 0.5, 0))
frame.BackgroundTransparency = 0.15
frame.ZIndex = 5

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 34)
title.Position = UDim2.new(0, 20, 0, 14)
title.BackgroundTransparency = 1
title.Font = Fonts.Heading
title.TextSize = 18
title.TextColor3 = Colors.Text
title.Text = "Personagem"
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6
title.Parent = frame

local backButton = Instance.new("TextButton")
backButton.Size = UDim2.new(0, 90, 0, 28)
backButton.Position = UDim2.new(0, 20, 0, 50)
backButton.BackgroundColor3 = Colors.Button
backButton.TextColor3 = Colors.Text
backButton.Font = Fonts.BodyBold
backButton.TextSize = 14
backButton.Text = "< Voltar"
backButton.AutoButtonColor = false
backButton.ZIndex = 6
backButton.Parent = frame

local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0, 10)
backCorner.Parent = backButton

local backStroke = Instance.new("UIStroke")
backStroke.Color = Colors.PanelStroke
backStroke.Thickness = 1
backStroke.Parent = backButton

backButton.MouseEnter:Connect(function()
	TweenService:Create(backButton, TweenInfo.new(0.12), { BackgroundColor3 = Colors.ButtonHover }):Play()
end)
backButton.MouseLeave:Connect(function()
	TweenService:Create(backButton, TweenInfo.new(0.12), { BackgroundColor3 = Colors.Button }):Play()
end)
backButton.MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "MainMenu")
end)

local body = Instance.new("TextLabel")
body.Size = UDim2.new(1, -40, 0, 120)
body.Position = UDim2.new(0, 20, 0, 100)
body.BackgroundTransparency = 1
body.Font = Fonts.Body
body.TextSize = 14
body.TextColor3 = Colors.TextMuted
body.Text = "Customizacao em breve. Aqui voce podera escolher skins, chapeus e mochilas."
body.TextXAlignment = Enum.TextXAlignment.Left
body.TextYAlignment = Enum.TextYAlignment.Top
body.TextWrapped = true
body.ZIndex = 6
body.Parent = frame

local defaultPos = frame.Position

local function openPanel()
	gui.Enabled = true
	fade.BackgroundTransparency = 0
	frame.Position = defaultPos + UDim2.new(0, 0, 0, 12)
	TweenService:Create(fade, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1,
	}):Play()
	TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = defaultPos,
	}):Play()
	TweenService:Create(getBlur(), TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = 12,
	}):Play()
	TweenService:Create(getDepth(), TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		FarIntensity = 0.25,
		NearIntensity = 0.15,
	}):Play()
end

local function closePanel()
	if not gui.Enabled then
		return
	end
	TweenService:Create(fade, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 0,
	}):Play()
	TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = defaultPos + UDim2.new(0, 0, 0, 12),
	}):Play()
	TweenService:Create(getBlur(), TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = 0,
	}):Play()
	TweenService:Create(getDepth(), TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		FarIntensity = 0,
		NearIntensity = 0,
	}):Play()
	task.delay(0.22, function()
		gui.Enabled = false
		frame.Position = defaultPos
		fade.BackgroundTransparency = 1
	end)
end

uiBus.Event:Connect(function(action, panel)
	if action == "OpenPanel" and panel == "Character" then
		openPanel()
	elseif action == "CloseAll" then
		closePanel()
	end
end)

