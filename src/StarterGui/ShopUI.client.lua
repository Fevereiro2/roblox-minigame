local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local getBuyItem = require(ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("BuyItem"))
local buyEvent = getBuyItem()
local getProfileRemote = require(ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetProfile"))
local getProfile = getProfileRemote()

local RodDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RodDatabase"))
local MapDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MapDatabase"))
local ProductDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ProductDatabase"))

local BACKGROUND_IMAGE = "rbxassetid://88755976907991"

local categoryIcons = {
	Rods = "rbxassetid://0",
	Maps = "rbxassetid://0",
	Coins = "rbxassetid://0",
	Boosts = "rbxassetid://0",
}

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

	return background
end

local background = buildBackground(gui)
local fade = addFade(background)

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.fromScale(0.86, 0.84)
frame.Position = UDim2.fromScale(0.5, 0.52)
frame.BackgroundColor3 = Color3.fromRGB(10, 26, 34)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.ZIndex = 5
frame.Parent = background

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0.04, 0)
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(90, 150, 170)
frameStroke.Thickness = 1
frameStroke.Parent = frame

local frameSize = Instance.new("UISizeConstraint")
frameSize.MinSize = Vector2.new(560, 360)
frameSize.MaxSize = Vector2.new(1100, 760)
frameSize.Parent = frame

local mainPadding = Instance.new("UIPadding")
mainPadding.PaddingLeft = UDim.new(0.03, 0)
mainPadding.PaddingRight = UDim.new(0.03, 0)
mainPadding.PaddingTop = UDim.new(0.03, 0)
mainPadding.PaddingBottom = UDim.new(0.03, 0)
mainPadding.Parent = frame

local container = Instance.new("Frame")
container.Size = UDim2.fromScale(1, 1)
container.BackgroundTransparency = 1
container.ZIndex = 6
container.Parent = frame

local containerLayout = Instance.new("UIListLayout")
containerLayout.FillDirection = Enum.FillDirection.Vertical
containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
containerLayout.Padding = UDim.new(0.025, 0)
containerLayout.Parent = container

local header = Instance.new("Frame")
header.Size = UDim2.fromScale(1, 0.14)
header.BackgroundTransparency = 1
header.ZIndex = 6
header.Parent = container

local headerLayout = Instance.new("UIListLayout")
headerLayout.FillDirection = Enum.FillDirection.Vertical
headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
headerLayout.Padding = UDim.new(0.15, 0)
headerLayout.Parent = header

local titleRow = Instance.new("Frame")
titleRow.Size = UDim2.fromScale(1, 0.45)
titleRow.BackgroundTransparency = 1
titleRow.ZIndex = 6
titleRow.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(0.6, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Text = "Loja"
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6
title.Parent = titleRow

local coinsPanel = Instance.new("Frame")
coinsPanel.Size = UDim2.fromScale(0.4, 1)
coinsPanel.AnchorPoint = Vector2.new(1, 0)
coinsPanel.Position = UDim2.fromScale(1, 0)
coinsPanel.BackgroundTransparency = 1
coinsPanel.ZIndex = 6
coinsPanel.Parent = titleRow

local coinsLayout = Instance.new("UIListLayout")
coinsLayout.FillDirection = Enum.FillDirection.Vertical
coinsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
coinsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
coinsLayout.SortOrder = Enum.SortOrder.LayoutOrder
coinsLayout.Parent = coinsPanel

local coinsLabel = Instance.new("TextLabel")
coinsLabel.Size = UDim2.fromScale(1, 0.5)
coinsLabel.BackgroundTransparency = 1
coinsLabel.Font = Enum.Font.GothamSemibold
coinsLabel.TextSize = 14
coinsLabel.TextColor3 = Color3.fromRGB(230, 240, 245)
coinsLabel.Text = "Moedas: 0"
coinsLabel.TextXAlignment = Enum.TextXAlignment.Right
coinsLabel.ZIndex = 6
coinsLabel.Parent = coinsPanel

local purchasedLabel = Instance.new("TextLabel")
purchasedLabel.Size = UDim2.fromScale(1, 0.5)
purchasedLabel.BackgroundTransparency = 1
purchasedLabel.Font = Enum.Font.Gotham
purchasedLabel.TextSize = 12
purchasedLabel.TextColor3 = Color3.fromRGB(170, 210, 220)
purchasedLabel.Text = "Compradas: 0"
purchasedLabel.TextXAlignment = Enum.TextXAlignment.Right
purchasedLabel.ZIndex = 6
purchasedLabel.Parent = coinsPanel

local tabsRow = Instance.new("Frame")
tabsRow.Size = UDim2.fromScale(1, 0.45)
tabsRow.BackgroundTransparency = 1
tabsRow.ZIndex = 6
tabsRow.Parent = header

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0.015, 0)
tabsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabsLayout.Parent = tabsRow

