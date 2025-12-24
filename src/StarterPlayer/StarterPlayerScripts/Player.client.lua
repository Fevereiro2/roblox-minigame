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

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		requestFish()
	elseif input.KeyCode == Enum.KeyCode.M then
		if menuOpen then
			uiBus:Fire("CloseAll")
		else
			uiBus:Fire("OpenPanel", "MainMenu")
		end
	end
end)

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
