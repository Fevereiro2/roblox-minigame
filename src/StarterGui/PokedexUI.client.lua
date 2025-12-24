local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local FishDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FishDatabase"))

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
gui.Name = "PokedexUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Enabled = false
gui.Parent = playerGui

local function buildBackground(parent)
	local background = Instance.new("Frame")
	background.Size = UDim2.fromScale(1, 1)
	background.BackgroundColor3 = Color3.fromRGB(10, 18, 24)
	background.BorderSizePixel = 0
	background.Parent = parent

	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 22, 28)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 44, 58)),
	})
	gradient.Rotation = 120
	gradient.Parent = background

	local water = Instance.new("Frame")
	water.Size = UDim2.new(1, 0, 0, 220)
	water.Position = UDim2.new(0, 0, 1, -220)
	water.BackgroundColor3 = Color3.fromRGB(12, 64, 86)
	water.BorderSizePixel = 0
	water.Parent = background
	local waterGradient = Instance.new("UIGradient")
	waterGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 80, 110)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(6, 34, 52)),
	})
	waterGradient.Rotation = 90
	waterGradient.Parent = water

	return background
end

local background = buildBackground(gui)

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.new(0.72, 0, 0.78, 0)
frame.Position = UDim2.new(0.5, 0, 0.52, 0)
frame.BackgroundColor3 = Color3.fromRGB(12, 22, 30)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = background

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(70, 110, 125)
frameStroke.Thickness = 1
frameStroke.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 34)
title.Position = UDim2.new(0, 20, 0, 14)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Text = "Pokedex"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local backButton = Instance.new("TextButton")
backButton.Size = UDim2.new(0, 90, 0, 28)
backButton.Position = UDim2.new(0, 20, 0, 50)
backButton.BackgroundColor3 = Color3.fromRGB(16, 34, 46)
backButton.TextColor3 = Color3.fromRGB(220, 230, 240)
backButton.Font = Enum.Font.GothamSemibold
backButton.TextSize = 14
backButton.Text = "< Voltar"
backButton.AutoButtonColor = false
backButton.Parent = frame

local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0, 10)
backCorner.Parent = backButton

local backStroke = Instance.new("UIStroke")
backStroke.Color = Color3.fromRGB(60, 95, 110)
backStroke.Thickness = 1
backStroke.Parent = backButton

backButton.MouseEnter:Connect(function()
	TweenService:Create(backButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(20, 44, 58) }):Play()
end)
backButton.MouseLeave:Connect(function()
	TweenService:Create(backButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(16, 34, 46) }):Play()
end)
backButton.MouseButton1Click:Connect(function()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "MainMenu")
end)

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -40, 1, -104)
list.Position = UDim2.new(0, 20, 0, 88)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ScrollBarThickness = 6
list.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = list

local discovered = {}

local function clearList()
	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end
end

local function rebuildList()
	clearList()
	for _, fish in ipairs(FishDatabase.Fish) do
		local row = Instance.new("TextLabel")
		row.Size = UDim2.new(1, 0, 0, 34)
		row.BackgroundColor3 = Color3.fromRGB(16, 34, 46)
		row.TextColor3 = Color3.fromRGB(240, 240, 240)
		row.Font = Enum.Font.GothamSemibold
		row.TextSize = 14
		row.TextXAlignment = Enum.TextXAlignment.Left
		row.Text = discovered[fish.id] and string.format("%s - %s", fish.name, fish.rarity) or "????"
		row.Parent = list

		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 14)
		padding.Parent = row

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 10)
		corner.Parent = row

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(60, 95, 110)
		stroke.Thickness = 1
		stroke.Parent = row
	end
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
end)

uiBus.Event:Connect(function(action, payload)
	if action == "OpenPanel" and payload == "Pokedex" then
		rebuildList()
		gui.Enabled = true
	elseif action == "CloseAll" then
		gui.Enabled = false
	elseif action == "FishDiscovered" and type(payload) == "string" then
		discovered[payload] = true
	end
end)
