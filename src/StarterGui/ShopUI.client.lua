local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local getBuyItem = require(ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyItem"))
local buyEvent = getBuyItem()

local RodDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RodDatabase"))
local MapDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MapDatabase"))
local ProductDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ProductDatabase"))

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
gui.Name = "ShopUI"
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

	local wave = Instance.new("Frame")
	wave.Size = UDim2.new(1.1, 0, 0, 70)
	wave.Position = UDim2.new(-0.05, 0, 1, -150)
	wave.BackgroundColor3 = Color3.fromRGB(18, 120, 150)
	wave.BackgroundTransparency = 0.65
	wave.BorderSizePixel = 0
	wave.Parent = background
	local waveCorner = Instance.new("UICorner")
	waveCorner.CornerRadius = UDim.new(0, 60)
	waveCorner.Parent = wave

	TweenService:Create(wave, TweenInfo.new(9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
		Position = UDim2.new(0, 0, 1, -150),
	}):Play()

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
title.Text = "Loja"
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
layout.Padding = UDim.new(0, 10)
layout.Parent = list

local function addHeader(text)
	local row = Instance.new("TextLabel")
	row.Size = UDim2.new(1, 0, 0, 22)
	row.BackgroundTransparency = 1
	row.TextColor3 = Color3.fromRGB(200, 200, 200)
	row.Font = Enum.Font.GothamBold
	row.TextSize = 13
	row.TextXAlignment = Enum.TextXAlignment.Left
	row.Text = text
	row.Parent = list
end

local function addItem(label, priceText, onClick)
	local row = Instance.new("TextButton")
	row.Size = UDim2.new(1, 0, 0, 38)
	row.BackgroundColor3 = Color3.fromRGB(16, 34, 46)
	row.TextColor3 = Color3.fromRGB(240, 240, 240)
	row.Font = Enum.Font.GothamSemibold
	row.TextSize = 14
	row.TextXAlignment = Enum.TextXAlignment.Left
	row.Text = string.format("%s - %s", label, priceText)
	row.AutoButtonColor = false
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

	row.MouseEnter:Connect(function()
		TweenService:Create(row, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(20, 44, 58) }):Play()
	end)
	row.MouseLeave:Connect(function()
		TweenService:Create(row, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(16, 34, 46) }):Play()
	end)

	row.MouseButton1Click:Connect(onClick)
end

addHeader("Canas")
for _, rod in ipairs(RodDatabase.Rods) do
	local priceText = string.format("%d %s", rod.price, rod.currency)
	addItem("Cana: " .. rod.name, priceText, function()
		buyEvent:FireServer({ itemType = "Rod", itemId = rod.id })
	end)
end

addHeader("Mapas")
for _, map in ipairs(MapDatabase.Maps) do
	local priceText = string.format("%d %s", map.price, map.currency)
	addItem("Mapa: " .. map.name, priceText, function()
		buyEvent:FireServer({ itemType = "Map", itemId = map.id })
	end)
end

addHeader("Moedas")
for _, product in ipairs(ProductDatabase.Products) do
	if product.category == "Coins" then
		local priceText = product.displayPrice or "Robux"
		addItem(product.name, priceText, function()
			buyEvent:FireServer({ itemType = "Coins", itemId = product.id })
		end)
	end
end

addHeader("Boosts")
for _, product in ipairs(ProductDatabase.Products) do
	if product.category == "Boost" then
		local priceText = product.displayPrice or "Robux"
		addItem(product.name, priceText, function()
			buyEvent:FireServer({ itemType = "Boost", itemId = product.id })
		end)
	end
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
end)

uiBus.Event:Connect(function(action, panel)
	if action == "OpenPanel" and panel == "Shop" then
		gui.Enabled = true
	elseif action == "CloseAll" then
		gui.Enabled = false
	end
end)

buyEvent.OnClientEvent:Connect(function(payload)
	if type(payload) ~= "table" then
		return
	end

	if payload.ok then
		uiBus:Fire("Notify", "Compra realizada")
	else
		uiBus:Fire("Notify", "Compra falhou")
	end
end)
