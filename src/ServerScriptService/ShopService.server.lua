local ServerScriptService = game:GetService("ServerScriptService")

local State = require(ServerScriptService:WaitForChild("State"))
local MapDatabase = State.Databases.Maps
local RodDatabase = State.Databases.Rods

local buyEvent = State.GetRemote("BuyItem")

local function fail(player, reason)
	buyEvent:FireClient(player, { ok = false, reason = reason })
end

buyEvent.OnServerEvent:Connect(function(player, payload)
	if type(payload) ~= "table" then
		return
	end

	local itemType = payload.itemType
	local itemId = payload.itemId
	local data = State.GetData(player)
	if not data then
		return
	end

	if itemType == "Rod" then
		local rod = RodDatabase.GetById(itemId)
		if not rod then
			fail(player, "INVALID_ITEM")
			return
		end

		if data.UnlockedRods[itemId] then
			fail(player, "ALREADY_OWNED")
			return
		end

		if rod.currency == "Coins" then
			if data.Coins < rod.price then
				fail(player, "NOT_ENOUGH_COINS")
				return
			end

			data.Coins = data.Coins - rod.price
			data.UnlockedRods[itemId] = true
			data.EquippedRod = itemId
			State.SetAttributes(player, data)

			buyEvent:FireClient(player, {
				ok = true,
				itemType = itemType,
				itemId = itemId,
				coins = data.Coins,
			})
			return
		end

		fail(player, "ROBLOX_PURCHASE_REQUIRED")
		return
	elseif itemType == "Map" then
		local map = MapDatabase.GetById(itemId)
		if not map then
			fail(player, "INVALID_ITEM")
			return
		end

		if data.UnlockedMaps[itemId] then
			fail(player, "ALREADY_OWNED")
			return
		end

		if map.currency == "Coins" then
			if data.Coins < map.price then
				fail(player, "NOT_ENOUGH_COINS")
				return
			end

			data.Coins = data.Coins - map.price
			data.UnlockedMaps[itemId] = true
			State.SetAttributes(player, data)

			buyEvent:FireClient(player, {
				ok = true,
				itemType = itemType,
				itemId = itemId,
				coins = data.Coins,
			})
			return
		end

		fail(player, "ROBLOX_PURCHASE_REQUIRED")
		return
	elseif itemType == "Boost" then
		fail(player, "NOT_IMPLEMENTED")
		return
	end

	fail(player, "INVALID_REQUEST")
end)
