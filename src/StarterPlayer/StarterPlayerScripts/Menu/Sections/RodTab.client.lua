local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local uiRoot = game:GetService("StarterGui"):WaitForChild("UI")
local Theme = require(uiRoot:WaitForChild("Theme"))
local rodTabRoot = uiRoot:WaitForChild("RodTab")
local RodTabUI = require(rodTabRoot:WaitForChild("RodTabUI"))
local Slots = require(rodTabRoot:WaitForChild("Slots"))
local PreviewStats = require(rodTabRoot:WaitForChild("PreviewStats"))

local sampleItems = require(ReplicatedStorage:WaitForChild("Items"):WaitForChild("SampleItems"))

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
gui.Name = "RodTabUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Enabled = false
gui.Parent = playerGui

local ui = RodTabUI.Create(gui)

ui.ItemsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ui.ItemsList.CanvasSize = UDim2.new(0, 0, 0, ui.ItemsLayout.AbsoluteContentSize.Y + 6)
end)

local slotDefinitions = {
	{ key = "Rod", label = "Slot Vara" },
	{ key = "Reel", label = "Slot Carreto" },
	{ key = "Line", label = "Slot Linha" },
	{ key = "Hook", label = "Slot Anzol" },
}

local equipped = {
	Rod = nil,
	Reel = nil,
	Line = nil,
	Hook = nil,
}

local slots = {}
local selectedSlot = slotDefinitions[1].key
local selectedItem = nil
local itemButtons = {}

local preview = PreviewStats.Create(ui.StatsContainer)

local function updatePreview()
	local totals = { strength = 0, maxWeight = 0, breakChance = 0, efficiency = 0 }
	for _, item in pairs(equipped) do
		if item and item.stats then
			totals.strength += item.stats.strength or 0
			totals.maxWeight += item.stats.maxWeight or 0
			totals.breakChance += item.stats.breakChance or 0
			totals.efficiency += item.stats.efficiency or 0
		end
	end
	totals.breakChance = math.clamp(totals.breakChance, 0, 100)
	preview.Update(totals)
end

local function updateSlotUI(slotKey)
	local slot = slots[slotKey]
	if slot then
		slot.SetItem(equipped[slotKey])
	end
end

local function clearItemList()
	for _, child in ipairs(ui.ItemsList:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
	itemButtons = {}
	selectedItem = nil
end

local function setSelectedButton(button)
	for btn, _ in pairs(itemButtons) do
		btn.BackgroundColor3 = Theme.Colors.Button
	end
	if button then
		button.BackgroundColor3 = Theme.Colors.ButtonHover
	end
end

local function equipItem(item)
	if not item or not selectedSlot then
		return
	end
	equipped[selectedSlot] = item
	updateSlotUI(selectedSlot)
	updatePreview()
	uiBus:Fire("Notify", "Peca equipada")
end

local function makeItemButton(item)
	local button = Instance.new("TextButton")
	button.Size = UDim2.fromScale(1, 0)
	button.AutomaticSize = Enum.AutomaticSize.Y
	button.BackgroundColor3 = Theme.Colors.Button
	button.Text = ""
	button.AutoButtonColor = false
	button.ZIndex = 8
	button.Parent = ui.ItemsList

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = button

	local stroke = Instance.new("UIStroke")
	stroke.Color = Theme.Colors.PanelStroke
	stroke.Thickness = 1
	stroke.Parent = button

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0.05, 0)
	padding.PaddingRight = UDim.new(0.05, 0)
	padding.PaddingTop = UDim.new(0.08, 0)
	padding.PaddingBottom = UDim.new(0.08, 0)
	padding.Parent = button

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0.03, 0)
	layout.Parent = button

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.fromScale(1, 0)
	nameLabel.AutomaticSize = Enum.AutomaticSize.Y
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Theme.Fonts.BodyBold
	nameLabel.TextSize = 13
	nameLabel.TextColor3 = Theme.Colors.Text
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Text = item.name
	nameLabel.ZIndex = 9
	nameLabel.Parent = button

	local statsLabel = Instance.new("TextLabel")
	statsLabel.Size = UDim2.fromScale(1, 0)
	statsLabel.AutomaticSize = Enum.AutomaticSize.Y
	statsLabel.BackgroundTransparency = 1
	statsLabel.Font = Theme.Fonts.Body
	statsLabel.TextSize = 12
	statsLabel.TextColor3 = Theme.Colors.TextMuted
	statsLabel.TextXAlignment = Enum.TextXAlignment.Left
	statsLabel.Text = string.format("Forca +%d | Peso +%d | Ef %d", item.stats.strength, item.stats.maxWeight, item.stats.efficiency)
	statsLabel.ZIndex = 9
	statsLabel.Parent = button

	local durability = 0
	if item.durability and item.durability.max > 0 then
		durability = math.floor((item.durability.current / item.durability.max) * 100)
	end

	local durabilityLabel = Instance.new("TextLabel")
	durabilityLabel.Size = UDim2.fromScale(1, 0)
	durabilityLabel.AutomaticSize = Enum.AutomaticSize.Y
	durabilityLabel.BackgroundTransparency = 1
	durabilityLabel.Font = Theme.Fonts.Body
	durabilityLabel.TextSize = 11
	durabilityLabel.TextColor3 = Theme.Colors.TextSoft
	durabilityLabel.TextXAlignment = Enum.TextXAlignment.Left
	durabilityLabel.Text = string.format("Durabilidade: %d%%", durability)
	durabilityLabel.ZIndex = 9
	durabilityLabel.Parent = button

	button.MouseEnter:Connect(function()
		if selectedItem ~= item then
			TweenService:Create(button, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Colors.ButtonHover }):Play()
		end
	end)
	button.MouseLeave:Connect(function()
		if selectedItem ~= item then
			TweenService:Create(button, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Colors.Button }):Play()
		end
	end)
	button.MouseButton1Click:Connect(function()
		playClick()
		selectedItem = item
		setSelectedButton(button)
		equipItem(item)
	end)

	itemButtons[button] = item
