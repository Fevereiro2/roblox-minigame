local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local LOGO_IMAGE = "rbxassetid://82425580179801"
local BACKGROUND_IMAGE = "rbxassetid://88755976907991"

local function getUiBus()
	local folder = playerGui:FindFirstChild("UIEvents")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "UIEvents"
		folder.Parent = playerGui
	end

	local bus = folder:FindFirstChild("UIBus")
	if not bus then
		bus = Instance.new("BindableEvent")
		bus.Name = "UIBus"
		bus.Parent = folder
	end

	return bus
end

local uiBus = getUiBus()

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
	fade.BackgroundColor3 = Color3.fromRGB(4, 12, 16)
	fade.BackgroundTransparency = 1
	fade.BorderSizePixel = 0
	fade.ZIndex = 20
	fade.Parent = parent
	return fade
end

local function buildBackground(parent)
	local background = Instance.new("Frame")
	background.Size = UDim2.fromScale(1, 1)
	background.BackgroundColor3 = Color3.fromRGB(8, 30, 38)
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
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 40, 54)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 92, 114)),
	})
	gradient.Rotation = 120
	gradient.Parent = background

	local sun = Instance.new("Frame")
	sun.Size = UDim2.new(0, 340, 0, 340)
	sun.Position = UDim2.new(0, -140, 0, -140)
	sun.BackgroundColor3 = Color3.fromRGB(255, 210, 140)
	sun.BackgroundTransparency = 0.35
	sun.BorderSizePixel = 0
	sun.Parent = background
	local sunCorner = Instance.new("UICorner")
	sunCorner.CornerRadius = UDim.new(1, 0)
	sunCorner.Parent = sun

	local sunGlow = Instance.new("UIGradient")
	sunGlow.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 230, 180)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 90)),
	})
	sunGlow.Rotation = 90
	sunGlow.Parent = sun

	local water = Instance.new("Frame")
	water.Size = UDim2.new(1, 0, 0, 240)
	water.Position = UDim2.new(0, 0, 1, -240)
	water.BackgroundColor3 = Color3.fromRGB(6, 96, 120)
	water.BorderSizePixel = 0
	water.Parent = background
	local waterGradient = Instance.new("UIGradient")
	waterGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(6, 110, 135)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(4, 46, 68)),
	})
	waterGradient.Rotation = 90
	waterGradient.Parent = water

	local waveA = Instance.new("Frame")
	waveA.Size = UDim2.new(1.2, 0, 0, 80)
	waveA.Position = UDim2.new(-0.1, 0, 1, -160)
	waveA.BackgroundColor3 = Color3.fromRGB(24, 150, 180)
	waveA.BackgroundTransparency = 0.6
	waveA.BorderSizePixel = 0
	waveA.Parent = background
	local waveCorner = Instance.new("UICorner")
	waveCorner.CornerRadius = UDim.new(0, 60)
	waveCorner.Parent = waveA

	local waveB = waveA:Clone()
	waveB.Position = UDim2.new(-0.2, 0, 1, -120)
	waveB.BackgroundColor3 = Color3.fromRGB(32, 170, 190)
	waveB.BackgroundTransparency = 0.65
	waveB.Parent = background

	TweenService:Create(waveA, TweenInfo.new(9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Position = UDim2.new(0, 0, 1, -160),
	}):Play()
	TweenService:Create(waveB, TweenInfo.new(7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Position = UDim2.new(0, 0, 1, -120),
	}):Play()

	local function addBubble(size, position, duration)
		local bubble = Instance.new("Frame")
		bubble.Size = size
		bubble.Position = position
		bubble.BackgroundColor3 = Color3.fromRGB(200, 235, 245)
		bubble.BackgroundTransparency = 0.55
		bubble.BorderSizePixel = 0
		bubble.Parent = background
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1, 0)
		corner.Parent = bubble

		TweenService:Create(bubble, TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1), {
			Position = position - UDim2.new(0, 0, 0, 120),
			BackgroundTransparency = 0.85,
		}):Play()
	end

	addBubble(UDim2.new(0, 10, 0, 10), UDim2.new(0.2, 0, 0.85, 0), 6)
	addBubble(UDim2.new(0, 14, 0, 14), UDim2.new(0.6, 0, 0.9, 0), 8)
	addBubble(UDim2.new(0, 8, 0, 8), UDim2.new(0.8, 0, 0.82, 0), 5)

	return background
