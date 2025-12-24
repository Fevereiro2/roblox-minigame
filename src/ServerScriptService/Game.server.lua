local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local State = require(ServerScriptService:WaitForChild("State"))

State.GetRemote("FishRequest")
State.GetRemote("BuyItem")
State.GetRemote("SelectMap")

local function onPlayerAdded(player)
	local data = State.InitPlayer(player)
	State.SetAttributes(player, data)
end

local function onPlayerRemoving(player)
	State.RemovePlayer(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end
