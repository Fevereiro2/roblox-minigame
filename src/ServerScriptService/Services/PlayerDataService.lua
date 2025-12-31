local DataStoreService = game:GetService("DataStoreService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FishDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FishDatabase"))
local MapDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MapDatabase"))
local RodDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RodDatabase"))
local ProductDatabase = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ProductDatabase"))

local PlayerDataService = {}
local initialized = false

PlayerDataService.Databases = {
	Fish = FishDatabase,
	Maps = MapDatabase,
	Rods = RodDatabase,
	Products = ProductDatabase,
}

PlayerDataService.PlayerData = {}
PlayerDataService.Store = DataStoreService:GetDataStore("FishingGameData_v1")

function PlayerDataService.DefaultData()
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

function PlayerDataService.MergeDefaults(defaults, loaded)
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

function PlayerDataService.MergeData(base, incoming)
	local data = cloneTable(base or {})
	if type(incoming) ~= "table" then
		return data
	end

	for key, value in pairs(incoming) do
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

function PlayerDataService.GetData(player)
	return PlayerDataService.PlayerData[player.UserId]
end

function PlayerDataService.InitPlayer(player)
	local data = PlayerDataService.DefaultData()
	PlayerDataService.PlayerData[player.UserId] = data
	return data
end

function PlayerDataService.LoadPlayer(player)
	local key = "player_" .. player.UserId
	local data = PlayerDataService.DefaultData()

	local ok, saved = pcall(function()
		return PlayerDataService.Store:GetAsync(key)
	end)

	if ok then
		data = PlayerDataService.MergeDefaults(data, saved)
	end

	PlayerDataService.CleanExpiredBoosts(data)
	PlayerDataService.PlayerData[player.UserId] = data
	return data
end

function PlayerDataService.SavePlayer(player)
	local data = PlayerDataService.PlayerData[player.UserId]
	if not data then
		return
	end

	local key = "player_" .. player.UserId
	local payload = cloneTable(data)

	pcall(function()
		PlayerDataService.Store:UpdateAsync(key, function(old)
			local base = PlayerDataService.MergeDefaults(PlayerDataService.DefaultData(), old)
			return PlayerDataService.MergeData(base, payload)
		end)
	end)
end

function PlayerDataService.RemovePlayer(player)
	PlayerDataService.PlayerData[player.UserId] = nil
end

function PlayerDataService.CleanExpiredBoosts(data)
	local now = os.time()
	for boostId, boostData in pairs(data.ActiveBoosts) do
		if type(boostData) ~= "table" or boostData.expiresAt <= now then
			data.ActiveBoosts[boostId] = nil
		end
	end
end

function PlayerDataService.ApplyBoost(data, boostDef)
	if not boostDef or not boostDef.id then
		return
	end

	local expiresAt = os.time() + (boostDef.durationSeconds or 0)
	data.ActiveBoosts[boostDef.id] = {
		expiresAt = expiresAt,
	}
end

function PlayerDataService.GetActiveBoostMultiplier(data, category)
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

function PlayerDataService.MarkReceipt(data, receiptId)
	if not data.ProcessedReceipts then
		data.ProcessedReceipts = {}
	end
	data.ProcessedReceipts[receiptId] = true
end

function PlayerDataService.IsReceiptProcessed(data, receiptId)
	if not data.ProcessedReceipts then
		return false
	end
	return data.ProcessedReceipts[receiptId] == true
end

function PlayerDataService.SetAttributes(player, data)
	player:SetAttribute("Coins", data.Coins)
	player:SetAttribute("PurchasedCoins", data.PurchasedCoins or 0)
	player:SetAttribute("Level", data.Level)
	player:SetAttribute("SelectedMap", data.SelectedMap or "")
	player:SetAttribute("EquippedRod", data.EquippedRod or "")
end

function PlayerDataService.GetRemote(name)
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

function PlayerDataService.GetRemoteFunction(name)
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

local function unlockGamePasses(player, data)
	local changed = false

	for _, map in ipairs(MapDatabase.Maps) do
		if map.currency == "Robux" and map.gamePassId and map.gamePassId > 0 then
			local ok, owns = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, map.gamePassId)
			end)
			if ok and owns and not data.UnlockedMaps[map.id] then
				data.UnlockedMaps[map.id] = true
				changed = true
			end
		end
	end

	for _, rod in ipairs(RodDatabase.Rods) do
		if rod.currency == "Robux" and rod.gamePassId and rod.gamePassId > 0 then
			local ok, owns = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, rod.gamePassId)
			end)
			if ok and owns and not data.UnlockedRods[rod.id] then
				data.UnlockedRods[rod.id] = true
				changed = true
			end
		end
	end

	if changed then
		PlayerDataService.SetAttributes(player, data)
		PlayerDataService.SavePlayer(player)
	end
end

function PlayerDataService.Init()
	if initialized then
		return
	end
	initialized = true

	Players.PlayerAdded:Connect(function(player)
		local data = PlayerDataService.LoadPlayer(player)
		PlayerDataService.SetAttributes(player, data)

		task.spawn(function()
			unlockGamePasses(player, data)
		end)
	end)

	Players.PlayerRemoving:Connect(function(player)
		PlayerDataService.SavePlayer(player)
		PlayerDataService.RemovePlayer(player)
	end)

	game:BindToClose(function()
		for _, player in ipairs(Players:GetPlayers()) do
			PlayerDataService.SavePlayer(player)
		end
	end)

	for _, player in ipairs(Players:GetPlayers()) do
		local data = PlayerDataService.LoadPlayer(player)
		PlayerDataService.SetAttributes(player, data)

		task.spawn(function()
			unlockGamePasses(player, data)
		end)
	end
end

return PlayerDataService
