local SampleItems = {}

SampleItems.Items = {
	{
		id = "rod_wood",
		name = "Vara de Madeira",
		slotType = "Rod",
		modelName = "Vara_Wood",
		durability = { current = 80, max = 100 },
		stats = { strength = 3, maxWeight = 8, breakChance = 6, efficiency = 2 },
	},
	{
		id = "rod_carbon",
		name = "Vara de Carbono",
		slotType = "Rod",
		modelName = "Vara_Carbon",
		durability = { current = 95, max = 120 },
		stats = { strength = 6, maxWeight = 14, breakChance = 4, efficiency = 4 },
	},
	{
		id = "reel_basic",
		name = "Carreto Basico",
		slotType = "Reel",
		modelName = "Carreto_Basico",
		durability = { current = 60, max = 100 },
		stats = { strength = 2, maxWeight = 6, breakChance = 4, efficiency = 2 },
	},
	{
		id = "reel_pro",
		name = "Carreto Pro",
		slotType = "Reel",
		modelName = "Carreto_Pro",
		durability = { current = 110, max = 140 },
		stats = { strength = 5, maxWeight = 12, breakChance = 3, efficiency = 4 },
	},
	{
		id = "line_nylon",
		name = "Linha Nylon",
		slotType = "Line",
		modelName = "Linha_Nylon",
		durability = { current = 70, max = 90 },
		stats = { strength = 1, maxWeight = 4, breakChance = 5, efficiency = 1 },
	},
	{
		id = "line_braided",
		name = "Linha Trancada",
		slotType = "Line",
		modelName = "Linha_Trancada",
		durability = { current = 90, max = 110 },
		stats = { strength = 3, maxWeight = 8, breakChance = 3, efficiency = 2 },
	},
	{
		id = "hook_small",
		name = "Anzol Pequeno",
		slotType = "Hook",
		modelName = "Anzol_Pequeno",
		durability = { current = 40, max = 60 },
		stats = { strength = 1, maxWeight = 3, breakChance = 2, efficiency = 1 },
	},
	{
		id = "hook_heavy",
		name = "Anzol Pesado",
		slotType = "Hook",
		modelName = "Anzol_Pesado",
		durability = { current = 75, max = 90 },
		stats = { strength = 2, maxWeight = 6, breakChance = 2, efficiency = 2 },
	},
}

return SampleItems
