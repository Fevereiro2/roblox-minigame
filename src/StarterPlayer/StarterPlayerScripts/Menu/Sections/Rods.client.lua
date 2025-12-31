local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local getProfileRemote = require(ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("GetProfile"))
local getProfile = getProfileRemote()
local getEquipRod = require(ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("EquipRod"))
local equipEvent = getEquipRod()

local RodDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RodDatabase"))

local uiRoot = game:GetService("StarterGui"):WaitForChild("UI")
local Theme = require(uiRoot:WaitForChild("Theme"))
local components = uiRoot:WaitForChild("Components")
local Panel = require(components:WaitForChild("Panel"))
local Colors = Theme.Colors
local Fonts = Theme.Fonts
local BACKGROUND_IMAGE = Theme.Assets.Wallpaper
local cachedUnlocked = {}

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
gui.Name = "RodsUI"
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

local frame = Panel.Create(background, UDim2.fromScale(0.74, 0.76), UDim2.fromScale(0.5, 0.52))
frame.BackgroundTransparency = 0.15
frame.ZIndex = 5

local frameSize = Instance.new("UISizeConstraint")
frameSize.MinSize = Vector2.new(420, 300)
frameSize.MaxSize = Vector2.new(960, 700)
frameSize.Parent = frame

local framePadding = Instance.new("UIPadding")
framePadding.PaddingLeft = UDim.new(0.04, 0)
framePadding.PaddingRight = UDim.new(0.04, 0)
framePadding.PaddingTop = UDim.new(0.04, 0)
framePadding.PaddingBottom = UDim.new(0.04, 0)
framePadding.Parent = frame

local header = Instance.new("Frame")
header.Size = UDim2.fromScale(1, 0.15)
header.BackgroundTransparency = 1
header.ZIndex = 6
header.Parent = frame

local headerLayout = Instance.new("UIListLayout")
headerLayout.FillDirection = Enum.FillDirection.Horizontal
headerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
headerLayout.SortOrder = Enum.SortOrder.LayoutOrder
headerLayout.Padding = UDim.new(0.02, 0)
headerLayout.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(0.7, 1)
title.BackgroundTransparency = 1
title.Font = Fonts.Heading
title.TextSize = 18
title.TextColor3 = Colors.Text
title.Text = "Canas"
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6
title.Parent = header

local backButton = Instance.new("TextButton")
backButton.Size = UDim2.fromScale(0.25, 0.8)
backButton.BackgroundColor3 = Colors.Button
backButton.TextColor3 = Colors.Text
backButton.Font = Fonts.BodyBold
backButton.TextSize = 14
backButton.Text = "< Voltar"
backButton.AutoButtonColor = false
backButton.ZIndex = 6
backButton.Parent = header

local backCorner = Instance.new("UICorner")
backCorner.CornerRadius = UDim.new(0.25, 0)
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

local listClip = Instance.new("Frame")
listClip.Size = UDim2.fromScale(1, 0.82)
listClip.Position = UDim2.fromScale(0, 0.18)
listClip.BackgroundTransparency = 1
listClip.ClipsDescendants = true
listClip.ZIndex = 6
listClip.Parent = frame

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.fromScale(1, 1)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ScrollBarThickness = 6
list.ZIndex = 6
list.Parent = listClip

local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0.02, 0)
listLayout.Parent = list

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	list.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end)

local function clearList()
	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("Frame") or child:IsA("TextLabel") then
			child:Destroy()
		end
	end
end

local function addSection(text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 0)
	label.AutomaticSize = Enum.AutomaticSize.Y
	label.BackgroundTransparency = 1
	label.Font = Fonts.Heading
	label.TextSize = 14
	label.TextColor3 = Colors.TextSoft
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Text = text
	label.ZIndex = 6
	label.Parent = list
end

local RARITY_COLORS = {
	{ min = 6, color = Colors.RarityLegendary },
	{ min = 4, color = Colors.Warning },
	{ min = 2, color = Colors.RarityEpic },
	{ min = 0, color = Colors.TextMuted },
}