local body = Instance.new("Frame")
body.Size = UDim2.fromScale(1, 0.8)
body.BackgroundTransparency = 1
body.ZIndex = 6
body.Parent = container

local bodyLayout = Instance.new("UIListLayout")
bodyLayout.FillDirection = Enum.FillDirection.Horizontal
bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
bodyLayout.Padding = UDim.new(0.02, 0)
bodyLayout.Parent = body

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.fromScale(0.64, 1)
leftPanel.BackgroundTransparency = 1
leftPanel.ZIndex = 6
leftPanel.Parent = body

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.fromScale(0.34, 1)
rightPanel.BackgroundColor3 = Color3.fromRGB(16, 40, 52)
rightPanel.BackgroundTransparency = 0.1
rightPanel.BorderSizePixel = 0
rightPanel.ZIndex = 6
rightPanel.Parent = body

local rightCorner = Instance.new("UICorner")
rightCorner.CornerRadius = UDim.new(0.06, 0)
rightCorner.Parent = rightPanel

local rightStroke = Instance.new("UIStroke")
rightStroke.Color = Color3.fromRGB(70, 120, 140)
rightStroke.Thickness = 1
rightStroke.Parent = rightPanel

local rightPad = Instance.new("UIPadding")
rightPad.PaddingLeft = UDim.new(0.05, 0)
rightPad.PaddingRight = UDim.new(0.05, 0)
rightPad.PaddingTop = UDim.new(0.05, 0)
rightPad.PaddingBottom = UDim.new(0.05, 0)
rightPad.Parent = rightPanel

local rightLayout = Instance.new("UIListLayout")
rightLayout.FillDirection = Enum.FillDirection.Vertical
rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
rightLayout.Padding = UDim.new(0.03, 0)
rightLayout.Parent = rightPanel

local detailTitle = Instance.new("TextLabel")
detailTitle.Size = UDim2.fromScale(1, 0.12)
detailTitle.BackgroundTransparency = 1
detailTitle.Font = Enum.Font.GothamBold
detailTitle.TextSize = 16
detailTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
detailTitle.Text = "Selecione um item"
detailTitle.TextXAlignment = Enum.TextXAlignment.Left
detailTitle.ZIndex = 7
detailTitle.Parent = rightPanel

local detailType = Instance.new("TextLabel")
detailType.Size = UDim2.fromScale(1, 0.08)
detailType.BackgroundTransparency = 1
detailType.Font = Enum.Font.Gotham
detailType.TextSize = 12
detailType.TextColor3 = Color3.fromRGB(170, 210, 220)
detailType.Text = ""
detailType.TextXAlignment = Enum.TextXAlignment.Left
detailType.ZIndex = 7
detailType.Parent = rightPanel

local detailDesc = Instance.new("TextLabel")
detailDesc.Size = UDim2.fromScale(1, 0.45)
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
detailPrice.Size = UDim2.fromScale(1, 0.08)
detailPrice.BackgroundTransparency = 1
detailPrice.Font = Enum.Font.GothamSemibold
detailPrice.TextSize = 14
detailPrice.TextColor3 = Color3.fromRGB(240, 240, 240)
detailPrice.Text = ""
detailPrice.TextXAlignment = Enum.TextXAlignment.Left
detailPrice.ZIndex = 7
detailPrice.Parent = rightPanel

local buyButton = Instance.new("TextButton")
buyButton.Size = UDim2.fromScale(1, 0.16)
buyButton.BackgroundColor3 = Color3.fromRGB(18, 150, 170)
buyButton.TextColor3 = Color3.fromRGB(245, 245, 245)
buyButton.Font = Enum.Font.GothamSemibold
buyButton.TextSize = 16
buyButton.Text = "Comprar"
buyButton.AutoButtonColor = false
buyButton.ZIndex = 7
buyButton.Parent = rightPanel

local buyCorner = Instance.new("UICorner")
buyCorner.CornerRadius = UDim.new(0.2, 0)
buyCorner.Parent = buyButton

local buyStroke = Instance.new("UIStroke")
buyStroke.Color = Color3.fromRGB(140, 230, 245)
buyStroke.Thickness = 1
buyStroke.Parent = buyButton

buyButton.MouseEnter:Connect(function()
	if not buyButton.Active then
		return
	end
	TweenService:Create(buyButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(26, 170, 190) }):Play()
