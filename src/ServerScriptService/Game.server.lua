local ServerScriptService = game:GetService("ServerScriptService")

local Services = ServerScriptService:WaitForChild("Services")
local PlayerDataService = require(Services:WaitForChild("PlayerDataService"))
local FishingService = require(Services:WaitForChild("FishingService"))
local ShopService = require(Services:WaitForChild("ShopService"))

PlayerDataService.GetRemote("FishRequest")
PlayerDataService.GetRemote("ShopAction")
PlayerDataService.GetRemote("MenuAction")
PlayerDataService.GetRemote("EquipRod")

local getProfile = PlayerDataService.GetRemoteFunction("GetProfile")
getProfile.OnServerInvoke = function(player)
	local data = PlayerDataService.GetData(player)
	if not data then
		return nil
	end

	local unlockedRods = {}
	for key, value in pairs(data.UnlockedRods or {}) do
		unlockedRods[key] = value
	end

	local unlockedMaps = {}
	for key, value in pairs(data.UnlockedMaps or {}) do
		unlockedMaps[key] = value
	end

	return {
		Coins = data.Coins,
		PurchasedCoins = data.PurchasedCoins or 0,
		UnlockedRods = unlockedRods,
		UnlockedMaps = unlockedMaps,
		EquippedRod = data.EquippedRod,
		Level = data.Level,
	}
end

PlayerDataService.Init()
FishingService.Init(PlayerDataService)
ShopService.Init(PlayerDataService)
