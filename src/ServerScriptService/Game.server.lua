local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local State = require(ServerScriptService:WaitForChild("State"))
local MapDatabase = State.Databases.Maps
local RodDatabase = State.Databases.Rods

State.GetRemote("FishRequest")
State.GetRemote("BuyItem")
State.GetRemote("SelectMap")
State.GetRemote("EquipRod")
local getProfile = State.GetRemoteFunction("GetProfile")

getProfile.OnServerInvoke = function(player)
	local data = State.GetData(player)
	if not data then
		return nil
	end

	local unlockedRods = {}
	for key, value in pairs(data.UnlockedRods or {}) do
		unlockedRods[key] = value
	end

	return {
		Coins = data.Coins,
		PurchasedCoins = data.PurchasedCoins or 0,
		UnlockedRods = unlockedRods,
		EquippedRod = data.EquippedRod,
		Level = data.Level,
	}
end

local function onPlayerAdded(player)
	local data = State.LoadPlayer(player)
	State.SetAttributes(player, data)

	task.spawn(function()
		local changed = false

		for _, map in ipairs(MapDatabase.Maps) do
			if map.currency == "Robux" and map.gamePassId and map.gamePassId > 0 then
				local ok, owns = pcall(function()
					return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId, map.gamePassId)
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
					return game:GetService("MarketplaceService"):UserOwnsGamePassAsync(player.UserId, rod.gamePassId)
				end)
				if ok and owns and not data.UnlockedRods[rod.id] then
					data.UnlockedRods[rod.id] = true
					changed = true
				end
			end
		end

		if changed then
			State.SetAttributes(player, data)
			State.SavePlayer(player)
		end
	end)
end

local function onPlayerRemoving(player)
	State.SavePlayer(player)
	State.RemovePlayer(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		State.SavePlayer(player)
	end
end)

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