end)
buyButton.MouseLeave:Connect(function()
	if not buyButton.Active then
		return
	end
	TweenService:Create(buyButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(18, 150, 170) }):Play()
end)

local listContainer = Instance.new("Frame")
listContainer.Size = UDim2.fromScale(1, 1)
listContainer.BackgroundTransparency = 1
listContainer.ZIndex = 6
listContainer.Parent = leftPanel

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0.06, 0)
listCorner.Parent = listContainer

local listClip = Instance.new("Frame")
listClip.Size = UDim2.fromScale(1, 1)
listClip.BackgroundTransparency = 1
listClip.ClipsDescendants = true
listClip.Parent = listContainer

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.fromScale(1, 1)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ScrollBarThickness = 6
list.ZIndex = 6
list.Parent = listClip

local grid = Instance.new("UIGridLayout")
grid.CellPadding = UDim2.new(0.02, 0, 0.02, 0)
grid.CellSize = UDim2.new(0.24, 0, 0.22, 0)
grid.SortOrder = Enum.SortOrder.LayoutOrder
grid.Parent = list

grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	list.CanvasSize = UDim2.new(0, 0, 0, grid.AbsoluteContentSize.Y + 8)
end)

local backButton = Instance.new("TextButton")
backButton.Size = UDim2.fromScale(0.12, 0.36)
backButton.AnchorPoint = Vector2.new(1, 0)
backButton.Position = UDim2.fromScale(1, 0)
backButton.BackgroundColor3 = Color3.fromRGB(16, 40, 52)
backButton.TextColor3 = Color3.fromRGB(220, 230, 240)
backButton.Font = Enum.Font.GothamSemibold
backButton.TextSize = 14
backButton.Text = "Voltar"
backButton.AutoButtonColor = false
backButton.ZIndex = 6
backButton.Parent = titleRow

local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0.2, 0)
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

local selected
local currentTab = "All"
local cards = {}
local cardData = {}
local ownedRods = {}
local ownedMaps = {}

local function resetDetails()
	selected = nil
	detailTitle.Text = "Selecione um item"
	detailType.Text = ""
	detailDesc.Text = "Clique num item para ver detalhes."
	detailPrice.Text = ""
	buyButton.Text = "Comprar"
	buyButton.Active = false
	buyButton.BackgroundColor3 = Color3.fromRGB(70, 90, 100)
end

local function setBuyState(owned)
	if owned then
		buyButton.Text = "Comprado"
		buyButton.Active = false
		buyButton.BackgroundColor3 = Color3.fromRGB(70, 90, 100)
	else
		buyButton.Active = true
		buyButton.BackgroundColor3 = Color3.fromRGB(18, 150, 170)
	end
end

local function setSelection(data)
	selected = data
	detailTitle.Text = data.name
	detailType.Text = data.typeLabel
	detailDesc.Text = data.description
	detailPrice.Text = data.priceText
	buyButton.Text = data.actionText
	if data.ownable then
		setBuyState(data.owned == true)
	else
		setBuyState(false)
	end
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

local function updateCoins()
	local coins = player:GetAttribute("Coins")
	local purchased = player:GetAttribute("PurchasedCoins")
	if typeof(coins) ~= "number" then
		coins = 0
	end
	if typeof(purchased) ~= "number" then
		purchased = 0
	end
	coinsLabel.Text = string.format("Moedas: %d", coins)
	purchasedLabel.Text = string.format("Compradas: %d", purchased)
end

player:GetAttributeChangedSignal("Coins"):Connect(updateCoins)
player:GetAttributeChangedSignal("PurchasedCoins"):Connect(updateCoins)
updateCoins()

buyButton.MouseButton1Click:Connect(function()
	if not selected then
		return
	end
	playClick()
	buyEvent:FireServer({ itemType = selected.itemType, itemId = selected.itemId })
end)

local function makeTab(label, key)
	local tab = Instance.new("TextButton")
	tab.Size = UDim2.fromScale(0.16, 1)
	tab.BackgroundColor3 = Color3.fromRGB(16, 40, 52)
	tab.TextColor3 = Color3.fromRGB(230, 240, 245)
	tab.Font = Enum.Font.GothamSemibold
	tab.TextSize = 13
	tab.Text = label
	tab.AutoButtonColor = false
	tab.ZIndex = 6
	tab.Parent = tabsRow

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
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
		for _, child in ipairs(tabsRow:GetChildren()) do
			if child:IsA("TextButton") then
				child.BackgroundColor3 = (child.Name == key) and Color3.fromRGB(18, 150, 170) or Color3.fromRGB(16, 40, 52)
			end
		end
		for _, card in ipairs(cards) do
			card.Visible = (key == "All") or (card:GetAttribute("Category") == key)
		end
		selectFirstVisible()
	end)

	tab.Name = key
	return tab
