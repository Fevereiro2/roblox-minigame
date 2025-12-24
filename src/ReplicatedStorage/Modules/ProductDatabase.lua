local ProductDatabase = {}

ProductDatabase.Products = {
	{
		id = "coins_small",
		name = "Pacote de Moedas S",
		category = "Coins",
		productId = 0,
		amount = 500,
		displayPrice = "49 Robux",
	},
	{
		id = "coins_medium",
		name = "Pacote de Moedas M",
		category = "Coins",
		productId = 0,
		amount = 1500,
		displayPrice = "129 Robux",
	},
	{
		id = "coins_large",
		name = "Pacote de Moedas L",
		category = "Coins",
		productId = 0,
		amount = 5000,
		displayPrice = "299 Robux",
	},
	{
		id = "boost_double_coins",
		name = "Boost Moedas x2 (15m)",
		category = "Boost",
		boostCategory = "Coins",
		productId = 0,
		durationSeconds = 900,
		multiplier = 2,
		displayPrice = "79 Robux",
	},
}

function ProductDatabase.GetById(productId)
	for _, product in ipairs(ProductDatabase.Products) do
		if product.id == productId then
			return product
		end
	end
	return nil
end

function ProductDatabase.GetByProductId(productId)
	for _, product in ipairs(ProductDatabase.Products) do
		if product.productId == productId then
			return product
		end
	end
	return nil
end

function ProductDatabase.GetBoostById(boostId)
	for _, product in ipairs(ProductDatabase.Products) do
		if product.id == boostId and product.category == "Boost" then
			return product
		end
	end
	return nil
end

return ProductDatabase