end

local background = buildBackground(gui)
local fade = addFade(background)

local content = Instance.new("Frame")
content.AnchorPoint = Vector2.new(0.5, 0.5)
content.Position = UDim2.new(0.5, 0, 0.5, 0)
content.Size = UDim2.new(0.62, 0, 0.7, 0)
content.BackgroundColor3 = Color3.fromRGB(10, 26, 34)
content.BackgroundTransparency = 0.15
content.BorderSizePixel = 0
content.ZIndex = 5
content.Parent = background

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 18)
contentCorner.Parent = content

local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(90, 150, 170)
contentStroke.Thickness = 1
contentStroke.Parent = content

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(320, 360)
sizeConstraint.MaxSize = Vector2.new(560, 520)
sizeConstraint.Parent = content

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 64)
title.Position = UDim2.new(0, 20, 0, 18)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 36
title.TextColor3 = Color3.fromRGB(245, 250, 255)
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
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 15
subtitle.TextColor3 = Color3.fromRGB(190, 230, 235)
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

local function applyHover(button, baseColor, hoverColor)
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12), { BackgroundColor3 = hoverColor }):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12), { BackgroundColor3 = baseColor }):Play()
	end)
end

local function styleButton(button, isPrimary)
	button.AutoButtonColor = false
	button.TextColor3 = Color3.fromRGB(245, 245, 245)
	button.Font = Enum.Font.GothamSemibold
	button.TextSize = 18
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Size = UDim2.new(1, 0, 0, isPrimary and 54 or 44)
	button.BackgroundColor3 = isPrimary and Color3.fromRGB(18, 150, 170) or Color3.fromRGB(16, 40, 52)
	button.ZIndex = 6

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 50)
	padding.Parent = button

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = isPrimary and Color3.fromRGB(140, 230, 245) or Color3.fromRGB(70, 120, 140)
	stroke.Thickness = 1
	stroke.Parent = button

	local hoverColor = isPrimary and Color3.fromRGB(26, 170, 190) or Color3.fromRGB(20, 52, 66)
	applyHover(button, button.BackgroundColor3, hoverColor)
end

local function makeButton(label, isPrimary, iconId)
	local button = Instance.new("TextButton")
	button.Text = label
	button.Parent = buttons
	styleButton(button, isPrimary)

	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0, 22, 0, 22)
	icon.Position = UDim2.new(0, 18, 0.5, -11)
	icon.BackgroundTransparency = 1
	icon.Image = iconId
	icon.ZIndex = 7
	icon.Parent = button

	return button
end

local playButton = makeButton("Jogar", true, icons.Jogar)
playButton.MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "MapSelection")
	gui.Enabled = false
end)

makeButton("Shop", false, icons.Shop).MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "Shop")
	gui.Enabled = false
end)

makeButton("Peixes", false, icons.Peixes).MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "Pokedex")
	gui.Enabled = false
end)

makeButton("Personagem", false, icons.Personagem).MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "Character")
	gui.Enabled = false
end)

makeButton("Canas", false, icons.Canas).MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "Rods")
	gui.Enabled = false
end)

makeButton("Mapas", false, icons.Mapas).MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "MapSelection")
	gui.Enabled = false
end)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -40, 0, 20)
footer.Position = UDim2.new(0, 20, 1, -28)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextColor3 = Color3.fromRGB(170, 210, 220)
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

openPanel()
