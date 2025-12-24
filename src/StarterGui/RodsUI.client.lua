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
gui.Name = "RodsUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Enabled = false
gui.Parent = playerGui

local background = Instance.new("Frame")
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(10, 18, 24)
background.BorderSizePixel = 0
background.Parent = gui

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 22, 28)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(7, 44, 58)),
})
gradient.Rotation = 120
gradient.Parent = background

local frame = Instance.new("Frame")
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Size = UDim2.new(0.6, 0, 0.6, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
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
title.Text = "Canas"
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

local body = Instance.new("TextLabel")
body.Size = UDim2.new(1, -40, 0, 120)
body.Position = UDim2.new(0, 20, 0, 100)
body.BackgroundTransparency = 1
body.Font = Enum.Font.Gotham
body.TextSize = 14
body.TextColor3 = Color3.fromRGB(190, 220, 235)
body.Text = "Detalhes das canas e upgrades em breve."
body.TextXAlignment = Enum.TextXAlignment.Left
body.TextYAlignment = Enum.TextYAlignment.Top
body.TextWrapped = true
body.Parent = frame

uiBus.Event:Connect(function(action, panel)
	if action == "OpenPanel" and panel == "Rods" then
		gui.Enabled = true
	elseif action == "CloseAll" then
		gui.Enabled = false
	end
end)