local function getRarityColor(rod)
	for _, tier in ipairs(RARITY_COLORS) do
		if rod.rarityBonus >= tier.min then
			return tier.color
		end
	end
	return RARITY_COLORS[#RARITY_COLORS].color
end

local function addRodCard(rod, tag, equipped, locked)
	local row = Instance.new("Frame")
	row.Size = UDim2.fromScale(1, 0)
	row.AutomaticSize = Enum.AutomaticSize.Y
	row.BackgroundColor3 = Colors.Button
	row.BackgroundTransparency = 0.05
	row.BorderSizePixel = 0
	row.ZIndex = 6
	row.Parent = list

	local rowCorner = Instance.new("UICorner")
	rowCorner.CornerRadius = UDim.new(0.2, 0)
	rowCorner.Parent = row

	local rowStroke = Instance.new("UIStroke")
	rowStroke.Color = Colors.PanelStroke
	rowStroke.Thickness = 1
	rowStroke.Parent = row

	local rowPad = Instance.new("UIPadding")
	rowPad.PaddingLeft = UDim.new(0.04, 0)
	rowPad.PaddingRight = UDim.new(0.04, 0)
	rowPad.PaddingTop = UDim.new(0.08, 0)
	rowPad.PaddingBottom = UDim.new(0.08, 0)
	rowPad.Parent = row

	local rowLayout = Instance.new("UIListLayout")
	rowLayout.FillDirection = Enum.FillDirection.Vertical
	rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rowLayout.Padding = UDim.new(0.05, 0)
	rowLayout.Parent = row

	local nameRow = Instance.new("TextLabel")
	nameRow.Size = UDim2.fromScale(1, 0)
	nameRow.AutomaticSize = Enum.AutomaticSize.Y
	nameRow.BackgroundTransparency = 1
	nameRow.Font = Fonts.BodyBold
	nameRow.TextSize = 14
	nameRow.TextColor3 = Colors.Text
	nameRow.TextXAlignment = Enum.TextXAlignment.Left
	if locked then
		nameRow.Text = rod.name .. " (Bloqueada)"
	elseif equipped then
		nameRow.Text = rod.name .. " (Equipada)"
	else
		nameRow.Text = rod.name
	end
	nameRow.ZIndex = 7
	nameRow.Parent = row

	local stats = Instance.new("TextLabel")
	stats.Size = UDim2.fromScale(1, 0)
	stats.AutomaticSize = Enum.AutomaticSize.Y
	stats.BackgroundTransparency = 1
	stats.Font = Enum.Font.Gotham
	stats.TextSize = 12
	stats.TextColor3 = getRarityColor(rod)
	stats.TextXAlignment = Enum.TextXAlignment.Left
	stats.Text = string.format("Raridade +%d | Tempo %0.1fs | %s", rod.rarityBonus, rod.speed, tag)
	stats.ZIndex = 7
	stats.Parent = row

	if locked then
		local priceLabel = Instance.new("TextLabel")
		priceLabel.Size = UDim2.fromScale(1, 0)
		priceLabel.AutomaticSize = Enum.AutomaticSize.Y
		priceLabel.BackgroundTransparency = 1
		priceLabel.Font = Enum.Font.Gotham
		priceLabel.TextSize = 12
		priceLabel.TextColor3 = Colors.TextSoft
		priceLabel.TextXAlignment = Enum.TextXAlignment.Left
		priceLabel.Text = string.format("Preco: %d %s", rod.price, rod.currency)
		priceLabel.ZIndex = 7
		priceLabel.Parent = row
	end

	local equipButton = Instance.new("TextButton")
	equipButton.Size = UDim2.fromScale(1, 0)
	equipButton.AutomaticSize = Enum.AutomaticSize.Y
	if locked then
		equipButton.BackgroundColor3 = Colors.Disabled
	else
		equipButton.BackgroundColor3 = equipped and Colors.Success or Colors.Accent
	end
	equipButton.TextColor3 = Colors.Text
	equipButton.Font = Fonts.BodyBold
	equipButton.TextSize = 14
	if locked then
		equipButton.Text = "Bloqueada"
	elseif equipped then
		equipButton.Text = "Equipada"
	else
		equipButton.Text = "Equipar"
	end
	equipButton.AutoButtonColor = false
	equipButton.ZIndex = 7
	equipButton.Parent = row

	local equipCorner = Instance.new("UICorner")
	equipCorner.CornerRadius = UDim.new(0.25, 0)
	equipCorner.Parent = equipButton

	local equipStroke = Instance.new("UIStroke")
	equipStroke.Color = Colors.AccentHover
	equipStroke.Thickness = 1
	equipStroke.Parent = equipButton

	equipButton.MouseEnter:Connect(function()
		if locked then
			return
		end
		TweenService:Create(equipButton, TweenInfo.new(0.12), { BackgroundColor3 = Colors.AccentHover }):Play()
	end)
	equipButton.MouseLeave:Connect(function()
		if locked then
			return
		end
		local base = equipped and Colors.Success or Colors.Accent
		TweenService:Create(equipButton, TweenInfo.new(0.12), { BackgroundColor3 = base }):Play()
	end)

		equipButton.MouseButton1Click:Connect(function()
			if locked or equipped then
				return
			end
			playClick()
			equipEvent:FireServer(rod.id)
		end)

	if locked then
		local buyButton = Instance.new("TextButton")
		buyButton.Size = UDim2.fromScale(1, 0)
		buyButton.AutomaticSize = Enum.AutomaticSize.Y
		buyButton.BackgroundColor3 = Colors.AccentAlt
		buyButton.TextColor3 = Colors.Text
		buyButton.Font = Fonts.BodyBold
		buyButton.TextSize = 13
		buyButton.Text = "Comprar na loja"
		buyButton.AutoButtonColor = false
		buyButton.ZIndex = 7
		buyButton.Parent = row

		local buyCorner = Instance.new("UICorner")
		buyCorner.CornerRadius = UDim.new(0.25, 0)
		buyCorner.Parent = buyButton

		local buyStroke = Instance.new("UIStroke")
		buyStroke.Color = Colors.AccentHover
		buyStroke.Thickness = 1
		buyStroke.Parent = buyButton

		buyButton.MouseEnter:Connect(function()
			TweenService:Create(buyButton, TweenInfo.new(0.12), { BackgroundColor3 = Colors.AccentAltHover }):Play()
		end)
		buyButton.MouseLeave:Connect(function()
			TweenService:Create(buyButton, TweenInfo.new(0.12), { BackgroundColor3 = Colors.AccentAlt }):Play()
		end)
		buyButton.MouseButton1Click:Connect(function()
			playClick()
			uiBus:Fire("CloseAll")
			uiBus:Fire("OpenPanel", "Shop")
		end)
	end

	if equipped then
		local badge = Instance.new("TextLabel")
		badge.Size = UDim2.fromScale(0.32, 0)
		badge.AutomaticSize = Enum.AutomaticSize.Y
		badge.AnchorPoint = Vector2.new(1, 0)
		badge.Position = UDim2.fromScale(1, 0)
		badge.BackgroundColor3 = Colors.Success
		badge.TextColor3 = Colors.SuccessText
		badge.Font = Fonts.BodyBold
		badge.TextSize = 12
		badge.Text = "EQUIPADA"
		badge.TextXAlignment = Enum.TextXAlignment.Center
		badge.ZIndex = 8
		badge.Parent = row

		local badgeCorner = Instance.new("UICorner")
		badgeCorner.CornerRadius = UDim.new(0.3, 0)
		badgeCorner.Parent = badge

		local badgePad = Instance.new("UIPadding")
		badgePad.PaddingLeft = UDim.new(0.08, 0)
		badgePad.PaddingRight = UDim.new(0.08, 0)
		badgePad.PaddingTop = UDim.new(0.02, 0)
		badgePad.PaddingBottom = UDim.new(0.02, 0)
		badgePad.Parent = badge
	end
end

local function rebuildList(profile)
	clearList()
	local unlocked = profile and profile.UnlockedRods or cachedUnlocked
	local equipped = (profile and profile.EquippedRod) or player:GetAttribute("EquippedRod")
	cachedUnlocked = unlocked or cachedUnlocked

	addSection("Canas default")
	for _, rod in ipairs(RodDatabase.Rods) do
		if rod.id == "rod_basic" then
			addRodCard(rod, "Default", equipped == rod.id)
		end
	end

	addSection("Canas compradas")
	local added = false
	for _, rod in ipairs(RodDatabase.Rods) do
		if rod.id ~= "rod_basic" then
			local isUnlocked = unlocked[rod.id] == true
			addRodCard(rod, isUnlocked and "Comprada" or "Loja", equipped == rod.id, not isUnlocked)
			added = added or isUnlocked
		end
	end

	if not added then
		local empty = Instance.new("TextLabel")
		empty.Size = UDim2.fromScale(1, 0)
		empty.AutomaticSize = Enum.AutomaticSize.Y
		empty.BackgroundTransparency = 1
		empty.Font = Enum.Font.Gotham
		empty.TextSize = 12
		empty.TextColor3 = Colors.TextMuted
		empty.TextXAlignment = Enum.TextXAlignment.Left
		empty.Text = "Sem canas compradas ainda."
		empty.ZIndex = 7
		empty.Parent = list
	end
end

local defaultPos = frame.Position
local isOpen = false
local PANEL_NAME = "Rods"

local function openPanel()
	if isOpen then
		return
	end
	isOpen = true
	gui.Enabled = true
	playerGui:SetAttribute("PanelTarget", "")
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

	local profile
	local ok, result = pcall(function()
		return getProfile:InvokeServer()
	end)
	if ok then
		profile = result
	end
	if not profile then
		profile = { UnlockedRods = { rod_basic = true }, EquippedRod = "rod_basic" }
	end
	rebuildList(profile)
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
	if action == "OpenPanel" and panel == "Rods" then
		openPanel()
	elseif action == "CloseAll" then
		closePanel()
	end
end)

local function checkPanelTarget()
	if playerGui:GetAttribute("PanelTarget") == PANEL_NAME then
		openPanel()
	end
end

playerGui:GetAttributeChangedSignal("PanelTarget"):Connect(checkPanelTarget)
checkPanelTarget()

player:GetAttributeChangedSignal("EquippedRod"):Connect(function()
	if gui.Enabled then
		rebuildList()
	end
end)

equipEvent.OnClientEvent:Connect(function(payload)
	if type(payload) ~= "table" then
		return
	end
	if payload.ok and gui.Enabled then
		rebuildList()
	end
end)

