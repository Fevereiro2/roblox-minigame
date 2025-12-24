local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local getSelectMap = require(ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SelectMap"))
local selectEvent = getSelectMap()

local MapDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MapDatabase"))

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
gui.Name = "MapSelectionUI"
gui.ResetOnSpawn = false
gui.Enabled = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 520, 0, 360)
frame.Position = UDim2.new(0.5, -260, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Position = UDim2.new(0, 20, 0, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Text = "Selecione um Mapa"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 24)
statusLabel.Position = UDim2.new(0, 20, 0, 44)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 14
statusLabel.Text = ""
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = frame

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -40, 1, -90)
list.Position = UDim2.new(0, 20, 0, 70)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ScrollBarThickness = 6
list.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = list

local function addMapButton(map)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 36)
	button.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
	button.TextColor3 = Color3.fromRGB(240, 240, 240)
	button.Font = Enum.Font.GothamSemibold
	button.TextSize = 14
	button.Text = string.format("%s - %d %s", map.name, map.price, map.currency)
	button.Parent = list
	button.MouseButton1Click:Connect(function()
		selectEvent:FireServer(map.id)
	end)
end

for _, map in ipairs(MapDatabase.Maps) do
	addMapButton(map)
end

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
end)

uiBus.Event:Connect(function(action, panel)
	if action == "OpenPanel" and panel == "MapSelection" then
		gui.Enabled = true
	elseif action == "CloseAll" then
		gui.Enabled = false
	end
end)

selectEvent.OnClientEvent:Connect(function(payload)
	if type(payload) ~= "table" then
		return
	end

	if payload.ok then
		statusLabel.Text = "Mapa selecionado"
		uiBus:Fire("CloseAll")
		uiBus:Fire("OpenPanel", "MainMenu")
	else
		statusLabel.Text = "Mapa bloqueado"
	end
end)
