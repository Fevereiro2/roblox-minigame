local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

local gui = Instance.new("ScreenGui")
gui.Name = "MainMenu"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local background = Instance.new("Frame")
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(10, 16, 24)
background.BorderSizePixel = 0
background.Parent = gui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 18, 26)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 42, 60)),
})
gradient.Rotation = 120
gradient.Parent = background

local glowLeft = Instance.new("Frame")
glowLeft.Size = UDim2.new(0, 520, 0, 520)
glowLeft.Position = UDim2.new(0, -180, 0, -120)
glowLeft.BackgroundColor3 = Color3.fromRGB(0, 130, 160)
glowLeft.BackgroundTransparency = 0.65
glowLeft.BorderSizePixel = 0
glowLeft.Parent = background
local glowLeftCorner = Instance.new("UICorner")
glowLeftCorner.CornerRadius = UDim.new(1, 0)
glowLeftCorner.Parent = glowLeft

local glowRight = Instance.new("Frame")
glowRight.Size = UDim2.new(0, 420, 0, 420)
glowRight.Position = UDim2.new(1, -220, 1, -280)
glowRight.BackgroundColor3 = Color3.fromRGB(255, 170, 70)
glowRight.BackgroundTransparency = 0.72
glowRight.BorderSizePixel = 0
glowRight.Parent = background
local glowRightCorner = Instance.new("UICorner")
glowRightCorner.CornerRadius = UDim.new(1, 0)
glowRightCorner.Parent = glowRight

local content = Instance.new("Frame")
content.AnchorPoint = Vector2.new(0.5, 0.5)
content.Position = UDim2.new(0.5, 0, 0.5, 0)
content.Size = UDim2.new(0.6, 0, 0.7, 0)
content.BackgroundTransparency = 1
content.Parent = background

local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(320, 360)
sizeConstraint.MaxSize = Vector2.new(560, 520)
sizeConstraint.Parent = content

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 80)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 36
title.TextColor3 = Color3.fromRGB(245, 245, 245)
title.Text = "Fishing Game"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = content

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 36)
subtitle.Position = UDim2.new(0, 0, 0, 70)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 16
subtitle.TextColor3 = Color3.fromRGB(200, 220, 235)
subtitle.Text = "Escolha o seu destino e comece a pescar"
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = content

local buttons = Instance.new("Frame")
buttons.Size = UDim2.new(1, 0, 1, -130)
buttons.Position = UDim2.new(0, 0, 0, 120)
buttons.BackgroundTransparency = 1
buttons.Parent = content

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 10)
list.Parent = buttons

local function applyHover(button, baseColor, hoverColor)
	local base = baseColor
	local hover = hoverColor
	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12), { BackgroundColor3 = hover }):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.12), { BackgroundColor3 = base }):Play()
	end)
end

local function styleButton(button, isPrimary)
	button.AutoButtonColor = false
	button.TextColor3 = Color3.fromRGB(245, 245, 245)
	button.Font = Enum.Font.GothamSemibold
	button.TextSize = 18
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.Size = UDim2.new(1, 0, 0, isPrimary and 54 or 44)
	button.BackgroundColor3 = isPrimary and Color3.fromRGB(16, 120, 150) or Color3.fromRGB(20, 30, 42)

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 18)
	padding.Parent = button

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = isPrimary and Color3.fromRGB(120, 210, 235) or Color3.fromRGB(60, 90, 110)
	stroke.Thickness = 1
	stroke.Parent = button

	local hoverColor = isPrimary and Color3.fromRGB(20, 140, 170) or Color3.fromRGB(28, 40, 54)
	applyHover(button, button.BackgroundColor3, hoverColor)
end

local function makeButton(label, isPrimary)
	local button = Instance.new("TextButton")
	button.Text = label
	button.Parent = buttons
	styleButton(button, isPrimary)
	return button
end

local playButton = makeButton("Jogar", true)
playButton.MouseButton1Click:Connect(function()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "MapSelection")
	gui.Enabled = false
end)

makeButton("Shop", false).MouseButton1Click:Connect(function()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "Shop")
	gui.Enabled = false
end)

makeButton("Peixes", false).MouseButton1Click:Connect(function()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "Pokedex")
	gui.Enabled = false
end)

makeButton("Personagem", false).MouseButton1Click:Connect(function()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "Character")
	gui.Enabled = false
end)

makeButton("Canas", false).MouseButton1Click:Connect(function()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "Rods")
	gui.Enabled = false
end)

makeButton("Mapas", false).MouseButton1Click:Connect(function()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "MapSelection")
	gui.Enabled = false
end)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -10)
footer.BackgroundTransparency = 1
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextColor3 = Color3.fromRGB(170, 190, 205)
footer.Text = "Colecione peixes raros e desbloqueie novos mapas"
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Parent = content

uiBus.Event:Connect(function(action, panel)
	if action == "OpenPanel" and (panel == "MainMenu" or panel == nil) then
		gui.Enabled = true
	elseif action == "CloseAll" then
		gui.Enabled = false
	end
end)