end

local function makeCard(data)
	local card = Instance.new("TextButton")
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

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = card

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(70, 120, 140)
	stroke.Thickness = 1
	stroke.Parent = card

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0.18, 0)
	padding.PaddingTop = UDim.new(0.12, 0)
	padding.Parent = card

	local icon = Instance.new("ImageLabel")
	icon.Size = UDim2.fromScale(0.16, 0.5)
	icon.Position = UDim2.fromScale(0.08, 0.18)
	icon.BackgroundTransparency = 1
	icon.Image = data.imageId or categoryIcons[data.category] or "rbxassetid://0"
	icon.ImageColor3 = Color3.fromRGB(210, 235, 245)
	icon.ZIndex = 7
	icon.Parent = card

	local price = Instance.new("TextLabel")
	price.Size = UDim2.fromScale(0.8, 0.25)
	price.Position = UDim2.fromScale(0.18, 0.52)
	price.BackgroundTransparency = 1
	price.Font = Enum.Font.Gotham
	price.TextSize = 12
	price.TextColor3 = Color3.fromRGB(190, 220, 235)
	price.TextXAlignment = Enum.TextXAlignment.Left
	price.Text = data.priceText
	price.ZIndex = 7
	price.Parent = card

	local badge
	if data.ownable then
		badge = Instance.new("TextLabel")
		badge.Size = UDim2.fromScale(0.45, 0.3)
		badge.AnchorPoint = Vector2.new(1, 0)
		badge.Position = UDim2.fromScale(1, 0)
		badge.BackgroundColor3 = Color3.fromRGB(30, 90, 70)
		badge.TextColor3 = Color3.fromRGB(235, 255, 245)
		badge.Font = Enum.Font.GothamSemibold
		badge.TextSize = 11
		badge.Text = "OWNED"
		badge.TextXAlignment = Enum.TextXAlignment.Center
		badge.Visible = false
		badge.ZIndex = 8
		badge.Parent = card

		local badgeCorner = Instance.new("UICorner")
		badgeCorner.CornerRadius = UDim.new(0.3, 0)
		badgeCorner.Parent = badge
	end

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

	data.badge = badge
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
		order = 10,
		imageId = categoryIcons.Rods,
		ownable = true,
		owned = false,
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
		order = 20,
		imageId = categoryIcons.Maps,
		ownable = true,
		owned = false,
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
			order = 30,
			imageId = categoryIcons.Coins,
			ownable = false,
			owned = false,
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
			order = 40,
			imageId = categoryIcons.Boosts,
			ownable = false,
			owned = false,
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

local function applyTabFilter()
	for _, card in ipairs(cards) do
		card.Visible = (currentTab == "All") or (card:GetAttribute("Category") == currentTab)
	end
	selectFirstVisible()
end

applyTabFilter()

local function layoutPanels()
	local width = frame.AbsoluteSize.X
	if width < 760 then
		bodyLayout.FillDirection = Enum.FillDirection.Vertical
		leftPanel.Size = UDim2.fromScale(1, 0.62)
		rightPanel.Size = UDim2.fromScale(1, 0.38)
		grid.CellSize = UDim2.new(0.48, 0, 0.3, 0)
		backButton.Size = UDim2.fromScale(0.2, 0.7)
		for _, tab in ipairs(tabsRow:GetChildren()) do
			if tab:IsA("TextButton") then
				tab.Size = UDim2.fromScale(0.22, 1)
			end
		end
	else
		bodyLayout.FillDirection = Enum.FillDirection.Horizontal
		leftPanel.Size = UDim2.fromScale(0.64, 1)
		rightPanel.Size = UDim2.fromScale(0.34, 1)
		grid.CellSize = UDim2.new(0.24, 0, 0.22, 0)
		backButton.Size = UDim2.fromScale(0.12, 0.9)
		for _, tab in ipairs(tabsRow:GetChildren()) do
			if tab:IsA("TextButton") then
				tab.Size = UDim2.fromScale(0.16, 1)
			end
		end
	end
end

frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutPanels)
layoutPanels()

local defaultPos = frame.Position
local isOpen = false

local function openPanel()
	if isOpen then
		return
	end
	isOpen = true
	gui.Enabled = true
	fade.BackgroundTransparency = 0
	frame.Position = defaultPos + UDim2.new(0, 0, 0, 0.02)
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
	layoutPanels()
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
		Position = defaultPos + UDim2.new(0, 0, 0, 0.02),
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
		isOpen = false
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
