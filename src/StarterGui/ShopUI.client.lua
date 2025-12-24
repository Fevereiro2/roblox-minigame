local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local getBuyItem = require(ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyItem"))
local buyEvent = getBuyItem()

local RodDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RodDatabase"))
local MapDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MapDatabase"))
local ProductDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ProductDatabase"))

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

local categoryIcons = {
	Rods = "rbxassetid://0",
	Maps = "rbxassetid://0",
	Coins = "rbxassetid://0",
	Boosts = "rbxassetid://0",
}

local gui = Instance.new("ScreenGui")
gui.Name = "ShopUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Enabled = false
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

	local water = Instance.new("Frame")
	water.Size = UDim2.new(1, 0, 0, 220)
	water.Position = UDim2.new(0, 0, 1, -220)
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

	local wave = Instance.new("Frame")
	wave.Size = UDim2.new(1.1, 0, 0, 70)
	wave.Position = UDim2.new(-0.05, 0, 1, -150)
	wave.BackgroundColor3 = Color3.fromRGB(24, 150, 180)
	wave.BackgroundTransparency = 0.6
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
local fade = addFade(background)

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.new(0.78, 0, 0.8, 0)
frame.Position = UDim2.new(0.5, 0, 0.52, 0)
frame.BackgroundColor3 = Color3.fromRGB(10, 26, 34)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.ZIndex = 5
frame.Parent = background

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(90, 150, 170)
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
title.ZIndex = 6
title.Parent = frame

local backButton = Instance.new("TextButton")
backButton.Size = UDim2.new(0, 90, 0, 28)
backButton.Position = UDim2.new(0, 20, 0, 50)
backButton.BackgroundColor3 = Color3.fromRGB(16, 40, 52)
backButton.TextColor3 = Color3.fromRGB(220, 230, 240)
backButton.Font = Enum.Font.GothamSemibold
backButton.TextSize = 14
backButton.Text = "< Voltar"
backButton.AutoButtonColor = false
backButton.ZIndex = 6
backButton.Parent = frame

local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0, 10)
backCorner.Parent = backButton

local backStroke = Instance.new("UIStroke")
backStroke.Color = Color3.fromRGB(70, 120, 140)
backStroke.Thickness = 1
backStroke.Parent = backButton

backButton.MouseEnter:Connect(function()
	TweenService:Create(backButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(20, 52, 66) }):Play()
end)
backButton.MouseLeave:Connect(function()
	TweenService:Create(backButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(16, 40, 52) }):Play()
end)
backButton.MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "MainMenu")
end)

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.62, 0, 1, -100)
leftPanel.Position = UDim2.new(0, 20, 0, 88)
leftPanel.BackgroundTransparency = 1
leftPanel.ZIndex = 6
leftPanel.Parent = frame

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.34, 0, 1, -100)
rightPanel.Position = UDim2.new(0.66, 0, 0, 88)
rightPanel.BackgroundColor3 = Color3.fromRGB(16, 40, 52)
rightPanel.BackgroundTransparency = 0.1
rightPanel.BorderSizePixel = 0
rightPanel.ZIndex = 6
rightPanel.Parent = frame

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0, 12)
rightCorner.Parent = rightPanel

local rightStroke = Instance.new("UIStroke")
rightStroke.Color = Color3.fromRGB(70, 120, 140)
rightStroke.Thickness = 1
rightStroke.Parent = rightPanel

local detailTitle = Instance.new("TextLabel")
detailTitle.Size = UDim2.new(1, -24, 0, 28)
detailTitle.Position = UDim2.new(0, 12, 0, 12)
detailTitle.BackgroundTransparency = 1
detailTitle.Font = Enum.Font.GothamBold
detailTitle.TextSize = 16
detailTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
detailTitle.Text = "Selecione um item"
detailTitle.TextXAlignment = Enum.TextXAlignment.Left
detailTitle.ZIndex = 7
detailTitle.Parent = rightPanel