end

local function rebuildItemList()
	clearItemList()
	for _, item in ipairs(sampleItems.Items or {}) do
		if item.slotType == selectedSlot then
			makeItemButton(item)
		end
	end
end

local function setSelectedSlot(slotKey)
	selectedSlot = slotKey
	for key, slot in pairs(slots) do
		slot.SetSelected(key == slotKey)
	end
	rebuildItemList()
end

for _, definition in ipairs(slotDefinitions) do
	local slot = Slots.Create(ui.SlotsContainer, definition)
	slots[definition.key] = slot
	slot.Root.MouseButton1Click:Connect(function()
		playClick()
		setSelectedSlot(definition.key)
	end)
	updateSlotUI(definition.key)
end

setSelectedSlot(selectedSlot)
updatePreview()

ui.EquipButton.MouseEnter:Connect(function()
	TweenService:Create(ui.EquipButton, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Colors.AccentHover }):Play()
end)
ui.EquipButton.MouseLeave:Connect(function()
	TweenService:Create(ui.EquipButton, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Colors.Accent }):Play()
end)
ui.EquipButton.MouseButton1Click:Connect(function()
	playClick()
	if selectedItem then
		equipItem(selectedItem)
	else
		uiBus:Fire("Notify", "Escolha uma peca")
	end
end)

ui.RemoveButton.MouseEnter:Connect(function()
	TweenService:Create(ui.RemoveButton, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Colors.ButtonHover }):Play()
end)
ui.RemoveButton.MouseLeave:Connect(function()
	TweenService:Create(ui.RemoveButton, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Colors.Button }):Play()
end)
ui.RemoveButton.MouseButton1Click:Connect(function()
	playClick()
	if selectedSlot then
		equipped[selectedSlot] = nil
		updateSlotUI(selectedSlot)
		updatePreview()
		uiBus:Fire("Notify", "Peca removida")
	end
end)

ui.BackButton.MouseEnter:Connect(function()
	TweenService:Create(ui.BackButton, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Colors.ButtonHover }):Play()
end)
ui.BackButton.MouseLeave:Connect(function()
	TweenService:Create(ui.BackButton, TweenInfo.new(0.12), { BackgroundColor3 = Theme.Colors.Button }):Play()
end)
ui.BackButton.MouseButton1Click:Connect(function()
	playClick()
	uiBus:Fire("CloseAll")
	uiBus:Fire("OpenPanel", "MainMenu")
end)

local function layoutPanels()
	local width = ui.Frame.AbsoluteSize.X
	if width < 780 then
		ui.BodyLayout.FillDirection = Enum.FillDirection.Vertical
	else
		ui.BodyLayout.FillDirection = Enum.FillDirection.Horizontal
	end
end

ui.Frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(layoutPanels)
layoutPanels()

local defaultPos = ui.Frame.Position
local isOpen = false
local PANEL_NAME = "RodTab"

local function openPanel()
	if isOpen then
		return
	end
	isOpen = true
	gui.Enabled = true
	playerGui:SetAttribute("PanelTarget", "")
	ui.Fade.BackgroundTransparency = 0
	ui.Frame.Position = defaultPos + UDim2.new(0, 0, 0, 0.02)
	TweenService:Create(ui.Fade, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1,
	}):Play()
	TweenService:Create(ui.Frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = defaultPos,
	}):Play()
	TweenService:Create(getBlur(), TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = 12,
	}):Play()
	TweenService:Create(getDepth(), TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		FarIntensity = 0.25,
		NearIntensity = 0.15,
	}):Play()
	rebuildItemList()
end

local function closePanel()
	if playerGui:GetAttribute("PanelTarget") == PANEL_NAME then
		return
	end
	if not gui.Enabled then
		return
	end
	TweenService:Create(ui.Fade, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 0,
	}):Play()
	TweenService:Create(ui.Frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
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
		ui.Frame.Position = defaultPos
		ui.Fade.BackgroundTransparency = 1
		isOpen = false
	end)
end

uiBus.Event:Connect(function(action, panel)
	if action == "OpenPanel" and panel == PANEL_NAME then
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
