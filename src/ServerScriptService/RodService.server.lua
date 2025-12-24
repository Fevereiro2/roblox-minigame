local ServerScriptService = game:GetService("ServerScriptService")

local State = require(ServerScriptService:WaitForChild("State"))
local RodDatabase = State.Databases.Rods

local equipEvent = State.GetRemote("EquipRod")

local function fail(player, reason)
	equipEvent:FireClient(player, { ok = false, reason = reason })
end

equipEvent.OnServerEvent:Connect(function(player, rodId)
	if type(rodId) ~= "string" then
		return
	end

	local data = State.GetData(player)
	if not data then
		return
	end

	local rod = RodDatabase.GetById(rodId)
	if not rod then
		fail(player, "INVALID_ROD")
		return
	end

	if not data.UnlockedRods[rodId] then
		fail(player, "LOCKED")
		return
	end

	data.EquippedRod = rodId
	State.SetAttributes(player, data)
	equipEvent:FireClient(player, { ok = true, rodId = rodId })
end)
