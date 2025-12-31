local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local getFishRequest = require(ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FishRequest"))
local fishEvent = getFishRequest()

local UIBus = require(script.Parent:WaitForChild("UIBus"))
local uiBus = UIBus.Get()
local menuOpen = false

local function syncMenuState()
	local flag = playerGui:GetAttribute("MenuOpen")
	if typeof(flag) == "boolean" then
		menuOpen = flag
	end
end

playerGui:GetAttributeChangedSignal("MenuOpen"):Connect(syncMenuState)
syncMenuState()

local lastRequest = 0
local requestCooldown = 1.0

local function requestFish()
	local now = os.clock()
	if now - lastRequest < requestCooldown then
		return
	end

	lastRequest = now
	fishEvent:FireServer()
end

local function toggleMenu()
	if menuOpen then
		uiBus:Fire("CloseAll")
	else
		uiBus:Fire("OpenPanel", "MainMenu")
	end
end

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if UserInputService:GetFocusedTextBox() then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		requestFish()
	end
end)

ContextActionService:BindAction("ToggleMenu", function(_, state)
	if state ~= Enum.UserInputState.Begin then
		return Enum.ContextActionResult.Pass
	end
	if UserInputService:GetFocusedTextBox() then
		return Enum.ContextActionResult.Pass
	end
	toggleMenu()
	return Enum.ContextActionResult.Sink
end, false, Enum.KeyCode.M)

uiBus.Event:Connect(function(action)
	if action == "RequestFish" then
		requestFish()
	elseif action == "OpenPanel" then
		menuOpen = true
	elseif action == "CloseAll" then
		menuOpen = false
	end
end)

local mobileGui = Instance.new("ScreenGui")
mobileGui.Name = "MobileMenuButton"
mobileGui.ResetOnSpawn = false
mobileGui.IgnoreGuiInset = true
mobileGui.Parent = playerGui

local menuButton = Instance.new("TextButton")
menuButton.Size = UDim2.new(0, 120, 0, 44)
menuButton.Position = UDim2.new(1, -136, 1, -70)
menuButton.BackgroundColor3 = Color3.fromRGB(16, 40, 52)
menuButton.TextColor3 = Color3.fromRGB(240, 240, 240)
menuButton.Font = Enum.Font.GothamSemibold
menuButton.TextSize = 16
menuButton.Text = "Menu"
menuButton.AutoButtonColor = false
menuButton.Visible = true
menuButton.Parent = mobileGui

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 12)
menuCorner.Parent = menuButton

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.fromRGB(70, 120, 140)
menuStroke.Thickness = 1
menuStroke.Parent = menuButton

menuButton.MouseEnter:Connect(function()
	TweenService:Create(menuButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(20, 52, 66) }):Play()
end)
menuButton.MouseLeave:Connect(function()
	TweenService:Create(menuButton, TweenInfo.new(0.12), { BackgroundColor3 = Color3.fromRGB(16, 40, 52) }):Play()
end)
menuButton.MouseButton1Click:Connect(function()
	toggleMenu()
end)