local detailType = Instance.new("TextLabel")
detailType.Size = UDim2.new(1, -24, 0, 20)
detailType.Position = UDim2.new(0, 12, 0, 40)
detailType.BackgroundTransparency = 1
detailType.Font = Enum.Font.Gotham
detailType.TextSize = 12
detailType.TextColor3 = Color3.fromRGB(170, 210, 220)
detailType.Text = ""
detailType.TextXAlignment = Enum.TextXAlignment.Left
detailType.ZIndex = 7
detailType.Parent = rightPanel

local detailDesc = Instance.new("TextLabel")
detailDesc.Size = UDim2.new(1, -24, 0, 140)
detailDesc.Position = UDim2.new(0, 12, 0, 66)
detailDesc.BackgroundTransparency = 1
detailDesc.Font = Enum.Font.Gotham
detailDesc.TextSize = 13
detailDesc.TextColor3 = Color3.fromRGB(200, 230, 235)
detailDesc.Text = "Clique num item para ver detalhes."
detailDesc.TextXAlignment = Enum.TextXAlignment.Left
detailDesc.TextYAlignment = Enum.TextYAlignment.Top
detailDesc.TextWrapped = true
detailDesc.ZIndex = 7
detailDesc.Parent = rightPanel

local detailPrice = Instance.new("TextLabel")
detailPrice.Size = UDim2.new(1, -24, 0, 20)
detailPrice.Position = UDim2.new(0, 12, 1, -70)
detailPrice.BackgroundTransparency = 1
detailPrice.Font = Enum.Font.GothamSemibold
detailPrice.TextSize = 14
detailPrice.TextColor3 = Color3.fromRGB(240, 240, 240)
detailPrice.Text = ""
detailPrice.TextXAlignment = Enum.TextXAlignment.Left
detailPrice.ZIndex = 7
detailPrice.Parent = rightPanel

local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.new(1, -24, 0, 36)
buyButton.Position = UDim2.new(0, 12, 1, -44)
buyButton.BackgroundColor3 = Color3.fromRGB(18, 150, 170)
buyButton.TextColor3 = Color3.fromRGB(245, 245, 245)
buyButton.Font = Enum.Font.GothamSemibold
buyButton.TextSize = 16
buyButton.Text = "Comprar"
buyButton.AutoButtonColor = false
buyButton.ZIndex = 7
buyButton.Parent = rightPanel

local buyCorner = Instance.new("UICorner")
buyCorner.CornerRadius = UDim.new(0, 10)
buyCorner.Parent = buyButton

local buyStroke = Instance.new("UIStroke")
buyStroke.Color = Color3.fromRGB(140, 230, 245)
buyStroke.Thickness = 1
buyStroke.Parent = buyButton

buyButton.MouseEnter:Connect(function()
	TweenService:Create(buyButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(26, 170, 190) }):Play()
end)
buyButton.MouseLeave:Connect(function()
	TweenService:Create(buyButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(18, 150, 170) }):Play()
end)

local tabs = Instance.new("Frame")
tabs.Size = UDim2.new(1, 0, 0, 36)
tabs.Position = UDim2.new(0, 0, 0, 0)
tabs.BackgroundTransparency = 1
tabs.ZIndex = 6
tabs.Parent = leftPanel

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 8)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabs

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, 0, 1, -44)
list.Position = UDim2.new(0, 0, 0, 44)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ScrollBarThickness = 6
list.ZIndex = 6
list.Parent = leftPanel

local grid = Instance.new("UIGridLayout")
grid.CellPadding = UDim2.new(0, 10, 0, 10)
grid.CellSize = UDim2.new(0.24, 0, 0, 72)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = list

local selected
local currentTab = "All"
local cards = {}
local cardData = {}
local currentColumns = 4
local updateCanvas

local function resetDetails()
	selected = nil
	detailTitle.Text = "Selecione um item"
	detailType.Text = ""
	detailDesc.Text = "Clique num item para ver detalhes."
	detailPrice.Text = ""
	buyButton.Text = "Comprar"
end

local function selectFirstVisible()
	for _, card in ipairs(cards) do
		if card.Visible then
			local data = cardData[card]
			if data then
				setSelection(data)
				return
			end
		end
	end

	resetDetails()
end

local function setSelection(data)
	selected = data
	detailTitle.Text = data.name
	detailType.Text = data.typeLabel
	detailDesc.Text = data.description
	detailPrice.Text = data.priceText
	buyButton.Text = data.actionText
