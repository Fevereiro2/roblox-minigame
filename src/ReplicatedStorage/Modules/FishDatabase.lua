local FishDatabase = {}

FishDatabase.Rarities = {
	Common = { weight = 60, rewardMultiplier = 1 },
	Rare = { weight = 25, rewardMultiplier = 2 },
	Epic = { weight = 10, rewardMultiplier = 4 },
	Legendary = { weight = 4, rewardMultiplier = 8 },
	Mythic = { weight = 1, rewardMultiplier = 12 },
}

FishDatabase.Fish = {
	{ id = "carp", name = "Carpa", rarity = "Common", mapId = "lago_inicial", image = "rbxassetid://0", baseReward = 5 },
	{ id = "tilapia", name = "Tilapia", rarity = "Common", mapId = "lago_inicial", image = "rbxassetid://0", baseReward = 5 },
	{ id = "bagre", name = "Bagre", rarity = "Rare", mapId = "lago_inicial", image = "rbxassetid://0", baseReward = 8 },
	{ id = "truta", name = "Truta", rarity = "Epic", mapId = "lago_inicial", image = "rbxassetid://0", baseReward = 12 },

	{ id = "peixe_lua", name = "Peixe Lua", rarity = "Rare", mapId = "lago_misterioso", image = "rbxassetid://0", baseReward = 10 },
	{ id = "enguia", name = "Enguia", rarity = "Epic", mapId = "lago_misterioso", image = "rbxassetid://0", baseReward = 14 },
	{ id = "dourado", name = "Dourado", rarity = "Legendary", mapId = "lago_misterioso", image = "rbxassetid://0", baseReward = 20 },

	{ id = "atum", name = "Atum", rarity = "Common", mapId = "mar_profundo", image = "rbxassetid://0", baseReward = 7 },
	{ id = "tubarao", name = "Tubarao", rarity = "Epic", mapId = "mar_profundo", image = "rbxassetid://0", baseReward = 18 },
	{ id = "lulao", name = "Lulao", rarity = "Legendary", mapId = "mar_profundo", image = "rbxassetid://0", baseReward = 22 },

	{ id = "peixe_papagaio", name = "Peixe Papagaio", rarity = "Common", mapId = "caribe", image = "rbxassetid://0", baseReward = 8 },
	{ id = "barracuda", name = "Barracuda", rarity = "Rare", mapId = "caribe", image = "rbxassetid://0", baseReward = 12 },
	{ id = "manta", name = "Manta", rarity = "Legendary", mapId = "caribe", image = "rbxassetid://0", baseReward = 24 },
	{ id = "kraken", name = "Kraken", rarity = "Mythic", mapId = "caribe", image = "rbxassetid://0", baseReward = 40 },

	{ id = "salmao", name = "Salmao", rarity = "Common", mapId = "rio_gelado", image = "rbxassetid://0", baseReward = 7 },
	{ id = "peixe_gelo", name = "Peixe Gelo", rarity = "Rare", mapId = "rio_gelado", image = "rbxassetid://0", baseReward = 11 },
	{ id = "esturjao", name = "Esturjao", rarity = "Epic", mapId = "rio_gelado", image = "rbxassetid://0", baseReward = 16 },
	{ id = "serpente_gelada", name = "Serpente Gelada", rarity = "Legendary", mapId = "rio_gelado", image = "rbxassetid://0", baseReward = 24 },
}

function FishDatabase.GetById(fishId)
	for _, fish in ipairs(FishDatabase.Fish) do
		if fish.id == fishId then
			return fish
		end
	end
	return nil
end

function FishDatabase.GetByRarityAndMap(rarity, mapId)
	local list = {}
	for _, fish in ipairs(FishDatabase.Fish) do
		if fish.rarity == rarity and fish.mapId == mapId then
			table.insert(list, fish)
		end
	end
	return list
end

function FishDatabase.GetAllForMap(mapId)
	local list = {}
	for _, fish in ipairs(FishDatabase.Fish) do
		if fish.mapId == mapId then
			table.insert(list, fish)
		end
	end
	return list
end

return FishDatabase
