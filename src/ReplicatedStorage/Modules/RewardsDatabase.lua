local RewardsDatabase = {}

RewardsDatabase.Daily = {
	{ day = 1, coins = 50 },
	{ day = 2, coins = 100 },
	{ day = 3, coins = 150 },
	{ day = 4, coins = 250 },
	{ day = 5, coins = 400 },
}

function RewardsDatabase.GetByDay(day)
	for _, reward in ipairs(RewardsDatabase.Daily) do
		if reward.day == day then
			return reward
		end
	end
	return nil
end

return RewardsDatabase