end

buyButton.MouseButton1Click:Connect(function()
	if not selected then
		return
	end
	playClick()
	buyEvent:FireServer({ itemType = selected.itemType, itemId = selected.itemId })
end)

local function makeTab(label, key)
	local tab = Instance.new("TextButton")
	tab.Size = UDim2.new(0, 110, 1, 0)
	tab.BackgroundColor3 = Color3.fromRGB(16, 40, 52)
	tab.TextColor3 = Color3.fromRGB(230, 240, 245)
	tab.Font = Enum.Font.GothamSemibold
	tab.TextSize = 13
	tab.Text = label
	tab.AutoButtonColor = false
	tab.ZIndex = 6
	tab.Parent = tabs

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = tab

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(70, 120, 140)
	stroke.Thickness = 1
	stroke.Parent = tab

	tab.MouseEnter:Connect(function()
		TweenService:Create(tab, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(20, 52, 66) }):Play()
	end)
	tab.MouseLeave:Connect(function()
		local base = key == currentTab and Color3.fromRGB(18, 150, 170) or Color3.fromRGB(16, 40, 52)
		TweenService:Create(tab, TweenInfo.new(0.12), { BackgroundColor3 = base }):Play()
	end)

	tab.MouseButton1Click:Connect(function()
		playClick()
		currentTab = key
		for _, child in ipairs(tabs:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = (child.Name == key) and Color3.fromRGB(18, 150, 170) or Color3.fromRGB(16, 40, 52)
			end
		end
		for _, card in ipairs(cards) do
			card.Visible = (key == "All") or (card:GetAttribute("Category") == key)
		end
		if updateCanvas then
			updateCanvas()
		end
		selectFirstVisible()
	end)

	tab.Name = key
	return tab
end

local function makeCard(data)
	local card = Instance.new("TextButton")
	card.Size = UDim2.new(0, 0, 0, 72)
	card.BackgroundColor3 = Color3.fromRGB(16, 40, 52)
	card.TextColor3 = Color3.fromRGB(240, 240, 240)
	card.Font = Enum.Font.GothamSemibold
	card.TextSize = 13
	card.TextXAlignment = Enum.TextXAlignment.Left
	card.Text = data.name
	card.AutoButtonColor = false
	card.ZIndex = 6
	card.Parent = list
	card:SetAttribute("Category", data.category)
	card.LayoutOrder = data.order

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 40)
	padding.PaddingTop = UDim.new(0, 10)
	padding.Parent = card

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = card

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(70, 120, 140)
	stroke.Thickness = 1
	stroke.Parent = card

	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.new(0, 20, 0, 20)
	icon.Position = UDim2.new(0, 12, 0, 12)
	icon.BackgroundTransparency = 1
	icon.Image = data.imageId or categoryIcons[data.category] or "rbxassetid://0"
	icon.ImageColor3 = Color3.fromRGB(210, 235, 245)
	icon.ZIndex = 7
	icon.Parent = card

	local price = Instance.new("TextLabel")
	price.Size = UDim2.new(1, -12, 0, 16)
	price.Position = UDim2.new(0, 12, 0, 36)
	price.BackgroundTransparency = 1
	price.Font = Enum.Font.Gotham
	price.TextSize = 12
	price.TextColor3 = Color3.fromRGB(190, 220, 235)
	price.TextXAlignment = Enum.TextXAlignment.Left
	price.Text = data.priceText
	price.ZIndex = 7
	price.Parent = card

	card.MouseEnter:Connect(function()
		TweenService:Create(card, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(20, 52, 66) }):Play()
	end)
	card.MouseLeave:Connect(function()
		TweenService:Create(card, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(16, 40, 52) }):Play()
	end)

	card.MouseButton1Click:Connect(function()
		playClick()
		setSelection(data)
	end)

	return card
end

local items = {}

for _, rod in ipairs(RodDatabase.Rods) do
	table.insert(items, {
		itemType = "Rod",
		itemId = rod.id,
		name = rod.name,
		priceText = string.format("%d %s", rod.price, rod.currency),
		typeLabel = "Cana",
		description = string.format("Aumenta raridade em +%d e reduz tempo para %0.1fs.", rod.rarityBonus, rod.speed),
		actionText = "Comprar cana",
		category = "Rods",
		imageId = categoryIcons.Rods,
		order = 10,
	})
