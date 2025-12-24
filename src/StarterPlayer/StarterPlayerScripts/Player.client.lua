local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local getFishRequest = require(ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FishRequest"))
local fishEvent = getFishRequest()

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
local camera = Workspace.CurrentCamera or Workspace:WaitForChild("Camera")
local menuCameraCFrame = CFrame.new(0, 12, 32) * CFrame.Angles(0, math.rad(180), 0)
local menuOpen = false

local function sinkAction()
	return Enum.ContextActionResult.Sink
end

local function lockControls()
	ContextActionService:BindAction("BlockMovement", sinkAction, false,
		Enum.KeyCode.W,
		Enum.KeyCode.A,
		Enum.KeyCode.S,
		Enum.KeyCode.D,
		Enum.KeyCode.Space,
		Enum.KeyCode.LeftShift,
		Enum.KeyCode.RightShift
	)
	ContextActionService:BindAction("BlockThumbstick", sinkAction, false, Enum.KeyCode.Thumbstick1)
end

local function unlockControls()
	ContextActionService:UnbindAction("BlockMovement")
	ContextActionService:UnbindAction("BlockThumbstick")
end

local function setMenuCamera()
	if camera then
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = menuCameraCFrame
	end
end

local function ensureSound(name, soundId, volume, looped)
	local sound = SoundService:FindFirstChild(name)
	if not sound then
		sound = Instance.new("Sound")
		sound.Name = name
		sound.SoundId = soundId
		sound.Volume = volume
		sound.Looped = looped
		sound.Parent = SoundService
	end
	return sound
end

local ambient = ensureSound("AmbientWaves", "rbxassetid://0", 0.3, true)
if not ambient.IsPlaying then
	ambient:Play()
end

ensureSound("UIClick", "rbxassetid://0", 0.6, false)

lockControls()
setMenuCamera()

local hud = Instance.new("ScreenGui")
hud.Name = "FishingHud"
hud.ResetOnSpawn = false
hud.Parent = playerGui

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(0, 360, 0, 40)
infoLabel.Position = UDim2.new(0, 16, 0, 16)
infoLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
infoLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
infoLabel.Font = Enum.Font.GothamSemibold
infoLabel.TextSize = 16
infoLabel.Text = "Clique para pescar"
infoLabel.Parent = hud

local coinsLabel = Instance.new("TextLabel")
coinsLabel.Size = UDim2.new(0, 200, 0, 32)
coinsLabel.Position = UDim2.new(1, -216, 0, 16)
coinsLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
coinsLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
coinsLabel.Font = Enum.Font.GothamSemibold
coinsLabel.TextSize = 14
coinsLabel.TextXAlignment = Enum.TextXAlignment.Left
coinsLabel.Text = "Moedas: 0"
coinsLabel.Parent = hud

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

local function updateCoins()
	local coins = player:GetAttribute("Coins")
	if typeof(coins) ~= "number" then
		coins = 0
	end
	coinsLabel.Text = string.format("Moedas: %d", coins)
end

player:GetAttributeChangedSignal("Coins"):Connect(updateCoins)
updateCoins()

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
		lockControls()
		setMenuCamera()
		menuOpen = true
	elseif action == "CloseAll" then
		unlockControls()
		if camera then
			camera.CameraType = Enum.CameraType.Custom
		end
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

fishEvent.OnClientEvent:Connect(function(payload)
	if type(payload) ~= "table" then
		return
	end

	if not payload.ok then
		if payload.reason == "NO_MAP" then
			infoLabel.Text = "Escolha um mapa antes de pescar"
		else
			infoLabel.Text = "Falha ao pescar"
		end
		return
	end

	infoLabel.Text = string.format("Pegou %s (%s) +%d moedas", payload.fishName, payload.rarity, payload.coins)
	uiBus:Fire("FishDiscovered", payload.fishId)
end)
