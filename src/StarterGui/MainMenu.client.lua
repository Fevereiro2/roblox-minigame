local Players = game:GetService("Players")

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
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 320)
frame.Position = UDim2.new(0.5, -180, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(240, 240, 240)
title.Text = "Fishing Game"
title.Parent = frame

local function makeButton(label, order)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 280, 0, 36)
	button.Position = UDim2.new(0.5, -140, 0, 60 + (order - 1) * 40)
	button.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
	button.TextColor3 = Color3.fromRGB(240, 240, 240)
	button.Font = Enum.Font.GothamSemibold
	button.TextSize = 16
	button.Text = label
	button.Parent = frame
	return button
end

makeButton("Jogar", 1).MouseButton1Click:Connect(function()
	uiBus:Fire("OpenPanel", "MapSelection")
	gui.Enabled = false
end)

makeButton("Shop", 2).MouseButton1Click:Connect(function()
	uiBus:Fire("OpenPanel", "Shop")
	gui.Enabled = false
end)

makeButton("Peixes", 3).MouseButton1Click:Connect(function()
	uiBus:Fire("OpenPanel", "Pokedex")
	gui.Enabled = false
end)

makeButton("Personagem", 4).MouseButton1Click:Connect(function()
	uiBus:Fire("OpenPanel", "Character")
end)

makeButton("Canas", 5).MouseButton1Click:Connect(function()
	uiBus:Fire("OpenPanel", "Rods")
end)

makeButton("Mapas", 6).MouseButton1Click:Connect(function()
	uiBus:Fire("OpenPanel", "MapSelection")
	gui.Enabled = false
end)

uiBus.Event:Connect(function(action, panel)
	if action == "OpenPanel" and (panel == "MainMenu" or panel == nil) then
		gui.Enabled = true
	end
end)
