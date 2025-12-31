local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local getFishRequest = require(ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FishRequest"))
local fishEvent = getFishRequest()

local root = script:FindFirstAncestor("StarterPlayerScripts") or script.Parent.Parent
local UIBus = require(root:WaitForChild("Systems"):WaitForChild("UIBus"))
local uiBus = UIBus.Get()

local function getHud()
	local hud = playerGui:FindFirstChild("FishingHud")
	if not hud then
		hud = Instance.new("ScreenGui")
		hud.Name = "FishingHud"
		hud.ResetOnSpawn = false
		hud.Parent = playerGui
	end
	return hud
end

local function getInfoLabel(hud)
	local label = hud:FindFirstChild("FishingInfo")
	if not label then
		label = Instance.new("TextLabel")
		label.Name = "FishingInfo"
		label.Size = UDim2.new(0, 360, 0, 40)
		label.Position = UDim2.new(0, 16, 0, 16)
		label.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
		label.TextColor3 = Color3.fromRGB(240, 240, 240)
		label.Font = Enum.Font.GothamSemibold
		label.TextSize = 16
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Text = "Clique para pescar"
		label.Parent = hud
	end
	return label
end

local hud = getHud()
local infoLabel = getInfoLabel(hud)

local function setInfo(text)
	infoLabel.Text = text
end

fishEvent.OnClientEvent:Connect(function(payload)
	if type(payload) ~= "table" then
		return
	end

	if not payload.ok then
		if payload.reason == "NO_MAP" then
			setInfo("Escolha um mapa antes de pescar")
		else
			setInfo("Falha ao pescar")
		end
		return
	end

	setInfo(string.format("Pegou %s (%s) +%d moedas", payload.fishName, payload.rarity, payload.coins))
	uiBus:Fire("FishDiscovered", payload.fishId)
end)
