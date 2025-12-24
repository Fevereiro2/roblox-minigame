local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local State = require(ServerScriptService:WaitForChild("State"))

State.GetRemote("FishRequest")
State.GetRemote("BuyItem")
State.GetRemote("SelectMap")
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