end

for _, map in ipairs(MapDatabase.Maps) do
	table.insert(items, {
		itemType = "Map",
		itemId = map.id,
		name = map.name,
		priceText = string.format("%d %s", map.price, map.currency),
		typeLabel = "Mapa",
		description = string.format("Mapa com bonus de raridade +%d. Nivel minimo %d.", map.rarityBonus, map.minLevel),
		actionText = "Comprar mapa",
		category = "Maps",
		imageId = categoryIcons.Maps,
		order = 20,
	})
end

for _, product in ipairs(ProductDatabase.Products) do
	if product.category == "Coins" then
		table.insert(items, {
			itemType = "Coins",
			itemId = product.id,
			name = product.name,
			priceText = product.displayPrice or "Robux",
			typeLabel = "Moedas",
			description = string.format("Recebe %d moedas instantaneamente.", product.amount or 0),
			actionText = "Comprar moedas",
			category = "Coins",
			imageId = categoryIcons.Coins,
			order = 30,
		})
	elseif product.category == "Boost" then
		table.insert(items, {
			itemType = "Boost",
			itemId = product.id,
			name = product.name,
			priceText = product.displayPrice or "Robux",
			typeLabel = "Boost",
			description = string.format("Multiplicador x%d por %d minutos.", product.multiplier or 1, math.floor((product.durationSeconds or 0) / 60)),
			actionText = "Ativar boost",
			category = "Boosts",
			imageId = categoryIcons.Boosts,
			order = 40,
		})
	end
end

makeTab("Todos", "All")
makeTab("Canas", "Rods")
makeTab("Mapas", "Maps")
makeTab("Moedas", "Coins")
makeTab("Boosts", "Boosts")

for _, data in ipairs(items) do
	local card = makeCard(data)
	cardData[card] = data
	table.insert(cards, card)
end

updateCanvas = function()
	local visibleCount = 0
	for _, card in ipairs(cards) do
		if card.Visible then
			visibleCount = visibleCount + 1
		end
	end
	local rows = math.ceil(visibleCount / math.max(1, currentColumns))
	local cellHeight = 72
	local padding = 10
	local total = rows * cellHeight + math.max(0, rows - 1) * padding + 12
	list.CanvasSize = UDim2.new(0, 0, 0, total)
end

for _, card in ipairs(cards) do
	card.Visible = true
end

for _, child in ipairs(tabs:GetChildren()) do
	if child:IsA("TextButton") then
		child.BackgroundColor3 = child.Name == "All" and Color3.fromRGB(18, 150, 170) or Color3.fromRGB(16, 40, 52)
	end
end

updateCanvas()

local function applyTabFilter()
	for _, card in ipairs(cards) do
		card.Visible = (currentTab == "All") or (card:GetAttribute("Category") == currentTab)
	end
	updateCanvas()
	selectFirstVisible()
end

applyTabFilter()

local function layoutPanels()
	local width = frame.AbsoluteSize.X
	if width < 800 then
		leftPanel.Size = UDim2.new(1, 0, 0.6, -70)
		leftPanel.Position = UDim2.new(0, 20, 0, 88)
		rightPanel.Size = UDim2.new(1, 0, 0.4, -40)
		rightPanel.Position = UDim2.new(0, 20, 0.6, 60)
		grid.CellSize = UDim2.new(0.48, 0, 0, 72)
		currentColumns = 2
	else
		leftPanel.Size = UDim2.new(0.62, 0, 1, -100)
		leftPanel.Position = UDim2.new(0, 20, 0, 88)
		rightPanel.Size = UDim2.new(0.34, 0, 1, -100)
		rightPanel.Position = UDim2.new(0.66, 0, 0, 88)
		grid.CellSize = UDim2.new(0.24, 0, 0, 72)
		currentColumns = 4
	end
	updateCanvas()
end

frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutPanels)
layoutPanels()

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
	selectFirstVisible()
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
	if action == "OpenPanel" and panel == "Shop" then
		openPanel()
	elseif action == "CloseAll" then
		closePanel()
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
