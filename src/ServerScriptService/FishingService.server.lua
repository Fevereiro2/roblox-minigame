local ServerScriptService = game:GetService("ServerScriptService")

local State = require(ServerScriptService:WaitForChild("State"))
local FishDatabase = State.Databases.Fish
local MapDatabase = State.Databases.Maps
local RodDatabase = State.Databases.Rods

local fishEvent = State.GetRemote("FishRequest")
local rng = Random.new()

local function buildWeights(mapId, rodId)
	local weights = {
		Common = FishDatabase.Rarities.Common.weight,
		Rare = FishDatabase.Rarities.Rare.weight,
		Epic = FishDatabase.Rarities.Epic.weight,
		Legendary = FishDatabase.Rarities.Legendary.weight,
		Mythic = FishDatabase.Rarities.Mythic.weight,
	}

	local map = MapDatabase.GetById(mapId)
	local rod = RodDatabase.GetById(rodId)
	local bonus = 0

	if map and map.rarityBonus then
		bonus = bonus + map.rarityBonus
	end

	if rod and rod.rarityBonus then
		bonus = bonus + rod.rarityBonus
	end

	if bonus > 0 then
		weights.Common = math.max(1, weights.Common - (bonus * 2))
		weights.Rare = weights.Rare + bonus
		weights.Epic = weights.Epic + math.floor(bonus * 0.6)
		weights.Legendary = weights.Legendary + math.floor(bonus * 0.3)
		weights.Mythic = weights.Mythic + math.floor(bonus * 0.1)
	end

	return weights
end

local function pickRarity(weights)
	local order = { "Common", "Rare", "Epic", "Legendary", "Mythic" }
	local total = 0
	for _, rarity in ipairs(order) do
		total = total + weights[rarity]
	end

	local roll = rng:NextNumber(0, total)
	local acc = 0
	for _, rarity in ipairs(order) do
		acc = acc + weights[rarity]
		if roll <= acc then
			return rarity
		end
	end

	return "Common"
end

local function pickFish(mapId, rodId)
	local rarity = pickRarity(buildWeights(mapId, rodId))
	local candidates = FishDatabase.GetByRarityAndMap(rarity, mapId)

	if #candidates == 0 then
		candidates = FishDatabase.GetAllForMap(mapId)
	end

	if #candidates == 0 then
		return nil
	end

	local fish = candidates[rng:NextInteger(1, #candidates)]
	return fish, rarity
end

fishEvent.OnServerEvent:Connect(function(player)
	local data = State.GetData(player)
	if not data then
		return
	end

	if not data.SelectedMap then
		fishEvent:FireClient(player, { ok = false, reason = "NO_MAP" })
		return
	end

	local fish, rarity = pickFish(data.SelectedMap, data.EquippedRod)
	if not fish then
		fishEvent:FireClient(player, { ok = false, reason = "NO_FISH" })
		return
	end

	local rarityDef = FishDatabase.Rarities[rarity]
	local rewardMultiplier = rarityDef and rarityDef.rewardMultiplier or 1
	local coinsEarned = math.floor((fish.baseReward or 1) * rewardMultiplier)

	data.Coins = data.Coins + coinsEarned
	data.DiscoveredFish[fish.id] = true
	State.SetAttributes(player, data)

	fishEvent:FireClient(player, {
		ok = true,
		fishId = fish.id,
		fishName = fish.name,
		rarity = rarity,
		coins = coinsEarned,
		totalCoins = data.Coins,
		mapId = data.SelectedMap,
	})
end)
