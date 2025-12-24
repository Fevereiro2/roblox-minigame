local MapDatabase = {}

MapDatabase.Maps = {
	{
		id = "lago_inicial",
		name = "Lago Inicial",
		price = 0,
		currency = "Coins",
		minLevel = 1,
		rarityBonus = 0,
	},
	{
		id = "lago_misterioso",
		name = "Lago Misterioso",
		price = 250,
		currency = "Coins",
		minLevel = 3,
		rarityBonus = 2,
	},
	{
		id = "mar_profundo",
		name = "Mar Profundo",
		price = 600,
		currency = "Coins",
		minLevel = 6,
		rarityBonus = 4,
	},
	{
		id = "caribe",
		name = "Caribe",
		price = 149,
		currency = "Robux",
		gamePassId = 0,
		minLevel = 8,
		rarityBonus = 5,
	},
	{
		id = "rio_gelado",
		name = "Rio Gelado",
		price = 900,
		currency = "Coins",
		minLevel = 10,
		rarityBonus = 6,
	},
}

function MapDatabase.GetById(mapId)
	for _, map in ipairs(MapDatabase.Maps) do
		if map.id == mapId then
			return map
		end
	end
	return nil
end

function MapDatabase.GetByGamePassId(gamePassId)
	for _, map in ipairs(MapDatabase.Maps) do
		if map.gamePassId == gamePassId then
			return map
		end
	end
	return nil
end

return MapDatabase
