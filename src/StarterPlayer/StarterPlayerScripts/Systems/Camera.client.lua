local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ContextActionService = game:GetService("ContextActionService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local UIBus = require(script.Parent:WaitForChild("UIBus"))
local uiBus = UIBus.Get()
local camera = Workspace.CurrentCamera or Workspace:WaitForChild("Camera")
local menuCameraCFrame = CFrame.new(0, 12, 32) * CFrame.Angles(0, math.rad(180), 0)
local menuOpen = false
local defaultWalkSpeed
local defaultJumpPower
local defaultJumpHeight

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

local function applyMovementLock(locked)
	local character = player.Character
	if not character then
		return
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoid then
		return
	end

	if locked then
		defaultWalkSpeed = defaultWalkSpeed or humanoid.WalkSpeed
		defaultJumpPower = defaultJumpPower or humanoid.JumpPower
		defaultJumpHeight = defaultJumpHeight or humanoid.JumpHeight
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
		humanoid.JumpHeight = 0
	else
		if defaultWalkSpeed then
			humanoid.WalkSpeed = defaultWalkSpeed
		end
		if defaultJumpPower then
			humanoid.JumpPower = defaultJumpPower
		end
		if defaultJumpHeight then
			humanoid.JumpHeight = defaultJumpHeight
		end
	end
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

local function syncMenuState()
	local flag = playerGui:GetAttribute("MenuOpen")
	if typeof(flag) == "boolean" then
		menuOpen = flag
	end
end

playerGui:GetAttributeChangedSignal("MenuOpen"):Connect(syncMenuState)
syncMenuState()

lockControls()
setMenuCamera()
applyMovementLock(true)

uiBus.Event:Connect(function(action)
	if action == "OpenPanel" then
		lockControls()
		setMenuCamera()
		applyMovementLock(true)
		menuOpen = true
	elseif action == "CloseAll" then
		unlockControls()
		if camera then
			camera.CameraType = Enum.CameraType.Custom
		end
		applyMovementLock(false)
		menuOpen = false
	end
end)

player.CharacterAdded:Connect(function()
	if menuOpen then
		applyMovementLock(true)
	end
end)
