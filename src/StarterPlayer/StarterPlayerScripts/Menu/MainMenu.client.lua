local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local uiRoot = game:GetService("StarterGui"):WaitForChild("UI")
local Theme = require(uiRoot:WaitForChild("Theme"))
local components = uiRoot:WaitForChild("Components")
local Panel = require(components:WaitForChild("Panel"))
local MenuButton = require(components:WaitForChild("MenuButton"))
local Colors = Theme.Colors
local Fonts = Theme.Fonts
local LOGO_IMAGE = Theme.Assets.Logo
local BACKGROUND_IMAGE = Theme.Assets.Wallpaper

local root = script:FindFirstAncestor("StarterPlayerScripts") or script.Parent.Parent
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
gui.Name = "MainMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
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

local function buildBackground(parent)
	local background = Instance.new("Frame")
	background.Size = UDim2.fromScale(1, 1)
	background.BackgroundColor3 = Colors.Background
	background.BorderSizePixel = 0
	background.Parent = parent

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

	local sun = Instance.new("Frame")
	sun.Size = UDim2.new(0, 340, 0, 340)
	sun.Position = UDim2.new(0, -140, 0, -140)
	sun.BackgroundColor3 = Theme.Sun.Fill
	sun.BackgroundTransparency = Theme.Sun.Transparency
	sun.BorderSizePixel = 0
	sun.Parent = background
	local sunCorner = Instance.new("UICorner")
	sunCorner.CornerRadius = UDim.new(1, 0)
	sunCorner.Parent = sun

	local sunGlow = Instance.new("UIGradient")
	sunGlow.Color = ColorSequence.new(Theme.Gradients.Sun)
	sunGlow.Rotation = 90
	sunGlow.Parent = sun

	return background
end

local background = buildBackground(gui)
local fade = addFade(background)

local content = Panel.Create(background, UDim2.new(0.62, 0, 0.7, 0), UDim2.new(0.5, 0, 0.5, 0))
content.BackgroundTransparency = 0.15
content.ZIndex = 5

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(320, 360)
sizeConstraint.MaxSize = Vector2.new(560, 520)
sizeConstraint.Parent = content

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 64)
title.Position = UDim2.new(0, 20, 0, 18)
title.BackgroundTransparency = 1
title.Font = Fonts.Title
title.TextSize = 36
title.TextColor3 = Colors.Text
title.Text = "Fishing Game"
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6
title.Parent = content

local logo = Instance.new("ImageLabel")
logo.Name = "Logo"
logo.Size = UDim2.new(0, 220, 0, 80)
logo.Position = UDim2.new(0.5, -110, 0, 10)
logo.BackgroundTransparency = 1
logo.Image = LOGO_IMAGE
logo.ScaleType = Enum.ScaleType.Fit
logo.ZIndex = 7
logo.Parent = content

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -40, 0, 32)
subtitle.Position = UDim2.new(0, 20, 0, 100)
subtitle.BackgroundTransparency = 1
subtitle.Font = Fonts.Body
subtitle.TextSize = 15
subtitle.TextColor3 = Colors.TextMuted
subtitle.Text = "Escolha um mapa e comece sua pescaria"
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 6
subtitle.Parent = content

local buttons = Instance.new("Frame")
buttons.Size = UDim2.new(1, -40, 1, -140)
buttons.Position = UDim2.new(0, 20, 0, 140)
buttons.BackgroundTransparency = 1
buttons.ZIndex = 6
buttons.Parent = content

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10)
list.Parent = buttons

local icons = {
	Jogar = "rbxassetid://0",
	Shop = "rbxassetid://0",
	Peixes = "rbxassetid://0",
	Personagem = "rbxassetid://0",
	Canas = "rbxassetid://0",
	Mapas = "rbxassetid://0",
}

local playButton = MenuButton.Create(buttons, "Jogar", icons.Jogar, { primary = true, height = 54 })
playButton.MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("OpenPanel", "Play")
	gui.Enabled = false
end)

MenuButton.Create(buttons, "Shop", icons.Shop, { height = 44 }).MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("OpenPanel", "Shop")
	gui.Enabled = false
end)

MenuButton.Create(buttons, "Peixes", icons.Peixes, { height = 44 }).MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("OpenPanel", "Pokedex")
	gui.Enabled = false
end)

MenuButton.Create(buttons, "Personagem", icons.Personagem, { height = 44 }).MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("OpenPanel", "Character")
	gui.Enabled = false
end)

MenuButton.Create(buttons, "Canas", icons.Canas, { height = 44 }).MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("OpenPanel", "Rods")
	gui.Enabled = false
end)

MenuButton.Create(buttons, "Mapas", icons.Mapas, { height = 44 }).MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("OpenPanel", "Maps")
	gui.Enabled = false
end)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -40, 0, 20)
footer.Position = UDim2.new(0, 20, 1, -28)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextColor3 = Colors.TextMuted
footer.Text = "Colecione peixes raros e explore aguas novas"
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.ZIndex = 6
footer.Parent = content

TweenService:Create(title, TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
	Position = UDim2.new(0, 20, 0, 14),
}):Play()

local defaultPos = content.Position

local function openPanel()
	gui.Enabled = true
	fade.BackgroundTransparency = 0
	content.Position = defaultPos + UDim2.new(0, 0, 0, 12)

	TweenService:Create(fade, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1,
	}):Play()
	TweenService:Create(content, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
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
	TweenService:Create(content, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
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
		content.Position = defaultPos
		fade.BackgroundTransparency = 1
	end)
end

uiBus.Event:Connect(function(action, panel)
	if action == "OpenPanel" and (panel == "MainMenu" or panel == nil) then
		openPanel()
	elseif action == "CloseAll" then
		closePanel()
	end
end)

playerGui:SetAttribute("MenuOpen", true)
uiBus:Fire("OpenPanel", "MainMenu")

