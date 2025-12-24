local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FishDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FishDatabase"))
local MapDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MapDatabase"))
local RodDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RodDatabase"))

local State = {}

State.Databases = {
	Fish = FishDatabase,
	Maps = MapDatabase,
	Rods = RodDatabase,
}

State.PlayerData = {}

function State.GetData(player)
	return State.PlayerData[player.UserId]
end

function State.InitPlayer(player)
	local data = {
		Coins = 0,
		Level = 1,
		DiscoveredFish = {},
		UnlockedMaps = { lago_inicial = true },
		UnlockedRods = { rod_basic = true },
		SelectedMap = nil,
		EquippedRod = "rod_basic",
	}

	State.PlayerData[player.UserId] = data
	return data
end

function State.RemovePlayer(player)
	State.PlayerData[player.UserId] = nil
end

function State.SetAttributes(player, data)
	player:SetAttribute("Coins", data.Coins)
	player:SetAttribute("Level", data.Level)
	player:SetAttribute("SelectedMap", data.SelectedMap or "")
	player:SetAttribute("EquippedRod", data.EquippedRod or "")
end

function State.GetRemote(name)
	local folder = ReplicatedStorage:FindFirstChild("RemoteEvents")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "RemoteEvents"
		folder.Parent = ReplicatedStorage
	end

	local remote = folder:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = folder
	end

	return remote
end

return State
