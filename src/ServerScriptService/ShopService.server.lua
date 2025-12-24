local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ServerScriptService = game:GetService("ServerScriptService")

local State = require(ServerScriptService:WaitForChild("State"))
local MapDatabase = State.Databases.Maps
local RodDatabase = State.Databases.Rods
local ProductDatabase = State.Databases.Products

local buyEvent = State.GetRemote("BuyItem")

local function fail(player, reason)
	buyEvent:FireClient(player, { ok = false, reason = reason })
end

local function grantRod(player, data, rod)
	data.UnlockedRods[rod.id] = true
	data.EquippedRod = rod.id
	State.SetAttributes(player, data)
	buyEvent:FireClient(player, {
		ok = true,
		itemType = "Rod",
		itemId = rod.id,
		coins = data.Coins,
	})
end

local function grantMap(player, data, map)
	data.UnlockedMaps[map.id] = true
	State.SetAttributes(player, data)
	buyEvent:FireClient(player, {
		ok = true,
		itemType = "Map",
		itemId = map.id,
		coins = data.Coins,
	})
end

local function promptGamePass(player, gamePassId)
	pcall(function()
		MarketplaceService:PromptGamePassPurchase(player, gamePassId)
	end)
end

local function promptProduct(player, productId)
	pcall(function()
		MarketplaceService:PromptProductPurchase(player, productId)
	end)
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
			grantRod(player, data, rod)
			return
		end

		if rod.currency == "Robux" then
			if not rod.gamePassId or rod.gamePassId == 0 then
				fail(player, "MISSING_GAMEPASS")
				return
			end

			local ownsPass = false
			local ok, result = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, rod.gamePassId)
			end)

			if ok and result == true then
				grantRod(player, data, rod)
				return
			end

			promptGamePass(player, rod.gamePassId)
			buyEvent:FireClient(player, { ok = true, status = "PROMPTED", itemType = "Rod", itemId = rod.id })
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
			grantMap(player, data, map)
			return
		end

		if map.currency == "Robux" then
			if not map.gamePassId or map.gamePassId == 0 then
				fail(player, "MISSING_GAMEPASS")
				return
			end

			local ownsPass = false
			local ok, result = pcall(function()
				return MarketplaceService:UserOwnsGamePassAsync(player.UserId, map.gamePassId)
			end)

			if ok and result == true then
				grantMap(player, data, map)
				return
			end

			promptGamePass(player, map.gamePassId)
			buyEvent:FireClient(player, { ok = true, status = "PROMPTED", itemType = "Map", itemId = map.id })
			return
		end

		fail(player, "ROBLOX_PURCHASE_REQUIRED")
		return
	elseif itemType == "Boost" or itemType == "Coins" then
		local product = ProductDatabase.GetById(itemId)
		if not product or product.category ~= itemType then
			fail(player, "INVALID_ITEM")
			return
		end

		if not product.productId or product.productId == 0 then
			fail(player, "MISSING_PRODUCT_ID")
			return
		end

		promptProduct(player, product.productId)
		buyEvent:FireClient(player, { ok = true, status = "PROMPTED", itemType = itemType, itemId = product.id })
		return
	end

	fail(player, "INVALID_REQUEST")
end)

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)
	if not wasPurchased then
		return
	end

	local data = State.GetData(player)
	if not data then
		return
	end

	local map = MapDatabase.GetByGamePassId(gamePassId)
	if map and not data.UnlockedMaps[map.id] then
		grantMap(player, data, map)
		return
	end

	local rod = RodDatabase.GetByGamePassId(gamePassId)
	if rod and not data.UnlockedRods[rod.id] then
		grantRod(player, data, rod)
		return
	end
end)

MarketplaceService.ProcessReceipt = function(receiptInfo)
	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local data = State.GetData(player)
	if not data then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	if State.IsReceiptProcessed(data, receiptInfo.PurchaseId) then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	local product = ProductDatabase.GetByProductId(receiptInfo.ProductId)
	if not product then
		State.MarkReceipt(data, receiptInfo.PurchaseId)
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	if product.category == "Coins" then
		data.Coins = data.Coins + (product.amount or 0)
		State.SetAttributes(player, data)
		buyEvent:FireClient(player, { ok = true, itemType = "Coins", itemId = product.id, coins = data.Coins })
	elseif product.category == "Boost" then
		State.ApplyBoost(data, product)
		State.SetAttributes(player, data)
		buyEvent:FireClient(player, { ok = true, itemType = "Boost", itemId = product.id })
	end

	State.MarkReceipt(data, receiptInfo.PurchaseId)
	return Enum.ProductPurchaseDecision.PurchaseGranted
end
