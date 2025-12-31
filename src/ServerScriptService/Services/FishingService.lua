local FishingService = {}

function FishingService.Init(PlayerDataService)
	local FishDatabase = PlayerDataService.Databases.Fish
	local MapDatabase = PlayerDataService.Databases.Maps
	local RodDatabase = PlayerDataService.Databases.Rods

	local fishEvent = PlayerDataService.GetRemote("FishRequest")
	local selectEvent = PlayerDataService.GetRemote("MenuAction")
	local equipEvent = PlayerDataService.GetRemote("EquipRod")
	local rng = Random.new()
	local lastFishTimes = {}

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

	local function ensureCharacter(player)
		if not player.Character or not player.Character.Parent then
			player:LoadCharacter()
		end

		local character = player.Character or player.CharacterAdded:Wait()
		local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 5)
		if root and not character.PrimaryPart then
			character.PrimaryPart = root
		end

		return character
	end

	local function teleportToMap(player, mapId)
		local spawnFolder = workspace:FindFirstChild("MapSpawns")
		if not spawnFolder then
			return
		end

		local spawnPart = spawnFolder:FindFirstChild(mapId)
		if not spawnPart or not spawnPart:IsA("BasePart") then
			return
		end

		local character = ensureCharacter(player)
		if not character or not character.PrimaryPart then
			return
		end

		character:SetPrimaryPartCFrame(spawnPart.CFrame + Vector3.new(0, 3, 0))
	end

	local function failEquip(player, reason)
		equipEvent:FireClient(player, { ok = false, reason = reason })
	end

	fishEvent.OnServerEvent:Connect(function(player)
		local data = PlayerDataService.GetData(player)
		if not data then
			return
		end

		if not data.SelectedMap then
			fishEvent:FireClient(player, { ok = false, reason = "NO_MAP" })
			return
		end

		local now = os.clock()
		local last = lastFishTimes[player.UserId] or 0
		local rod = RodDatabase.GetById(data.EquippedRod)
		local cooldown = 2.5
		if rod and rod.speed then
			cooldown = math.max(0.6, rod.speed)
		end
		if now - last < cooldown then
			fishEvent:FireClient(player, { ok = false, reason = "COOLDOWN" })
			return
		end
		lastFishTimes[player.UserId] = now

		local fish, rarity = pickFish(data.SelectedMap, data.EquippedRod)
		if not fish then
			fishEvent:FireClient(player, { ok = false, reason = "NO_FISH" })
			return
		end

		local rarityDef = FishDatabase.Rarities[rarity]
		local rewardMultiplier = rarityDef and rarityDef.rewardMultiplier or 1
		local coinsEarned = math.floor((fish.baseReward or 1) * rewardMultiplier)
		local boostMultiplier = PlayerDataService.GetActiveBoostMultiplier(data, "Coins")
		coinsEarned = math.floor(coinsEarned * boostMultiplier)

		data.Coins = data.Coins + coinsEarned
		data.DiscoveredFish[fish.id] = true
		PlayerDataService.SetAttributes(player, data)

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

	selectEvent.OnServerEvent:Connect(function(player, mapId)
		if type(mapId) ~= "string" then
			return
		end

		local data = PlayerDataService.GetData(player)
		if not data then
			return
		end

		local map = MapDatabase.GetById(mapId)
		if not map then
			selectEvent:FireClient(player, { ok = false, reason = "INVALID_MAP" })
			return
		end

		if not data.UnlockedMaps[mapId] then
			selectEvent:FireClient(player, { ok = false, reason = "LOCKED" })
			return
		end

		if data.Level < map.minLevel then
			selectEvent:FireClient(player, { ok = false, reason = "LOW_LEVEL" })
			return
		end

		data.SelectedMap = mapId
		PlayerDataService.SetAttributes(player, data)
		teleportToMap(player, mapId)

		selectEvent:FireClient(player, { ok = true, mapId = mapId })
	end)

	equipEvent.OnServerEvent:Connect(function(player, rodId)
		if type(rodId) ~= "string" then
			return
		end

		local data = PlayerDataService.GetData(player)
		if not data then
			return
		end

		local rod = RodDatabase.GetById(rodId)
		if not rod then
			failEquip(player, "INVALID_ROD")
			return
		end

		if not data.UnlockedRods[rodId] then
			failEquip(player, "LOCKED")
			return
		end

		data.EquippedRod = rodId
		PlayerDataService.SetAttributes(player, data)
		equipEvent:FireClient(player, { ok = true, rodId = rodId })
	end)
end

return FishingService
