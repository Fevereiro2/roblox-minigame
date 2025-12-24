local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FishDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FishDatabase"))
local MapDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MapDatabase"))
local RodDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RodDatabase"))
local ProductDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ProductDatabase"))

local State = {}

State.Databases = {
	Fish = FishDatabase,
	Maps = MapDatabase,
	Rods = RodDatabase,
	Products = ProductDatabase,
}

State.PlayerData = {}
State.Store = DataStoreService:GetDataStore("FishingGameData_v1")

function State.DefaultData()
	return {
		Coins = 0,
		PurchasedCoins = 0,
		Level = 1,
		DiscoveredFish = {},
		UnlockedMaps = { lago_inicial = true },
		UnlockedRods = { rod_basic = true },
		ActiveBoosts = {},
		ProcessedReceipts = {},
		SelectedMap = nil,
		EquippedRod = "rod_basic",
	}
end

local function cloneTable(source)
	local copy = {}
	for key, value in pairs(source) do
		if type(value) == "table" then
			copy[key] = cloneTable(value)
		else
			copy[key] = value
		end
	end
	return copy
end

function State.MergeDefaults(defaults, loaded)
	local data = cloneTable(defaults)
	if type(loaded) ~= "table" then
		return data
	end

	for key, value in pairs(loaded) do
		if type(value) == "table" and type(data[key]) == "table" then
			for innerKey, innerValue in pairs(value) do
				data[key][innerKey] = innerValue
			end
		else
			data[key] = value
		end
	end

	return data
end

function State.GetData(player)
	return State.PlayerData[player.UserId]
end

function State.InitPlayer(player)
	local data = State.DefaultData()
	State.PlayerData[player.UserId] = data
	return data
end

function State.LoadPlayer(player)
	local key = "player_" .. player.UserId
	local data = State.DefaultData()

	local ok, saved = pcall(function()
		return State.Store:GetAsync(key)
	end)

	if ok then
		data = State.MergeDefaults(data, saved)
	end

	State.CleanExpiredBoosts(data)
	State.PlayerData[player.UserId] = data
	return data
end

function State.SavePlayer(player)
	local data = State.PlayerData[player.UserId]
	if not data then
		return
	end

	local key = "player_" .. player.UserId
	local payload = cloneTable(data)

	pcall(function()
		State.Store:SetAsync(key, payload)
	end)
end

function State.RemovePlayer(player)
	State.PlayerData[player.UserId] = nil
end

function State.CleanExpiredBoosts(data)
	local now = os.time()
	for boostId, boostData in pairs(data.ActiveBoosts) do
		if type(boostData) ~= "table" or boostData.expiresAt <= now then
			data.ActiveBoosts[boostId] = nil
		end
	end
end

function State.ApplyBoost(data, boostDef)
	if not boostDef or not boostDef.id then
		return
	end

	local expiresAt = os.time() + (boostDef.durationSeconds or 0)
	data.ActiveBoosts[boostDef.id] = {
		expiresAt = expiresAt,
	}
end

function State.GetActiveBoostMultiplier(data, category)
	local multiplier = 1
	local now = os.time()
	for boostId, boostData in pairs(data.ActiveBoosts) do
		if type(boostData) == "table" and boostData.expiresAt and boostData.expiresAt > now then
			local def = ProductDatabase.GetBoostById(boostId)
			if def and (not category or def.boostCategory == category) then
				multiplier = multiplier * (def.multiplier or 1)
			end
		else
			data.ActiveBoosts[boostId] = nil
		end
	end
	return multiplier
end

function State.MarkReceipt(data, receiptId)
	if not data.ProcessedReceipts then
		data.ProcessedReceipts = {}
	end
	data.ProcessedReceipts[receiptId] = true
end

function State.IsReceiptProcessed(data, receiptId)
	if not data.ProcessedReceipts then
		return false
	end
	return data.ProcessedReceipts[receiptId] == true
end

function State.SetAttributes(player, data)
	player:SetAttribute("Coins", data.Coins)
	player:SetAttribute("PurchasedCoins", data.PurchasedCoins or 0)
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

function State.GetRemoteFunction(name)
	local folder = ReplicatedStorage:FindFirstChild("RemoteFunctions")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "RemoteFunctions"
		folder.Parent = ReplicatedStorage
	end

	local remote = folder:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteFunction")
		remote.Name = name
		remote.Parent = folder
	end

	return remote
end

return State
