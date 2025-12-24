local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local State = require(ServerScriptService:WaitForChild("State"))

State.GetRemote("FishRequest")
State.GetRemote("BuyItem")
State.GetRemote("SelectMap")

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
