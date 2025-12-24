local RodDatabase = {}

RodDatabase.Rods = {
	{
		id = "rod_basic",
		name = "Cana Basica",
		price = 0,
		currency = "Coins",
		rarityBonus = 0,
		speed = 3,
	},
	{
		id = "rod_advanced",
		name = "Cana Avancada",
		price = 300,
		currency = "Coins",
		rarityBonus = 2,
		speed = 2.5,
	},
	{
		id = "rod_golden",
		name = "Cana Dourada",
		price = 799,
		currency = "Coins",
		rarityBonus = 4,
		speed = 2.0,
	},
	{
		id = "rod_legendary",
		name = "Cana Lendaria",
		price = 299,
		currency = "Robux",
		gamePassId = 0,
		rarityBonus = 6,
		speed = 1.5,
	},
}

function RodDatabase.GetById(rodId)
	for _, rod in ipairs(RodDatabase.Rods) do
		if rod.id == rodId then
			return rod
		end
	end
	return nil
end

function RodDatabase.GetByGamePassId(gamePassId)
	for _, rod in ipairs(RodDatabase.Rods) do
		if rod.gamePassId == gamePassId then
			return rod
		end
	end
	return nil
end

return RodDatabase
