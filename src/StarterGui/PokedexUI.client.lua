local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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
title.Text = "Pokedex"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -40, 1, -70)
list.Position = UDim2.new(0, 20, 0, 50)
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
		row.Size = UDim2.new(1, 0, 0, 30)
		row.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
		row.TextColor3 = Color3.fromRGB(240, 240, 240)
		row.Font = Enum.Font.GothamSemibold
		row.TextSize = 14
		row.TextXAlignment = Enum.TextXAlignment.Left
		if discovered[fish.id] then
			row.Text = string.format("%s - %s", fish.name, fish.rarity)
		else
			row.Text = "????"
		end
		row.Parent = list
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
